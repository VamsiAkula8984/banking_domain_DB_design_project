-- showing all customers with their accounts
SELECT
    c.CustomerID,c.First_name,c.Last_name,
    a.AccountID,a.Account_number,a.Account_type,
    ca.OwnershipRole
FROM Customer c
JOIN CustomerAccount ca
    ON c.CustomerID = ca.CustomerID
JOIN Account a
    ON ca.AccountID = a.AccountID
ORDER BY c.CustomerID, a.AccountID;


--Joint accounts
SELECT
    a.AccountID,
    a.Account_number,
    COUNT(ca.CustomerID) AS NumberOfHolders
FROM Account a
JOIN CustomerAccount ca
    ON a.AccountID = ca.AccountID
GROUP BY a.AccountID, a.Account_number
HAVING COUNT(ca.CustomerID) > 1;


--customers with active loans
SELECT
    c.CustomerID,c.First_name,c.Last_name,
    l.LoanID,l.Loan_type,l.Loan_amount,l.Status
FROM Customer c
JOIN Loan l
    ON c.CustomerID = l.CustomerID
WHERE l.Status = 'Active'
ORDER BY c.CustomerID;


--loan payment history
SELECT
    l.LoanID,
    lp.PaymentID,
    lp.PaymentDate,
    lp.Amount,
    lp.Payment_method,
    lp.Status
FROM Loan l
JOIN LoanPayment lp
    ON l.LoanID = lp.LoanID
ORDER BY l.LoanID, lp.PaymentDate;


--Customers holding multiple cards--NO such customers
SELECT
    c.CustomerID,c.First_name,c.Last_name,
    COUNT(cd.CardID) AS CardCount
FROM Customer c
JOIN Card cd
    ON c.CustomerID = cd.CustomerID
GROUP BY c.CustomerID, c.First_name, c.Last_name
HAVING COUNT(cd.CardID) > 1;

--Employee count by branch
SELECT
    b.BranchID,
    b.Branch_name,
    COUNT(e.EmployeeID) AS EmployeeCount
FROM Branch b
LEFT JOIN Employee e
    ON b.BranchID = e.BranchID
GROUP BY b.BranchID, b.Branch_name
ORDER BY EmployeeCount DESC;

--Txns for a specific account
SELECT
    TxnID,from_acct_id,to_acct_id,Txn_type,Amount,Txn_date,Status
FROM [Transaction]
WHERE from_acct_id = 'A001'
   OR to_acct_id = 'A001'
ORDER BY Txn_date;





