##	ASSIGNMENT DAY 3

USE `classicmodels`;
show tables;

##		1)	Show customer number, customer name, state and credit limit from customers table for below conditions. 
##		Sort the results by highest to lowest values of creditLimit.

##		●	State should not contain null values
## 		●	credit limit should be between 50000 and 100000


select `customerNumber`, `customerName`, `state`, `creditLimit`
from customers
where `state` is not null 
and `creditlimit` between 50000 and 100000
order by `creditlimit` desc;


##		2)	Show the unique productline values containing the word cars at the end from products table.

select distinct productline 
from products
where productline like '%cars';



##	ASSIGNMENTS DAY 4

USE `classicmodels`;
show tables;


##		1)	Show the orderNumber, status and comments from orders table for shipped status only. 
##		If some comments are having null values then show them as “-“.

SELECT orderNumber, status, COALESCE(comments, '-') AS comments
FROM orders
WHERE status = 'Shipped';


##		2)	Select employee number, first name, job title and job title abbreviation from employees table based on following conditions.
##		If job title is one among the below conditions, then job title abbreviation column should show below forms.
##		●	President then “P”
##		●	Sales Manager / Sale Manager then “SM”
##		●	Sales Rep then “SR”
##		●	Containing VP word then “VP”


SELECT employeeNumber, firstName, jobTitle,
    CASE
        WHEN jobTitle = 'President' THEN 'P'
        WHEN jobTitle LIKE '%Sales Manager%' THEN 'SM'
        WHEN jobTitle = 'Sales Rep' THEN 'SR'
        WHEN jobTitle LIKE '%VP%' THEN 'VP'
        ELSE jobTitle -- Default to the original job title if none of the conditions match
    END AS jobTitleAbbreviation
FROM employees;



##	ASSIGNMENT DAY 5

USE `classicmodels`;
show tables;


##		1)	For every year, find the minimum amount value from payments table.

SELECT YEAR(paymentDate) AS paymentYear, MIN(amount) AS minimumAmount
FROM payments
GROUP BY paymentYear
ORDER BY paymentYear;


##		2)	For every year and every quarter, find the unique customers and total orders from orders table. 
##		Make sure to show the quarter as Q1,Q2 etc.

SELECT YEAR(orderdate) AS Year,
    CONCAT('Q', QUARTER(orderdate)) AS Quarter,
    COUNT(DISTINCT (CustomerNumber)) AS UniqueCustomers,
    COUNT(*) AS TotalOrders
FROM orders
GROUP BY Year, Quarter
ORDER BY Year, Quarter;


##		3)	Show the formatted amount in thousands unit (e.g. 500K, 465K etc.) for every month (e.g. Jan, Feb etc.) with filter on total amount as 500000 to 1000000. 
##		Sort the output by total amount in descending mode. [ Refer. Payments Table]

select monthname(paymentdate) as months, concat(format(sum(amount)/1000,0),"k") as fromated_amount  from payments group by months
having fromated_amount between 500 and 1000 order by fromated_amount desc;
  
  
  ##	ASSIGNMENT DAY 6
  
  USE `classicmodels`;
show tables;


##		1)	Create a journey table with following fields and constraints.
##		●	Bus_ID (No null values)
##		●	Bus_Name (No null values)
##		●	Source_Station (No null values)
##		●	Destination (No null values)
##		●	Email (must not contain any duplicates)


CREATE TABLE journey 
	(Bus_ID INT NOT NULL,
    Bus_Name VARCHAR(255) NOT NULL,
    Source_Station VARCHAR(255) NOT NULL,
    Destination VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    PRIMARY KEY (Bus_ID));
desc journey;


##		2)	Create vendor table with following fields and constraints.
##		●	Vendor_ID (Should not contain any duplicates and should not be null)
##		●	Name (No null values)
##		●	Email (must not contain any duplicates)
##		●	Country (If no data is available then it should be shown as “N/A”)


CREATE TABLE vendor 
	(Vendor_ID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE,
    Country VARCHAR(255) DEFAULT 'N/A');
desc vendor;


##		3)	Create movies table with following fields and constraints.
##		●	Movie_ID (Should not contain any duplicates and should not be null)
##		●	Name (No null values)
##		●	Release_Year (If no data is available then it should be shown as “-”)
##		●	Cast (No null values)
##		●	Gender (Either Male/Female)
##		●	No_of_shows (Must be a positive number)


CREATE TABLE movies (
    Movie_ID INT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Release_Year INT,
    Cast VARCHAR(255) NOT NULL,
    Gender ENUM('Male', 'Female'),
    No_of_shows INT CHECK (No_of_shows > 0));
desc movies;

##		4)	Create the following tables. Use auto increment wherever applicable

##		b. Suppliers
##		✔	supplier_id - primary key
##		✔	supplier_name
##		✔	location

-- Suppliers Table
CREATE TABLE Suppliers 
	(supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(255),
    location VARCHAR(255));
desc suppliers;


##		a. Product
##		✔	product_id - primary key
##		✔	product_name - cannot be null and only unique values are allowed
##		✔	description
##		✔	supplier_id - foreign key of supplier table

-- Product Table
CREATE TABLE Product 
	(product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id));
desc product;

##		c. Stock
##		✔	id - primary key
##		✔	product_id - foreign key of product table
##		✔	balance_stock

-- Stock Table
CREATE TABLE Stock 
	(id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT,
    balance_stock INT,
    FOREIGN KEY (product_id) REFERENCES Product(product_id));
desc stock;


##	ASSIGNMENT DAY 7

use classicmodels;
show tables;


##		1)	Show employee number, Sales Person (combination of first and last names of employees), 
##		unique customers for each employee number and sort the data by highest to lowest unique customers.
##		Tables: Employees, Customers

select  e.employeenumber , concat(firstname," ",lastname) as sale_person, count(distinct(customerName)) as unique_customers from employees as e
join customers as c
on e.employeeNumber = c.salesRepEmployeeNumber
group by e.employeeNumber
order by unique_customers desc;


##		2)	Show total quantities, total quantities in stock, left over quantities for each product and each customer. 
##		Sort the data by customer number.
##		Tables: Customers, Orders, Orderdetails, Products

SELECT c.customernumber AS "Customer Number", 
	c.customername as "Customer Name",
    p.productcode AS "Product Code",
    SUM(od.quantityordered) AS "Total Quantities",
    p.quantityinstock AS "Total Quantities in Stock",
    (p.quantityinstock - SUM(od.quantityordered)) AS "Leftover Quantities"
FROM Customers c
JOIN Orders o ON c.customernumber = o.customernumber
JOIN Orderdetails od ON o.ordernumber = od.ordernumber
JOIN Products p ON od.productcode = p.productcode
GROUP BY c.customernumber, p.productcode, p.quantityinstock
ORDER BY c.customernumber, p.productcode;


##		3)	Create below tables and fields. (You can add the data as per your wish)
##		●	Laptop: (Laptop_Name)
##		●	Colours: (Colour_Name)
##		Perform cross join between the two tables and find number of rows.

-- Create Laptop table
CREATE TABLE Laptop (Laptop_Name VARCHAR(255));

-- Create Colours table
CREATE TABLE Colours (Colour_Name VARCHAR(255));

-- Insert data into Laptop table
INSERT INTO Laptop (Laptop_Name)
VALUES ('Dell'), ('HP');
select * from Laptop;

-- Insert data into Colours table
INSERT INTO Colours (Colour_Name)
VALUES ('White'), ('Silver'), ('Black');
select * from Colours;

-- Perform cross join
SELECT Laptop.Laptop_Name, Colours.Colour_Name
FROM Laptop
CROSS JOIN Colours order by Laptop_name;

-- Perform cross join and find the number of rows
SELECT COUNT(*) AS Number_of_Rows
FROM Laptop
CROSS JOIN Colours;


##		4)	Create table project with below fields.
##		●	EmployeeID
##		●	FullName
##		●	Gender
##		●	ManagerID
##		Find out the names of employees and their related managers.

-- Create the Project table
CREATE TABLE Project 
	(EmployeeID INT PRIMARY KEY,
    FullName VARCHAR(255),
    Gender VARCHAR(10),
    ManagerID INT);

-- Insert data into the Project table
INSERT INTO Project (EmployeeID, FullName, Gender, ManagerID) VALUES
    (1, 'Pranaya', 'Male', 3),
    (2, 'Priyanka', 'Female', 1),
    (3, 'Preety', 'Female', NULL),
    (4, 'Anurag', 'Male', 1),
    (5, 'Sambit', 'Male', 1),
    (6, 'Rajesh', 'Male', 3),
    (7, 'Hina', 'Female', 3);

-- Find the names of employees and their related managers
select a.fullname , b.fullname as emp_name from project as a
inner join project as b 
on a.employeeid = b.managerid
order by fullname;


##	ASSIGNMENT DAY 8

use classicmodels;
show tables;


##		Create table facility. Add the below fields into it.
##		●	Facility_ID
##		●	Name
##		●	State
##		●	Country
##		i) Alter the table by adding the primary key and auto increment to Facility_ID column.
##		ii) Add a new column city after name with data type as varchar which should not accept any null values.

-- Create the initial Facility table without the primary key and auto-increment
create table facility (
Facility_ID int ,
Name varchar(100),
State varchar(100),
Country varchar(100));

desc facility;

-- Add primary key and auto-increment to Facility_ID column

alter table facility
ADD COLUMN City VARCHAR(100) NOT NULL after name,
modify column facility_id int primary key auto_increment ;

desc facility;


## ASSIGNMENT DAY 9

use classicmodels;
show tables;

##		Create table university with below fields.
##		●	ID
##		●	Name
##		Remove the spaces from everywhere and update the column like Pune University etc.

-- Create the University table
CREATE TABLE University 
	(ID INT PRIMARY KEY,
    Name VARCHAR(255));

-- Insert data into the University table
INSERT INTO University (ID, Name) VALUES
    (1, "       Pune          University     "),
    (2, "  Mumbai          University     "),
    (3, "     Delhi   University     "),
    (4, "Madras University"),
    (5, "Nagpur University");

select * from university;

-- Remove spaces from the Name column and update it
SET SQL_SAFE_UPDATES=0;
 
update university set name = ltrim(rtrim(name));
select * from university;
UPDATE university SET name = replace(name,'    ','');

select ID,replace(trim(name),"     "," ") as Name from university;


##	ASSIGNMENT DAY 10

use classicmodels;
show tables;

##		Create the view products status. Show year wise total products sold. Also find the percentage of total value for each year. 
##		The output should look as shown in below figure.

-- Create a view named "products_status"

create view products_status as 
 select year(o.orderdate) as Year, 
 concat(count(od.productcode)," ","(",round((count(od.productcode)*100.0/sum(count(od.productcode)) over ()),0),'%',")")as value 
 from orders o  join orderdetails od on o.ordernumber=od.ordernumber
 group by year(o.orderdate)
 order by count(od.productcode) desc;
 
 select * from products_status;
 
 
 ##	ASSIGNMENT DAY 11
 
 ##		1)	Create a stored procedure GetCustomerLevel which takes input as customer number and gives the output as either  
##			Platinum, Gold or Silver as per below criteria.
##			Table: Customers

##			●	Platinum: creditLimit > 100000
##			●	Gold: creditLimit is between 25000 to 100000
##			●	Silver: creditLimit < 25000


select * from customers;
desc customers;

##		CREATE DEFINER=`root`@`localhost` PROCEDURE `GetCustomerLevel`(Cust_no int)
##	BEGIN

##  	declare Category varchar(20);
##	Select creditlimit into Category from customers where Customernumber = Cust_no;
 
##	if Category > 100000 then 
##		set Category = "Platinum" ;

##		elseif Category < 25000 then  
##		set Category = " Silver";

##		else 
##		set Category = "Gold";
##		end if;
##	select cust_no as Customer_number, category;

##	END

call getcustomerlevel (103); ## Ex ------> Silver

call getcustomerlevel (124); ## Ex ------> Platinum

call getcustomerlevel (112); ## Ex -------> GoldGat_country_payments
 
 ##		2)	Create a stored procedure Get_country_payments which takes in year and country as inputs and gives 
##			year wise, country wise total amount as an output. Format the total amount to nearest thousand unit (K)
##			Tables: Customers, Payments

## 		Downside is stored procedure for country wise payments.

select * from customers;
select * from payments;
desc payments;

##		CREATE DEFINER=`root`@`localhost` PROCEDURE `Get_country_payments`(in  inputyear int, in  inputcountry varchar(50))
##	BEGIN
##	select year(p.paymentdate) as Year , c.country, concat(format(sum(amount)/1000,0),'K') as Total_Amount
##	from payments p join customers c on p.customernumber=c.customernumber
##	where year(p.paymentdate)= inputyear and (c.country)=inputcountry
##	group by year(P.paymentdate),country;
##	END

call get_country_payments(2003, 'france');


##	ASSIGNMENT DAY 12

##		1)	Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
##			Format the YoY values in no decimals and show in % sign.
##			Table: Orders

select * from orders;

select year(orderdate) as year, monthname(orderdate) as month,
count(orderNumber) as total_orders,
CONCAT(IFNULL(round((COUNT(*) - LAG(COUNT(*), 1) OVER (ORDER BY YEAR(orderdate), MONTHname(orderdate))) / LAG(COUNT(*), 1) 
OVER (ORDER BY YEAR(orderdate), MONTHname(orderdate)) * 100), 100)," ",'%') AS YoY_percentage_change
FROM orders group by year, month;

##		2)	Create the table emp_udf with below fields.
##			●	Emp_ID
##			●	Name
##			●	DOB
##		Create a user defined function calculate_age which returns the age in years and months (e.g. 30 years 5 months) 
##		by accepting DOB column as a parameter.

create table emp_udf(emp_id int, name varchar(20), dob date);
INSERT INTO Emp_UDF
VALUES (1, "Piyush", "1990-03-30"),
(2, "Aman", "1992-08-15"), 
(3, "Meena", "1998-07-28"), 
(4, "Ketan", "2000-11-21"), 
(5, "Sanjay", "1995-05-21");

select emp_id, name, dob, 
concat(round(datediff(now(),dob)/365)," ","years"," ",round(DATEDIFF(NOW(), dob) % 365 / 30)," ","Months")
as Age from emp_udf;


##	ASSIGNMENT DAY 13

##		1)	Display the customer numbers and customer names from customers table who have not placed any orders using subquery
##			Table: Customers, Orders

select customernumber, customername from customers where
 (customernumber) not in (select customernumber from orders);
 
##		2)	Write a full outer join between customers and orders using union and get 
##			the customer number, customer name, count of orders for every customer.
##			Table: Customers, Orders
-- Get a list of customers and their orders

select c.customernumber, c.customername, count(o.customernumber) as total_orders
from customers c left join orders o on c.customerNumber = o.customerNumber group by c.customerNumber;

##		3)	Show the second highest quantity ordered value for each order number.
##			Table: Orderdetails

select * from orderdetails;
select count(*) from orderdetails;
select o.ordernumber, o.quantityordered from (
select ordernumber, quantityordered, dense_rank() over (partition by ordernumber order by quantityordered desc) as abc
from orderdetails) as o where abc = 2;

##		4)	For each order number count the number of products and then find the min and max of the values among count of orders.
##			Table: Orderdetails

select * from orderdetails;

SELECT max(product_count) AS max_count, min(product_count) AS min_count FROM 
( SELECT count(distinct productCode) AS product_count FROM Orderdetails GROUP BY ordernumber ) AS order_counts;


##		5)	Find out how many product lines are there for which the buy price value is greater than the average of buy price value. 
##			Show the output as product line and its count.

select * from products;

select productline, count(productcode) as total from products 
where buyprice > (select avg(buyprice) from products)
group by productline order by total desc;


##	ASSIGNMENT DAY 14

##		Create the table Emp_EH. Below are its fields.
##		●	EmpID (Primary Key)
##		●	EmpName
##		●	EmailAddress
##		Create a procedure to accept the values for the columns in Emp_EH. Handle the error using exception handling concept. 
##		Show the message as “Error occurred” in case of anything wrong.

-- Create the Emp_EH table
CREATE TABLE Emp_EH 
	(EmpID INT PRIMARY KEY,
    EmpName VARCHAR(255),
    EmailAddress VARCHAR(255));
    
select * from emp_EH;

##		CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertIntoEmpEH`( in EmpID int,in EmpName varchar (20),  in EmailAddress varchar (50))
##	BEGIN
##       DECLARE EXIT HANDLER FOR SQLEXCEPTION
##	SELECT 'Error occurred' AS Message;
##        INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress)
##  VALUES (EmpID, EmpName, EmailAddress);
##	end

##	ASSIGNMENT DAY 15

##		Create the table Emp_BIT. Add below fields in it.
##			●	Name
##			●	Occupation
##			●	Working_date
##			●	Working_hours

##		Create before insert trigger to make sure any new value of Working_hours, if it is negative, then it should be inserted as positive.

CREATE TABLE Emp_BIT 
	(Name VARCHAR(255),
    Occupation VARCHAR(255),
    Working_date DATE,
    Working_hours INT);

INSERT INTO Emp_BIT VALUES
    ('Robin', 'Scientist', '2020-10-04', 12),
    ('Warner', 'Engineer', '2020-10-04', 10),
    ('Peter', 'Actor', '2020-10-04', 13),
    ('Marco', 'Doctor', '2020-10-04', 14),
    ('Brayden', 'Teacher', '2020-10-04', 12),
    ('Antonio', 'Business', '2020-10-04', 11);

select * from emp_bit;

INSERT INTO Emp_BIT VALUES
('Anna', 'Scientist', '2020-10-04', -14);

##		CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
##    IF NEW.Working_hours < 0 THEN
##        SET NEW.Working_hours = -NEW.Working_hours;
##    END IF;

##	END
