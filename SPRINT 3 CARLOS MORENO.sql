-- NIVEL I  
-- Ejercicio 1 

create table credit_card
(ID varchar (10),
IBAN varchar (34),
PAN varchar (25),
PIN varchar(4),
CVV varchar(3),
Expiring_Date varchar(10),
primary key (ID))
;

ALTER TABLE credit_card
MODIFY COLUMN id varchar(20); 

ALTER TABLE credit_card
MODIFY COLUMN IBAN varchar(50); 

ALTER TABLE credit_card
MODIFY COLUMN CVV int; 

ALTER TABLE credit_card
MODIFY COLUMN Expiring_Date varchar(20); 



-- Ejercicio 2 

UPDATE credit_card
SET IBAN = 'R323456312213576817699999'
WHERE ID = 'CcU-2938';





-- Ejercicio 3

INSERT INTO company (id) VALUES ('b-9999');

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
SELECT company_name, phone, country, ROUND(AVG(amount),2) As media
FROM transaction t
	JOIN company c ON t.company_id = c.id
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
RENAME date_user;

-- 	Añadir en la tabla user el ID 9999

INSERT INTO data_user (id) 
VALUES ('9999');

--  	Añadir la restricción con la tabla data_user

ALTER TABLE transaction
ADD FOREIGN KEY (user_id) REFERENCES data_user(id);

-- 	Añadir en la tabla credit_card el ID CcU-9999

INSERT INTO credit_card (id) 
VALUES ('CcU-9999');

-- 	Añadir la restricción con la tabla credit_card

ALTER TABLE transaction
ADD FOREIGN KEY (credit_card_id) REFERENCES credit_card(id);


-- Ejercicio 3 


CREATE VIEW 	InformeTecnico AS 
SELECT t.id AS ID_transaccion, ROUND (amount, 2) AS cantidad, timestamp AS fecha, 
declined AS declinado, du.name AS nombre_usuario, du.surname AS apellido_usuario, cc.IBAN, 
credit_card_id AS ID_tarjeta, company_name AS nombre_compañía, c.country AS pais
FROM company c 	
	JOIN transaction t  ON c.id = t.company_id
    JOIN credit_card cc ON t.credit_card_id = cc.id
    JOIN data_user du   ON t.user_id = du.id
ORDER BY ID_transaccion desc;










