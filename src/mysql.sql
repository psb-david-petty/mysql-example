# brew install mysql
# mysql.server start
# https://medium.com/@andrewpongco/solving-the-mysql-server-is-running-with-the-secure-file-priv-option-so-it-cannot-execute-this-d319de864285

#CREATE USER 'mysql'@'localhost' IDENTIFIED BY 'mysql';
#GRANT ALL PRIVILEGES ON *.* TO 'mysql'@'localhost';
#FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS test;
USE test;

DROP TABLE IF EXISTS pioneers;
CREATE TABLE pioneers (
    first_name VARCHAR(255) NULL,
    last_name VARCHAR(255) NOT NULL,
    gender CHAR(1) NOT NULL,
    first_year SMALLINT NOT NULL, 
    email_school VARCHAR(255) NOT NULL,
    email_gmail VARCHAR(255) NOT NULL
);

LOAD DATA INFILE '~/work/mysql-example/data/pioneers.computer.csv'
    INTO TABLE pioneers
    FIELDS TERMINATED BY ','
    ENCLOSED BY '"'
    LINES TERMINATED BY '\r\n'
    IGNORE 1 ROWS;

SHOW TABLES;
SHOW COLUMNS FROM pioneers;
SELECT * FROM pioneers WHERE gender = "F";

# http://zetcode.com/mysql/exportimport/
