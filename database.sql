-- CREATE DATABASE
DROP DATABASE IF EXISTS helpdesk;
CREATE DATABASE helpdesk;
USE helpdesk;

-- DROP TABLES
DROP TABLE IF EXISTS audit_log;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS status;
DROP TABLE IF EXISTS priority;
DROP TABLE IF EXISTS roles;

-- ROLES TABLE
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE
);

-- PRIORITY TABLE
CREATE TABLE priority (
    priority_id INT AUTO_INCREMENT PRIMARY KEY,
    priority_level VARCHAR(20) NOT NULL UNIQUE
);

-- STATUS TABLE
CREATE TABLE status (
    status_id INT AUTO_INCREMENT PRIMARY KEY,
    status_name VARCHAR(50) NOT NULL UNIQUE
);

-- USERS TABLE
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    role_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- TICKETS TABLE
CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    assigned_to INT NULL,
    subject VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    priority_id INT NOT NULL,
    status_id INT NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL,
    resolved_at TIMESTAMP NULL,
    submitted_name VARCHAR(100),
    submitted_email VARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id),
    FOREIGN KEY (priority_id) REFERENCES priority(priority_id),
    FOREIGN KEY (status_id) REFERENCES status(status_id)
);

-- COMMENTS TABLE
CREATE TABLE comments (
    comment_id INT AUTO_INCREMENT PRIMARY KEY,
    ticket_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    is_internal BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ticket_id) REFERENCES tickets(ticket_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- AUDIT LOG TABLE
CREATE TABLE audit_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    action VARCHAR(255),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- INSERT DEFAULT DATA
INSERT INTO roles (role_name) VALUES
('User'),
('Technician'),
('Admin');

INSERT INTO priority (priority_level) VALUES
('Low'),
('Medium'),
('High'),
('Critical');

INSERT INTO status (status_name) VALUES
('Open'),
('In Progress'),
('Resolved'),
('Closed');

-- TEST DATA
INSERT INTO users (first_name, last_name, email, password_hash, role_id)
VALUES ('Test', 'User', 'test@email.com', 'hashedpassword', 1);

INSERT INTO tickets (
    user_id, subject, description, priority_id, status_id, submitted_name, submitted_email
)
VALUES (
    1,
    'Test Ticket',
    'This is a test ticket submission',
    2,
    1,
    'Test User',
    'test@email.com'
);

-- TEST QUERY
SELECT 
    t.ticket_id,
    t.subject,
    t.description,
    p.priority_level,
    s.status_name,
    t.created_at
FROM tickets t
JOIN priority p ON t.priority_id = p.priority_id
JOIN status s ON t.status_id = s.status_id;
