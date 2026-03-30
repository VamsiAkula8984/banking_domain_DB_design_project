/* =========================================
   INDEXES
========================================= */

-- Branch
CREATE INDEX IX_Branch_City
ON Branch (City);

-- Customer
CREATE INDEX IX_Customer_LastName_FirstName
ON Customer (Last_name, First_name);

CREATE INDEX IX_Customer_Status
ON Customer (Status);

-- Account
CREATE INDEX IX_Account_BranchID
ON Account (BranchID);

CREATE INDEX IX_Account_AccountType
ON Account (Account_type);

CREATE INDEX IX_Account_Status
ON Account (Status);

-- Employee
CREATE INDEX IX_Employee_BranchID
ON Employee (BranchID);

CREATE INDEX IX_Employee_ManagerID
ON Employee (ManagerID);

CREATE INDEX IX_Employee_JobTitle
ON Employee (JobTitle);

-- Loan
CREATE INDEX IX_Loan_CustomerID
ON Loan (CustomerID);

CREATE INDEX IX_Loan_BranchID
ON Loan (BranchID);

CREATE INDEX IX_Loan_Status
ON Loan (Status);

-- CustomerAccount
CREATE INDEX IX_CustomerAccount_AccountID
ON CustomerAccount (AccountID);

CREATE INDEX IX_CustomerAccount_Status
ON CustomerAccount (Status);

-- Card
CREATE INDEX IX_Card_CustomerID
ON Card (CustomerID);

CREATE INDEX IX_Card_AccountID
ON Card (AccountID);

CREATE INDEX IX_Card_Status
ON Card (Status);

-- LoanPayment
CREATE INDEX IX_LoanPayment_LoanID
ON LoanPayment (LoanID);

CREATE INDEX IX_LoanPayment_PaymentDate
ON LoanPayment (PaymentDate);

-- Transaction
CREATE INDEX IX_Transaction_FromAccount
ON [Transaction] (from_acct_id);

CREATE INDEX IX_Transaction_ToAccount
ON [Transaction] (to_acct_id);

CREATE INDEX IX_Transaction_TxnDate
ON [Transaction] (Txn_date);

CREATE INDEX IX_Transaction_TxnType
ON [Transaction] (Txn_type);