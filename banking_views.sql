--to see view definition
EXEC sp_helptext 'dbo.vw_ActiveAccounts';

--to list all views
SELECT name
FROM sys.views;

--==================================
--View showing Active customers
--===================================
GO
CREATE OR ALTER VIEW vw_active_customers
as(
SELECT
    c.CustomerID,c.First_name,c.Last_name,
    c.Date_of_birth,c.Gender,
    c.Email,c.Phone_number,
    c.Address,c.City,c.State,c.Country,c.ZipCode
FROM dbo.Customer AS c
WHERE c.Status = 'Active')
WITH CHECK OPTION;
GO

--select * from vw_active_customers

--==================================
--View showing Active accounts
--===================================
GO
CREATE OR ALTER VIEW dbo.vw_ActiveAccounts
WITH SCHEMABINDING, ENCRYPTION
AS
SELECT
    a.AccountID,a.Account_number,a.Account_type,
    a.Balance,a.Open_date,a.Close_date,a.BranchID
FROM dbo.Account AS a
WHERE a.Status = 'Active'
WITH CHECK OPTION;
GO

--==================================
--View showing Active loans
--===================================
GO
CREATE OR ALTER VIEW dbo.vw_ActiveLoans
WITH SCHEMABINDING, ENCRYPTION
AS
SELECT
    l.LoanID,l.CustomerID,l.BranchID,l.Loan_type,
    l.[Description],l.Loan_amount,l.Interest_rate,
    l.Start_date,l.End_date
FROM dbo.Loan AS l
WHERE l.Status = 'Active'
WITH CHECK OPTION;
GO
--select * from vw_ActiveLoans

--==================================
--View showing Active cards
--===================================
GO
CREATE OR ALTER VIEW dbo.vw_ActiveCards
WITH SCHEMABINDING, ENCRYPTION
AS
SELECT
    cd.CardID,cd.CardNumber,cd.CustomerID,
    cd.AccountID,cd.CardType,
	cd.ExpiryDate,
    cd.IssueDate,cd.DailyLimit
FROM dbo.Card AS cd
WHERE cd.Status = 'Active'
WITH CHECK OPTION;
GO

--==================================
--View showing Account summary
--===================================
GO
CREATE OR ALTER VIEW dbo.vw_CustomerAccountSummary
WITH SCHEMABINDING
AS
SELECT
    c.CustomerID,c.First_name,c.Last_name,
    a.AccountID,a.Account_number,a.Account_type,a.Balance,a.Status AS AccountStatus,
    ca.OwnershipRole,ca.StartDate,
    b.BranchID,b.Branch_name
FROM dbo.Customer AS c
INNER JOIN dbo.CustomerAccount AS ca
    ON c.CustomerID = ca.CustomerID
INNER JOIN dbo.Account AS a
    ON ca.AccountID = a.AccountID
INNER JOIN dbo.Branch AS b
    ON a.BranchID = b.BranchID;
GO

--select * from vw_CustomerAccountSummary;

--==================================
--View showing loan payment history
--===================================
GO
CREATE OR ALTER VIEW dbo.vw_LoanPaymentHistory
WITH SCHEMABINDING, ENCRYPTION
AS
SELECT
    l.LoanID,l.CustomerID,l.Loan_type,l.Loan_amount,
    lp.PaymentID,lp.PaymentDate,lp.Amount as [loan payment account],
	lp.Payment_method,
    lp.Reference_number,lp.Status AS PaymentStatus
FROM dbo.Loan AS l
INNER JOIN dbo.LoanPayment AS lp
    ON l.LoanID = lp.LoanID;
GO



