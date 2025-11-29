create database bank;
use bank;

select * from bank_loan_data;

-- Total Loan Applications
select count(id) as total_loan_application
from bank_loan_data;


-- MTD Loan Applications
SELECT COUNT(id) AS MTD_Total_Loan_Applications FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 12;


-- PMTD Loan Applications
SELECT COUNT(id) AS PMTD_Total_Loan_Applications FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 11;


-- Calculate MoM % Change in SQL
WITH cte_MOM AS (
    SELECT 
        YEAR(STR_TO_DATE(issue_date,'%d-%m-%Y')) AS year,
        MONTH(STR_TO_DATE(issue_date,'%d-%m-%Y')) AS month,
        COUNT(id) AS total_count
    FROM bank_loan_data
    GROUP BY year, month
)
SELECT 
    year,
    month,
    ROUND(
        (
            (total_count - LAG(total_count) OVER (ORDER BY year, month))
            / LAG(total_count) OVER (ORDER BY year, month)
        ) * 100
        , 2
    ) AS MOM_percentage
FROM cte_MOM;


-- Total Funded Amount
SELECT SUM(loan_amount) AS Total_Funded_Amount FROM bank_loan_data;
 
-- MTD Total Funded Amount
SELECT SUM(loan_amount) AS MTD_Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 12;
 
-- PMTD Total Funded Amount
SELECT SUM(loan_amount) AS PMTD_Total_Funded_Amount FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 11;

-- Month-over-Month (MoM) changes.
WITH cte_MOM AS (
    SELECT 
        YEAR(STR_TO_DATE(issue_date,'%d-%m-%Y')) AS year,
        MONTH(STR_TO_DATE(issue_date,'%d-%m-%Y')) AS month,
       SUM(loan_amount) AS total_amount
    FROM bank_loan_data
    GROUP BY year, month
)
SELECT 
    year,
    month,
    ROUND(
        (
            (total_amount - LAG(total_amount) OVER (ORDER BY year, month))
            / LAG(total_amount) OVER (ORDER BY year, month)
        ) * 100
        , 2
    ) AS MOM_percentage
FROM cte_MOM;


-- Total Amount Received
SELECT SUM(total_payment) AS Total_Amount_Collected FROM bank_loan_data;
 
-- MTD Total Amount Received
SELECT SUM(total_payment) AS MTD_Total_Amount_Collected FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 12;
 
-- PMTD Total Amount Received
SELECT SUM(total_payment) AS PMTD_Total_Amount_Collected FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 11;


-- Average Interest Rate
SELECT round(AVG(int_rate)* 100,2)  AS Avg_Int_Rate FROM bank_loan_data;
 
 
-- MTD Average Interest
SELECT ROUND(AVG(int_rate)*100 ,2) AS MTD_Avg_Int_Rate FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 12;
 
 
-- PMTD Average Interest
SELECT ROUND(AVG(int_rate)*100 ,2) AS PMTD_Avg_Int_Rate FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 11;


-- Avg DTI
SELECT ROUND(AVG(dti),4)*100 AS Avg_DTI FROM bank_loan_data;
 
-- MTD Avg DTI
SELECT AVG(dti)*100 AS MTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 12;
 
-- PMTD Avg DTI
SELECT AVG(dti)*100 AS PMTD_Avg_DTI FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 11;


-- GOOD LOAN ISSUED

-- Good Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Fully Paid' OR loan_status = 'Current' THEN id END) * 100.0) / 
	COUNT(id) AS Good_Loan_Percentage
FROM bank_loan_data;
 
 
-- Good Loan Applications
SELECT COUNT(id) AS Good_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
 
 
-- Good Loan Funded Amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';
 

-- Good Loan Amount Received
SELECT SUM(total_payment) AS Good_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Fully Paid' OR loan_status = 'Current';



-- BAD LOAN ISSUED
-- Bad Loan Percentage
SELECT
    (COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0) / 
	COUNT(id) AS Bad_Loan_Percentage
FROM bank_loan_data;
 

-- Bad Loan Applications
SELECT COUNT(id) AS Bad_Loan_Applications FROM bank_loan_data
WHERE loan_status = 'Charged Off';
 

-- Bad Loan Funded Amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_amount FROM bank_loan_data
WHERE loan_status = 'Charged Off';
 

-- Bad Loan Amount Received
SELECT SUM(total_payment) AS Bad_Loan_amount_received FROM bank_loan_data
WHERE loan_status = 'Charged Off';


-- LOAN STATUS
SELECT
	loan_status,
	COUNT(id) AS LoanCount,
	SUM(total_payment) AS Total_Amount_Received,
	SUM(loan_amount) AS Total_Funded_Amount,
	AVG(int_rate * 100) AS Interest_Rate,
	AVG(dti * 100) AS DTI
FROM
	bank_loan_data
GROUP BY
	loan_status;
 

SELECT 
	loan_status, 
	SUM(total_payment) AS MTD_Total_Amount_Received, 
	SUM(loan_amount) AS MTD_Total_Funded_Amount 
FROM bank_loan_data
WHERE MONTH(str_to_date(issue_date,'%d-%m-%Y')) = 12 
GROUP BY loan_status;


-- B.	BANK LOAN REPORT | OVERVIEW
-- MONTH
SELECT 
    MONTH(STR_TO_DATE(issue_date, '%d-%m-%Y')) AS Month_Number,
    MONTHNAME(STR_TO_DATE(issue_date, '%d-%m-%Y')) AS Month_Name,
    COUNT(id) AS Total_Loan_Applications,
    SUM(loan_amount) AS Total_Funded_Amount,
    SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY Month_Number, Month_Name
ORDER BY Month_Number;


-- STATE
SELECT 
	address_state AS State, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY address_state
ORDER BY address_state;

-- TERM
SELECT 
	term , 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY term
ORDER BY term;

-- EMPLOYEE LENGTH
SELECT 
	emp_length , 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY emp_length
ORDER BY emp_length;


-- PURPOSE
SELECT 
	purpose, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY purpose
ORDER BY purpose;


-- HOME OWNERSHIP
SELECT 
	home_ownership , 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
GROUP BY home_ownership
ORDER BY home_ownership;

-- when we hit the Grade A in the filters 
SELECT 
	purpose AS PURPOSE, 
	COUNT(id) AS Total_Loan_Applications,
	SUM(loan_amount) AS Total_Funded_Amount,
	SUM(total_payment) AS Total_Amount_Received
FROM bank_loan_data
WHERE grade = 'A'
GROUP BY purpose
ORDER BY purpose;









