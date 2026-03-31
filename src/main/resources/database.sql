CREATE DATABASE IF NOT EXISTS students_db;
USE students_db;

-- Users table (Vulnerable: Plain text passwords)
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Storing plain text passwords
    role VARCHAR(20) NOT NULL -- 'admin' or 'student'
);

-- Students table
CREATE TABLE IF NOT EXISTS students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    marks VARCHAR(20), -- Storing specific marks or grades
    division VARCHAR(50), -- Renamed from course
    profile_pic VARCHAR(255), -- VULNERABILITY: Storing file paths uploaded insecurely
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Safely add the column if the table was previously created without it
-- Note: MySQL doesn't have "ADD COLUMN IF NOT EXISTS", so this may throw an error 
-- if run twice, but it allows upgrading existing databases.
-- Alternatively, just execute this line manually in phpMyAdmin:
-- ALTER TABLE students ADD COLUMN profile_pic VARCHAR(255);
-- ALTER TABLE students CHANGE course study_year VARCHAR(50);

-- Announcements table (Vulnerable to Stored XSS)
CREATE TABLE IF NOT EXISTS announcements (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL, -- VULNERABILITY: Will store raw HTML/JS inputted by users
    date_posted DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Initial Data
-- VULNERABILITY: Hardcoded credentials
INSERT INTO users (username, password, role) VALUES 
('admin', 'admin123', 'admin'),
('rahul', 'rahul123', 'student'),
('priya', 'priya123', 'student'),
('amit', 'amit123', 'student'),
('neha', 'neha123', 'student'),
('vikram', 'vikram123', 'student');

INSERT INTO students (user_id, full_name, email, phone, marks, division) VALUES 
(2, 'Rahul Verma', 'rahul.verma@example.com', '9876543210', '85', 'A'),
(3, 'Priya Sharma', 'priya.sharma@example.com', '9988776655', '92', 'A'),
(4, 'Amit Patil', 'amit.patil@example.com', '9765432109', '78', 'B'),
(5, 'Neha Gupta', 'neha.gupta@example.com', '9654321098', '88', 'A'),
(6, 'Vikram Singh', 'vikram.singh@example.com', '9543210987', '65', 'B');

-- Attendance table
CREATE TABLE IF NOT EXISTS attendance (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT,
    date DATE NOT NULL,
    status VARCHAR(20) NOT NULL, -- 'Present', 'Absent', 'Late'
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
);

-- Initial Attendance Data
INSERT INTO attendance (student_id, date, status) VALUES 
(1, CURDATE(), 'Present'),
(1, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 'Present'),
(2, CURDATE(), 'Absent');
