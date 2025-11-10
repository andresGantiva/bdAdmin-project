CREATE DATABASE IF NOT EXISTS coworking CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE coworking;

CREATE TABLE IF NOT EXISTS companies (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  nit VARCHAR(20),
  contact_email VARCHAR(100),
  phone VARCHAR(30),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  company_id INT NOT NULL,
  first_name VARCHAR(80) NOT NULL,
  last_name VARCHAR(80) NOT NULL,
  document VARCHAR(40) NOT NULL,
  role VARCHAR(50),
  status ENUM('ACTIVO','INACTIVO') DEFAULT 'ACTIVO',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_emp_company FOREIGN KEY (company_id) REFERENCES companies(id)
);

CREATE TABLE IF NOT EXISTS access_points (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(80) NOT NULL,
  location VARCHAR(120)
);

CREATE TABLE IF NOT EXISTS access_logs (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_id INT NOT NULL,
  access_point_id INT,
  direction ENUM('IN','OUT') NOT NULL,
  occurred_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_log_emp FOREIGN KEY (employee_id) REFERENCES employees(id),
  CONSTRAINT fk_log_ap FOREIGN KEY (access_point_id) REFERENCES access_points(id)
);

INSERT INTO companies(name, nit) VALUES ('Empresa Demo', '900123456');
INSERT INTO access_points(name, location) VALUES ('Torno Principal', 'Lobby');
