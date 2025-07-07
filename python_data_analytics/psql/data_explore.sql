-- Show table schema 
\d+ retail;

-- Q1: Show first 10 rows
SELECT * FROM retail limit 10;

-- Q2: Check # of records
SELECT COUNT(*) FROM RETAIL R ;

-- Q3: number of clients (e.g. unique client ID)
SELECT COUNT(DISTINCT R.CUSTOMER_ID) FROM RETAIL R ;


-- Q4: invoice date range (e.g. max/min dates)
SELECT MIN(INVOICE_DATE), MAX(INVOICE_DATE) FROM RETAIL;

    
-- Q5: number of SKU/merchants (e.g. unique stock code)
SELECT COUNT(DISTINCT STOCK_CODE) FROM RETAIL;

    
-- Q6: Calculate average invoice amount excluding invoices with a negative amount (e.g. canceled orders have negative amount)
SELECT
	AVG(INVOICE_AMOUNT) AS AVG
FROM
	(
	SELECT
		INVOICE_NO,
		SUM(UNIT_PRICE * QUANTITY) AS INVOICE_AMOUNT
	FROM
		RETAIL
	GROUP BY
		INVOICE_NO
	HAVING
		SUM(UNIT_PRICE * QUANTITY) > 0
	ORDER BY
		INVOICE_NO) AS INVOICE;
    
-- Q7: Calculate total revenue (e.g. sum of unit_price * quantity)
SELECT
		SUM(UNIT_PRICE * QUANTITY) AS REVENUE
FROM
		RETAIL
ORDER BY
		REVENUE;
    
-- Q8: Calculate total revenue by YYYYMM
SELECT
	TO_CHAR(INVOICE_DATE, 'YYYYMM') AS YYYYMM,
	SUM(UNIT_PRICE * QUANTITY )AS REVENUE
FROM
	RETAIL
GROUP BY
	YYYYMM
ORDER BY
	YYYYMM;
