/* =======================================================================
   Run below Delete statements only if you want to insert your data again
========================================================================== */
/*
DELETE FROM LoanPayment;
DELETE FROM [Transaction];
DELETE FROM Card;
DELETE FROM CustomerAccount;
DELETE FROM Loan;
DELETE FROM Employee;
DELETE FROM Account;
DELETE FROM Customer;
DELETE FROM Branch;
*/

/* =========================================
   BRANCH
========================================= */
INSERT INTO Branch (BranchID, BranchCode, Branch_name, PhoneNumber, AddressLine, City, State, Country, Email)
VALUES
('B001', 'BR0001', 'Downtown Branch', '11111111111', '101 Main St', 'Newark', 'NJ', 'USA', 'downtown@bank.com'),
('B002', 'BR0002', 'Uptown Branch',   '11111111112', '202 Oak Ave', 'Jersey City', 'NJ', 'USA', 'uptown@bank.com'),
('B003', 'BR0003', 'Midtown Branch',  '11111111113', '303 Pine Rd', 'Edison', 'NJ', 'USA', 'midtown@bank.com'),
('B004', 'BR0004', 'Westside Branch', '11111111114', '404 Elm St', 'Princeton', 'NJ', 'USA', 'westside@bank.com'),
('B005', 'BR0005', 'Eastside Branch', '11111111115', '505 Cedar Ln', 'Trenton', 'NJ', 'USA', 'eastside@bank.com');

/* =========================================
   CUSTOMER
========================================= */
INSERT INTO Customer
(CustomerID, First_name, Last_name, Date_of_birth, Gender, Email, Phone_number, Address, City, State, Country, ZipCode, Status)
VALUES
('C001','John','Smith','1990-01-15','Male','john.smith@email.com','9000000001','12 Park St','Newark','NJ','USA','07101','Active'),
('C002','Emma','Johnson','1992-03-20','Female','emma.johnson@email.com','9000000002','45 Lake Rd','Jersey City','NJ','USA','07302','Active'),
('C003','Liam','Brown','1988-07-11','Male','liam.brown@email.com','9000000003','78 Hill Ave','Edison','NJ','USA','08817','Active'),
('C004','Olivia','Davis','1995-11-02','Female','olivia.davis@email.com','9000000004','90 River Dr','Princeton','NJ','USA','08540','Active'),
('C005','Noah','Miller','1987-05-29','Male','noah.miller@email.com','9000000005','23 Sunset Blvd','Trenton','NJ','USA','08608','Active'),
('C006','Ava','Wilson','1993-09-13','Female','ava.wilson@email.com','9000000006','14 Broad St','Newark','NJ','USA','07102','Active'),
('C007','William','Moore','1985-02-22','Male','william.moore@email.com','9000000007','11 Chapel St','Jersey City','NJ','USA','07303','Active'),
('C008','Sophia','Taylor','1998-04-05','Female','sophia.taylor@email.com','9000000008','66 State St','Edison','NJ','USA','08818','Active'),
('C009','James','Anderson','1991-12-18','Male','james.anderson@email.com','9000000009','81 King St','Princeton','NJ','USA','08541','Active'),
('C010','Isabella','Thomas','1994-06-26','Female','isabella.thomas@email.com','9000000010','72 Queen St','Trenton','NJ','USA','08609','Active'),
('C011','Benjamin','Jackson','1989-08-15','Male','ben.jackson@email.com','9000000011','17 Green St','Newark','NJ','USA','07103','Active'),
('C012','Mia','White','1996-10-07','Female','mia.white@email.com','9000000012','29 Pearl St','Jersey City','NJ','USA','07304','Active'),
('C013','Lucas','Harris','1986-01-30','Male','lucas.harris@email.com','9000000013','83 Rose Ave','Edison','NJ','USA','08819','Inactive'),
('C014','Charlotte','Martin','1997-03-17','Female','charlotte.martin@email.com','9000000014','54 Birch Rd','Princeton','NJ','USA','08542','Active'),
('C015','Henry','Thompson','1990-05-08','Male','henry.thompson@email.com','9000000015','36 Willow Ln','Trenton','NJ','USA','08610','Blocked'),
('C016','Amelia','Garcia','1992-07-21','Female','amelia.garcia@email.com','9000000016','62 Spruce St','Newark','NJ','USA','07104','Active'),
('C017','Alexander','Martinez','1984-09-09','Male','alex.martinez@email.com','9000000017','93 Maple Dr','Jersey City','NJ','USA','07305','Active'),
('C018','Harper','Robinson','1999-11-25','Female','harper.robinson@email.com','9000000018','25 Highland Rd','Edison','NJ','USA','08820','Active'),
('C019','Daniel','Clark','1983-12-14','Male','daniel.clark@email.com','9000000019','48 Grove St','Princeton','NJ','USA','08543','Active'),
('C020','Evelyn','Rodriguez','1991-02-03','Female','evelyn.rodriguez@email.com','9000000020','59 Orchard Ave','Trenton','NJ','USA','08611','Active');

/* =========================================
   ACCOUNT
========================================= */
INSERT INTO Account
(AccountID, Account_number, Account_type, Balance, Open_date, Close_date, Status, BranchID)
VALUES
('A001','1000000000000001','Savings', 5200.00,'2023-01-10',NULL,'Active','B001'),
('A002','1000000000000002','Current',12800.00,'2023-02-15',NULL,'Active','B001'),
('A003','1000000000000003','Salary', 7600.00,'2023-03-18',NULL,'Active','B002'),
('A004','1000000000000004','Savings', 9100.00,'2023-04-12',NULL,'Active','B002'),
('A005','1000000000000005','Current',15000.00,'2023-05-20',NULL,'Active','B003'),
('A006','1000000000000006','Savings', 4300.00,'2023-06-11',NULL,'Active','B003'),
('A007','1000000000000007','Salary', 2200.00,'2023-07-01',NULL,'Active','B004'),
('A008','1000000000000008','Savings', 6800.00,'2023-07-22',NULL,'Active','B004'),
('A009','1000000000000009','Current',17250.00,'2023-08-05',NULL,'Active','B005'),
('A010','1000000000000010','Savings', 5400.00,'2023-08-17',NULL,'Active','B005'),
('A011','1000000000000011','Salary', 9900.00,'2023-09-09',NULL,'Active','B001'),
('A012','1000000000000012','Savings', 3100.00,'2023-09-28',NULL,'Active','B002'),
('A013','1000000000000013','Current',11200.00,'2023-10-14',NULL,'Active','B003'),
('A014','1000000000000014','Savings', 8700.00,'2023-11-03',NULL,'Active','B004'),
('A015','1000000000000015','Salary', 6400.00,'2023-11-19',NULL,'Active','B005');

/* =========================================
   CUSTOMERACCOUNT
========================================= */
INSERT INTO CustomerAccount
(CustomerID, AccountID, OwnershipRole, StartDate, Status)
VALUES
('C001','A001','Primary Holder','2023-01-10','Active'),
('C002','A002','Primary Holder','2023-02-15','Active'),
('C003','A003','Primary Holder','2023-03-18','Active'),
('C004','A004','Primary Holder','2023-04-12','Active'),
('C005','A005','Primary Holder','2023-05-20','Active'),
('C006','A006','Primary Holder','2023-06-11','Active'),
('C007','A007','Primary Holder','2023-07-01','Active'),
('C008','A008','Primary Holder','2023-07-22','Active'),
('C009','A009','Primary Holder','2023-08-05','Active'),
('C010','A010','Primary Holder','2023-08-17','Active'),
('C011','A011','Primary Holder','2023-09-09','Active'),
('C012','A012','Primary Holder','2023-09-28','Active'),
('C013','A013','Primary Holder','2023-10-14','Active'),
('C014','A014','Primary Holder','2023-11-03','Active'),
('C015','A015','Primary Holder','2023-11-19','Active'),

-- joint accounts
('C016','A001','Joint Holder','2023-02-01','Active'),
('C017','A005','Joint Holder','2023-06-01','Active'),
('C018','A009','Joint Holder','2023-08-20','Active'),
('C019','A010','Joint Holder','2023-09-01','Active'),
('C020','A015','Joint Holder','2023-12-01','Active');

/* =========================================
   EMPLOYEE
========================================= */
INSERT INTO Employee
(EmployeeID, First_name, Last_name, Email, Phone_number, JobTitle, Hire_date, Salary, ManagerID, BranchID)
VALUES
('E001','Robert','King','robert.king@bank.com','8000000001','Branch Manager','2021-01-10',90000,NULL,'B001'),
('E002','Nancy','Hall','nancy.hall@bank.com','8000000002','Cashier','2022-02-14',42000,'E001','B001'),
('E003','Steven','Allen','steven.allen@bank.com','8000000003','Loan Officer','2022-03-01',55000,'E001','B001'),

('E004','Karen','Young','karen.young@bank.com','8000000004','Branch Manager','2021-04-12',91000,NULL,'B002'),
('E005','Brian','Hernandez','brian.hernandez@bank.com','8000000005','Cashier','2022-05-15',41500,'E004','B002'),
('E006','Laura','Wright','laura.wright@bank.com','8000000006','Relationship Manager','2022-06-18',60000,'E004','B002'),

('E007','Jason','Lopez','jason.lopez@bank.com','8000000007','Branch Manager','2021-07-21',92000,NULL,'B003'),
('E008','Megan','Hill','megan.hill@bank.com','8000000008','Cashier','2022-08-11',41000,'E007','B003'),
('E009','Kevin','Scott','kevin.scott@bank.com','8000000009','Loan Officer','2022-09-23',56000,'E007','B003'),

('E010','Rachel','Green','rachel.green@bank.com','8000000010','Branch Manager','2021-10-02',90500,NULL,'B004'),
('E011','Eric','Adams','eric.adams@bank.com','8000000011','Cashier','2022-10-19',43000,'E010','B004'),
('E012','Diana','Baker','diana.baker@bank.com','8000000012','Service Rep','2022-11-27',47000,'E010','B004'),

('E013','Peter','Nelson','peter.nelson@bank.com','8000000013','Branch Manager','2021-12-05',91500,NULL,'B005'),
('E014','Samantha','Carter','samantha.carter@bank.com','8000000014','Cashier','2023-01-13',42500,'E013','B005'),
('E015','Chris','Mitchell','chris.mitchell@bank.com','8000000015','Loan Officer','2023-02-28',56500,'E013','B005');

/* =========================================
   LOAN
========================================= */
INSERT INTO Loan
(LoanID, CustomerID, BranchID, Loan_type, [Description], Loan_amount, Interest_rate, Start_date, End_date, Status)
VALUES
('L001','C001','B001','Personal','Personal emergency loan',12000.00,8.50,'2024-01-10','2026-01-10','Active'),
('L002','C003','B002','Auto','Used car loan',18000.00,7.25,'2024-02-15','2029-02-15','Active'),
('L003','C005','B003','Home','Home renovation loan',25000.00,6.80,'2024-03-01','2034-03-01','Active'),
('L004','C007','B004','Education','Masters tuition support',15000.00,5.90,'2024-03-22','2028-03-22','Active'),
('L005','C009','B005','Personal','Travel and family expenses',9000.00,9.10,'2024-04-14','2026-04-14','Active'),
('L006','C011','B001','Auto','New bike and accessories',7000.00,7.75,'2024-05-05','2027-05-05','Active'),
('L007','C013','B003','Other','Small business setup',30000.00,10.25,'2024-06-18','2029-06-18','Pending'),
('L008','C016','B001','Home','Apartment down payment support',40000.00,6.45,'2024-07-09','2034-07-09','Active');

/* =========================================
   LOANPAYMENT
========================================= */
INSERT INTO LoanPayment
(PaymentID, LoanID, PaymentDate, Amount, Payment_method, Reference_number, Remarks, Status)
VALUES
('LP001','L001','2024-02-10', 550.00,'Auto Debit','RLP001','EMI month 1','Completed'),
('LP002','L001','2024-03-10', 550.00,'Auto Debit','RLP002','EMI month 2','Completed'),
('LP003','L002','2024-03-15', 430.00,'Online Transfer','RLP003','First installment','Completed'),
('LP004','L002','2024-04-15', 430.00,'Online Transfer','RLP004','Second installment','Completed'),
('LP005','L003','2024-04-01', 725.00,'Cheque','RLP005','Initial payment','Completed'),
('LP006','L004','2024-04-22', 390.00,'Cash','RLP006','Counter payment','Completed'),
('LP007','L005','2024-05-14', 410.00,'Auto Debit','RLP007','EMI processed','Completed'),
('LP008','L006','2024-06-05', 300.00,'Online Transfer','RLP008','June payment','Completed'),
('LP009','L008','2024-08-09', 980.00,'Auto Debit','RLP009','Month 1 EMI','Completed'),
('LP010','L008','2024-09-09', 980.00,'Auto Debit','RLP010','Month 2 EMI','Completed');

/* =========================================
   CARD
========================================= */
INSERT INTO Card
(CardID, CardNumber, CustomerID, AccountID, CardType, ExpiryDate, IssueDate, DailyLimit, Status)
VALUES
('CD001','4000000000000001','C001','A001','Debit','2028-01-31','2024-01-31',2000.00,'Active'),
('CD002','4000000000000002','C016','A001','Debit','2028-02-15','2024-02-15',1500.00,'Active'),
('CD003','4000000000000003','C002','A002','Credit','2028-03-10','2024-03-10',5000.00,'Active'),
('CD004','4000000000000004','C003','A003','Debit','2028-04-05','2024-04-05',2500.00,'Active'),
('CD005','4000000000000005','C004','A004','Debit','2028-05-01','2024-05-01',1800.00,'Active'),
('CD006','4000000000000006','C005','A005','Credit','2028-05-20','2024-05-20',6000.00,'Active'),
('CD007','4000000000000007','C017','A005','Debit','2028-06-01','2024-06-01',2000.00,'Active'),
('CD008','4000000000000008','C006','A006','Debit','2028-06-22','2024-06-22',1500.00,'Blocked'),
('CD009','4000000000000009','C007','A007','Debit','2028-07-15','2024-07-15',1200.00,'Active'),
('CD010','4000000000000010','C008','A008','Credit','2028-08-09','2024-08-09',4500.00,'Active'),
('CD011','4000000000000011','C009','A009','Debit','2028-08-25','2024-08-25',3000.00,'Active'),
('CD012','4000000000000012','C018','A009','Debit','2028-09-03','2024-09-03',1800.00,'Active'),
('CD013','4000000000000013','C010','A010','Debit','2028-09-17','2024-09-17',2200.00,'Active'),
('CD014','4000000000000014','C019','A010','Credit','2028-09-30','2024-09-30',5500.00,'Active'),
('CD015','4000000000000015','C011','A011','Debit','2028-10-20','2024-10-20',2000.00,'Inactive');

/* =========================================
   TRANSACTION
========================================= */
INSERT INTO [Transaction]
(TxnID, from_acct_id, to_acct_id, Txn_type, Amount, Txn_date, [Description], Status, Ref_num)
VALUES
-- Deposits
('T001', NULL,  'A001','Deposit',    1000.00,'2024-01-12 09:15:00','Cash deposit','Success','RT001'),
('T002', NULL,  'A002','Deposit',    2000.00,'2024-01-13 10:00:00','Cheque deposit','Success','RT002'),
('T003', NULL,  'A003','Deposit',    1500.00,'2024-01-14 11:30:00','Salary credit','Success','RT003'),
('T004', NULL,  'A004','Deposit',     800.00,'2024-01-15 12:20:00','Cash deposit','Success','RT004'),
('T005', NULL,  'A005','Deposit',    2500.00,'2024-01-16 14:10:00','Online deposit','Success','RT005'),

-- Withdrawals
('T006', 'A001',NULL,'Withdrawal',    300.00,'2024-01-17 09:45:00','ATM withdrawal','Success','RT006'),
('T007', 'A002',NULL,'Withdrawal',    450.00,'2024-01-18 15:00:00','Cash withdrawal','Success','RT007'),
('T008', 'A003',NULL,'Withdrawal',    600.00,'2024-01-19 17:15:00','ATM withdrawal','Success','RT008'),
('T009', 'A004',NULL,'Withdrawal',    200.00,'2024-01-20 13:25:00','Cash withdrawal','Success','RT009'),
('T010', 'A005',NULL,'Withdrawal',    750.00,'2024-01-21 16:40:00','Branch withdrawal','Success','RT010'),

-- Transfers
('T011','A001','A006','Transfer',     500.00,'2024-02-01 10:10:00','Rent transfer','Success','RT011'),
('T012','A002','A007','Transfer',     700.00,'2024-02-02 11:45:00','Family transfer','Success','RT012'),
('T013','A003','A008','Transfer',     350.00,'2024-02-03 12:00:00','Utility transfer','Success','RT013'),
('T014','A004','A009','Transfer',     900.00,'2024-02-04 13:35:00','Vendor payment','Success','RT014'),
('T015','A005','A010','Transfer',    1200.00,'2024-02-05 14:20:00','Savings transfer','Success','RT015'),
('T016','A006','A011','Transfer',     250.00,'2024-02-06 15:10:00','Gift transfer','Success','RT016'),
('T017','A007','A012','Transfer',     430.00,'2024-02-07 16:00:00','Monthly support','Success','RT017'),
('T018','A008','A013','Transfer',     620.00,'2024-02-08 17:30:00','Investment funding','Success','RT018'),
('T019','A009','A014','Transfer',     510.00,'2024-02-09 09:05:00','Personal transfer','Success','RT019'),
('T020','A010','A015','Transfer',     275.00,'2024-02-10 10:40:00','Wallet transfer','Success','RT020'),

-- Fee Debit / Loan Auto Debit
('T021','A001',NULL,'Fee Debit',       25.00,'2024-02-11 08:00:00','Service charge','Success','RT021'),
('T022','A003',NULL,'Fee Debit',       18.00,'2024-02-12 08:00:00','SMS charge','Success','RT022'),
('T023','A005',NULL,'Loan Auto Debit',550.00,'2024-02-13 08:00:00','Loan EMI auto debit','Success','RT023'),
('T024','A009',NULL,'Loan Auto Debit',410.00,'2024-02-14 08:00:00','Loan EMI auto debit','Success','RT024'),
('T025','A011',NULL,'Fee Debit',       20.00,'2024-02-15 08:00:00','Card annual fee','Success','RT025');





