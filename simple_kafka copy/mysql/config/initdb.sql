-- ensure the database exists and is selected
CREATE DATABASE IF NOT EXISTS inventory;
USE inventory;

-- minimal demo table (keep it simple for CDC)
CREATE TABLE IF NOT EXISTS customers (
  id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50),
  last_name  VARCHAR(50),
  email      VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- seed data for snapshot
INSERT INTO customers (first_name, last_name, email) VALUES
('Alice', 'Smith', 'alice@example.com'),
('Bob',   'Johnson', 'bob@example.com');