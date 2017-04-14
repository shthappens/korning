-- DEFINE YOUR DATABASE SCHEMA HERE

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;

CREATE TABLE employees (
  id SERIAL PRIMARY KEY,
  employee_name VARCHAR(255),
  email VARCHAR(255)
);

CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  customer_name VARCHAR(255),
  account_no VARCHAR(255)
);

CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  product_name VARCHAR(255)
);

CREATE TABLE sales (
  id SERIAL PRIMARY KEY,
  sale_date DATE,
  sale_amount VARCHAR(255),
  units_sold INTEGER,
  invoice_no INTEGER,
  invoice_frequency VARCHAR(255),
  employee_id INTEGER REFERENCES employees(id),
  customer_id INTEGER REFERENCES customers(id),
  product_id INTEGER REFERENCES products(id)
);
