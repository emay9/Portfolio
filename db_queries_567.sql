USE cs340_mayel;

-- LOB Manipulation 
INSERT INTO LOB (lob_type) VALUES ('[input type]');

SELECT lob_id FROM LOB WHERE lob_type = '[type]';

UPDATE LOB 
SET lob_type = '[edited_type]'
WHERE lob_id = '[id]';

-- Roles Manipulation 
INSERT INTO Roles (role_title) VALUES ('[role type]');

SELECT role_id FROM Roles WHERE role_title = '[title]';

INSERT INTO Carriers (carrier_name) VALUES ('[insurance company name]');

-- Carriers 
-- Pick specific carrier 
SELECT carrier_name FROM Carriers WHERE carrier_id = '[carrier_id]';

-- Populate drop down menu of carriers. 
SELECT * FROM Carriers; 

-- Add new address 
INSERT INTO Addresses (address1, address2, city, county, sstate, zip, country) VALUES ('[address1]', '[address2]', '[city]', '[county]', '[state]', '[zip]', '[country]');
-- Before a user can complete create a new customer, an address will either need to be created or selected and the id returned. This will be a separate action but not noticable on the website. So the customer Update & Insert just reference an address id which the user will unknowningly have. 

SELECT ad_id FROM Addresses WHERE cid = '[Customer id]';

UPDATE Addresses
SET [whichever fields user edits on form] = '[user edits]'
WHERE ad_id = [address id];

-- OR cid = '[customer]
DELETE FROM Addresses WHERE cid = [customer id];

--Populate drop down table for operations info 
SELECT * FROM Operations; 

-- Populate LOB drop down 
SELECT * FROM LOB; 
-- Populate Staff Assignment Drop down 
SELECT staff_id, CONCAT(fname," ", lname) FROM Staff; 

-- Assign staff to account  (M:M relationship)
INSERT INTO Acct_Assign (cid, sid) VALUES ('[customer id]', '[staff id]');

co_name, website, address_id, phone, p_contact, op_type, op_desc

-- CUSTOMERS 
-- INSERT - since all foreign key references will be drop downs there is no need for complex inserts. 
INSERT INTO Customers (co_name, website, address_id, phone, p_contact, op_type, op_desc) VALUES ('[company name]', '[url]', '[address id]', '[phone no]', '[contact name]', '[op_id]', '[description]');

-- UPDATE : straight forward connection to right customer id 
UPDATE Customers
SET co_name = '[xxxx]', website = '[url]', address_id = '[id]', op_type =   
WHERE cid = '[customer id]';

-- DELETE : Techincally you should NOT be able to delete a customer as the data represents legal contracts with big impacts.  But if we were to allow it the query would be: 
DELETE FROM Customers WHERE cid = '[customer id]';

-- POLICIES 
-- INSERT & UPDATE -- again all foreign keys references will be handled by drop downs so this is a standard insert. 

UPDATE Policies 
SET [whichever fields are picked] = '[user input]'
WHERE pid = '[policy id]';

DELETE FROM Policies WHERE pid = '[policy id]'; 

-- Combined request to ask for all account info (customer & policy)
SELECT * FROM Policies p 
INNER JOIN Customers c ON c.cid = p.acct_id
INNER JOIN LOB l ON l.lob_id = p.lob_id 
INNER JOIN Carriers cr ON cr.carrier_id = p.carrier_id
INNER JOIN Addresses a ON a.ad_id = c.address_id
WHERE p.policy_no = '[policy number]' OR c.co_name = '[company name]';
-- This will be filling in a large page with many forms/cells so I don't actually want to limit the data. Sometime you want to know everything there is to know about an account. 


-- ADD Coverages to a Policy (M:M relationship)
-- After a policy is created, the user can add however many coverages they need to. Could be none, more likely one or two, but possible 5 to 10 or more. 
-- Note: I have a few ways to do this on the website. 1) Where the page already has the policy id and coverage id from drop down 2) where user can add coverage to a specific policy number without going into customer page which means you need to validate both policy_no and policy year because the policy_no could be the same each year. The pid is the unique primary key not the policy_no. 
 
INSERT INTO Policy_Coverage (pid, cvg_id) VALUES ((SELECT pid FROM Policies WHERE policy_no = '[policy number]' AND YEAR(i_date) = '[year]'), (SELECT covg_id FROM Coverage WHERE covg_type = '[type]'));

INSERT INTO Policy_Coverage (pid, cvg_id) VALUES ('[pid]', '[cid]'); 


-- DELETE M:M relationship Policy_Coverage
-- 1) delete 1 coverage from a policy
DELETE FROM Policy_Coverage 
WHERE pid IN (SELECT pid FROM Policies 
	WHERE policy_no = '[user inputs]' 
	AND YEAR(i_date) = '[user inputs year]')
AND cvg_id = (SELECT covg_id FROM Coverage WHERE covg_type = '[user inputs]');

-- 2) delete all coverages from a policy

DELETE FROM Policy_Coverage 
WHERE pid IN (SELECT pid FROM Policies 
	WHERE policy_no = '[user inputs]' 
	AND YEAR(i_date) = '[user inputs year]');

DELETE FROM Policy_Coverage WHERE pid = '[policy id]';
	
-- Options for Reports
-- not all of these may be used, but I am working to offer the website visitor options and these are what I am picking between. 

-- Premium Management
-- In order to manage work loads and business in general a typical report would be about premium. So I have a few potential queries.
-- Premium by Month For a Specific Year

SELECT MONTHNAME(i_date), SUM(premium) 
FROM Policies 
WHERE YEAR(i_date)= [user input]
GROUP BY MONTH(i_date);

-- Account Management 
-- Reports each customers current premium & number of policies. 
SELECT c.co_name AS 'Company', SUM(p.premium) AS 'Total Premium', COUNT(p.pid) AS 'No. Inforce Policies'
FROM Policies p INNER JOIN Customers c ON c.cid = p.acct_id 
WHERE p.status = 'Inforce'
GROUP BY p.acct_id ASC;

-- Staff Dashboard -- The information about all the active accounts (customer & policy info) a staff member is assigned. 

SELECT p.policy_no, c.co_name, l.lob_type, p.x_date, p.premium, p.status FROM Policies p 
INNER JOIN Customers c ON p.acct_id = c.cid 
INNER JOIN LOB l ON l.lob_id = p.lob_id 
WHERE c.cid IN ( SELECT a.cid FROM Acct_Assign a 
	INNER JOIN Staff s ON s.staff_id = a.sid 
	WHERE fname = '[user inputs name]' AND lname = '[user inputs name]' ) 
AND p.status = 'Inforce';

-- Similar to above, but this picks the accounts between a user determined time period. For example maybe the accounts between August 1, 2016 & August 31, 2017. 
SELECT p.policy_no, c.co_name, l.lob_type, p.x_date, p.premium, p.status 
FROM Policies p INNER JOIN customers c ON p.acct_id = c.cid 
INNER JOIN LOB l ON l.lob_id = p.lob_id 
WHERE cid IN ( 
	SELECT a.cid FROM Acct_Assign a 
	INNER JOIN Staff s ON s.staff_id = a.sid 
	WHERE fname = '[user inputs name]' AND lname = '[user inputs name]' ) 
AND p.x_date BETWEEN '[user input date]' AND '[user input date]';


--
-- Drop down list of producers (out of entire staff)
--
SELECT fname, lname FROM Staff
INNER JOIN Roles ON Roles.role_id = Staff.role_id
WHERE Roles.role_title = 'Producer'

--
-- Policy count by Carrier
--
SELECT carrier_name AS 'Insurance Company', COUNT(p.pid) AS 'Policy Count' FROM policies pid
INNER JOIN carriers c ON c.carrier_id = p.carrier_id
GROUP BY (carrier_name);
