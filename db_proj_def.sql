USE cs340_mayel;


DROP TABLE IF EXISTS `LOB`;
DROP TABLE IF EXISTS `Roles`;
DROP TABLE IF EXISTS `Operations`;
DROP TABLE IF EXISTS `Carriers`;
DROP TABLE IF EXISTS `Coverage`;
DROP TABLE IF EXISTS `Addresses`;
DROP TABLE IF EXISTS `Contacts`;
DROP TABLE IF EXISTS `Policies`;
DROP TABLE IF EXISTS `Staff`;
DROP TABLE IF EXISTS `Customers`;
DROP TABLE IF EXISTS `Acct_Assign`;
DROP TABLE IF EXISTS `Policy_Coverage`;

-- 
-- Table: Line of Business 
-- 
CREATE TABLE LOB (
	lob_id	SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	lob_type VARCHAR(25) NOT NULL,
	PRIMARY KEY (lob_id)
) ENGINE=InnoDB	DEFAULT CHARSET=utf8;

-- 
-- Table: Roles of staff (E.g. producer, account manager, underwriter, etc.)
-- 
CREATE TABLE Roles (
	role_id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
	role_title	VARCHAR(25) NOT NULL,
	PRIMARY KEY (role_id)
) ENGINE=InnoDB	DEFAULT CHARSET=utf8;

-- 
-- Table: Type of Business Operations (E.g. Manufacturing, Retail, Construction, Agriculture ...)
-- 
CREATE TABLE Operations (
	ops_code INT(11) UNSIGNED NOT NULL, 
	ops_desc VARCHAR(50) NOT NULL,
	PRIMARY KEY (ops_code)
) ENGINE=InnoDB	DEFAULT CHARSET=utf8;

-- 
-- Table: Carriers (Insurance Companies)
-- 
CREATE TABLE Carriers (
	carrier_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT, 
	carrier_name VARCHAR(35) NOT NULL,
	PRIMARY KEY (carrier_id)
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;


-- 
-- Table: Coverage Type - More specific identifiers of what coverage is included in policy.
-- Example would be a policy with property coverages could have Personal Property (coverage type), 
-- but not Building (coverage type). 
-- 
CREATE TABLE Coverage (
	covg_id INT(11) NOT NULL AUTO_INCREMENT,
	covg_type VARCHAR(100) NOT NULL,
	PRIMARY KEY (covg_id)
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;

-- 
-- Table: Addresses
-- 
CREATE TABLE Addresses (
	ad_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT, 
	address1 VARCHAR(50) DEFAULT NULL,
	address2 VARCHAR(50) DEFAULT NULL,
	city VARCHAR(50) NOT NULL, 
	county VARCHAR(50) DEFAULT NULL,
	sstate VARCHAR(3) NOT NULL,
	zip	VARCHAR(15) DEFAULT NULL,
	country	VARCHAR(30) NOT NULL,
	PRIMARY KEY (ad_id)
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;

-- 
-- Table: External Contacts (usually customers)
-- 
CREATE TABLE  Contacts (
	contact_id INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	acct_id	INT(11) UNSIGNED NOT NULL,
	fname VARCHAR(50) NOT NULL, 			
	lname VARCHAR(50),  
	title VARCHAR(50) DEFAULT NULL,
	email VARCHAR(50) DEFAULT NULL,
	phone VARCHAR(20) DEFAULT NULL,
	PRIMARY KEY (contact_id),
	KEY idx_fk_acct_id (acct_id),
	KEY idx_fname (fname)
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;


-- 
-- Table Customers - Synonymous with "Insured", "Account", "Client", which is  for 
-- 

CREATE TABLE Customers (
	cid INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	co_name	VARCHAR(50) NOT NULL,
	website VARCHAR(100) DEFAULT NULL,
	address_id INT(11) UNSIGNED NOT NULL,
	phone VARCHAR(20) NOT NULL,
	p_contact INT(10) UNSIGNED,
	op_type	INT(11) UNSIGNED,  
	op_desc TEXT,
	last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(cid),
	KEY idx_co_name (co_name),
	CONSTRAINT fk_address_id FOREIGN KEY (address_id) REFERENCES Addresses (ad_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_p_contact FOREIGN KEY (p_contact) REFERENCES Contacts (contact_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_op_type FOREIGN KEY (op_type) REFERENCES Operations (ops_code) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;

-- 
-- Table: Staff of Agency (E.g. agents, account mgrs, claims, auditing) 
-- 
CREATE TABLE Staff (
	staff_id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	fname VARCHAR(50) NOT NULL,
	lname VARCHAR(50) NOT NULL,
	role_id SMALLINT UNSIGNED NOT NULL,
	email VARCHAR(50) DEFAULT NULL,
	active BOOLEAN NOT NULL DEFAULT TRUE,
	last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (staff_id),  
	CONSTRAINT fk_role_id FOREIGN KEY (role_id) REFERENCES Roles (role_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;

-- 
-- Table: Account Assignment (M:N Relationship) - Assigns staff to customer accounts 
-- 
CREATE TABLE Acct_Assign (
	cid INT(11) UNSIGNED NOT NULL,
	sid INT(11) UNSIGNED NOT NULL,
	PRIMARY KEY (cid, sid),
	CONSTRAINT fk_ac_cid FOREIGN KEY (cid) REFERENCES Customers (cid) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_ac_aid FOREIGN KEY (sid) REFERENCES Staff (staff_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;


-- 
-- Table: Policies 
-- 
CREATE TABLE Policies (
	pid INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
	policy_no VARCHAR(20) NOT NULL,
	acct_id INT(11) UNSIGNED NOT NULL,
	lob_id SMALLINT UNSIGNED NOT NULL,
	premium DECIMAL(10, 2) NOT NULL,
	carrier_id	INT(11) UNSIGNED NOT NULL, 
	status VARCHAR(25) NOT NULL,
	i_date DATE NOT NULL,
	x_date DATE NOT NULL,
	last_update TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (pid),
	CONSTRAINT unique_p UNIQUE (policy_no, i_date),
	CONSTRAINT fk_acct_id_p FOREIGN KEY (acct_id) REFERENCES Customers (cid) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_p_lob_id FOREIGN KEY (lob_id) REFERENCES LOB (lob_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_carrier_id FOREIGN KEY (carrier_id) REFERENCES Carriers (carrier_id) ON DELETE RESTRICT ON UPDATE CASCADE
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;


-- 
-- Table: Policy Coverage (M:N Relationship) - Keeps track of what coverages each policy has
-- 
CREATE TABLE Policy_Coverage (
	pid INT(11) UNSIGNED,
	cvg_id INT(11),
	PRIMARY KEY (pid, cvg_id),
	CONSTRAINT fk_pc_pid FOREIGN KEY (pid) REFERENCES Policies (pid) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_pc_cvg FOREIGN KEY (cvg_id) REFERENCES Coverage (covg_id) ON DELETE CASCADE ON UPDATE CASCADE
)ENGINE=InnoDB	DEFAULT CHARSET=utf8;


