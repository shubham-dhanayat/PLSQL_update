CREATE TABLE student (
    student_id INT primary key,
    FirstName VARCHAR2(50),
    LastName VARCHAR2(50),
    Email VARCHAR2(100) default 'ABC@gmail.com' ,
    DOB DATE DEFAULT SYSDATE,  -- SYSDATE is similar to GETDATE() in SQL Server
    addmissiom_date DATE
);


INSERT INTO student (student_id, FirstName, LastName, DOB, addmissiom_date)
VALUES 
(1, 'Shiv', 'S', TO_DATE('2002-08-12', 'YYYY-MM-DD'), TO_DATE('2024-03-01', 'YYYY-MM-DD'));

INSERT INTO student (student_id, FirstName, LastName, DOB, addmissiom_date)
VALUES 
(2, 'Deep', 'D', TO_DATE('2001-11-23', 'YYYY-MM-DD'), TO_DATE('2024-03-05', 'YYYY-MM-DD'));

INSERT INTO student (student_id, FirstName, LastName, DOB, addmissiom_date)
VALUES 
(3, 'Kiran', 'K', TO_DATE('2003-04-17', 'YYYY-MM-DD'), TO_DATE('2024-03-10', 'YYYY-MM-DD'));

INSERT INTO student (student_id, FirstName, LastName, DOB, addmissiom_date)
VALUES 
(4, 'Bob', 'B', TO_DATE('2000-12-05', 'YYYY-MM-DD'), TO_DATE('2024-03-15', 'YYYY-MM-DD'));

INSERT INTO student (student_id, FirstName, LastName, DOB, addmissiom_date)
VALUES 
(5, 'Sam', 'S', TO_DATE('1999-07-19', 'YYYY-MM-DD'), SYSDATE);


select * from student;

drop table student ;

-------------------------

CREATE  TABLE City (
    CityID INT unique ,             
    CityName VARCHAR2(100) primary key,    
    State VARCHAR2(50),                
    Country VARCHAR2(50) DEFAULT 'INDIA',
    Population INT,
    constraint POPULATION_CHECK check (Population > 30000)                
);


INSERT INTO City (CityID, CityName, State, Population) VALUES (1, 'pune', 'maharashtra', 500000);

INSERT INTO City (CityID, CityName, State, Population) VALUES (2, 'Bengaluru', 'Karnataka', 93846);

INSERT INTO City (CityID, CityName, State, Population) VALUES (3, 'sambhajinagar', 'maharashtra', 450000);

INSERT INTO City (CityID, CityName, State, Population) VALUES (4, 'Surat', 'Gujarat', 40500);


select * from city ;

drop table city ;
---------------------------

CREATE TABLE Bike (
    BikeID INT PRIMARY KEY,            
    BikeName VARCHAR2(100) NOT NULL,   
    Brand VARCHAR2(50) unique,        
    EngineCapacity INT,                
    Price NUMBER(10, 2),               
    LaunchYear INT                    
);


INSERT INTO Bike (BikeID, BikeName, Brand, EngineCapacity, Price, LaunchYear)
VALUES (1, 'Pulsar NS200', 'Bajaj', 200, 150000.00, 2012);

INSERT INTO Bike (BikeID, BikeName, Brand, EngineCapacity, Price, LaunchYear)
VALUES (2, 'Apache RTR 160', 'TVS', 160, 118000.00, 2005);

INSERT INTO Bike (BikeID, BikeName, Brand, EngineCapacity, Price, LaunchYear)
VALUES (3, 'Royal Enfield Classic 350', 'Royal Enfield', 350, 210000.00, 2009);

INSERT INTO Bike (BikeID, BikeName, Brand, EngineCapacity, Price, LaunchYear)
VALUES (4, 'KTM Duke 390', 'KTM', 390, 310000.00, 2013);

INSERT INTO Bike (BikeID, BikeName, Brand, EngineCapacity, Price, LaunchYear)
VALUES (5, 'Yamaha R15 V4', 'Yamaha', 155, 180000.00, 2021);

select * from bike ;

--------------------------------------------

CREATE TABLE Shop (
    ShopID INT PRIMARY KEY,            
    ShopName VARCHAR2(100) NOT NULL,     
    Location VARCHAR2(100),
    constraint location_fk foreign key (Location) references city(cityname)     
);

INSERT ALL
    INTO Shop (ShopID, ShopName, Location) VALUES (1, 'Reliance Fresh', 'pune');
    INTO Shop (ShopID, ShopName, Location) VALUES (2, 'Big Bazaar', 'surat')
    INTO Shop (ShopID, ShopName, Location) VALUES (3, 'D-Mart', 'pune')
    INTO Shop (ShopID, ShopName, Location) VALUES (4, 'More Supermarket', 'sambhajinagar')
    INTO Shop (ShopID, ShopName, Location) VALUES (5, 'Retail', 'Bengaluru')
SELECT 1 FROM DUAL;


select * from shop ;

drop table shop ;

ALTER TABLE shop 
DISABLE CONSTRAINT location_fk;

------------------------------------------------synonym-----------------------------------------

--Oracle supports private and public synonyms, while SQL Server only supports public synonyms.
--Dropping an object doesn’t remove the synonym, but queries using it will fail in both databases.


create synonym my_table_1 for bike ;

select * from my_table_1 ;

create table bike1 as select * from bike ;

select * from bike1;

create or replace synonym my_table_1 for bike1 ;

update my_table_1 set bikename = 'RTR 300' where bikeid = 2 ;

delete from my_table_1 where bikeid = 1 ;
delete from bike1 where bikeid = 2 ;

--
create or replace synonym grocery for shop ;

select * from grocery ;

insert into grocery values (6, 'retail', 'gujrat');

select * from shop ;
--
create or replace synonym my_synonym for city ;

select * from my_synonym ;
--
create or replace synonym practice_sy for student  ;

select * from practice_sy ;

-------------------------------------------sequence-------------------------------
--syntax 
CREATE SEQUENCE sequence_name
    START WITH start_value      -- Initial value (default: 1)
    INCREMENT BY increment_value -- Step size (default: 1)
    MAXVALUE max_value          -- Maximum value (optional)
    MINVALUE min_value          -- Minimum value (optional)
    CYCLE | NOCYCLE             -- Restart at min_value after reaching max_value or not (default: NOCYCLE)
    CACHE cache_size | NOCACHE  -- Store values in memory for performance or disable caching (default: 20)
    ORDER | NOORDER;            -- Guarantee order of sequence values (rarely used)

--Oracle Error: ORA-04013 – "Number to CACHE must be less than Cycle value"
--This error occurs when the CACHE value (default is 20) is greater than the MAXVALUE when using CYCLE.

--Sequences in SQL Server are global, while in Oracle, they are session-specific

create or replace sequence seq_1
 start with 1
 increment by 2
 maxvalue 21
 cycle ;

SELECT seq_1.CURRVAL FROM  dual;
SELECT seq_1.NEXTVAL FROM dual; -- Generate the first value


INSERT INTO student (student_id, FirstName, LastName, DOB, addmissiom_date)
VALUES 
(seq_1.NEXTVAL, 'Sanny', 'SN', TO_DATE('1999-07-19', 'YYYY-MM-DD'), SYSDATE);

select * from student ;

SELECT seq_1.CURRVAL FROM  dual;
--
create  sequence seq_2
 start with 100
 increment by -10
 maxvalue 100
 minvalue -100
 nocycle ;

SELECT seq_2.NEXTVAL FROM  dual;
SELECT seq_2.CURRVAL FROM  dual;

create  table test1(
id int,
name varchar2(100)
);

insert all 
 into test1 values(seq_2.NEXTVAL, 'a')
 into test1 values(seq_2.NEXTVAL, 'b')
 into test1 values(seq_2.NEXTVAL, 'c')
 into test1 values(seq_2.NEXTVAL, 'd')
 into test1 values(seq_2.NEXTVAL, 'e')
 into test1 values(seq_2.NEXTVAL, 'f')
select 1 from dual ;

select * from test1 ;

truncate table test1 ;

 insert into test1 values(seq_2.NEXTVAL, 'a');

 insert into test1 values(seq_2.NEXTVAL, 'b');

 insert into test1 values(seq_2.NEXTVAL, 'c');

 insert into test1 values(seq_2.NEXTVAL, 'd');
 
select seq_2.currval from dual ;


select substr ('shubham',2,length('shubham')-2) from dual ;

select instr('shubham dhanayat','a',2,2) from dual


select round(25.50) from dual ;

--------------------------------16-3-025, Functins -----------------------------------------
--===========================string function=============================

1. UPPER() – Convert to Uppercase  =         SELECT UPPER('hello world') FROM DUAL;

2. LOWER() – Convert to Lowercase =          SELECT LOWER('HELLO WORLD') FROM DUAL;

3. INITCAP() – Capitalize First Letter =     SELECT INITCAP('hello world') FROM DUAL;

4. LENGTH() – Get String Length =            SELECT LENGTH('Oracle SQL') FROM DUAL;

5. SUBSTR() – Extract a Part of String =     SELECT SUBSTR('Oracle SQL', 1, 6) FROM DUAL;

6. INSTR() – Find Position of a Substring =  SELECT INSTR('Oracle SQL', 'SQL') FROM DUAL;

7. REPLACE() – Replace Substring =           SELECT REPLACE('Hello World', 'World', 'Oracle') FROM DUAL;

8. TRIM() – Remove Spaces from Both Sides =  SELECT TRIM('   Oracle SQL   ') FROM DUAL;

 rtrim = SELECT RTRIM('Oracle SQL   ') FROM DUAL;
 ltrim = SELECT LTRIM('   Oracle SQL') FROM DUAL;

11. CONCAT() – Join Two Strings =            SELECT CONCAT('Hello', ' Oracle') FROM DUAL;

12. LPAD() – Add Padding on Left =           SELECT LPAD('SQL', 6, '*') FROM DUAL;

13. RPAD() – Add Padding on Right =          SELECT RPAD('SQL', 6, '*') FROM DUAL;

14. TRANSLATE() – Replace Multiple Characters = SELECT TRANSLATE('123-456-789', '123', 'XYZ') FROM DUAL;


-------------------------------------------Number function---------------------------------------------

1. ROUND() – Round a Number =                     SELECT ROUND(123.456, 2) FROM DUAL;
 The Oracle/PLSQL ROUND function returns a number rounded to a certain number of decimal places.

2. TRUNC() – Truncate a Number =                  SELECT TRUNC(123.456, 2) FROM DUAL; 
 The Oracle/PLSQL TRUNC function returns a number truncated to a certain number of decimal places.                                                 SELECT TRUNC(123.456, 0) FROM DUAL;

3. CEIL() – Round Up to Next Integer =            SELECT CEIL(10.2) FROM DUAL; 
                                                  SELECT CEIL(-10.2) FROM DUAL;
       
4. FLOOR() – Round Down to Previous Integer =     SELECT FLOOR(10.9) FROM DUAL;
                                                  SELECT FLOOR(-10.9) FROM DUAL;

5. MOD() – Get Remainder of Division =            SELECT MOD(10, 3) FROM DUAL;
 The Oracle/PLSQL MOD function returns the remainder of m divided by n.
 
6. POWER() – Exponentiation =                     SELECT POWER(2, 3) FROM DUAL;

7. SQRT() – Square Root =                         SELECT SQRT(25) FROM DUAL;

8. ABS() – Absolute Value =                       SELECT ABS(-10) FROM DUAL;

10. GREATEST() – Find Largest Number =            SELECT GREATEST(10, 20, 30, 40) FROM DUAL;

11. LEAST() – Find Smallest Number =              SELECT LEAST(10, 20, 30, 40) FROM DUAL;

-------------------------------------------------------------------------------------------------------


CREATE TABLE Departments (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL
);


INSERT INTO Departments VALUES (1, 'Computer Science');
INSERT INTO Departments VALUES (2, 'Electronics');
INSERT INTO Departments VALUES (3, 'Mechanical');
INSERT INTO Departments VALUES (4, 'Civil');
INSERT INTO Departments VALUES (5, 'Electrical');

INSERT INTO Departments VALUES (6, 'Information Technology');
INSERT INTO Departments VALUES (7, 'Artificial Intelligence');
INSERT INTO Departments VALUES (8, 'Robotics');
INSERT INTO Departments VALUES (9, 'Aerospace Engineering');
INSERT INTO Departments VALUES (10, 'Biotechnology');

INSERT INTO Departments VALUES (11, 'Cyber Security');
INSERT INTO Departments VALUES (12, 'Big Data Analytics');
INSERT INTO Departments VALUES (13, 'Cloud Computing');
INSERT INTO Departments VALUES (14, 'Internet of Things');
INSERT INTO Departments VALUES (15, 'Software Engineering');
INSERT INTO Departments VALUES (16, 'Data Science');
INSERT INTO Departments VALUES (17, 'Embedded Systems');
INSERT INTO Departments VALUES (18, 'Game Development');
INSERT INTO Departments VALUES (19, 'Quantum Computing');
INSERT INTO Departments VALUES (20, 'Bioinformatics');


select * from departments ;

--
CREATE TABLE Faculty (
    Faculty_ID INT PRIMARY KEY,
    Faculty_Name VARCHAR(100) NOT NULL,
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);


INSERT INTO Faculty VALUES (101, 'Dr. Suresh Kumar', 1);
INSERT INTO Faculty VALUES (102, 'Dr. Anjali Sharma', 1);
INSERT INTO Faculty VALUES (103, 'Dr. Prakash Verma', 2);
INSERT INTO Faculty VALUES (104, 'Dr. Ramesh Gupta', 3);
INSERT INTO Faculty VALUES (105, 'Dr. Meena Iyer', 4);
INSERT INTO Faculty VALUES (106, 'Dr. Neha Saxena', 2);
INSERT INTO Faculty VALUES (107, 'Dr. Amit Dubey', 5);
INSERT INTO Faculty VALUES (108, 'Dr. Priya Menon', 4);
INSERT INTO Faculty VALUES (109, 'Dr. Rajiv Nair', 3);
INSERT INTO Faculty VALUES (110, 'Dr. Sunita Rao', 1);
INSERT INTO Faculty VALUES (112, 'Dr. Sneha Verma', 12);
INSERT INTO Faculty VALUES (113, 'Dr. Prakash Sharma', 13);
INSERT INTO Faculty VALUES (114, 'Dr. Anjali Gupta', 14);
INSERT INTO Faculty VALUES (115, 'Dr. Manish Pandey', 15);
INSERT INTO Faculty VALUES (116, 'Dr. Kavita Rao', 16);
INSERT INTO Faculty VALUES (117, 'Dr. Suresh Nair', 17);
INSERT INTO Faculty VALUES (118, 'Dr. Priya Mehta', 18);
INSERT INTO Faculty VALUES (119, 'Dr. Rohan Deshmukh', 19);
INSERT INTO Faculty VALUES (120, 'Dr. Neha Joshi', 20);

select * from faculty ;
---

CREATE TABLE Students (
    Student_ID INT PRIMARY KEY,
    First_Name VARCHAR(50),
    Last_Name VARCHAR(50),
    Age INT,
    Gender CHAR(1),
    City VARCHAR(100),
    State VARCHAR(100),
    Mobile_No VARCHAR(15),
    Email VARCHAR(100),
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID)
);


BEGIN
    FOR i IN 1..100 LOOP
        INSERT INTO Students VALUES (
            i, 
            'Student_' || i, 
            'Last_' || i, 
            TRUNC(DBMS_RANDOM.VALUE(18, 25)), 
            CASE WHEN MOD(i, 2) = 0 THEN 'M' ELSE 'F' END, 
            'City_' || MOD(i, 10), 
            'State_' || MOD(i, 5), 
            '98' || LPAD(TO_CHAR(DBMS_RANDOM.VALUE(100000000, 999999999)), 8, '0'),
            'student' || i || '@gmail.com', 
            MOD(i, 5) + 1
        );
    END LOOP;
    COMMIT;
END;

insert into cricket values (cr_1.nextval ,upper(DBMS_RANDOM.STRING('', 5)),(round(DBMS_RANDOM.VALUE(18, 100))),(round(DBMS_RANDOM.VALUE(1, 100))),(round(DBMS_RANDOM.VALUE(1, 100))),'pune');
 
SELECT DBMS_RANDOM.RANDOM FROM dual;

SELECT DBMS_RANDOM.VALUE(10, 100) AS Random_Num FROM dual;

SELECT TO_DATE('2020-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 365)) AS Random_Date 
FROM dual;
select * from students ;
----

CREATE TABLE Courses (
    Course_ID INT PRIMARY KEY,
    Course_Name VARCHAR(100) NOT NULL,
    Dept_ID INT,
    Faculty_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES Departments(Dept_ID),
    FOREIGN KEY (Faculty_ID) REFERENCES Faculty(Faculty_ID)
);

drop table courses ;

INSERT INTO Courses VALUES (201, 'Database Management', 1, 101);
INSERT INTO Courses VALUES (202, 'Data Structures', 1, 102);
INSERT INTO Courses VALUES (203, 'Microprocessors', 2, 103);
INSERT INTO Courses VALUES (204, 'Thermodynamics', 3, 104);
INSERT INTO Courses VALUES (205, 'Structural Analysis', 4, 105);
INSERT INTO Courses VALUES (206, 'Machine Learning', 1, 110);
INSERT INTO Courses VALUES (207, 'Power Systems', 5, 107);
INSERT INTO Courses VALUES (208, 'Digital Circuits', 2, 106);
INSERT INTO Courses VALUES (209, 'Hydraulics', 4, 108);
INSERT INTO Courses VALUES (210, 'Mechanics', 3, 109);

INSERT INTO Courses VALUES (211, 'Cyber Security Fundamentals', 11, 111);
INSERT INTO Courses VALUES (212, 'Big Data Analytics', 12, 112);
INSERT INTO Courses VALUES (213, 'Cloud Computing Technologies', 13, 113);
INSERT INTO Courses VALUES (214, 'IoT and Smart Devices', 14, 114);
INSERT INTO Courses VALUES (215, 'Software Engineering Principles', 15, 115);
INSERT INTO Courses VALUES (216, 'Data Science with Python', 16, 116);
INSERT INTO Courses VALUES (217, 'Embedded Systems Design', 17, 117);
INSERT INTO Courses VALUES (218, 'Game Development Basics', 18, 118);
INSERT INTO Courses VALUES (219, 'Quantum Computing Concepts', 19, 119);
INSERT INTO Courses VALUES (220, 'Bioinformatics and Genomics', 20, 120);
--

CREATE TABLE Exams (
    Exam_ID INT PRIMARY KEY,
    Exam_Name VARCHAR(100),
    Course_ID INT,
    Exam_Date DATE,
    Max_Marks INT,
    FOREIGN KEY (Course_ID) REFERENCES Courses(Course_ID)
);

INSERT INTO Exams VALUES (301, 'DBMS Midterm', 201, TO_DATE('2024-04-10', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (302, 'Data Structures Final', 202, TO_DATE('2024-05-15', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (303, 'Microprocessors Midterm', 203, TO_DATE('2024-04-12', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (304, 'Thermodynamics Final', 204, TO_DATE('2024-06-20', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (305, 'Structural Analysis Midterm', 205, TO_DATE('2024-03-30', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (306, 'Machine Learning Final', 206, TO_DATE('2024-07-10', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (307, 'Power Systems Midterm', 207, TO_DATE('2024-08-05', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (308, 'Digital Circuits Final', 208, TO_DATE('2024-09-15', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (309, 'Hydraulics Midterm', 209, TO_DATE('2024-10-10', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (310, 'Mechanics Final', 210, TO_DATE('2024-11-20', 'YYYY-MM-DD'), 100);

INSERT INTO Exams VALUES (311, 'Artificial Intelligence Midterm', 206, TO_DATE('2024-04-15', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (312, 'Machine Learning Final', 206, TO_DATE('2024-05-10', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (313, 'Robotics Practical', 208, TO_DATE('2024-06-05', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (314, 'Aerospace Engineering Midterm', 209, TO_DATE('2024-07-15', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (315, 'Biotechnology Midterm', 210, TO_DATE('2024-08-20', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (316, 'IoT and Cloud Computing', 206, TO_DATE('2024-09-25', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (317, 'Cyber Security Final', 207, TO_DATE('2024-10-30', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (318, 'Big Data Analytics', 208, TO_DATE('2024-11-05', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (319, 'Blockchain Technology', 209, TO_DATE('2024-12-10', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (320, 'Quantum Computing', 210, TO_DATE('2025-01-15', 'YYYY-MM-DD'), 100);

INSERT INTO Exams VALUES (321, 'Cyber Security Fundamentals', 207, TO_DATE('2025-02-20', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (322, 'Big Data Analytics Final', 208, TO_DATE('2025-03-10', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (323, 'Cloud Computing Midterm', 209, TO_DATE('2025-04-05', 'YYYY-MM-DD'), 100);
INSERT INTO Exams VALUES (324, 'IoT and Smart Devices', 210, TO_DATE('2025-05-15', 'YYYY-MM-DD'), 100);

select * from exams
order by exam_id  ;
--

CREATE TABLE Results (
    Result_ID INT PRIMARY KEY,
    Student_ID INT,
    Exam_ID INT,
    Marks_Obtained INT,
    FOREIGN KEY (Student_ID) REFERENCES Students(Student_ID),
    FOREIGN KEY (Exam_ID) REFERENCES Exams(Exam_ID)
);

BEGIN
    FOR i IN 1..200 LOOP
        INSERT INTO Results VALUES (
            i, 
            MOD(i, 100) + 1,   -- Random student ID
            MOD(i, 20) + 301,  -- Random exam ID
            TRUNC(DBMS_RANDOM.VALUE(30, 100))  -- Random marks between 30-100
        );
    END LOOP;
    COMMIT;
END;
/



select * from departments ;
select * from faculty ;
select * from students ;
select * from courses ;
select * from exams ;
select * from Results ;


/*The DBMS_RANDOM package in Oracle SQL is used to generate random numbers, strings, 
and values. It provides a set of functions to generate random integers, floating-point numbers, 
and alphanumeric strings.*/
insert into cricket values (cr_1.nextval ,upper(DBMS_RANDOM.STRING('', 5)),(round(DBMS_RANDOM.VALUE(18, 100))),(round(DBMS_RANDOM.VALUE(1, 100))),(round(DBMS_RANDOM.VALUE(1, 100))),'pune');
 
SELECT DBMS_RANDOM.RANDOM FROM dual;

SELECT DBMS_RANDOM.VALUE(10, 100) AS Random_Num FROM dual;

SELECT TO_DATE('2020-01-01', 'YYYY-MM-DD') + TRUNC(DBMS_RANDOM.VALUE(0, 365)) AS Random_Date 
FROM dual;

select round(18,100) from dual ;

select upper(first_name) from students ;  

select lower(first_name) from students ;

select initcap(first_name) from students ;

select concat(first_name, last_name) from students ;

select length(first_name) from students
where student_id = 10 ;

select substr(first_name,4,7) from students
where student_id = 50 ;

select concat('name of the student - ',substr(first_name,4,7)) from students
where student_id = 50 ;

select concat('name of the student - ',substr(first_name,4,7)) , 
length(concat('name of the student - ',substr(first_name,4,7))) from students
where student_id = 50 ;

select instr(first_name,4,7) from students
where student_id = 34 ;

select instr('ABC*D','*') from dual;

select instr('ABCDEFGHCDIJKLCDMNP','CD',-5,2) from dual;

select instr('ABCDEABFGHCDIABJKLABCDMNP','AB',1,2) from dual;

select instr('ABCDEABFGHCDIABJKLABCDMNP','AB',-7,2) from dual;

select course_id,upper(course_name),dept_id,faculty_id from courses ;

select c.* ,initcap(faculty_name) from courses c
join faculty f
on c.faculty_id = f.faculty_id ;


select concat(course_name ,faculty_name) from courses c
join faculty f
on c.faculty_id = f.faculty_id ;


select d.* ,faculty_name from departments d
join faculty f
on d.dept_id = f.dept_id ;

select d.* ,length(faculty_name) from departments d
join faculty f
on d.dept_id = f.dept_id 
where d.dept_id = 1;

select replace(dept_name,'Science','Scientist') from departments ;

select rtrim('S' from 'SSTHSSMISS')from dual;

select TRIM('n' FROM 'neen') FROM dual;

select TRIM ('h' FROM 'hanmant') FROM dual; 

select lpad('ABCD',10,'#') from dual;

select LPAD('Hanmant',10,'@'),LPAD('Hanmant',10,'*') FROM dual;

select concat(LPAD('Hanmant',10,'@'),LPAD('Hanmant',10,'*')) FROM dual;

--

select round(45.923,0),Round(45.923,2),Round(45.923,-1) From dual ;

select round(152.7, 2) from dual	;

select round(152.7, 0) from dual	;

select round(152.7, -1)	from dual ;

select round(152.7, -2)	from dual ;

select round(152.7, -3)	from dual ;

select round(5.7) from dual;

select round(1.3) from dual;

select Trunc(45.923,0),Trunc(45.923,2),trunc(492.923,-1) From dual;

select trunc(1.2) from dual;

select trunc(1.23456,3) from dual;

select Mod(16,4) From dual;

select Mod(16,5) From dual;

select mod(10,0) from dual;

select abs(-32523.3) from dual;  --convert negative valuse into positive

select abs(-2224.2) from dual;

select abs(500) from dual;

select ceil(1.4) from dual;

select floor(1.4) from dual;

select greatest(5,8,9,7) from dual;

select least(5,8,9,7) from dual;

--The REGEXP_REPLACE function in Oracle SQL is used to replace substrings that match a regular expression 
--pattern with another substring.
REGEXP_REPLACE(source_string, pattern, replacement [, position [, occurrence [, match_parameter]]])

SELECT REGEXP_REPLACE('AB123CD456', '[^0-9]', '') AS OnlyNumbers FROM dual;

SELECT REGEXP_REPLACE('AB123CD456', '[^A-Z]', '') AS OnlyNumbers FROM dual;

SELECT reverse(REGEXP_REPLACE('AB123CD456', '[^A-Z]', '')) AS OnlyNumbers FROM dual;

SELECT REGEXP_REPLACE('Hello@#123!!', '[^a-zA-Z0-9]', '') AS CleanedString FROM dual;

SELECT REGEXP_REPLACE('SQL is a SQL language', 'SQL', 'Oracle', 1, 1) AS Replaced FROM dual;



select * from departments ;
select * from faculty ;
select * from students ;
select * from courses ;
select * from exams ;
select * from Results ;


SELECT TO_DATE('2025-03-22', 'YYYY-MM-DD') FROM dual;

select next_day(sysdate,'monday') from dual ;


select employee_id, first_name, last_name, email, salary as emp_sal, department_id,
max(salary) over (partition by department_id) as grp_max_sal from hr.employees;

-------------------Aggregative Function------------------

select * from orderr;
select * from customer;

------------------------------------------------------------------------
--Q. write a  SQL query to calculate total purchase amount of all orders. Return total purchase amount.
select sum(purch_am) from orderr;

--Q. write a SQL query to calculate the average purchase amount of all orders. Return average purchase amount. 
select avg(purch_am) from orderr;

--Q.write a SQL query that counts the number of unique salespeople. Return number of salespeople. 
select count(distinct salesman_id)from orderr;  

--Q.write a SQL query to count the number of customers. Return number of customers.  
select count(cust_name) from customer;

--Q. write a SQL query to determine the number of customers who received at least one grade for their activity.  
select count(cust_name) from customer
where grade >= 1;

select count(all grade) from customer;

--Q.write a SQL query to find the maximum purchase amount.  
select max(purch_am) from orderr;

--Q.write a SQL query to find the minimum purchase amount.
select min(purch_am) from orderr;


------------------group by & having ------------


--Q.write a SQL query to find the highest grade of the customers in each city. Return city, maximum grade.  
select max(grade),city from customer
group by city
order by max(grade) desc;

--Q.write a SQL query to find the highest purchase amount ordered by each customer. Return customer ID, maximum purchase amount. 
select customr_id, max(purch_am) from orderr
group by customr_id
order by customr_id asc;

--Q.write a SQL query to find the highest purchase amount ordered by each customer on a particular date. Return, order date and highest purchase amount.
select customr_id, ord_date, max(purch_am) from orderr
group by customr_id, ord_date                 ----not done
order by max(purch_am) desc;

--Q.write a SQL query to determine the highest purchase amount made by each salesperson on '2012-08-17'. Return salesperson ID, purchase amount 
select max(purch_am),selsman_id from orderr
where ord_date = TO_DATE('08-17-2012', 'MM-DD-YYYY')
group by selsman_id ;

--Q. write a SQL query to find the highest order (purchase) amount by each customer on a particular order date. Filter the result by highest order (purchase) amount above 2000.00. Return customer id, order date and maximum purchase amount.
select customr_id, ord_date, max(purch_am) from orderr
group by customr_id, ord_date 
having max(purch_am)> 2000;

--Q.write a SQL query to find the maximum order (purchase) amount in the range 2000 - 6000 (Begin and end values are included.) by combination of each customer and order date. Return customer id, order date and maximum purchase amount.
select customr_id, ord_date, max(purch_am) from orderr
group by customr_id, ord_date 
having max(purch_am) between 2000 and 6000;

--Q.write a SQL query to find the maximum order (purchase) amount based on the combination of each customer and order date. Filter the rows for maximum order (purchase) amount is either 2000, 3000, 5760, 6000.
--Return customer id, order date and maximum purchase amount.
select customr_id, ord_date, max(purch_am) from orderr
group by customr_id, ord_date 
having max(purch_am) in (2000, 3000, 5760, 6000) ;

--Q. write a  SQL query to determine the maximum order amount for each customer. The customer ID should be in the range 3002 and 3007(Begin and end values are included.). 
--Return customer id and maximum purchase amount.
select customr_id, max(purch_am) from orderr
group by customr_id 
having customr_id between 3002 and 3007;

--Q.write a SQL query to find the maximum order (purchase) amount for each customer. The customer ID should be in the range 3002 and 3007(Begin and end values are included.).
--Filter the rows for maximum order (purchase) amount is higher than 1000. Return customer id and maximum purchase amount.
select customr_id, max(purch_am) from orderr
where customr_id between 3002 and 3007
group by customr_id
having max(purch_am) > 1000;

--Q.write a SQL query to determine the maximum order (purchase) amount generated by each salesperson. 
--Filter the rows for the salesperson ID is in the range 5003 and 5008 (Begin and end values are included.).
-- Return salesperson id and maximum purchase amount.
select selsman_id, max(purch_am) from orderr
where selsman_id between 5003 and 5008
group by selsman_id;

--Q, write a SQL query to count all the orders generated on '2012-08-17'. Return number of orders.
select count(ord_no) from orderr
group by ord_date
having ord_date = to_date('08-17-2012', 'MM-DD-YYYY');

CREATE TABLE salesman (
    salesman_id NUMBER(4),
    name VARCHAR2(50),
    city VARCHAR2(50),
    commission NUMBER(4, 2)
);

INSERT INTO salesman (salesman_id, name, city, commission) 
VALUES (5001, 'James Hoog', 'New York', 0.15);

INSERT INTO salesman (salesman_id, name, city, commission) 
VALUES (5002, 'Nail Knite', 'Paris', 0.13);

INSERT INTO salesman (salesman_id, name, city, commission) 
VALUES (5005, 'Pit Alex', 'London', 0.11);

INSERT INTO salesman (salesman_id, name, city, commission) 
VALUES (5006, 'Mc Lyon', 'Paris', 0.14);

INSERT INTO salesman (salesman_id, name, city, commission) 
VALUES (5007, 'Paul Adam', 'Rome', 0.13);

INSERT INTO salesman (salesman_id, name, city, commission) 
VALUES (5003, 'Lauson Hen', 'San Jose', 0.12);

select * from salesman;
--Q.write a SQL query to count the number of salespeople in a city. Return number of salespeople.
select count(all city) from salesman;

--Q.write a SQL query to count the number of orders based on the combination of each order date and salesperson. 
--Return order date, salesperson id.


select ord_date, salesman_id, count(ord_no) from orderr
group by ord_date, salesman_id;     



select * from salesman;
select * from hr.order;

select first_name,last_name,department_id , sum(salary) over (partition by department_id) from hr.employees ;

---------------------------------------------windows function ----------------------------------------------

--In Oracle, analytical functions (also known as window functions) allow 
--you to perform calculations across a set of table rows that are somehow related to the current row. 
--They are different from aggregate functions, which return a single result for a group of rows. 
--Analytical functions, however, provide multiple rows of output based on a group of rows.

--Here’s a breakdown of analytical functions:

--Key Components
--PARTITION BY: Divides the result set into partitions to which the function is applied.
--ORDER BY: Defines the order of rows within each partition.
--Windowing Clause: Specifies a subset of rows to perform the operation on, relative to the current row (using ROWS or RANGE).

--1. ROW_NUMBER()
--Assigns a unique sequential integer to rows within a partition, ordered by the specified columns.
SELECT employee_id, department_id, salary,
       ROW_NUMBER() OVER (PARTITION BY department_id ORDER BY salary DESC) AS row_num
FROM hr.employees;

SELECT employee_id, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM hr.employees;

select e.*, row_number() over(partition by job_id order by salary desc) r
  from hr.employees e;


SELECT employee_id, salary,
       row_number() OVER (ORDER BY salary DESC) AS rank
FROM hr.employees;

select * from(
select e.*, row_number() over (partition by job_id order by salary desc) r
from hr.employees e )
where r <=2;

--2. RANK()
--Provides a rank to each row within a partition, with gaps in ranks for tied values.
SELECT employee_id, department_id, salary,
      RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS rank
FROM hr.employees;

SELECT employee_id, salary,
       rank() OVER (ORDER BY salary DESC) AS rank
FROM hr.employees;

--3. DENSE_RANK()
--Similar to RANK(), but without gaps. Tied values share the same rank, and the next rank is incremented sequentially.
SELECT employee_id, salary,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM hr.employees;

SELECT employee_id, department_id, salary,
       DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS dense_rank
FROM hr.employees;

--4. LEAD()
--Accesses data from the following row, allowing for "look-ahead" comparisons.
SELECT employee_id, salary,
       LEAD(salary,  1) OVER (ORDER BY salary) AS next_salary
FROM hr.employees;

--5. LAG()
--Accesses data from the preceding row, allowing for "look-back" comparisons.
SELECT employee_id, salary,
       LAG(salary, 2, 0) OVER (ORDER BY salary) AS previous_salary--if no previous row then return 0
FROM hr.employees;


-------------------------------------------------set operator------------------------------------------------

--1. From the following tables, write a SQL query to find all salespeople and customers located in the city of London.

select salesman_id,name as salesman_name ,city  from salesman
where city = 'London' 
union 
select customer_id,cust_name as customer_name, city from customer 
where city = 'London' ; 

--2. From the following tables, write a SQL query to find distinct salespeople and their cities. Return salesperson ID and city.

select salesman_id ,city  from salesman
union 
select salesman_id, city from customer ; 

--3. From the following tables, write a SQL query to find all those salespeople and customers who are involved 
--in the inventory management system. Return salesperson ID, customer ID.

select customr_id ,salesman_id from orderr
union
select customer_id ,salesman_id from customer ;

--4. From the following table, write a SQL query to find the salespersons who generated the largest 
--and smallest orders on each date. Return salesperson ID, name, order no., highest on/lowest on, order date.

select s.salesman_id ,name , ord_no, ord_date, 'highest on'
from salesman s, orderr o 
where s.salesman_id = o.salesman_id
and purch_am = (select max(purch_am) from orderr b where o.ord_date = b.ord_date ) 
union
select s.salesman_id ,name , ord_no, ord_date, 'lowest on'
from salesman s, orderr o 
where s.salesman_id = o.salesman_id
and purch_am = (select min(purch_am) from orderr b where o.ord_date = b.ord_date ) ;

--5. From the following tables, write a SQL query to find the salespeople who generated the largest 
--and smallest orders on each date. Sort the result-set on third field. Return salesperson 
--ID, name, order no., highest on/lowest on, order date.

select s.salesman_id ,name , ord_no, ord_date, 'highest on'
from salesman s, orderr o 
where s.salesman_id = o.salesman_id
and purch_am = (select max(purch_am) from orderr b where o.ord_date = b.ord_date ) 
union
select s.salesman_id ,name , ord_no, ord_date, 'lowest on'
from salesman s, orderr o 
where s.salesman_id = o.salesman_id
and purch_am = (select min(purch_am) from orderr b where o.ord_date = b.ord_date ) 
order by 3 ;

--6. From the following tables, write a SQL query to find those salespeople who live in the same city 
--where the customer lives as well as those who do not have customers in their cities by 
--indicating 'NO MATCH'. Sort the result set on 2nd column (i.e. name) in descending order. 
--Return salesperson ID, name, customer name, commission.

SELECT salesman.salesman_id, name as salespeople_name, cust_name, commission 
FROM salesman, customer 
WHERE salesman.city = customer.city 
UNION 
SELECT salesman_id, name, 'NO MATCH', commission 
FROM salesman 
WHERE NOT city = ANY (SELECT city FROM customer) ORDER BY 2 DESC ;

--8. From the following table, write a SQL query to create a union of two queries that shows the customer id, 
--cities, and ratings of all customers. Those with a rating of 300 or greater will have the 
--words 'High Rating', while the others will have the words 'Low Rating'.

select customer_id,city,grade,'High rating'
from customer where grade >= 300 
union 
select customer_id,city,grade,'Low rating'
from customer where grade < 300  ;



select * from customer ;
select * from salesman ;
select * from orderr ;


---------------------------------------where,having,group by clause -------------------------------------------------
--Write a Oracle  SQL query to get the employee no, first name and last name for those employees who are earning commission.

select employee_id,first_name,last_name,commission_pct from hr.employees
where commission_pct is not null ;  --we can not use '=' with null values function.

--WSQ to get employee details who are join before 2006

select * from hr.employees
where hire_date <= to_date('2006', 'YYYY' ) ;  --we need to give date formate 

--show the record of employees whos manager id is 100.
select * from hr.employees
where manager_id = 100 ;

--find employees whos hire date before 2006, manager_id = 100, also salary greter than 10000
select * from hr.employees
where hire_date <= to_date('2006', 'YYYY' ) and manager_id = 100 and  salary > 10000 ; 

--find employess whos salary in 10000 to 30000 and manager_id greater than 140
select * from hr.employees
where salary in (10000, 30000) and manager_id > 140 ;

--Write a Oracle SQL query to get the maximum salary being paid to department ID.
select department_id, max(salary)
from hr.employees
group by department_id;

--Write a Oracle SQL query to get the designations (jobs) along with the total salary for those 
--designations where total salary is more than 50000.
select job_id, sum(salary) from hr.employees
group by job_id
having sum(salary) > 50000;

-- Write a Oracle SQL query to get the designations (jobs) along with the total salary 
-- for those designations where total salary is more than 50000.
select job_id, count(employee_id) from hr.employees
group by job_id
having count(employee_id) > 3;

--Write a Oracle SQL query to get the department number with more than 10 employees in each department.
select department_id,count(*) 
from hr.employees
group by department_id
having count(employee_id) > 10;

-------------------------------

--Find the Total and Average Salary per Department

select sum(salary),avg(salary),department_id from hr.employees
group by department_id ;

-- Count the Number of Employees in Each Job Role

select count(*) ,job_id from hr.employees
group by job_id ;

--Find the Highest, Lowest, and Average Salary in the Company

select round(avg(salary)), min(salary), max(salary) 
from hr.employees

--Find the Department with the Highest Average Salary

select * from (
select avg(salary), department_id 
from hr.employees
group by department_id
ORDER BY avg(salary) DESC )
where rownum = 1;


------------------------------------------------------------32 Q---------------------------------------------


select * from hr.employees 
select * from hr.departments
select * from hr.jobs

01 Write an SQL query to fetch all employees whose salary is greater than 50,000.
select * from hr.employees where salary > 50000 ;

02 Write an SQL query to fetch all employees working in the "IT" department.
select * from hr.employees e
join hr.departments d
on e.department_id = d.department_id
where department_name = 'IT'  ;

03 Write an SQL query to fetch employee names and their departments.
select first_name,last_name,department_name from hr.employees e
join hr.departments d
on e.department_id = d.department_id ;

04 Write an SQL query to fetch the top 3 highest-paid employees.
select * from (
select max(salary) from hr.employees order by salary desc )
where rownum <= 3 ;

05 Write an SQL query to fetch employees whose names start with the letter "A".
select * from hr.employees
where first_name like 'A%' ;

06 Write an SQL query to fetch employees who were hired in the year 2022.
select * from hr.employees
where hire_date = to_date('2022', 'YYYY');

07 Write an SQL query to count the total number of employees in each department.
select department_id,count(*) from hr.employees
group by department_id ;

08 Write an SQL query to find the average salary of employees in the "Finance" department.
select avg(salary),e.department_id,d.department_name from hr.employees e
join hr.departments d
on e.department_id = d.department_id
group by e.department_id ,d.department_name
having d.department_name = 'Finance' ;

SELECT AVG(e.salary) AS avg_salary, e.department_id
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance'
GROUP BY e.department_id;

09 Write an SQL query to fetch employees with salaries between 30,000 and 60,000.
select * from hr.employees
where salary between 30000 and 60000 ;

10 Write an SQL query to fetch all employees who do not belong to the "Human Resources" department.
select e.* from hr.employees e
join hr.departments d
on e.department_id = d.department_id
where department_name not in 'Human Resources' ;

11 Write an SQL query to fetch the details of employees who have not been assigned a department (NULL department).
select * from hr.employees
where department_id is null ;

12 Write an SQL query to fetch employee details sorted by their salaries in descending order.
select * from hr.employees
order by salary desc ;

13 Write an SQL query to fetch duplicate employee names from the employee table.
select count(*),first_name from hr.employees
group by first_name
having count(*) >= 2 ;

14 Write an SQL query to fetch the department name and the highest salary in each department.
select max(salary),department_name from hr.employees e
join hr.departments d
on e.department_id = d.department_id
group by department_name ;

15 Write an SQL query to update the salary of employees in the "IT" department by 10%.
UPDATE hr.employees e
SET e.salary = e.salary * 1.10
WHERE e.department_id = (            --not solve
    SELECT d.department_id 
    FROM hr.departments d 
    WHERE d.department_name = 'IT'
);

16 Write an SQL query to delete employees whose salaries are below 20,000.
delete from hr.employees
where salary < 20000 ;

17 Write an SQL query to insert a new employee into the table.
insert into hr.employees values(207,'Mical','Fay','MFAY',345.345.555,to_date('04-04-2025','DD-MM-YYYY'),50000,0.25,50,40);

18 Write an SQL query to fetch employees whose names contain the substring "John".
select * from hr.employees
where first_name like '%John%' ;

19 Write an SQL query to fetch employees whose email IDs end with "@company.com".
select * from hr.employees
where email like '%@company.com' ;

20 Write an SQL query to find the total salary paid to employees in each department.
select sum(salary),department_id from hr.employees
group by department_id ;

21 Write an SQL query to fetch the employee with the second-highest salary.
select max(salary) from hr.employees
where salary < (select max(salary) from hr.employees );

22 Write an SQL query to fetch the number of employees hired in each year.
select count(*),hire_date from hr.employees
group by hire_date = todate          --not solved
having hire_date = to_date(

SELECT EXTRACT(YEAR FROM hire_date) AS hire_year, 
       COUNT(*) AS employee_count
FROM hr.employees
GROUP BY EXTRACT(YEAR FROM hire_date)
ORDER BY hire_year;

23 Write an SQL query to fetch employees who share the same salary as another employee.
SELECT e1.* 
FROM hr.employees e1
JOIN hr.employees e2 
ON e1.salary = e2.salary    --not solve
AND e1.employee_id <> e2.employee_id
ORDER BY e1.salary;

24 Write an SQL query to fetch employees along with their managers name (using self-join).

select e.employee_id,e.first_name || e.last_name ,m.first_name || m.last_name 
from hr.employees e, hr.employees m
where e.manager_id = m.employee_id ;

25 Write an SQL query to fetch employees with the same department and job title as "John Doe."

26 Write an SQL query to find the maximum and minimum salary of employees.
select max(salary),min(salary) from hr.employees ;

27 Write an SQL query to fetch employees who were hired in the last 6 months.
SELECT employee_id, first_name, last_name, hire_date
FROM hr.employees
WHERE hire_date >= ADD_MONTHS(SYSDATE, -6);

28 Write an SQL query to fetch the employees who have worked for more than 5 years.
select employee_id, first_name, last_name, hire_date
from hr.employees
where months_between(sysdate, hire_date) > 60;

29 Write an SQL query to fetch all employees who do not have a manager assigned.
select employee_id, first_name, last_name, manager_id
from hr.employees
where manager_id is null;

30 Write an SQL query to fetch the first name, last name, and full name of employees.
select first_name,last_name,first_name || ' ' || last_name as full_name from hr.employees ;

31 Write an SQL query to fetch employees grouped by department and sorted by the total salary in descending order.
select department_id,sum(salary) from hr.employees
group by department_id
order by sum(salary) desc ;

32 Write an SQL query to fetch all employees whose salaries are more than the average salary.
select * from hr.employees
where salary > (select avg(salary) from hr.employees ) ;






----------------------------------------------------------------------------------------------
-----------------------------------------joins------------------------------------------------

/*I want to show employee details with salary having greater than 10 thousand also department_id should be less than 90
along with employee job description
and department description and the country of that employee*/

select e.* ,j.job_title,d.department_name,c.country_name
from hr.employees e
join hr.departments d
on e.department_id = d.department_id
join hr.jobs j ------------------------------inner join
on j.job_id = e.job_id
join hr.locations l
on l.location_id = d.location_id
join hr.countries c
on c.country_id = l.country_id
where e.salary > 10000 and e.department_id < 90 ;


SELECT e.*, j.job_title, d.department_name, c.country_name
FROM hr.employees e, hr.departments d, hr.jobs j, hr.locations l, hr.countries c
WHERE e.department_id = d.department_id
  AND j.job_id = e.job_id -----------------------------------equi join
  AND l.location_id = d.location_id
  AND c.country_id = l.country_id
  AND e.salary > 10000
  AND e.department_id < 90;
  

--                                        inner join

1. Get a list of employees and their department names, but only for those working in department_id 60 or 80.

select first_name ,last_name ,department_name from hr.employees e
inner join hr.departments d
on e.department_id = d.department_id
where e.department_id in (60 , 80) ;

select first_name, last_name, department_name
from hr.employees e, hr.departments d
where e.department_id = d.department_id
and e.department_id in (60, 80);



2.Show employee first name, last name, and their job title, but only for employees earning more than 10000.

select first_name ,last_name ,job_title from hr.employees e
inner join hr.jobs s
on e.job_id = s.job_id 
where  salary > 10000 ;

select first_name, last_name, job_title
from hr.employees e, hr.jobs s
where e.job_id = s.job_id
and salary > 10000;


3.Display all departments along with their location city and postal code.

select department_name, city, postal_code from hr.departments d
inner join hr.locations l 
on d.location_id = l.location_id ;

select department_name, city, postal_code
from hr.departments d, hr.locations l
where d.location_id = l.location_id;

4.List employees with their country name, only for employees working in the US or Canada.

select first_name ,last_name ,country_name from hr.employees e
inner join hr.departments d
on e.department_id = d.department_id
inner join hr.locations l
on l.location_id = d.location_id
inner join hr.countries c
on l.country_id = c.country_id
where c.country_id in ('US' , 'CA' ) ;

select first_name, last_name, country_name
from hr.employees e, hr.departments d, hr.locations l, hr.countries c
where e.department_id = d.department_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and c.country_id in ('us', 'ca');


5.Show department name along with the manager's full name, only if the manager's last name starts with 'K'.

select department_name , first_name || ' ' || last_name as full_name from hr.employees e
inner join hr.departments d
on e.manager_id = d.manager_id
where last_name like 'K%' ;

select department_name, first_name || ' ' || last_name as full_name
from hr.employees e, hr.departments d
where e.manager_id = d.manager_id
and last_name like 'k%';


6.Display each region name and the count of employees working in that region.

select r.region_name , count(employee_id) from hr.employees e
inner join hr.departments d
on e.manager_id = d.manager_id
inner join hr.locations l
on l.location_id = d.location_id
inner join hr.countries c
on l.country_id = c.country_id
inner join hr.regions r
on r.region_id = c.region_id
group by r.region_name ;

select r.region_name, count(employee_id)
from hr.employees e, hr.departments d, hr.locations l, hr.countries c, hr.regions r
where e.manager_id = d.manager_id
and d.location_id = l.location_id
and l.country_id = c.country_id
and c.region_id = r.region_id
group by r.region_name;

7.Show department name and count of different job titles, but only if the department has 
  more than 3 job types assigned.

select department_name , count(job_title) from hr.departments d
inner join hr.employees e
on d.department_id = e.department_id
inner join hr.jobs j
on e.job_id = j.job_id
group by department_name
having count(job_title) > 3 ;

select department_name, count(job_title)
from hr.departments d, hr.employees e, hr.jobs j
where d.department_id = e.department_id
and e.job_id = j.job_id
group by department_name
having count(job_title) > 3;


8.List all countries in the 'Europe' and 'Asia' regions only.

select country_name , region_name from hr.countries c
inner join hr.regions r
on c.region_id = r.region_id
where region_name  in ('Europe' , 'Asia') ;

select country_name, region_name
from hr.countries c, hr.regions r
where c.region_id = r.region_id
and region_name in ('Europe', 'Asia');


9.For each job title, show the number of employees, but only include job titles with more than 5 employees.

select job_title , count(employee_id) from hr.employees e
inner join hr.jobs j
on e.job_id = j.job_id
group by job_title 
having count(employee_id) > 5 ;

select job_title, count(employee_id)
from hr.employees e, hr.jobs j
where e.job_id = j.job_id
group by job_title
having count(employee_id) > 5;


10.List all locations with their country and region name, only for locations in cities that start with 'S' or 'B'

select location_id, region_name, country_name from hr.locations l
inner join hr.countries c
on l.country_id = c.country_id
inner join hr.regions r
on r.region_id = c.region_id
where l.city like 'S%' or l.city like 'B%' ;

select location_id, region_name, country_name
from hr.locations l, hr.countries c, hr.regions r
where l.country_id = c.country_id
and c.region_id = r.region_id
and (l.city like 's%' or l.city like 'b%');


--                                                  Left Join

1.List all departments and the employees in them, including departments that have no employees.

select first_name, last_name, d.department_name from hr.departments d
left join hr.employees e on e.department_id = d.department_id;

2.Show all employees and their managers full names, even if the manager information is missing.

SELECT 
    e.first_name AS employee_first_name,
    e.last_name AS employee_last_name,
    m.first_name || ' ' || m.last_name AS manager_full_name
FROM hr.employees e
LEFT JOIN hr.employees m
    ON e.manager_id = m.employee_id;
    
    select emp.first_name  , emp.last_name, concat( man.first_name, man.last_name) AS manager_full_name from hr.employees emp
left outer join hr.employees man
on man.employee_id = emp.manager_id ;

3.List all job titles and the employees assigned to them, even if no employee currently holds a certain job.

select job_title, first_name, last_name from hr.jobs s
left join hr.employees e
on s.job_id = e.job_id ;

4.Display all countries and the departments located in them, even if a country has no department assigned.

select country_name, department_name from hr.countries c
left join hr.locations l  
on c.country_id = l.country_id
left join hr.departments d
on l.location_id = d.location_id ;

5.Show all locations and the departments at each location, including locations that currently have no departments

select city, department_name from hr.locations l
left join hr.departments d
on l.location_id = d.location_id ;

6.List all employees and the department names they belong to, but include employees even 
  if they’re not assigned to any department.

select first_name, last_name, department_name from hr.employees e
left join hr.departments d
on e.department_id = d.department_id ;

7.Get a list of all regions and the countries within them, even if the region has no countries assigned.

select region_name, country_name from hr.regions r
left join hr.countries c
on r.region_id = c.region_id ; 

8.Show all managers and the departments they manage, including managers who are not managing any department.

select first_name ||' '|| last_name as manager_name ,department_name from hr.employees e
left join hr.departments d
on e.manager_id = d.manager_id ;

select first_name ||' '|| last_name as manager_name ,department_name from hr.employees e
left join hr.departments d                   --correct 
on e.employee_id = d.manager_id ;

9.Display all job titles and the average salary of employees in each, even if no one currently has that job

select job_title, avg(salary) from hr.jobs j
left join hr.employees e
on j.job_id = e.job_id
group by job_title ;

10.List all employees and the cities of their departments, even if some employees are not 
   assigned to a department or the department is not assigned to a location.

select first_name, last_name, city from hr.employees e 
left join hr.departments d
on e.department_id = d.department_id
left join hr.locations l
on l.location_id = d.location_id ;

--                                        Right Join 

1.List all employees along with their department names, including departments that have no employees.

select first_name, last_name, department_name from hr.employees e
right join hr.departments d
on e.department_id = d.department_id ;

2.Show all job titles and the employees holding them, including job titles that are not currently 
  assigned to any employee.

select job_title, first_name, last_name from hr.employees e
right join hr.jobs j 
on j.job_id = e.job_id ;

3.Display all countries and the departments located in them, including countries that have no departments.

select country_name, department_name from hr.departments d
right join hr.locations l 
on d.location_id = l.location_id
right join hr.countries c
on c.country_id = l.country_id ;

4.List all locations and the departments at those locations, including locations without any departments.

select l.city, department_name from hr.departments d
right join hr.locations l
on d.location_id = l.location_id ;

5.Show all departments and the managers assigned to them, including departments that currently don’t have a manager

select department_name, first_name ||' '|| last_name as manager_name from hr.employees e
right join hr.departments d 
on e.department_id = d.manager_id ;

6.Display all employees and their managers’ names, including employees who are not managed by anyone.

select e.first_name || ' ' || e.last_name as employee_name ,
       b.first_name || ' ' || b.last_name as manager_name from hr.employees b
       right join  hr.employees e
       on b.manager_id = e.employee_id ;
       
7.List all countries and the cities they contain, including countries without any cities (locations).

select country_name, city from hr.locations l
right join hr.countries c 
on c.country_id = l.country_id ;

8.Get all employees and the job details, even if the job info is missing (maybe due to incorrect job_id).

select first_name, last_name, job_title from hr.employees e
right join hr.jobs j 
on e.job_id = j.job_id ;

9.Show all regions and the countries in them, even if some countries are not assigned to any region.

select region_name, country_name 
from hr.countries c
right join hr.regions r 
on c.region_id = r.region_id;

10.Display all departments and the employees working in them, even if an employee is not assigned to any department.

select department_name, first_name, last_name 
from hr.employees e
right join hr.departments d 
on e.department_id = d.department_id;


--                                       Full Join

1.List all employees and departments, including employees not assigned to any department and departments 
  with no employees.

select first_name, last_name, department_name from hr.employees e
full join hr.departments d
on e.department_id = d.department_id ;

2.Show all jobs and employees, including jobs with no employees and employees with invalid job IDs.

select first_name, last_name, job_title from hr.employees e
full join hr.jobs j
on e.job_id = j.job_id ;

3.Display all departments and their managers, even if a department has no manager or a manager 
  is not assigned to a department

select department_name, first_name||' '||last_name as manager_name from hr.employees e
full join hr.departments d
on e.employee_id = d.manager_id ;

4.List all countries and locations, even if a country has no locations or a location 
  has an invalid country reference.

select country_name, l.city from hr.locations l
full join hr.countries c
on l.country_id = c.country_id ;

5.Show all employees and their managers’ names, even if an employee has no manager or 
  someone is not managing anyone.

select a.first_name ||' '|| a.last_name as employee_name ,
       b.first_name ||' '|| b.last_name as manager_name from hr.employees a
       full join hr.employees b 
       on a.manager_id = b.employee_id ;
       
6.List all regions and countries, even if some regions have no countries or 
  some countries have invalid region IDs.

select region_name, country_name from hr.countries c
full join hr.regions r
on c.region_id = r.region_id ;

7.Display all locations and departments, including locations with no departments and 
  departments with invalid location IDs.

select city, department_name from hr.departments d
full join hr.locations l
on d.location_id = l.location_id ;

8.Show all employees and job history records, including employees with no history and 
  historical jobs not linked to current employees.

select first_name, last_name, j.* from hr.employees e
full join hr.job_history j
on e.employee_id = j.employee_id ;

9.List all departments and job titles, even if some job titles aren’t assigned in the department or vice versa.

select department_name, job_title from hr.departments d
full join hr.employees e
on d.department_id = e.department_id 
full join hr.jobs j
on e.job_id = j.job_id ;

10.Show all employees and the projects they are assigned to, even if some employees are 
   not in any project or some projects have no employees assigned.

--here 1 table not exist

--                                 Non-corelated  Subquery

--1.Find employees who earn more than the average salary of all employees.

select first_name, last_name, salary from hr.employees
where salary > (select avg(salary) from hr.employees ) ;

--2.Display departments located in the same location as department 90.

select d.department_name, location_id from hr.departments d
where location_id = (select location_id from hr.departments where department_id = 90 ) ;

--3.Display departments and there city located in the same location as department 90.

select d.department_name, d.location_id, l.city from hr.departments d
inner join hr.locations l
on d.location_id = l.location_id
where d.location_id = (select location_id from hr.departments where department_id = 90 ) ;


--4.List employees who have the same job as employee ID 105.

select * from hr.employees 
where job_id = (select job_id from hr.employees where employee_id = 105 ) ;

--5.Show job titles where the minimum salary is less than the average salary of all employees.

select job_title,min_salary from hr.jobs
where min_salary < (select avg(salary) from hr.employees );

--6.Find employees who work in the same department as employee ID 100.

select * from hr.employees 
where department_id = (select department_id from hr.employees where employee_id = 100 );

--7.List all countries that belong to the same region as the United States of America.

select country_name,region_id from hr.countries
where region_id = ( select region_id from hr.countries where country_name = 'United States of America' ) ;

--8.Identify jobs where the maximum salary is higher than the max salary of the 'IT_PROG' job.

select * from hr.jobs 
where max_salary > (select max_salary from hr.jobs where job_id = 'IT_PROG');

--9.Find employees hired after the earliest hire date in the company.

select * from hr.employees 
where hire_date > (select min(hire_date) from hr.employees) ;

--10.Display departments located in the city of Toronto.

select * from hr.departments
where location_id = (select location_id from hr.locations where city = 'Toronto') ;

--11.Show the region name where the country 'China' is located.

select region_name from hr.regions 
where region_id = (select region_id from hr.countries where country_name = 'China' ) ;


----------------------------------------------------------------------------------------------------------------
--                                   corelated subquery
  
                      Important SQL Subquery Comparison Keywords:

Keyword                                      	Meaning

ALL                         	Condition must be true for all values returned by the subquery.
                              Compare to every value in a list	
                              
ANY / SOME                  	Condition must be true for at least one value from the subquery.
                              Compare to at least one value in a list	
                              
IN	                          Checks if a value exists in the list returned by the subquery.
                              Check if value is inside a list	
                              
EXISTS	                      Checks whether the subquery returns any rows (true/false).
                              Check if at least one row exists	
                              
NOT IN	                      Checks if a value is not in the list returned by the subquery.
                              Exclude values from a list	
                              
NOT EXISTS	                  Checks if the subquery returns no rows.
                              Check if no matching row exists	
                              
= != < > <= >=                Also we can use comparison operator.
                              

--1.List employees who earn more than the average salary of their own department.

select e.first_name , e.last_name, e.salary, e.department_id from hr.employees e
where e.salary > (select avg(e1.salary) from hr.employees e1      
                 where e.department_id = e1.department_id) ; 

--2.Show employees whose hire date is earlier than the hire date of their manager.

select e.first_name, e.last_name, e.hire_date, e.manager_id from hr.employees e
where e.hire_date < (select e1.hire_date from hr.employees e1
                     where e.manager_id = e1.employee_id ) ; 

--3.Display employees who earn more than any other employee in the same job.

select e.first_name, e.last_name, e.salary from hr.employees e
where e.salary > ( select max(e1.salary) from hr.employees e1
                   where e1.job_id = e.job_id and e.employee_id != e1.employee_id ) ;
                   
                   select * from hr.employees ;
                   
--4.List departments where the number of employees is greater than 5.

select e.department_id from hr.employees e
where e.department_id > (select e1.department_id from hr.employees e1
                        where  e.department_id = e1.department_id and count(e1.employee_id) > 5 ) ;
                        
select department_name
from hr.departments d
where (
  select count(*)            --correct
  from hr.employees e 
  where e.department_id = d.department_id
) > 5;

--5.Find employees who are the only person in their department.

select e.first_name, e.last_name from hr.employees e
where  (select count(e1.employee_id) from hr.employees e1
        where e.department_id = e1.department_id ) = 1 ;
                            
--6.Show employees whose salary is the highest in their department.

select e.first_name, e.last_name, e.salary from hr.employees e
where e.salary = (select max(e1.salary) from hr.employees e1
                   where e.department_id = e1.department_id ) ;

--7.List employees who have the lowest salary in their job.

select e.first_name, e.last_name, e.salary from hr.employees e
where e.salary = (select min(e1.salary) from hr.employees e1
                   where e.job_id = e1.job_id ) ;

--8.Display employees whose commission is greater than their department’s average commission.

select e.first_name, e.last_name, e.salary 
from hr.employees e
where e.commission_pct > (
select avg(e1.commission_pct) 
from hr.employees e1
where e.department_id = e1.department_id ) ;

select e.first_name, e.last_name, e.commission_pct
from hr.employees e
where e.commission_pct is not null
  and e.commission_pct > (                     ---Handles null
    select avg(e1.commission_pct)
    from hr.employees e1
    where e1.department_id = e.department_id
      and e1.commission_pct is not null
  );

--9.Find departments where all employees earn more than 5000.

select distinct e.department_id
from hr.employees e
where not exists (
    select 1
    from hr.employees e1
    where e1.department_id = e.department_id
      and e1.salary <= 5000
);

select distinct e.department_id, d.department_name
from hr.employees e
join hr.departments d on e.department_id = d.department_id
where not exists (
    select 1
    from hr.employees e1
    where e1.department_id = e.department_id
      and e1.salary <= 5000
);


--10.List jobs where the maximum salary is more than any employee’s salary in that job.

select j.job_id, j.job_title
from hr.jobs j
where j.max_salary > (
    select max(e.salary)
    from hr.employees e
    where e.job_id = j.job_id
);

----------------------------------------------------------------------------------------------------------------
--                                        Analytical Function

--1.Rank employees based on salary within each department.

select first_name, last_name, rank() over (partition by department_id order by salary ) from hr.employees ;

--2.Show employees salaries along with the average salary of their department.

select 
       first_name, 
       last_name, 
       salary,
       avg(salary) over (partition by department_id) as avg_dpt_sal
from
       hr.employees ;
       
--3.Display employees with their salary and the highest salary in their department.

select 
       first_name, 
       last_name, 
       salary,
   
       hr.employees ;

--4.List employees with their hire date and the number of days since the last hire in their department.

select 
       first_name, 
       last_name, 
       hire_date,
       hire_date - lag(hire_date) over (partition by department_id order by hire_date) as days_since_last_hire
from 
    hr.employees;

--5.Show employees along with their cumulative salary in their department (ordered by salary).

select 
       first_name, 
       last_name, 
       salary,
       sum(salary) over (partition by department_id order by salary) as sum_dpt_sal
from
       hr.employees ;

--6.Display each employee’s salary and the difference from the department’s average salary.

select 
       first_name, 
       last_name, 
       salary,
       salary - avg(salary) over (partition by department_id ) as avg_dpt_sal
from
       hr.employees ;
       
--7.For each department, show the first and last employee hired.

select 
       first_name, 
       last_name, 
       min(hire_date) over (partition by department_id order by  department_id asc ) as min_hire_date
from 
       hr.employees ;
       
select 
    department_id,
    first_name,
    last_name,
    hire_date,
    first_value(first_name || ' ' || last_name) over (
        partition by department_id                  --first_value,last_value is the analytical functions in 
        order by hire_date                          --Oracle SQL that let you look at values from other rows 
    ) as first_hired,                               --within a group (partition).
    last_value(first_name || ' ' || last_name) over (
        partition by department_id 
        order by hire_date 
        rows between unbounded preceding and unbounded following
    ) as last_hired
from 
    hr.employees;

--8.List employees and their row number based on salary descending within their job.

select 
       first_name,
       last_name,
       row_number() over (order by salary desc) as row_num
from
       hr.employees ;
       
--9.Rank employees across the entire company based on hire date.

select 
       first_name,
       last_name,
       hire_date,
       rank() over (order by hire_date )
from
       hr.employees ;

--10.Show the percentage contribution of each employees salary to their departments total salary.

select 
    first_name,
    last_name,
    department_id,
    salary,
    round((salary / sum(salary) over (partition by department_id)) * 100, 2) as contribution_percent
from 
    hr.employees;




select * from hr.employees;
select * from hr.departments;
select * from hr.countries;
select * from hr.jobs;
select * from hr.locations;
select * from hr.regions;
select * from hr.Job_History;


--List Employees Who Have a Salary Greater Than Their Departments Average Salary
--Get employees who earn more than the average salary of their department using HR.EMPLOYEES and HR.DEPARTMENTS.

  select e.first_name, e.last_name, e.department_id, e.salary
  from hr.employees e
  join (
      select department_id, avg(salary) as avg_salary
      from hr.employees
      group by department_id
  ) dept_avg
  on e.department_id = dept_avg.department_id
  where e.salary > dept_avg.avg_salary;


----


select region_name from hr.regions 
where region_id = (select region_id from countries where country_name = 'China' ) ;




-------------------------------------------------SQL loader--------------------------------------------------
 CREATE TABLE EMPLOYEE22 (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(100),
    emp_salary NUMBER(10, 2),
    emp_department VARCHAR2(50)
);

 
select * from employee ;
truncate table employee ;
drop table employee ;


ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;

SELECT table_name FROM user_tables WHERE table_name = 'EMPLOYEE';

CREATE TABLE customer2 (
  c_id          NUMBER PRIMARY KEY,
  c_name        VARCHAR2(100),
  c_address     VARCHAR2(200),
  c_contact     VARCHAR2(15),
  c_creditdays  NUMBER,
  cj_date       DATE,
  c_sex         CHAR(1)
);

select * from CUSTOMER2 ;


ALTER USER loader ACCOUNT UNLOCK;




select * from image_table ;


CREATE USER shubh IDENTIFIED BY shubh123;
GRANT CONNECT, RESOURCE TO shubh;

CREATE TABLE employee (
  emp_id     NUMBER,
  first_name VARCHAR2(50),
  last_name  VARCHAR2(50)
);

SELECT * FROM employee;

SELECT table_name FROM user_tables WHERE table_name LIKE '%EMP%';

SELECT table_name FROM all_tables WHERE owner = 'shubh' AND table_name LIKE '%EMP%';

SELECT USER FROM DUAL;

ALTER SESSION SET CURRENT_SCHEMA = shubh;

CREATE TABLE employee1 (
  emp_id       NUMBER,         -- Assuming `emp_id` is a numeric value
  emp_name     VARCHAR2(100),  -- Assuming `emp_name` is a string
  emp_salary   NUMBER(10, 2),  -- Assuming `emp_salary` is a decimal (you can adjust precision as needed)
  emp_department VARCHAR2(50)  -- Assuming `emp_department` is a string
);

select * from employee ;

truncate table employee1 ;

---image

CREATE TABLE image_table (
    image_id   VARCHAR2(50),
    image_data BLOB
);

select * from image_table ;


SELECT first_name,
    last_name,
    job_id,
    CASE
        WHEN salary < 5000 THEN 'poor'
        WHEN salary < 10000 THEN 'lower middle class'
        WHEN salary < 15000 THEN 'upper middle class'
        ELSE 'Rich'
    END AS status_symbol FROM
    hr.employees;
    
    SELECT 
    CASE
        WHEN salary < 5000 THEN 'poor'
        WHEN salary < 10000 THEN 'lower middle class'
        WHEN salary < 15000 THEN 'upper middle class'
        ELSE 'Rich'
    END AS status_symbol,
    first_name,
    last_name,
    job_id FROM
    hr.employees;
    
    
create table emp5(
employee_id int,
 first_name varchar2(100),
  last_name varchar2(100), 
  email varchar2(100),
   phone_number varchar2(100), 
   hire_date date,
    job_id varchar(30), 
    salary int, 
    manager_id varchar(10), 
    department_id varchar2(10));
    
select * from emp5 ;
    
begin
  for i in 1 .. 500000 loop
    insert into emp(employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, manager_id, department_id)
    values (dbms_random.value(1,10000000),dbms_random.string('a',26),dbms_random.string('a',26),
            dbms_random.string('a',26)||'@mail.com',dbms_random.value(1,100),'01-01-25',
            'Housekeep',dbms_random.value(1,100),null,null);
  end loop;
exception
  when others then
    dbms_output.put_line('Err: '||dbms_utility.format_error_stack||dbms_utility.format_error_backtrace);
end;
/
alter table emp modify phone_number varchar2(100);


select * from emp5;

BEGIN
  FOR i IN 1..500000 LOOP
    INSERT INTO emp5 (
      employee_id,
      first_name,
      last_name,
      email,
      phone_number,
      hire_date,
      job_id,
      salary,
      manager_id,
      department_id
    )
    VALUES (
      i,
      'First_' || i,
      'Last_' || i,
      'user' || i || '@mail.com',
      '90000000' || MOD(i, 100),
      SYSDATE - MOD(i, 1000),
      CASE
        WHEN MOD(i, 5) = 0 THEN 'HR'
        WHEN MOD(i, 5) = 1 THEN 'IT_PROG'
        WHEN MOD(i, 5) = 2 THEN 'MKT_EXEC'
        WHEN MOD(i, 5) = 3 THEN 'ACCT_CLRK'
        ELSE 'SA_REP'
      END,
      TRUNC(DBMS_RANDOM.VALUE(2000, 10000)),
      TO_CHAR(MOD(i, 50)),
      TO_CHAR(MOD(i, 10))
    );

    -- Commit every 10,000 rows to avoid rollback overflow
    IF MOD(i, 10000) = 0 THEN
      COMMIT;
    END IF;
  END LOOP;

  COMMIT;
END;
/
SELECT COUNT(*) FROM emp5;

CREATE OR REPLACE VIEW emp_summary_view AS
SELECT
  job_id,
  department_id,            --complex view 
  COUNT(*) AS total_employees,
  ROUND(AVG(salary), 2) AS avg_salary
FROM emp5
GROUP BY job_id, department_id;

SELECT * FROM emp_summary_view WHERE job_id = 'HR';

CREATE MATERIALIZED VIEW emp_summary_mv1
BUILD IMMEDIATE
REFRESH ON DEMAND
AS
SELECT
  job_id,
  department_id,
  COUNT(*) AS total_employees,
  ROUND(AVG(salary), 2) AS avg_salary
FROM emp5
GROUP BY job_id, department_id;

SELECT * FROM emp_summary_mv1 WHERE job_id = 'HR';

SELECT * FROM emp_summary_mv ;
SELECT * FROM emp_summary_view ;

select employee_id, first_name, last_name, sum(salary) over (partition by job_id) as sum_salary from emp5 ;

create materialized view m_views_on_5L 
refresh force on demand as 
select employee_id, first_name, last_name, sum(salary) over (partition by job_id) as sum_salary from emp5 ;

exec dbms_mview.refresh('m_views_on_5L');

drop materialized view m_views_on_5L ;

select * from m_views_on_5L where employee_id > 499000 ;

create view c_views_on_5L as
 select employee_id, first_name, last_name, sum(salary) over (partition by job_id) as sum_salary from emp5 ;

select * from c_views_on_5L where employee_id > 499000 ;


create table demo1(id int,
             name varchar2(50),
             result varchar2(10) );

select * from demo1 ;

insert into demo1 values(1,'student1','pass');
insert into demo1 values(2,'student2','pass');
insert into demo1 values(3,'student3','pass');
insert into demo1 values(4,'student4','pass');
insert into demo1 values(5,'student5','pass');
insert into demo1 values(6,'student6','fail');
insert into demo1 values(7,'student7','fail');
insert into demo1 values(8,'student8','fail');
insert into demo1 values(9,'student9','fail');
insert into demo1 values(10,'student10','fail');

--on demand
create materialized view mviews_demo1  
refresh force on demand as select * from demo1 ;

select * from mviews_demo1 ;


SELECT * FROM (
  SELECT t.*, ROWNUM rn FROM hr.employees t WHERE ROWNUM <= 10
)
WHERE rn > 5;

SELECT LEVEL FROM dual CONNECT BY LEVEL <= 5;

drop table demo1

-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------
-- Dataset name is RETAIL_DATA for chat_gpt reference.
--If you want to perform any operation base on this data then just point chat_gpt to RETAIL_DATA
--hi will understand.

-- Creted in user := shubh, Pass := shubh123, AS SYSDBA :



CREATE TABLE CLIENTS (
    CLIENT_ID NUMBER PRIMARY KEY,
    CLIENT_NAME VARCHAR2(50),
    CITY VARCHAR2(30),
    JOIN_DATE DATE
);

-- Insert 100 clients
INSERT INTO CLIENTS (CLIENT_ID, CLIENT_NAME, CITY, JOIN_DATE)
SELECT LEVEL,
       'Client_' || LEVEL,
       CASE MOD(LEVEL,5)
            WHEN 0 THEN 'Mumbai'
            WHEN 1 THEN 'Delhi'
            WHEN 2 THEN 'Bangalore'
            WHEN 3 THEN 'Chennai'
            ELSE 'Kolkata'
       END,
       TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 1000))
FROM dual
CONNECT BY LEVEL <= 100;

CREATE TABLE ITEMS (
    ITEM_ID NUMBER PRIMARY KEY,
    ITEM_NAME VARCHAR2(50),
    CATEGORY VARCHAR2(20),
    PRICE NUMBER(8,2)
);

-- Insert 20 items
INSERT INTO ITEMS (ITEM_ID, ITEM_NAME, CATEGORY, PRICE)
SELECT LEVEL,
       'Item_' || LEVEL,
       CASE
            WHEN LEVEL <= 5 THEN 'Electronics'
            WHEN LEVEL <= 10 THEN 'Clothing'
            WHEN LEVEL <= 15 THEN 'Furniture'
            ELSE 'Stationery'
       END,
       ROUND(DBMS_RANDOM.VALUE(100, 5000),2)
FROM dual
CONNECT BY LEVEL <= 20;

CREATE TABLE SALES (
    SALE_ID NUMBER PRIMARY KEY,
    CLIENT_ID NUMBER REFERENCES CLIENTS(CLIENT_ID),
    ITEM_ID NUMBER REFERENCES ITEMS(ITEM_ID),
    SALE_DATE DATE,
    QUANTITY NUMBER(3)
);

-- Insert 200 sales
INSERT INTO SALES (SALE_ID, CLIENT_ID, ITEM_ID, SALE_DATE, QUANTITY)
SELECT LEVEL,
       TRUNC(DBMS_RANDOM.VALUE(1,101)),  -- Random client 1-100
       TRUNC(DBMS_RANDOM.VALUE(1,21)),   -- Random item 1-20
       TRUNC(SYSDATE - DBMS_RANDOM.VALUE(0, 365)),
       TRUNC(DBMS_RANDOM.VALUE(1,10))
FROM dual
CONNECT BY LEVEL <= 200;

commit;

--Aggregate Functions (GROUP BY / HAVING / SUM / AVG / COUNT)
--Q1: Find the total quantity of items purchased by each client.
--Show CLIENT_NAME, total quantity.
--Sort by total quantity descending.

select c.client_name, sum(quantity) as total_quentity
  from clients c
  join sales s
    on c.client_id = s.client_id
 group by c.client_name
 order by total_quentity desc;


--Q2: Find the average order value per client.
--Use PRICE * QUANTITY as order value.
--Show CLIENT_NAME and average order value.

select c.client_name, round(avg(quantity*price),2) as avg_order_value
  from clients c
  join sales s
    on c.client_id = s.client_id
  join items i
    on i.item_id = s.item_id
 group by c.client_name
 order by avg_order_value desc;

--Q3: Find items that have been sold more than 5 times in total.
--Show ITEM_NAME, total quantity sold.
  select i.item_name, sum(quantity) as quantity_sold
    from items i
    join sales s
      on i.item_id = s.item_id
   group by i.item_name
  having sum(quantity) > 5;


--2.Analytical Functions (OVER / RANK / ROW_NUMBER / LEAD / LAG)
--Q4: For each client, assign a rank based on total purchase amount.
--Total purchase amount = SUM(PRICE * QUANTITY) per client
--Use RANK() function



select * from clients ;
select * from items ;
select * from sales ;
/*Q5: For each client, show their last 3 purchases by SALE_DATE.

Include SALE_ID, ITEM_NAME, SALE_DATE, QUANTITY

Use ROW_NUMBER() or RANK() analytical function

Q6: Show for each client the current sale amount and previous sale amount (based on SALE_DATE).

Columns: CLIENT_NAME, SALE_DATE, CURRENT_AMOUNT, PREV_AMOUNT

Use LAG()

3️⃣ Joins (INNER / LEFT / RIGHT / FULL / CROSS)

Q7: List all sales with client and item details.

Columns: SALE_ID, CLIENT_NAME, ITEM_NAME, QUANTITY, SALE_DATE

Use INNER JOIN

Q8: List all clients and their total number of orders, including clients who never placed an order.

Columns: CLIENT_NAME, TOTAL_ORDERS

Use LEFT JOIN

Q9: List all items and total quantity sold, including items never sold.

Columns: ITEM_NAME, TOTAL_QUANTITY

Use RIGHT JOIN or LEFT JOIN

Q10: Find clients who have purchased the same item more than once.

Show CLIENT_NAME, ITEM_NAME, COUNT(*)

Use JOIN with aggregate*/


---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
--- SubQuery

--Q1: Clients with above-average total purchase quantity
--Find all clients whose total quantity purchased across all items is greater than the 
--average total quantity per client.
--Show: CLIENT_NAME and total purchased quantity.

select client_name, sum(quantity) as total_purchase_Q
  from clients c
  join sales s
    on c.client_id = s.client_id
 group by client_name
having sum(quantity) > (select avg(total_qty)
                          from (select sum(quantity) as total_qty
                                  from sales
                                 group by client_id));

--Q2: Items never sold
--List all items that never appear in SALES.
--Show: ITEM_NAME and CATEGORY.

select item_name, category
  from items i
 where not exists (select 1 from sales s where i.item_id = s.item_id);

/*Q3: Clients who purchased the same item more than 5 times in total

Find clients who bought any item more than 5 times in total.
Show: CLIENT_NAME, ITEM_NAME, and total quantity purchased.

Q4: Latest sale date for each client

Show each CLIENT_NAME and the latest sale date they made a purchase.
Use a scalar subquery.

Q5: Clients who purchased all items from category ‘Electronics’

Find clients who have bought every item in the 'Electronics' category.
Show: CLIENT_NAME.
Use a double NOT EXISTS (division-style query).*/


select * from clients ;
select * from items ;
select * from sales ;

---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
-- Case Decode

--Q1: Categorize clients based on total purchase quantity
--For each client, calculate the total quantity purchased and categorize as:
--'Low' → total quantity < 20
--'Medium' → total quantity between 20 and 50
--'High' → total quantity > 50
--Show: CLIENT_NAME, total_quantity, CATEGORY using CASE.


/*Q2: Flag items as expensive or cheap

Show ITEM_NAME, PRICE and a flag 'Expensive' if price > 2000, 'Moderate' if price between 1000–2000, 'Cheap' if price < 1000.

Use DECODE or CASE.

Q3: Discount assignment using DECODE

For each client, assign a discount % based on total purchase quantity:

0–10 → 5%

11–30 → 10%

31–50 → 15%

50 → 20%

Show CLIENT_NAME, total_quantity, DISCOUNT using DECODE.

Q4: Sale quantity status

For each sale in SALES, create a column STATUS:

'Small' → quantity <= 3

'Medium' → quantity between 4–6

'Large' → quantity > 6

Use CASE.

Q5: Client city and purchase category summary

For each client, show CLIENT_NAME and a summary based on the categories of items purchased:

'Electronics Lover' → if purchased at least one Electronics item

'Clothing Fan' → if purchased at least one Clothing item

'Mixed Shopper' → if purchased multiple categories

Use CASE or DECODE with subqueries or aggregation.
*/

















