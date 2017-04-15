# Use this file to import the sales information into the
# the database.

require 'pg'
require 'csv'
require 'pry'
system "psql korning < schema.sql"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end

CSV.foreach("sales.csv", headers: true) do |row|
  db_connection do |conn|

    values = row[0].split(" ")
    employee_name = values[0..1].join(" ")
    email = values[2].delete! "()"

    insert_employees = "SELECT employee_name FROM employees WHERE employee_name = $1"
    results = conn.exec_params(insert_employees, [employee_name])
    if results.to_a.empty?
      insert_employees = "INSERT INTO employees (employee_name, email) VALUES ($1, $2)"
      results = conn.exec_params(insert_employees, [employee_name, email])
    end

    values = row[1].split(" ")
    customer_name = values[0]
    account_no = values[1].delete! "()"

    insert_customers = "SELECT customer_name, account_no FROM customers WHERE customer_name = $1 AND account_no = $2"
    results = conn.exec_params(insert_customers, [customer_name, account_no])
    if results.to_a.empty?
      insert_customers = "INSERT INTO customers (customer_name, account_no) VALUES ($1, $2)"
      results = conn.exec_params(insert_customers, [customer_name, account_no])
    end

    product_name = row[2]

    insert_products = "SELECT product_name FROM products WHERE product_name = $1"
    results = conn.exec_params(insert_products, [product_name])
    if results.to_a.empty?
      insert_products = "INSERT INTO products (product_name) VALUES ($1)"
      results = conn.exec_params(insert_products, [product_name])
    end

    sale_date = row[3]
    sale_amount = row[4]
    units_sold = row[5]
    invoice_no = row[6]
    invoice_frequency = row[7]

    employee_id = conn.exec_params("SELECT id FROM employees").to_a
    employee_id.each do |value|
      # binding.pry
      employee_id = value["id"]
    end

    customer_id = conn.exec_params("SELECT id FROM customers").to_a
    customer_id.each do |value|
      customer_id = value["id"]
    end

    product_id = conn.exec_params("SELECT id FROM products").to_a
    product_id.each do |value|
      product_id = value["id"]
    end

    insert_sales = "SELECT sale_date, sale_amount, units_sold, invoice_no, invoice_frequency FROM sales WHERE sale_date = $1 AND sale_amount = $2 AND units_sold = $3 AND invoice_no = $4 AND invoice_frequency = $5"
    results = conn.exec_params(insert_sales, [sale_date, sale_amount, units_sold, invoice_no, invoice_frequency])
    if results.to_a.empty?
      insert_sales = "INSERT INTO sales (sale_date, sale_amount, units_sold, invoice_no, invoice_frequency, employee_id, customer_id, product_id) VALUES ($1, $2, $3, $4, $5, $6, $7, $8)"
      results = conn.exec_params(insert_sales, [sale_date, sale_amount, units_sold, invoice_no, invoice_frequency, employee_id, customer_id, product_id])
    end
  end
end
