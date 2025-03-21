
create database banking_db;   					-- to database creation scritp

SELECT * FROM banking_db.cedit_debit;  			-- to show the table contains scritp

-- to find out the Total Amount with Group by Summary of Transction Type
SELECT 
    Transaction_Type, ROUND(SUM(Amount), 0) AS Total_Amount
FROM
    cedit_debit 
    where Transaction_Type="credit"
GROUP BY Transaction_Type;


--- to calculate Debit Amount
SELECT 
    Transaction_Type, ROUND(SUM(Amount), 0) AS Total_Amount
FROM
    cedit_debit 
    where Transaction_Type="Debit"
GROUP BY Transaction_Type;




--- to find the Net transaction
SELECT 
    ROUND(SUM(CASE
                WHEN Transaction_Type = 'Credit' THEN Amount
                WHEN Transaction_Type = 'Debit' THEN - Amount
                ELSE 0
            END),
            0) AS NetTransactionAmount
FROM
    cedit_debit;



--- to find the transaction RATIOS..

SELECT 
    round(SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END),0) AS TotalCredit,
    round(SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END),0) AS TotalDebit,
    CASE 
        WHEN SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END) = 0 THEN NULL
        ELSE round(round(SUM(CASE WHEN Transaction_Type = 'Credit' THEN Amount ELSE 0 END),0) / 
             round(SUM(CASE WHEN Transaction_Type = 'Debit' THEN Amount ELSE 0 END),0),3)
    END AS CreditDebitRatio
FROM cedit_debit;
-- to calculate Account Activity Ratio
select count(Customer_id) as total_count, sum(amount) as TotalAmount from cedit_debit;                        
with Account_summary as(
select sum(amount) as total_amountsum, count(Customer_Name)as customercount from cedit_debit)
Select 
total_amountsum,
customercount,
case
when customercount=0 then 0   -- avoid division of zero if total account no is zero
else (total_amountsum/customercount)
end as Acount_Activity_ratio
from Account_summary;


-- Total Transaction Amount By Branch wise

SELECT 
    Branch, SUM(amount) AS Branch_wise_transaction_volume
FROM
    cedit_debit
GROUP BY Branch;



-- Transaction over period of per day/week/month

SELECT 
    DATE(Transaction_Date) AS Transaction_day, sum(Amount),
    COUNT(*) AS transaction_count
FROM
    cedit_debit
GROUP BY DATE(Transaction_Date)
ORDER BY transaction_day;




-- month(Transaction_Date) as Month, Year

SELECT 
    year(Transaction_Date) AS Transaction_year,
    month(Transaction_Date) AS Transaction_month,sum(Amount),
    
    COUNT(*) AS transaction_count
FROM
    cedit_debit
GROUP BY month(Transaction_Date),year(Transaction_date)
ORDER BY transaction_month;





