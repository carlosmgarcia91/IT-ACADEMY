-- SPRINT 4 
-- CREACIÓN DATABASE

CREATE DATABASE ventas;

USE ventas;


CREATE TABLE companies(
company_ID varchar(7),
company_name varchar (100),
phone varchar(15),
email varchar (100),
country varchar (50),
website varchar (80),
primary key(company_ID)
);

SELECT @@secure_file_priv; 


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv'
INTO TABLE companies
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;



create table credit_card (
ID varchar  	(10),
user_ID int     	,
IBAN varchar 	(50),
PAN varchar 	(50),
PIN varchar     	(4),
CVV varchar   	(3),
TRACK1 varchar (100),
TRACK2 varchar (100),
expiring_date varchar(30),
primary key (ID)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv'
INTO TABLE credit_card
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

create table products (
ID varchar              	(10),
product_name varchar 	(50),
price varchar          	(10),
colour varchar          	(20),
weight decimal (10,2),
warehouse_ID varchar 	(10),
primary key (ID)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


SET SQL_safe_updates = 0;

UPDATE products
SET
price = REPLACE (price, "$", " ");

SET SQL_safe_updates = 1;

ALTER TABLE products
MODIFY price float (10,2);

CREATE TABLE users (
	ID INT PRIMARY KEY,
	name VARCHAR(50),
	surname VARCHAR(50),
	phone VARCHAR(15),
	email VARCHAR(50),
	birth_date VARCHAR(20),
	country VARCHAR(20),
	city VARCHAR(50),
	postal_code VARCHAR(10),
	address VARCHAR(100)
);


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id, name, surname, phone, email, birth_date, country, city, postal_code, address);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id, name, surname, phone, email, birth_date, country, city, postal_code, address);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv'
INTO TABLE users
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(id, name, surname, phone, email, birth_date, country, city, postal_code, address);

ALTER TABLE credit_card
ADD FOREIGN KEY (user_ID) REFERENCES users(ID);

CREATE TABLE transaction (
ID varchar        	(100),
card_ID varchar  	(20),
business_ID varchar (10),
date timestamp,
amount decimal   	(10,2),
declined tinyint,
products varchar	(50),
user_ID int,
lat float,
longitude float,
PRIMARY KEY (ID)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ';'
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;


ALTER TABLE transaction
ADD FOREIGN KEY (card_ID) REFERENCES credit_card(id);


ALTER TABLE transaction
ADD FOREIGN KEY (business_ID) REFERENCES companies(company_ID);


ALTer table credit_card
drop constraint credit_card_ibfk_1;

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES users(ID);

-- Cambiar el formato de las columnas que están en varchar, conteniendo una fecha, para modificar el formato a date a posteriori. 

SET SQL_safe_updates = 0;

UPDATE users
SET birth_date = STR_TO_DATE(birth_date, '%M %d, %Y');

ALTER TABLE users
MODIFY birth_date date;

UPDATE credit_card
SET expiring_Date = DATE_FORMAT(STR_TO_DATE(expiring_date, '%m/%d/%y '), '%y-%m-%d');

-- El segundo cambio de formato es para dejarlo como dia-mes-año (paso posterior)

UPDATE credit_card
SET expiring_Date = DATE_FORMAT(STR_TO_DATE(expiring_date, '%y-%m-%d'), '%d-%m-%y');

ALTER TABLE credit_card
MODIFY expiring_date date;

SET SQL_safe_updates = 1;

-- _________________________________________________________________________________________________________________________________

-- EJERCICIOS 

USE ventas;

SELECT * 
FROM user
WHERE user.id IN (

					SELECT DISTINCT transactions.user_id
					FROM transactions
					GROUP BY transactions.user_id
					HAVING COUNT(transactions.id) > 30
                );
-- Con COALESCE, en caso de haber valores nulos en amount, los devolverá como 0. 

SELECT cc.IBAN, COALESCE(ROUND(AVG(t.amount),2), 0) AS media
FROM credit_card cc
	JOIN transaction t
    	ON cc.id = t.card_id
	JOIN companies c
    	ON t.business_ID = c.company_ID
WHERE company_name = 'Donec Ltd'
AND declined = 0
GROUP BY IBAN;


CREATE TABLE credit_card_estado AS
SELECT card_id, SUM(declined) AS suma_declinados,
	CASE
    	WHEN SUM(declined) = 3 THEN 'Tarjeta inactiva'
    	ELSE 'Tarjeta activa'
	END AS tarjeta_estado
FROM (
	SELECT card_id, business_ID, date, amount, declined,
    	ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY date DESC) AS numeroFila
	FROM
    	transaction
) AS ranked_transactions
WHERE
	numeroFila <= 3
GROUP BY
	card_id;
    

SELECT Count(card_id)
FROM credit_card_estado
WHERE tarjeta_Estado = lower('Tarjeta activa');


ALTER TABLE credit_card_estado
ADD PRIMARY KEY (card_id);

ALTER TABLE credit_card_estado
ADD FOREIGN KEY (card_id) REFERENCES credit_card(ID);


SET SQL_safe_updates = 0;


UPDATE transaction
SET products =  REPLACE(products, ' ', '');


SET SQL_safe_updates = 1;


CREATE TABLE  products_transactions (
transaction_id VARCHAR (100),
products_id varchar (10),
FOREIGN KEY (products_id) REFERENCES products (id),
FOREIGN KEY (transaction_id) REFERENCES transaction (id)
);


INSERT INTO products_transactions (transaction_id, products_id)
SELECT transaction.id AS transaction_id, products.id AS product_id
FROM transaction
JOIN products
	ON FIND_IN_SET(products.id, transaction.products) > 0;


SELECT product_name, COUNT(transaction_id) AS recuento_ventas_producto
FROM products_transactions pt
	JOIN products p
	ON pt.products_id = p.id
GROUP BY 1
ORDER BY recuento_ventas_producto asc;


