-- ============================================================
--  Banking Database  —  DDL Script (T-SQL / SQL Server)
--  Database : SQL Server 2019+
--  Author   : Vamsi Akula
-- ============================================================


-- ============================================================
-- Creating Database
-- ============================================================
-- Dropping DB if it already exists --
USE master; 
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = N'BankingDB')
BEGIN
    ALTER DATABASE BankingDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BankingDB;
    PRINT 'Database(old) dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Database does not exist...skipping drop.';
END
GO

-- creating fresh database --
CREATE DATABASE BankingDB;
PRINT 'Database - BankingDB created successfully!!';
GO
USE BankingDB;
GO
-- =========================================
-- DDL Statements
-- =========================================
-- 1. Branch
-- =========================================
CREATE TABLE Branch
(
    BranchID        VARCHAR(25)  NOT NULL,
    BranchCode      CHAR(6)      NOT NULL,
    Branch_name     VARCHAR(50)  NOT NULL,
    PhoneNumber     CHAR(11)     NOT NULL,
    AddressLine     VARCHAR(200) NOT NULL,
    City            VARCHAR(50)  NOT NULL,
    State           VARCHAR(50)  NOT NULL,
    Country         VARCHAR(50)  NOT NULL,
    Email           VARCHAR(50)  NOT NULL,

    CONSTRAINT PK_Branch PRIMARY KEY (BranchID),
    CONSTRAINT UQ_Branch_BranchCode UNIQUE (BranchCode),
    CONSTRAINT UQ_Branch_PhoneNumber UNIQUE (PhoneNumber),
    CONSTRAINT UQ_Branch_Email UNIQUE (Email)
);
GO

-- =========================================
-- 2. Customer
-- =========================================
CREATE TABLE Customer
(
    CustomerID      VARCHAR(25)  NOT NULL,
    First_name      VARCHAR(50)  NOT NULL,
    Last_name       VARCHAR(50)  NOT NULL,
    Date_of_birth   DATE         NOT NULL,
    Gender          VARCHAR(20)  NULL,
    Email           VARCHAR(100) NOT NULL,
    Phone_number    VARCHAR(15)  NOT NULL,
    Address         VARCHAR(200) NOT NULL,
    City            VARCHAR(50)  NOT NULL,
    State           VARCHAR(20)  NOT NULL,
    Country         VARCHAR(20)  NOT NULL,
    ZipCode         VARCHAR(6)   NOT NULL,
    Status          VARCHAR(20)  NOT NULL,

    CONSTRAINT PK_Customer PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_Customer_Email UNIQUE (Email),
    CONSTRAINT UQ_Customer_Phone UNIQUE (Phone_number),
    CONSTRAINT CHK_Customer_Status CHECK (Status IN ('Active', 'Inactive', 'Blocked', 'Closed')),
    CONSTRAINT CHK_Customer_Gender CHECK (Gender IN ('Male', 'Female', 'Other') OR Gender IS NULL)
);
GO

-- =========================================
-- 3. Account
-- =========================================
CREATE TABLE Account
(
    AccountID       VARCHAR(25)  NOT NULL,
    Account_number  VARCHAR(18)  NOT NULL,
    Account_type    VARCHAR(10)  NOT NULL,
    Balance         DECIMAL(14,2) NOT NULL,
    Open_date       DATETIME     NOT NULL,
    Close_date      DATETIME     NULL,
    Status          VARCHAR(10)  NOT NULL,
    BranchID        VARCHAR(25)  NOT NULL,

    CONSTRAINT PK_Account PRIMARY KEY (AccountID),
    CONSTRAINT UQ_Account_AccountNumber UNIQUE (Account_number),
    CONSTRAINT FK_Account_Branch FOREIGN KEY (BranchID)
        REFERENCES Branch(BranchID),
    CONSTRAINT CHK_Account_Balance CHECK (Balance >= 0),
    CONSTRAINT CHK_Account_Status CHECK (Status IN ('Active', 'Closed', 'Frozen', 'Inactive')),
    CONSTRAINT CHK_Account_AccountType CHECK (Account_type IN ('Savings', 'Current', 'Salary')),
    CONSTRAINT CHK_Account_CloseDate CHECK (Close_date IS NULL OR Close_date >= Open_date)
);
GO

-- =========================================
-- 4. Employee
-- =========================================
CREATE TABLE Employee
(
    EmployeeID      VARCHAR(25)   NOT NULL,
    First_name      VARCHAR(50)   NOT NULL,
    Last_name       VARCHAR(50)   NOT NULL,
    Email           VARCHAR(100)  NOT NULL,
    Phone_number    VARCHAR(15)   NOT NULL,
    JobTitle        VARCHAR(30)   NOT NULL,
    Hire_date       DATE          NOT NULL,
    Salary          DECIMAL(10,2) NOT NULL,
    ManagerID       VARCHAR(25)   NULL,
    BranchID        VARCHAR(25)   NOT NULL,

    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT UQ_Employee_Email UNIQUE (Email),
    CONSTRAINT UQ_Employee_Phone UNIQUE (Phone_number),
    CONSTRAINT FK_Employee_Branch FOREIGN KEY (BranchID)
        REFERENCES Branch(BranchID),
    CONSTRAINT FK_Employee_Manager FOREIGN KEY (ManagerID)
        REFERENCES Employee(EmployeeID),
    CONSTRAINT CHK_Employee_Salary CHECK (Salary >= 0),
    CONSTRAINT CHK_Employee_NotSelfManager CHECK (ManagerID IS NULL OR ManagerID <> EmployeeID)
);
GO

-- =========================================
-- 5. Loan
-- =========================================
CREATE TABLE Loan
(
    LoanID          VARCHAR(25)   NOT NULL,
    CustomerID      VARCHAR(25)   NOT NULL,
    BranchID        VARCHAR(25)   NOT NULL,
    Loan_type       VARCHAR(20)   NOT NULL,
    [Description]   VARCHAR(MAX)  NULL,
    Loan_amount     DECIMAL(14,2) NOT NULL,
    Interest_rate   DECIMAL(5,2)  NOT NULL,
    Start_date      DATE          NOT NULL,
    End_date        DATE          NULL,
    Status          VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_Loan PRIMARY KEY (LoanID),
    CONSTRAINT FK_Loan_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT FK_Loan_Branch FOREIGN KEY (BranchID)
        REFERENCES Branch(BranchID),
    CONSTRAINT CHK_Loan_Amount CHECK (Loan_amount > 0),
    CONSTRAINT CHK_Loan_Interest CHECK (Interest_rate > 0),
    CONSTRAINT CHK_Loan_Status CHECK (Status IN ('Active', 'Closed', 'Defaulted', 'Pending')),
    CONSTRAINT CHK_Loan_LoanType CHECK (Loan_type IN ('Personal', 'Home', 'Auto', 'Education', 'Other')),
    CONSTRAINT CHK_Loan_EndDate CHECK (End_date IS NULL OR End_date >= Start_date)
);
GO

-- =========================================
-- 6. CustomerAccount (bridge table)
-- =========================================
CREATE TABLE CustomerAccount
(
    CustomerID      VARCHAR(25)  NOT NULL,
    AccountID       VARCHAR(25)  NOT NULL,
    OwnershipRole   VARCHAR(25)  NOT NULL,
    StartDate       DATE         NOT NULL,
    Status          VARCHAR(20)  NOT NULL,

    CONSTRAINT PK_CustomerAccount PRIMARY KEY (CustomerID, AccountID),
    CONSTRAINT FK_CustomerAccount_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT FK_CustomerAccount_Account FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID),
    CONSTRAINT CHK_CustomerAccount_Role CHECK (OwnershipRole IN ('Primary Holder', 'Joint Holder')),
    CONSTRAINT CHK_CustomerAccount_Status CHECK (Status IN ('Active', 'Inactive', 'Removed'))
);
GO

-- =========================================
-- 7. Card
-- =========================================
CREATE TABLE [Card]
(
    CardID          VARCHAR(25)   NOT NULL,
    CardNumber      VARCHAR(16)   NOT NULL,
    CustomerID      VARCHAR(25)   NOT NULL,
    AccountID       VARCHAR(25)   NOT NULL,
    CardType        VARCHAR(10)   NOT NULL,
    ExpiryDate      DATE          NOT NULL,
    IssueDate       DATE          NOT NULL,
    DailyLimit      DECIMAL(10,2) NOT NULL,
    Status          VARCHAR(10)   NOT NULL,

    CONSTRAINT PK_Card PRIMARY KEY (CardID),
    CONSTRAINT UQ_Card_CardNumber UNIQUE (CardNumber),
    CONSTRAINT FK_Card_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT FK_Card_Account FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID),
    CONSTRAINT CHK_Card_Type CHECK (CardType IN ('Debit', 'Credit')),
    CONSTRAINT CHK_Card_DailyLimit CHECK (DailyLimit >= 0),
    CONSTRAINT CHK_Card_Status CHECK (Status IN ('Active', 'Blocked', 'Expired', 'Inactive')),
    CONSTRAINT CHK_Card_Dates CHECK (ExpiryDate > IssueDate)
);
GO

-- =========================================
-- 8. LoanPayment
-- =========================================
CREATE TABLE LoanPayment
(
    PaymentID           VARCHAR(25)   NOT NULL,
    LoanID              VARCHAR(25)   NOT NULL,
    PaymentDate         DATE          NOT NULL,
    Amount              DECIMAL(14,2) NOT NULL,
    Payment_method      VARCHAR(20)   NOT NULL,
    Reference_number    VARCHAR(20)   NULL,
    Remarks             VARCHAR(MAX)  NULL,
    Status              VARCHAR(20)   NOT NULL,

    CONSTRAINT PK_LoanPayment PRIMARY KEY (PaymentID),
    CONSTRAINT FK_LoanPayment_Loan FOREIGN KEY (LoanID)
        REFERENCES Loan(LoanID),
    CONSTRAINT CHK_LoanPayment_Amount CHECK (Amount > 0),
    CONSTRAINT CHK_LoanPayment_Method CHECK (Payment_method IN ('Auto Debit', 'Cash', 'Cheque', 'Online Transfer')),
    CONSTRAINT CHK_LoanPayment_Status CHECK (Status IN ('Completed', 'Pending', 'Failed'))
);
GO

-- =========================================
-- 9. Transaction
-- =========================================
CREATE TABLE [Transaction]
(
    TxnID           VARCHAR(25)   NOT NULL,
    from_acct_id    VARCHAR(25)   NULL,
    to_acct_id      VARCHAR(25)   NULL,
    Txn_type        VARCHAR(20)   NOT NULL,
    Amount          DECIMAL(10,2) NOT NULL,
    Txn_date        DATETIME      NOT NULL,
    [Description]   VARCHAR(MAX)  NULL,
    Status          VARCHAR(10)   NOT NULL,
    Ref_num         VARCHAR(30)   NULL,

    CONSTRAINT PK_Transaction PRIMARY KEY (TxnID),
    CONSTRAINT FK_Transaction_FromAccount FOREIGN KEY (from_acct_id)
        REFERENCES Account(AccountID),
    CONSTRAINT FK_Transaction_ToAccount FOREIGN KEY (to_acct_id)
        REFERENCES Account(AccountID),
    CONSTRAINT CHK_Transaction_Amount CHECK (Amount > 0),
    CONSTRAINT CHK_Transaction_Status CHECK (Status IN ('Success', 'Pending', 'Failed', 'Reversed')),
    CONSTRAINT CHK_Transaction_Type CHECK (Txn_type IN ('Deposit', 'Withdrawal', 'Transfer', 'Fee Debit', 'Loan Auto Debit')),
    CONSTRAINT CHK_Transaction_Accounts CHECK (
        from_acct_id IS NOT NULL
        OR to_acct_id IS NOT NULL
    ),
    CONSTRAINT CHK_Transaction_DepositWithdrawalTransfer CHECK (
        (Txn_type = 'Deposit' AND from_acct_id IS NULL AND to_acct_id IS NOT NULL)
        OR
        (Txn_type = 'Withdrawal' AND from_acct_id IS NOT NULL AND to_acct_id IS NULL)
        OR
        (Txn_type IN ('Transfer', 'Fee Debit', 'Loan Auto Debit') AND from_acct_id IS NOT NULL)
    )
);
GO


