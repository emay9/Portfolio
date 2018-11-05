USE cs340_mayel;

INSERT INTO LOB (lob_type) VALUES ("Package"), ("Umbrella"), ("Work Comp"), ("Auto"), ("International"), ("Mono-Prop"), ("Mono-GL"), ("Product Liab."), ("K&R"), ("Exec. Risk");

INSERT INTO Roles (role_title) VALUES ("Producer"), ("Account Manager"), ("Billing"), ("Claims Manager"), ("Assistant"), ("Underwriter"), ("Loss Control");

INSERT INTO Operations VALUES (00001, "Agriculture"), (00010, "Mining"), (00015, "Construction"), (00020, "Manufacturing"), (00040, "Transportation & Communications"), (00050, "Wholesale Trade"), (00052, "Retail Trade"), (00060, "Finance, Insurance & RealEstate"), (00070, "Services"), (00091, "Public Administration");

INSERT INTO Carriers (carrier_name) VALUES ("Liberty Mutual"), ("Chubb"), ("AIG"), ("EMC"), ("Travelers"), ("Farmers"), ("Hanover"), ("Progressive"), ("Zurich"), ("Ace"), ("CNA"), ("SAIF"), ("Safeco"), ("Aetna"), ("Kaiser"), ("Allstate"), ("Allied"), ("Nationwide"), ("Mutual of Omaha"), ("QBE"), ("The Standard"),("Hartford"), ("GEICO"), ("Hancock");

INSERT INTO Coverage (covg_type) VALUES ("Building"), ("Personal Property"), ("Equipment"), ("Products Completed Operations"), ("Premise Liability"), ("Hired Non Owned"), ("Excess"), ("Products"), ("Crops"), ("Int'l Travel"), ("Storm"), ("Named Risk"), ("Liquor Liab"), ("Property Damage"), ("Bodily Injury"), ("All Risk"), ("Stated Risk"), ("Fraud"), ("Theft"), ("Errors & Omission "), ("Group Health Stuff - placeholder"),("Valuables");

INSERT INTO Addresses (address1, address2, city, county, sstate, zip, country) VALUES ("OSU Example 1","104 Kerr Admin Bldg # 1011", "Corvallis", "Benton", "OR", "97331", "USA"), ("OSU Example 2","104 Kerr Admin Bldg # 1011", "Corvallis", "Benton", "OR", "97331", "USA"), ("OSU Example 3","104 Kerr Admin Bldg # 1011", "Corvallis", "Benton", "OR", "97331", "USA"), ("OSU Example 4","104 Kerr Admin Bldg # 1011", "Corvallis", "Benton", "OR", "97331", "USA"), ("OSU Example 5","104 Kerr Admin Bldg # 1011", "Corvallis", "Benton", "OR", "97331", "USA");

INSERT INTO Customers (cid, co_name, website, address_id, phone, p_contact, op_type, op_desc) VALUES (NULL, 'ABC Company', 'abc.com', '1', '111-111-1111', NULL, '70', 'This company does something'), (NULL, 'XYZ Company', 'xyz.com', '2', '503-111-1111', NULL, '15', 'This company does nothing...');

INSERT INTO Staff (fname, lname, role_id) VALUES ('Wilford', 'Sorrell', 1), ('Elizabeth', 'Kaye', 2), ('Dante', 'Bolen', 3), ('Kyle', 'Landry', 1), ('Marna', 'Augusta', 2), ('Tatum', 'Quin', 4);

INSERT INTO Policies (policy_no, acct_id, lob_id, carrier_id, i_date, x_date, status, premium) VALUES 
('48437064', 1, 5, 1, '2017-05-01', '2018-09-01', 'Inforce', 500), 
('48174653', 2, 5, 2, '2017-09-01', '2018-09-01', 'Inforce', 5000),
('881C3851', 1, 5, 3, '2017-09-01', '2018-09-01', 'Inforce', 300),
('8C32151C', 2, 6, 4, '2016-07-01', '2017-06-01', 'Expired',2500),
('4255237C', 1, 7, 5, '2017-09-01', '2018-06-01', 'Inforce', 1500),
('41566785', 2, 3, 6, '2017-09-01', '2018-09-01', 'Inforce', 10000),
('6CCCA237', 1, 4, 7, '2017-09-01', '2018-09-01', 'Inforce', 2500);



INSERT INTO Acct_assign (cid, sid) VALUES (1, 1), (2, 1), (2, 2), (1, 4);


INSERT INTO Policy_Coverage (pid, cvg_id) VALUES ((SELECT pid FROM Policies WHERE policy_no = '41566785'), (SELECT covg_id FROM Coverage WHERE covg_type = 'Theft'));
