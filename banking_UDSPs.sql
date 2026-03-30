--=======================================
-- Open a new account
--=======================================
CREATE OR ALTER PROCEDURE dbo.usp_OpenAccount
    @AccountID        VARCHAR(25),
    @AccountNumber    VARCHAR(18),
    @AccountType      VARCHAR(10),
    @InitialBalance   DECIMAL(14,2),
    @OpenDate         DATETIME,
    @Status           VARCHAR(10),
    @BranchID         VARCHAR(25),
    @CustomerID       VARCHAR(25),
    @OwnershipRole    VARCHAR(25) = 'Primary Holder',
    @StartDate        DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Branch
            WHERE BranchID = @BranchID
        )
        BEGIN
            THROW 50001, 'Invalid BranchID.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Customer
            WHERE CustomerID = @CustomerID
        )
        BEGIN
            THROW 50002, 'Invalid CustomerID.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.Account
            WHERE AccountID = @AccountID
               OR Account_number = @AccountNumber
        )
        BEGIN
            THROW 50003, 'AccountID or Account number already exists.', 1;
        END;

        IF @InitialBalance < 0
        BEGIN
            THROW 50004, 'Initial balance cannot be negative.', 1;
        END;

        INSERT INTO dbo.Account
        (
            AccountID,
            Account_number,
            Account_type,
            Balance,
            Open_date,
            Close_date,
            Status,
            BranchID
        )
        VALUES
        (
            @AccountID,
            @AccountNumber,
            @AccountType,
            @InitialBalance,
            @OpenDate,
            NULL,
            @Status,
            @BranchID
        );

        INSERT INTO dbo.CustomerAccount
        (
            CustomerID,
            AccountID,
            OwnershipRole,
            StartDate,
            Status
        )
        VALUES
        (
            @CustomerID,
            @AccountID,
            @OwnershipRole,
            ISNULL(@StartDate, CAST(@OpenDate AS DATE)),
            'Active'
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO


--===========================================================
-- To add a customer to an existing account- for joint account
--===========================================================
CREATE OR ALTER PROCEDURE dbo.usp_AddCustomerToAccount
    @CustomerID      VARCHAR(25),
    @AccountID       VARCHAR(25),
    @OwnershipRole   VARCHAR(25),
    @StartDate       DATE,
    @Status          VARCHAR(20) = 'Active'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Customer
            WHERE CustomerID = @CustomerID
        )
        BEGIN
            THROW 50011, 'Invalid CustomerID.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Account
            WHERE AccountID = @AccountID
        )
        BEGIN
            THROW 50012, 'Invalid AccountID.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.CustomerAccount
            WHERE CustomerID = @CustomerID
              AND AccountID = @AccountID
        )
        BEGIN
            THROW 50013, 'Customer is already linked to this account.', 1;
        END;

        INSERT INTO dbo.CustomerAccount
        (
            CustomerID,
            AccountID,
            OwnershipRole,
            StartDate,
            Status
        )
        VALUES
        (
            @CustomerID,
            @AccountID,
            @OwnershipRole,
            @StartDate,
            @Status
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH
END;
GO



--======================================================================
-- MOney deposit- Deposits money, updates balance and saves transaction
--======================================================================
CREATE OR ALTER PROCEDURE dbo.usp_DepositMoney
    @TxnID           VARCHAR(25),
    @ToAccountID     VARCHAR(25),
    @Amount          DECIMAL(10,2),
    @TxnDate         DATETIME,
    @Description     VARCHAR(MAX) = NULL,
    @RefNum          VARCHAR(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF @Amount <= 0
        BEGIN
            THROW 50021, 'Deposit amount must be greater than 0.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Account
            WHERE AccountID = @ToAccountID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50022, 'Destination account is invalid or not active.', 1;
        END;

        UPDATE dbo.Account
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        INSERT INTO dbo.[Transaction]
        (
            TxnID,
            from_acct_id,
            to_acct_id,
            Txn_type,
            Amount,
            Txn_date,
            [Description],
            Status,
            Ref_num
        )
        VALUES
        (
            @TxnID,
            NULL,
            @ToAccountID,
            'Deposit',
            @Amount,
            @TxnDate,
            @Description,
            'Success',
            @RefNum
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH
END;
GO


--============================================================================
-- Withdraw money
-- This validates available balance, updates account, and records transaction.
--=============================================================================
CREATE OR ALTER PROCEDURE dbo.usp_WithdrawMoney
    @TxnID           VARCHAR(25),
    @FromAccountID   VARCHAR(25),
    @Amount          DECIMAL(10,2),
    @TxnDate         DATETIME,
    @Description     VARCHAR(MAX) = NULL,
    @RefNum          VARCHAR(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CurrentBalance DECIMAL(14,2);

    BEGIN TRY
        BEGIN TRAN;

        IF @Amount <= 0
        BEGIN
            THROW 50031, 'Withdrawal amount must be greater than 0.', 1;
        END;

        SELECT @CurrentBalance = Balance
        FROM dbo.Account
        WHERE AccountID = @FromAccountID
          AND Status = 'Active';

        IF @CurrentBalance IS NULL
        BEGIN
            THROW 50032, 'Source account is invalid or not active.', 1;
        END;

        IF @CurrentBalance < @Amount
        BEGIN
            THROW 50033, 'Insufficient balance.', 1;
        END;

        UPDATE dbo.Account
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        INSERT INTO dbo.[Transaction]
        (
            TxnID,
            from_acct_id,
            to_acct_id,
            Txn_type,
            Amount,
            Txn_date,
            [Description],
            Status,
            Ref_num
        )
        VALUES
        (
            @TxnID,
            @FromAccountID,
            NULL,
            'Withdrawal',
            @Amount,
            @TxnDate,
            @Description,
            'Success',
            @RefNum
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH
END;
GO



--=================================================================
-- Transfer money
--=================================================================
CREATE OR ALTER PROCEDURE dbo.usp_TransferMoney
    @TxnID             VARCHAR(25),
    @FromAccountID     VARCHAR(25),
    @ToAccountID       VARCHAR(25),
    @Amount            DECIMAL(10,2),
    @TxnDate           DATETIME,
    @Description       VARCHAR(MAX) = NULL,
    @RefNum            VARCHAR(30) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @FromBalance DECIMAL(14,2);

    BEGIN TRY
        BEGIN TRAN;

        IF @Amount <= 0
        BEGIN
            THROW 50041, 'Transfer amount must be greater than 0.', 1;
        END;

        IF @FromAccountID = @ToAccountID
        BEGIN
            THROW 50042, 'Source and destination accounts cannot be the same.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Account
            WHERE AccountID = @FromAccountID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50043, 'Source account is invalid or not active.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Account
            WHERE AccountID = @ToAccountID
              AND Status = 'Active'
        )
        BEGIN
            THROW 50044, 'Destination account is invalid or not active.', 1;
        END;

        SELECT @FromBalance = Balance
        FROM dbo.Account
        WHERE AccountID = @FromAccountID;

        IF @FromBalance < @Amount
        BEGIN
            THROW 50045, 'Insufficient balance for transfer.', 1;
        END;

        UPDATE dbo.Account
        SET Balance = Balance - @Amount
        WHERE AccountID = @FromAccountID;

        UPDATE dbo.Account
        SET Balance = Balance + @Amount
        WHERE AccountID = @ToAccountID;

        INSERT INTO dbo.[Transaction]
        (
            TxnID,
            from_acct_id,
            to_acct_id,
            Txn_type,
            Amount,
            Txn_date,
            [Description],
            Status,
            Ref_num
        )
        VALUES
        (
            @TxnID,
            @FromAccountID,
            @ToAccountID,
            'Transfer',
            @Amount,
            @TxnDate,
            @Description,
            'Success',
            @RefNum
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH
END;
GO

--===============================================
--	Record a loan payment
--================================================
CREATE OR ALTER PROCEDURE dbo.usp_RecordLoanPayment
    @PaymentID          VARCHAR(25),
    @LoanID             VARCHAR(25),
    @PaymentDate        DATE,
    @Amount             DECIMAL(14,2),
    @PaymentMethod      VARCHAR(20),
    @ReferenceNumber    VARCHAR(20) = NULL,
    @Remarks            VARCHAR(MAX) = NULL,
    @Status             VARCHAR(20) = 'Completed'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        BEGIN TRAN;

        IF @Amount <= 0
        BEGIN
            THROW 50051, 'Payment amount must be greater than 0.', 1;
        END;

        IF NOT EXISTS (
            SELECT 1
            FROM dbo.Loan
            WHERE LoanID = @LoanID
        )
        BEGIN
            THROW 50052, 'Invalid LoanID.', 1;
        END;

        IF EXISTS (
            SELECT 1
            FROM dbo.LoanPayment
            WHERE PaymentID = @PaymentID
        )
        BEGIN
            THROW 50053, 'PaymentID already exists.', 1;
        END;

        INSERT INTO dbo.LoanPayment
        (
            PaymentID,
            LoanID,
            PaymentDate,
            Amount,
            Payment_method,
            Reference_number,
            Remarks,
            Status
        )
        VALUES
        (
            @PaymentID,
            @LoanID,
            @PaymentDate,
            @Amount,
            @PaymentMethod,
            @ReferenceNumber,
            @Remarks,
            @Status
        );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;
    END CATCH
END;
GO

--sample usage
declare @currentdate datetime
set @currentdate = getdate();

EXEC dbo.usp_OpenAccount
    @AccountID = 'A100',
    @AccountNumber = '1000000000000100',
    @AccountType = 'Savings',
    @InitialBalance = 5000.00,
    @OpenDate = @currentdate,
    @Status = 'Active',
    @BranchID = 'B001',
    @CustomerID = 'C001',
    @OwnershipRole = 'Primary Holder'

select * from dbo.Account

declare @currentdate datetime
set @currentdate = getdate();
EXEC dbo.usp_AddCustomerToAccount
    @CustomerID = 'C002',
    @AccountID = 'A100',
    @OwnershipRole = 'Joint Holder',
    @StartDate = @currentdate;

select * from dbo.CustomerAccount

declare @currentdate datetime
set @currentdate = getdate();
EXEC dbo.usp_RecordLoanPayment
    @PaymentID = 'LP9001',
    @LoanID = 'L001',
    @PaymentDate = @currentdate,
    @Amount = 500.00,
    @PaymentMethod = 'Online Transfer',
    @ReferenceNumber = 'LOANREF9001',
    @Remarks = 'Monthly EMI',
    @Status = 'Completed';

select * from LoanPayment
where Reference_number = 'LOANREF9001'








