	
--TASK1

/* the business deals only in the eurozone, therefore the constraint on country_code */
CREATE TABLE country (
	country_code CHAR(2) PRIMARY KEY CHECK(country_code IN ('AT', 'BE', 'CY', 'EE', 'FI', 'FR', 'DE', 'GR', 'IE', 'IT', 'LV', 'LT', 'LU', 'MT', 'NL', 'PT', 'SK', 'SI', 'ES', 'HR')),
	country_name VARCHAR(30) UNIQUE NOT NULL
);

/* All phone numbers have the datatype VARCHAR(13) since most international numbers have 13 characters, but Dutch numbers have 12 characters */
CREATE TABLE partner (
	partner_id CHAR(6) PRIMARY KEY,
	company_name VARCHAR(30) NOT NULL,
	country_code CHAR(2),
	partner_email VARCHAR(20) UNIQUE CHECK (partner_email LIKE '%@%'),
	partner_phone VARCHAR(13) UNIQUE CHECK (partner_phone LIKE '+%'),
	FOREIGN KEY (country_code) REFERENCES country(country_code)
);


/* Customer can be a business or consumer in the Eurozone */
CREATE TABLE customer (
	customer_id CHAR(6) PRIMARY KEY,
	first_name VARCHAR(20) NOT NULL,
	last_name VARCHAR(20),
	email VARCHAR(20) UNIQUE CHECK (email LIKE '%@%'),
	customer_phone VARCHAR(13) UNIQUE CHECK (customer_phone LIKE '+%'),
	street VARCHAR(30),
	house_number VARCHAR(30),
	city VARCHAR(20),
	country_code CHAR(2), 
	FOREIGN KEY (country_code) REFERENCES country(country_code)
);



CREATE TABLE branch (
	branch_id CHAR(6) PRIMARY KEY,
	branch_name VARCHAR(30) UNIQUE,
	branch_email VARCHAR(20) UNIQUE CHECK (branch_email LIKE '%@%'),
	branch_phone VARCHAR(13) UNIQUE CHECK (branch_phone LIKE '+%'),
	country_code CHAR(2),
	FOREIGN KEY (country_code) REFERENCES country(country_code)
);


CREATE TABLE bill (
	bill_id CHAR(6) PRIMARY KEY,
	branch_id CHAR(6) NOT NULL,
	bill_date CHAR(10) NOT NULL CHECK (bill_date LIKE '__-__-____'),
	bill_amount INTEGER NOT NULL CHECK (bill_amount > 0),
	FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);


CREATE TABLE bill_customer (
	bill_id CHAR(6),
	customer_id CHAR(6),
	PRIMARY KEY (bill_id,customer_id),
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
	FOREIGN KEY (bill_id) REFERENCES bill(bill_id)
);


CREATE TABLE bill_partner (
	bill_id CHAR(6),
	partner_id CHAR(6),
	PRIMARY KEY (bill_id,partner_id),
	FOREIGN KEY (partner_id) REFERENCES partner(partner_id),
	FOREIGN KEY (bill_id) REFERENCES bill(bill_id)
);


CREATE TABLE product_bill_mapping (
	product_id CHAR(6),
	bill_id CHAR(6),
	product_quantity INTEGER NOT NULL CHECK (product_quantity > 0),
	PRIMARY KEY (product_id, bill_id, product_quantity),
	FOREIGN KEY (bill_id) REFERENCES bill(bill_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id)
);


CREATE TABLE product (
	product_id CHAR(6) PRIMARY KEY,
	product_name VARCHAR(20) NOT NULL, 
	product_price INTEGER NOT NULL CHECK (product_price > 0),
	product_category VARCHAR(20) CHECK (product_category IN ('FMCG', 'Construction', 'Automotive', 'Furniture', 'Electronics')),
	product_rating VARCHAR(20) CHECK (product_rating IN ('Positive', 'Negative', 'Neither'))
);


--VALUES


-- Countries
INSERT INTO country (country_code, country_name) VALUES
('DE', 'Germany'),
('FR', 'France'),
('IT', 'Italy'),
('ES', 'Spain'),
('NL', 'Netherlands'),
('BE', 'Belgium'),
('AT', 'Austria'),
('FI', 'Finland'),
('PT', 'Portugal'),
('IE', 'Ireland');


-- Partners (10)
INSERT INTO partner (partner_id, company_name, country_code, partner_email, partner_phone) VALUES
('P00001', 'AutoParts GmbH', 'DE', 'contact@ap.de', '+491234567890'),
('P00002', 'MaisonElectro SA', 'FR', 'info@me.fr', '+331234567891'),
('P00003', 'Mobili Italia SRL', 'IT', 'sales@mi.it', '+391234567892'),
('P00004', 'Iberica Foods', 'ES', 'contact@ib.es', '+341234567893'),
('P00005', 'DutchTech BV', 'NL', 'info@dt.nl', '+31634567894'),
('P00006', 'Brussels Steel', 'BE', 'sales@bs.be', '+321234567895'),
('P00007', 'Vienna Timber', 'AT', 'info@vt.at', '+431234567896'),
('P00008', 'Helsinki Paper', 'FI', 'sales@hp.fi', '+358123456789'),
('P00009', 'Lisboa Wines', 'PT', 'info@lw.pt', '+351123456789'),
('P00010', 'Dublin Textiles', 'IE', 'contact@dt.ie', '+353123456789');


-- Customers (20)
INSERT INTO customer (customer_id, first_name, last_name, email, customer_phone, street, house_number, city, country_code) VALUES
('C00001', 'Anna', 'Müller', 'anna.mueller@gmail.com', '+491111111111', 'Berliner Strasse', '10A', 'Berlin', 'DE'),
('C00002', 'Pierre', 'Dubois', 'pierre.dubois@orange.fr', '+331111111111', 'Rue de Rivoli', '5B', 'Paris', 'FR'),
('C00003', 'Luca', 'Rossi', 'luca.rossi@libero.it', '+391111111111', 'Via Roma', '22', 'Rome', 'IT'),
('C00004', 'Maria', 'Lopez', 'maria.lopez@hotmail.es', '+341111111111', 'Calle Mayor', '12', 'Madrid', 'ES'),
('C00005', 'Jan', 'Jansen', 'jan.jansen@kpn.nl', '+311111111111', 'Damrak', '30', 'Amsterdam', 'NL'),
('C00006', 'Sophie', 'Vermeer', 'sophie.vermeer@ziggo.nl', '+31611111112', 'Keizersgracht', '12', 'Amsterdam', 'NL'),
('C00007', 'Paul', 'Schmidt', 'paul.schmidt@yahoo.de', '+491111111112', 'Königsallee', '100', 'Düsseldorf', 'DE'),
('C00008', 'Laura', 'Meyer', 'laura.meyer@web.de', '+491111111113', 'Hauptstrasse', '3', 'Munich', 'DE'),
('C00009', 'Isabelle', 'Martin', 'isabelle.martin@sfr.fr', '+331111111113', 'Boulevard St.', '44', 'Lyon', 'FR'),
('C00010', 'Carlos', 'Garcia', 'carlos.garcia@telefonica.es', '+341111111112', 'Gran Via', '50', 'Barcelona', 'ES'),
('C00011', 'Joao', 'Silva', 'joao.silva@sapo.pt', '+351111111111', 'Avenida Liberdade', '88', 'Lisbon', 'PT'),
('C00012', 'Mika', 'Korhonen', 'mika.korhonen@elisa.fi', '+358111111111', 'Mannerheimintie', '60', 'Helsinki', 'FI'),
('C00013', 'Thomas', 'OConnor', 'thomas.oconnor@eir.ie', '+353111111111', 'OConnell St.', '5', 'Dublin', 'IE'),
('C00014', 'Claire', 'Dupont', 'claire.dupont@free.fr', '+331111111114', 'Avenue Victor Hugo', '8', 'Paris', 'FR'),
('C00015', 'Marco', 'Bianchi', 'marco.bianchi@tin.it', '+391111111112', 'Corso Italia', '77', 'Milan', 'IT'),
('C00016', 'Helena', 'Keller', 'helena.keller@aon.at', '+431111111111', 'Ringstrasse', '15', 'Vienna', 'AT'),
('C00017', 'Eva', 'Novak', 'eva.novak@gmx.at', '+431111111112', 'Mariahilfer Str.', '20', 'Vienna', 'AT'),
('C00018', 'Hans', 'Peters', 'hans.peters@gmx.de', '+491111111114', 'Goethestrasse', '55', 'Frankfurt', 'DE'),
('C00019', 'Luc', 'Declerck', 'luc.declerck@proximus.be', '+321111111111', 'Rue Neuve', '99', 'Brussels', 'BE'),
('C00020', 'Sanna', 'Virtanen', 'sanna.virtanen@saunalahti.fi', '+358111111112', 'Esplanadi', '23', 'Helsinki', 'FI'),
('C00021', 'Sophie', 'Termier', 'sophie.termier@ziggo.nl', '+31611101119', 'Keizersgracht', '18', 'Amsterdam', 'NL'),
('C00022', 'Raul', 'Schmitt', 'raul.schmitt@yahoo.de', '+491111011112', 'Königsallee', '10', 'Düsseldorf', 'DE'),
('C00023', 'Annie', 'Meyer', 'annie.meyer@web.de', '+491110111113', 'Hauptstrasse', '30', 'Munich', 'DE');



-- Branches (6)
INSERT INTO branch (branch_id, branch_name, branch_email, branch_phone, country_code) VALUES
('B00001', 'Berlin HQ', 'berlin@hq.de', '+491234111111', 'DE'),
('B00002', 'Paris Central', 'paris@hq.fr', '+331234111111', 'FR'),
('B00003', 'Rome Store', 'rome@hq.it', '+391234111111', 'IT'),
('B00004', 'Madrid Hub', 'madrid@hq.es', '+341234111111', 'ES'),
('B00005', 'Amsterdam Office', 'amsterdam@hq.nl', '+31634111111', 'NL'),
('B00006', 'Lisbon Branch', 'lisbon@hq.pt', '+351234111111', 'PT');


-- Bills (12)
INSERT INTO bill (bill_id, branch_id, bill_date, bill_amount) VALUES
('BL0001', 'B00001', '01-09-2025', 1200),
('BL0002', 'B00002', '02-09-2025', 2500),
('BL0003', 'B00003', '03-09-2025', 800),
('BL0004', 'B00004', '04-09-2025', 4500),
('BL0005', 'B00005', '05-09-2025', 1600),
('BL0006', 'B00006', '06-09-2025', 2100),
('BL0007', 'B00001', '07-09-2025', 900),
('BL0008', 'B00002', '08-09-2025', 3500),
('BL0009', 'B00003', '09-09-2025', 2200),
('BL0010', 'B00004', '10-09-2025', 1300),
('BL0011', 'B00005', '11-09-2025', 1900),
('BL0012', 'B00006', '12-09-2025', 2750);


-- Bill-Customer links
INSERT INTO bill_customer (bill_id, customer_id) VALUES
('BL0001', 'C00001'),
('BL0002', 'C00002'),
('BL0003', 'C00003'),
('BL0004', 'C00004'),
('BL0005', 'C00005'),
('BL0006', 'C00006');


-- Bill-Partner links
INSERT INTO bill_partner (bill_id, partner_id) VALUES
('BL0007', 'P00007'),
('BL0008', 'P00008'),
('BL0009', 'P00009'),
('BL0010', 'P00010'),
('BL0011', 'P00001'),
('BL0012', 'P00002');


-- Products (15)
INSERT INTO product (product_id, product_name, product_price, product_category, product_rating) VALUES
('PR0001','Laptop',1200,'Electronics','Positive'),
('PR0002','Chair',150,'Furniture','Positive'),
('PR0003','Cement Bag',10,'Construction','Neither'),
('PR0004','Car Tire',80,'Automotive','Positive'),
('PR0005','Shampoo',5,'FMCG','Negative'),
('PR0006','Smartphone',800,'Electronics','Positive'),
('PR0007','Table',200,'Furniture','Positive'),
('PR0008','TV',600,'Electronics','Positive'),
('PR0009','Paint Bucket',25,'Construction','Neither'),
('PR0010','Engine Oil',40,'Automotive','Positive'),
('PR0011','Sofa',700,'Furniture','Positive'),
('PR0012','Washing Machine',900,'Electronics','Positive'),
('PR0013','Bread',2,'FMCG','Positive'),
('PR0014','Drill',120,'Construction','Positive'),
('PR0015','Car Battery',150,'Automotive','Negative');


-- Product-Bill Mapping
INSERT INTO product_bill_mapping (product_id, bill_id, product_quantity) VALUES
('PR0001', 'BL0001', 10),
('PR0002', 'BL0002', 3),
('PR0003', 'BL0003', 5),
('PR0004', 'BL0004', 15),
('PR0005', 'BL0005', 2),
('PR0006', 'BL0006', 4),
('PR0007', 'BL0007', 1),
('PR0008', 'BL0008', 6),
('PR0009', 'BL0009', 2),
('PR0010', 'BL0010', 8),
('PR0011', 'BL0011', 3),
('PR0012', 'BL0012', 7),
('PR0013', 'BL0002', 1),
('PR0014', 'BL0005', 20),
('PR0015', 'BL0009', 4);


--TASK2

/* a) Find all bills together with the customer name and the branch name */

SELECT b.bill_id, b.bill_date, c.first_name, c.last_name, br.branch_name 
FROM bill AS b 
JOIN bill_customer AS bc ON b.bill_id = bc.bill_id 
JOIN customer AS c ON c.customer_id = bc.customer_id 
JOIN branch AS br ON br.branch_id = b.branch_id;

/* b) Find the total amount of all bills per branch. */

SELECT br.branch_name, SUM(b.bill_amount) AS total_sales 
FROM bill AS b 
JOIN branch AS br ON b.branch_id = br.branch_id 
GROUP BY br.branch_name;

/* c)Find customers who have spent more than the average bill amount. */

SELECT c.customer_id, c.first_name, c.last_name, SUM(b.bill_amount) AS total_spent 
FROM customer c 
JOIN bill_customer bc ON bc.customer_id = c.customer_id 
JOIN bill b ON b.bill_id = bc.bill_id 
GROUP BY c.customer_id 
HAVING total_spent > (SELECT AVG(bill_amount) FROM bill);