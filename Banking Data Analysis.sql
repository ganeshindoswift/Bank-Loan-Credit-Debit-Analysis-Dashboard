create database SQLDBP1;

create table creddeb ( Customer_ID varchar(38),
Customer_Name varchar(30),
Account_Number int,
Transaction_Date date,
Transaction_Type varchar(10),
Amount decimal(10,2),
Balance decimal(10,2),
Description varchar(35),
Branch varchar(35),
Transaction_Method varchar(20),
Currency varchar(5),
Bank_Name varchar(30)
);

select * from creddeb;

create	table bankdb_analys ( State_Abbr varchar(6),
Account_ID varchar(10),
Age varchar(5),
BH_Name varchar(20),
Bank_Name varchar(15),
Branch_Name varchar(20),
Caste varchar(10),
Center_Id int1,
City varchar(10),
Client_id int1,
Client_Name varchar(20),
Close_Client varchar(3),
Closed_Date date,
Credit_Officer_Name varchar(20),
Dateof_Birth date,
Disb_By varchar(20),
Disbursement_Date date,
Disbursement_Date_Years date,
Gender_ID varchar(10),
Home_Ownership varchar(10),
Loan_Status varchar(10),
Loan_Transferdate varchar(5),
NextMeetingDate date,
Product_Code varchar(20),
Grrade varchar(20),
Sub_Grade varchar(20),
Product_Id varchar(10),
Purpose_Category varchar(20),
Region_Name varchar(20),
Religion varchar(20),
Verification_Status varchar(20) ,
State_Name varchar(20),
Tranfer_Logic varchar(10),
Is_Delinquent_Loan varchar(3),
Is_Default_Loan varchar(3),
Age_T int,
Delinq2_Yrs decimal,
Application_Type varchar(15),
Loan_Amount int1,
Funded_Amount int1,
Funded_Amount_Inv decimal(10,2),
Term varchar(10),
Int_Rate decimal(10,2),
Total_Pymnt decimal(10,2),
Total_Pymnt_inv decimal(10,2),
Total_Rec_Prncp decimal(10,2),
Total_Fees decimal(10,2),
Total_Rrec_int decimal(10,2),
Total_Rec_Late_fee decimal(10,2),
Recoveries decimal(10,2),
Collection_Recovery_fee decimal(10,2)
);

drop table bankdb;
drop table creddeb;
select * from creddeb;
select * from bankdb;


-- copy bankdbanalys
 -- COPY bankdb_analys
-- FROM 'D:\Final Project ExlR\Banking Project\Data\SQLDB\bankdbanalys.csv'
-- DELIMITER ','
-- CSV HEADER;

-- 1. Total Loan Amount Funded

SELECT 
    SUM(funded_amount) AS Total_Loan_Amount_Funded
FROM
    bankdb  ;
    
    
    
-- 2. Total Loans as per Activity( active & close ) operations
SELECT 
    Loan_Status,count(*) AS TotalLoanIssueCount,
    SUM(Loan_Amount) AS total_Loan
FROM
    bankdb
WHERE
    Loan_Status IN ('Active Loan' , 'fully paid')
GROUP BY Loan_Status;

-- 3. Total Collection
SELECT 
    
    SUM(Funded_amount+Total_Fees_ + Total_Rrec_int + Total_Rec_Late_Fee + Total_Fees_ + Recoveries + Collection_Recovery_fee) 
    
    AS TotalCollection

FROM
    
    bankdb;
    
-- 4. Total Interest Collection
SELECT 
    SUM(Total_Fees_ + Total_Rrec_int + Total_Rec_Late_Fee + Total_Fees_ + Recoveries + Collection_Recovery_fee) 
    
    AS TotalInterestCollection
    
FROM
    
    bankdb;    
    
    
-- 5. Total Branch wise Revenue Collection
SELECT 
    Branch_Name,
    SUM(Loan_Amount * Int_Rate) AS TotalInterestCollection
FROM
    bankdb
WHERE
    loan_status = 'Fully Paid'
GROUP BY Branch_Name;    
    
-- 6. State-Wise Loan
SELECT 
    State_Name, SUM(Loan_Amount) as total_loan
    
FROM
    bankdb
GROUP BY State_Name order by State_Name;

-- 7. Religion-Wise Loan
SELECT 
    Religion, SUM(Loan_Amount) as total_loan
FROM
    bankdb
GROUP BY Religion order by Religion;

-- 8. Product group-Wise Loan
SELECT 
    Product_Code,
    Purpose_Category,
    SUM(Loan_Amount) AS total_loan
FROM
    bankdb
WHERE
    Purpose_Category IN ('Services' , 'Home Loan','Agriculture','Business','Trade','Production','Washing Machine','Mobile Phone', 'Solar')
GROUP BY Product_Code , Purpose_Category
ORDER BY Product_Code DESC;

-- 10. Disbursement Trend
-- change date column to text column
alter table bankdb add column disbursement_date_new date;
set sql_safe_updates=0;
alter table bankdb 
change column disbursement_date disbursement_date_new date;
update bankdb set disbursement_date_new=case
when disbursement_date like '__/__/____' then str_to_date(disbursement_date, '%d/%m/%Y') -- dd/mm/yyyy
when disbursement_date like '__-__-____' then str_to_date(disbursement_date, '%d-%m-%Y') -- dd-mm-yyyy
when disbursement_date like '___-__-__' then str_to_date(disbursement_date, '%Y-%m-%d')  -- yyyy/mm/dd
else null
end;
alter table bankdb
drop column Disbursement_Date;
alter table bankdb 

change column disbursement_date_new disbursement_date date;

SELECT 
    DATE_FORMAT(disbursement_date, '%d-%m-%Y') AS disbursement_month,
    SUM(Loan_Amount) AS Total_disbursement
FROM
    bankdb
GROUP BY disbursement_month;




-- 8-Transaction Volume by Bank:



SELECT 
    Bank_Name, SUM(loan_Amount) AS Total_Amount
FROM
    bankdb
GROUP BY Bank_Name
ORDER BY Bank_Name DESC
LIMIT 5;

-- 9-Transaction Method Distribution:
select * from bankdb;
SELECT 
    Grrade, SUM(Loan_Amount) AS total_loanTransaction
FROM
    bankdb
WHERE
    Grrade IN ('A' , 'B', 'C', 'D')
        AND Loan_Amount < 10000
GROUP BY Grrade; 
