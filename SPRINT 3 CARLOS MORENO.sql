-- NIVEL I  
-- Ejercicio 1 

create table credit_card
(ID varchar (20),
IBAN varchar (50),
PAN varchar (25),
PIN varchar(4),
CVV varchar(3),
Expiring_Date varchar(20),
primary key (ID))
;


-- Para crear la relación entre las tablas transaction y credit_card:

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_ID) REFERENCES credit_card(ID);



-- Ejercicio 2 

UPDATE credit_card
SET IBAN = 'R323456312213576817699999'
WHERE ID = 'CcU-2938';





-- Ejercicio 3

INSERT INTO company (id) VALUES ('b-9999');

INSERT INTO credit_card (id) VALUES ('CcU-9999');

INSERT INTO transaction (
id, credit_card_id, company_id, user_id, lat, longitude, amount, declined
)
VALUES (    
'108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', 9999, 829.999, -117.999, 111.11, 0
);

-- Ejercicio 4

ALTER TABLE credit_card
DROP COLUMN pan;

-- _____________________________________________________________________________________________________________________________________________


-- NIVEL II

-- Ejercicio 1

DELETE from transaction
WHERE id = ‘02C6201E-D90A-1859-B4EE-88D2986D3B02’;



-- Ejercicio 2 CREATE VIEW VistaMarketing AS
CREATE VIEW VistaMarketing AS
SELECT company_name, phone, country, COALESCE(ROUND(AVG(amount),2)) As media
FROM transaction t
	JOIN company c 
	ON t.company_id = c.id
WHERE t.declined = 0
GROUP BY company_name, phone, country
ORDER BY media desc;


-- Ejercicio 3

SELECT * FROM transactions.vistamarketing
WHERE country = 'Germany';

-- _____________________________________________________________________________________________________________________________________________



-- NIVEL III 

-- Ejercicio 1 

-- En la tabla company se elimina la fila “website”

ALTER TABLE company 
DROP website;

-- En la tabla credit card se ha añadido “fecha actual”

ALTER TABLE credit_card
ADD fecha_actual date;

-- 	La tabla user cambió el nombre a data_user:

ALTER TABLE user
RENAME data_user;

-- Cambiar email por personal_email

ALTER TABLE data_user
RENAME COLUMN email TO personal_email;

-- Cambiar CVV por int

Alter table credit_card
Modify CVV int;






-- Ejercicio 3 

CREATE VIEW InformeTecnico AS
SELECT t.id AS transaction_id, amount, timestamp AS date, declined, du.name, du.surname, cc.IBAN, credit_card_id, company_name, c.country
FROM company c
	JOIN transaction t  ON c.id = t.company_id
	JOIN credit_card cc ON t.credit_card_id = cc.id
	JOIN data_user  du 	ON t.user_id = du.id
ORDER BY transaction_id desc;










