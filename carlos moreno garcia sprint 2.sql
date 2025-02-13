#NIVEL 1 EJ 2

SELECT DISTINCT country from company;

-- corección 

USE transactions;

SELECT DISTINCT c.country
FROM company c
JOIN transaction t ON c.id = t.company_id;


SELECT COUNT(DISTINCT country)  AS cantidad_paises from company;

-- corección

USE transactions;

SELECT COUNT(DISTINCT c.country) AS total_paises
FROM company c
JOIN transaction t ON c.id = t.company_id;


SELECT company_name, ROUND(AVG(amount),2) AS media FROM transactions.transaction 
	JOIN company ON transaction.company_id = company.id
WHERE declined = 0 
GROUP BY company_name
ORDER BY media desc
LIMIT 1;



#NIVEL 1 EJ 3

Select * from transaction 
WHERE company_id IN (
					SELECT id 
                    from company 
                    WHERE country = 'Germany'
		    );

SELECT distinct company_name
FROM company, transaction
WHERE transaction.company_id = company.id  AND amount >(
								SELECT AVG(amount) 
								FROM transaction
							);

-- corrección 

SELECT *

FROM company
WHERE id IN (
SELECT DISTINCT company_id 
FROM transaction WHERE amount > (
				SELECT AVG(amount) FROM transaction)
				);

                       
SELECT id 
FROM company
WHERE id NOT IN (
						SELECT DISTINCT company_id
						FROM transaction
		);

-- ALTERNATIVA

SELECT company_name 
FROM company 
WHERE NOT EXISTS (
		SELECT * 
		FROM transaction t 
		WHERE t.company_id = company.id
		);
-- ____________________________________________________________________________________________________________________________________________________
#NIVEL 2 EJ 1 

SELECT date (timestamp) AS fecha, SUM(amount) AS total_ventas 
FROM transaction
	JOIN company ON transaction.company_id = company.id
WHERE declined = 0
group by 1
ORDER BY 2 desc
LIMIT 5;

-- CORRECCIÓN

SELECT DATE(timestamp) AS fecha_transaccion, SUM(amount) AS suma_cantidad
FROM transaction
GROUP BY fecha_transaccion
ORDER BY suma_cantidad DESC
LIMIT 5;


#NIVEL 2 EJ 2

SELECT country, ROUND(AVG(amount),2) AS mediaXpais #añdir round
from transaction t
	JOIN company c
	ON t.company_id = c.id
WHERE declined = 0
GROUP BY country
ORDER by mediaXpais desc;



#NIVEL 2 EJ 3 

#CON JOIN
SELECT * 
from company c
	JOIN transaction t
	ON c.id = t.company_id
WHERE company_name != 'Non Institute' AND country = (
								Select country from company
								WHERE company_name = 'Non Institute'
						    ); 

#SIN JOIN

SELECT transaction.*
FROM company, transaction
WHERE transaction.company_id = company.id
AND company_name != 'Non Institute'
AND country = (
        		Select country from company
			WHERE company_name = 'Non Institute' #excluir empresa igual que en paso anterior con otra subquery
	      );

-- CORECCIÓN

SELECT * 
FROM transaction
WHERE company_id IN (
		SELECT id 
		FROM company
		WHERE company_name != 'Non Institute'
		AND country = 
						(
						SELECT country 
						FROM company	
						WHERE company_name = 'Non Institute'
						)
		    );

#NIVEL 3 EJ 1 

SELECT company_name, phone, country, date (timestamp), amount FROM transaction
	JOIN company ON transaction.company_id = company.id
WHERE amount BETWEEN 100 and 200
AND DATE(timestamp) IN ('2021-04-29', '2021-07-20', '2022-03-13')
ORDER BY amount desc;

#NIVEL 3 EJ 2

SELECT company_name, COUNT(transaction.id) AS total_transacciones,
	CASE 
		WHEN COUNT(transaction.id) >= 4 THEN 'mayor o igual a 4'
		ELSE 'menos de 4'
	 END AS más_4_transacciones
from transaction
	JOIN company
ON transaction.company_id = company.id
GROUP BY 1
ORDER BY total_transacciones desc;

-- HACIENDO SUBQUERY

SELECT company_name,
	CASE 
	WHEN (SELECT COUNT(*) FROM transaction WHERE company_id = c.id) > 4
		THEN 'Más de 4 transacciones'
	ELSE 'Menos transacciones'
	END AS transaction_status
FROM company c;




