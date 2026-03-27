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

CREATE TABLE Branch (
    BranchID        VARCHAR(25)  NOT NULL,
    BranchName      VARCHAR(50)  NOT NULL,
    IFSCCode        CHAR(11)     NOT NULL,
    AddressLine     VARCHAR(200) NULL,
    City            VARCHAR(50)  NULL,
    State           VARCHAR(50)  NULL,
    Country         VARCHAR(50)  NULL,
    ContactNumber   VARCHAR(15)  NULL,
    CONSTRAINT PK_Branch PRIMARY KEY (BranchID),
    CONSTRAINT UQ_Branch_IFSCCode UNIQUE (IFSCCode)
);

CREATE TABLE Customer (
    CustomerID      VARCHAR(25)  NOT NULL,
    FirstName       VARCHAR(50)  NOT NULL,
    LastName        VARCHAR(50)  NOT NULL,
    DateOfBirth     DATE         NULL,
    Gender          VARCHAR(20)  NULL,
    Email           VARCHAR(100) NULL,
    PhoneNumber     VARCHAR(15)  NULL,
    AddressLine     VARCHAR(200) NULL,
    City            VARCHAR(50)  NULL,
    State           VARCHAR(50)  NULL,
    Country         VARCHAR(50)  NULL,
    CreatedDate     DATETIME2    NOT NULL,
    CONSTRAINT PK_Customer PRIMARY KEY (CustomerID),
    CONSTRAINT UQ_Customer_Email UNIQUE (Email)
);

CREATE TABLE Employee (
    EmployeeID      VARCHAR(25)  NOT NULL,
    FirstName       VARCHAR(50)  NOT NULL,
    LastName        VARCHAR(50)  NOT NULL,
    Email           VARCHAR(100) NULL,
    PhoneNumber     VARCHAR(15)  NULL,
    RoleName        VARCHAR(30)  NOT NULL,
    HireDate        DATE         NOT NULL,
    Salary          DECIMAL(12,2) NOT NULL,
    BranchID        VARCHAR(25)  NOT NULL,
    CONSTRAINT PK_Employee PRIMARY KEY (EmployeeID),
    CONSTRAINT FK_Employee_Branch FOREIGN KEY (BranchID)
        REFERENCES Branch(BranchID),
	CONSTRAINT UQ_Employee_Email UNIQUE (Email)
);

CREATE TABLE Account (
    AccountID           VARCHAR(25)   NOT NULL,
    AccountNumber       VARCHAR(18)   NOT NULL,
    AccountType         VARCHAR(20)   NOT NULL,
    Balance             DECIMAL(14,2) NOT NULL,
    OpenDate            DATE          NOT NULL,
    Status              VARCHAR(20)   NOT NULL,
    CurrencyCode        CHAR(3)       NOT NULL,
    BranchID            VARCHAR(25)   NOT NULL,
    CONSTRAINT PK_Account PRIMARY KEY (AccountID),
    CONSTRAINT UQ_Account_AccountNumber UNIQUE (AccountNumber),
    CONSTRAINT FK_Account_Branch FOREIGN KEY (BranchID)
        REFERENCES Branch(BranchID),
	CONSTRAINT chk_account_type 
		CHECK(AccountType in ('Savings', 'Current', 'Checking')),
	CONSTRAINT chk_status 
		CHECK(Status in ('Active', 'Closed', 'Frozen'))
);

CREATE TABLE Loan (
    LoanID                  VARCHAR(25)   NOT NULL,
    LoanType                VARCHAR(20)   NOT NULL,
    LoanAmount              DECIMAL(14,2) NOT NULL,
    InterestRate            DECIMAL(5,2)  NOT NULL,
    StartDate               DATE          NOT NULL,
    EndDate                 DATE          NULL,
    Status                  VARCHAR(20)   NOT NULL,
    DisbursementAccountID   VARCHAR(25)   NULL,
    CONSTRAINT PK_Loan PRIMARY KEY (LoanID),
    CONSTRAINT FK_Loan_DisbursementAccount FOREIGN KEY (DisbursementAccountID)
        REFERENCES Account(AccountID),
	CONSTRAINT chk_loan_type 
		CHECK(LoanType in ('Home', 'Personal', 'Auto', 'Other')),
	CONSTRAINT chk_loan_status 
		CHECK(Status in ('Active', 'Closed', 'Defaulted'))
);

CREATE TABLE LoanPayment (
    PaymentID        VARCHAR(25)   NOT NULL,
    LoanID           VARCHAR(25)   NOT NULL,
    PaymentDate      DATETIME2     NOT NULL,
    Amount           DECIMAL(14,2) NOT NULL,
    PaymentMode      VARCHAR(20)   NOT NULL,
    Status           VARCHAR(20)   NOT NULL,
    CONSTRAINT PK_LoanPayment PRIMARY KEY (PaymentID),
    CONSTRAINT FK_LoanPayment_Loan FOREIGN KEY (LoanID)
        REFERENCES Loan(LoanID),
	CONSTRAINT chk_payment_mode 
		CHECK(PaymentMode in ('Cash', 'Online', 'Cheque', 'check'))
);

CREATE TABLE Card (
    CardID           VARCHAR(25)  NOT NULL,
    CardNumber       VARCHAR(16)  NOT NULL,
    CardType         VARCHAR(20)  NOT NULL,
    ExpiryDate       DATE         NOT NULL,
    IssueDate        DATE         NOT NULL,
    Status           VARCHAR(20)  NOT NULL,
    CONSTRAINT PK_Card PRIMARY KEY (CardID),
    CONSTRAINT UQ_Card_CardNumber UNIQUE (CardNumber),
    CONSTRAINT CK_Card_CardNumber_16Digits
        CHECK (LEN(CardNumber) = 16 AND CardNumber NOT LIKE '%[^0-9]%'),
	CONSTRAINT chk_card_type 
		CHECK(CardType in ('Debit', 'Credit')),
	CONSTRAINT chk_card_status
		CHECK(Status in ('Active', 'blocked', 'expired'))
);

CREATE TABLE Beneficiary (
    BeneficiaryID    VARCHAR(25)  NOT NULL,
    BeneficiaryName  VARCHAR(100) NOT NULL,
    AccountNumber    VARCHAR(18)  NOT NULL,
    BankName         VARCHAR(100) NOT NULL,
    IFSCCode         CHAR(11)     NOT NULL,
    AddedDate        DATETIME2    NOT NULL,
    CONSTRAINT PK_Beneficiary PRIMARY KEY (BeneficiaryID)
);

CREATE TABLE [Transaction] (
    TransactionID    VARCHAR(25)   NOT NULL,
    FromAccountID    VARCHAR(25)   NOT NULL,
    ToAccountID      VARCHAR(25)   NULL,
    TransactionType  VARCHAR(20)   NOT NULL,
    Amount           DECIMAL(14,2) NOT NULL,
    TransactionDate  DATETIME2     NOT NULL,
    Description      VARCHAR(255)  NULL,
    Status           VARCHAR(20)   NOT NULL,
    ReferenceNumber  VARCHAR(30)   NULL,
    CONSTRAINT PK_Transaction PRIMARY KEY (TransactionID),
    CONSTRAINT FK_Transaction_FromAccount FOREIGN KEY (FromAccountID)
        REFERENCES Account(AccountID),
    CONSTRAINT FK_Transaction_ToAccount FOREIGN KEY (ToAccountID)
        REFERENCES Account(AccountID)
);

-- Bridge tables

CREATE TABLE CustomerAccount (
    CustomerID        VARCHAR(25) NOT NULL,
    AccountID         VARCHAR(25) NOT NULL,
    CONSTRAINT PK_CustomerAccount PRIMARY KEY (CustomerID, AccountID),
    CONSTRAINT FK_CustomerAccount_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT FK_CustomerAccount_Account FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID)
);

CREATE TABLE CustomerLoan (
    CustomerID     VARCHAR(25) NOT NULL,
    LoanID         VARCHAR(25) NOT NULL,
    CONSTRAINT PK_CustomerLoan PRIMARY KEY (CustomerID, LoanID),
    CONSTRAINT FK_CustomerLoan_Customer FOREIGN KEY (CustomerID)
        REFERENCES Customer(CustomerID),
    CONSTRAINT FK_CustomerLoan_Loan FOREIGN KEY (LoanID)
        REFERENCES Loan(LoanID)
);

CREATE TABLE AccountCard (
    AccountID            VARCHAR(25) NOT NULL,
    CardID               VARCHAR(25) NOT NULL,
    IssuedToCustomerID   VARCHAR(25) NULL,
    CardHolderName       VARCHAR(100) NULL,
    IssueDate            DATE         NULL,
    CONSTRAINT PK_AccountCard PRIMARY KEY (AccountID, CardID),
    CONSTRAINT FK_AccountCard_Account FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID),
    CONSTRAINT FK_AccountCard_Card FOREIGN KEY (CardID)
        REFERENCES Card(CardID),
    CONSTRAINT FK_AccountCard_Customer FOREIGN KEY (IssuedToCustomerID)
        REFERENCES Customer(CustomerID)
);

CREATE TABLE AccountBeneficiary (
    AccountID        VARCHAR(25) NOT NULL,
    BeneficiaryID    VARCHAR(25) NOT NULL,
    AddedDate        DATETIME2   NOT NULL,
    NickName         VARCHAR(50) NULL,
    Status           VARCHAR(20) NOT NULL,
    CONSTRAINT PK_AccountBeneficiary PRIMARY KEY (AccountID, BeneficiaryID),
    CONSTRAINT FK_AccountBeneficiary_Account FOREIGN KEY (AccountID)
        REFERENCES Account(AccountID),
    CONSTRAINT FK_AccountBeneficiary_Beneficiary FOREIGN KEY (BeneficiaryID)
        REFERENCES Beneficiary(BeneficiaryID)
);



