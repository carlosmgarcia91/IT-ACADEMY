#NIVEL 1 EJ 2

SELECT DISTINCT country from company;



SELECT COUNT(DISTINCT country)  AS cantidad_paises from company;

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


                       
SELECT id 
FROM company
WHERE id NOT IN (
						SELECT DISTINCT company_id
						FROM transaction
);
#NIVEL 2 EJ 1 

SELECT date (timestamp) AS fecha, SUM(amount) AS total_ventas 
FROM transaction
	JOIN company ON transaction.company_id = company.id
WHERE declined = 0
group by 1
ORDER BY 2 desc
LIMIT 5;



#NIVEL 2 EJ 2

SELECT country, ROUND(AVG(amount),2) AS mediaXpais #añdir round
from transaction
	JOIN company ON transaction.company_id = company.id
WHERE declined = 0
GROUP BY country
ORDER by mediaXpais desc;


#NIVEL 2 EJ 3 

#CON JOIN
SELECT * 
from company
	JOIN transaction ON company.id = transaction.company_id
WHERE company_name != 'Non Institute' AND country = (
													Select country from company
													WHERE company_name = 'Non Institute'); 

#SIN JOIN

SELECT transaction.*
FROM company, transaction
WHERE transaction.company_id = company.id
AND company_name != 'Non Institute'
AND country = (
        	Select country from company
			WHERE company_name = 'Non Institute' #excluir empresa igual que en paso anterior con otra subquery
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




