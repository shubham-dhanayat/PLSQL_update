
create or replace function demo
return varchar2
is 
begin
  return 'hello word';
  end;
  
  begin
    dbms_output.put_line(demo());
    end;

--------------------------------------------------functon -------------
CREATE OR REPLACE FUNCTION calculate_square (
    number_in IN NUMBER
)
RETURN NUMBER IS
    square NUMBER;
BEGIN
    square := number_in * number_in;
    RETURN square;
END calculate_square;

-- Calling the function in PL/SQL
DECLARE
    result NUMBER;
BEGIN
    result := calculate_square(5);
    DBMS_OUTPUT.PUT_LINE('Square: ' || result);
END;

-- Calling the function in SQL
SELECT calculate_square(4) AS square_value FROM DUAL;

begin
      DBMS_OUTPUT.PUT_LINE('square : ' || calculate_square(5));
      end;
      
      
      
      
      
--Function with Conditional Logic
CREATE OR REPLACE FUNCTION check_even_odd (
    number_in IN NUMBER
)
RETURN VARCHAR2 IS
BEGIN
    IF MOD(number_in, 2) = 0 THEN
        RETURN 'Even';
    ELSE
        RETURN 'Odd';
    END IF;
END check_even_odd;


-- Calling the function in PL/SQL
DECLARE
    result VARCHAR2(10);
BEGIN
    result := check_even_odd(7);
    DBMS_OUTPUT.PUT_LINE('The number is: ' || result);
END;

-- Calling the function in SQL
SELECT check_even_odd(8) AS number_type FROM DUAL;

begin 
      DBMS_OUTPUT.PUT_LINE('The number is: ' || check_even_odd(29));
end;



CREATE OR REPLACE FUNCTION get_total_sales(
    in_year PLS_INTEGER
) 
RETURN NUMBER
IS
    l_total_sales NUMBER := 0;
BEGIN
    -- get total sales
    SELECT SUM(unit_price * quantity)
    INTO l_total_sales
    FROM order_items
    INNER JOIN orders USING (order_id)
    WHERE status = 'Shipped'
    GROUP BY EXTRACT(YEAR FROM order_date)
    HAVING EXTRACT(YEAR FROM order_date) = in_year;
    
    -- return the total sales
    RETURN l_total_sales;
END;


create or replace function test_fn return number as 
pragma autonomous_transaction ;
begin
  execute immediate 'create table test_table(id number)';
  execute immediate 'drop table test_table' ;
  update emp 
  set sal1 = sal1 ;
  return 1;
  end;
  
declare 
IV number;
begin
  IV := test_fn;
  end;
  
  
---------------------------------------functions--------------------------------------------------
----------------------------------------Forward Declaration--------------------------------------------

DECLARE  
   -- Forward Declaration of Function  
   FUNCTION get_bonus(emp_id NUMBER) RETURN NUMBER;  

   -- Using the Function Before Definition  
   emp_bonus NUMBER;
BEGIN  
   emp_bonus := get_bonus(101);  
   DBMS_OUTPUT.PUT_LINE('Bonus: ' || emp_bonus);  
END;  

-- Function Definition  
FUNCTION get_bonus(emp_id NUMBER) RETURN NUMBER IS  
BEGIN  
   RETURN emp_id * 100;  -- Example bonus calculation  
END;




CREATE OR REPLACE PACKAGE employee_pkg AS  
   FUNCTION get_bonus(emp_id NUMBER) RETURN NUMBER;  -- Forward Declaration  
END employee_pkg;  
/  

CREATE OR REPLACE PACKAGE BODY employee_pkg AS  
   FUNCTION get_bonus(emp_id NUMBER) RETURN NUMBER IS  
   BEGIN  
      RETURN emp_id * 100;  
   END;  
END employee_pkg;  
/

--���� This example shows how to declare a function before using it in a DECLARE block.

DECLARE  
   -- Forward Declaration of Function  
   FUNCTION calculate_tax(salary NUMBER) RETURN NUMBER;  

   emp_salary NUMBER := 50000;  
   tax_amount NUMBER;  
BEGIN  
   -- Calling the function before its definition  
   tax_amount := calculate_tax(emp_salary);  

   DBMS_OUTPUT.PUT_LINE('Tax Amount: ' || tax_amount);  
END;  

-- Function Definition  
FUNCTION calculate_tax(salary NUMBER) RETURN NUMBER IS  
BEGIN  
   RETURN salary * 0.10;  -- Assume tax is 10% of salary  
END;

--���� Forward Declaration is also useful for procedures, 
--especially when a procedure calls another procedure before it is defined.

DECLARE  
   -- Forward Declaration of Procedure  
   PROCEDURE process_salary(emp_id NUMBER);  

BEGIN  
   -- Calling the procedure before defining it  
   process_salary(101);  
END;  

-- Procedure Definition  
PROCEDURE process_salary(emp_id NUMBER) IS  
   emp_salary NUMBER;  
BEGIN  
   SELECT salary INTO emp_salary FROM employees WHERE employee_id = emp_id;  
   DBMS_OUTPUT.PUT_LINE('Salary Processed: ' || emp_salary);  
END;


--���� Sometimes, two functions depend on each other, creating a circular dependency.
--���� Forward declaration allows them to call each other without causing an error.

DECLARE  
   -- Forward Declaration of Functions  
   FUNCTION funcA(num NUMBER) RETURN NUMBER;  
   FUNCTION funcB(num NUMBER) RETURN NUMBER;  

BEGIN  
   DBMS_OUTPUT.PUT_LINE('Result: ' || funcA(10));  
END;  

-- Function Definitions  
FUNCTION funcA(num NUMBER) RETURN NUMBER IS  
BEGIN  
   RETURN funcB(num) + 5;  -- Calls funcB before it is defined  
END funcA;  

FUNCTION funcB(num NUMBER) RETURN NUMBER IS  
BEGIN  
   RETURN num * 2;  
END funcB;


-------------------------------can you use collection method types in functions?---------------------------------

--Create a function that returns the total number of elements in a collection.

CREATE OR REPLACE FUNCTION get_emp_count 
RETURN NUMBER  
IS  
    TYPE emp_table IS TABLE OF VARCHAR2(50);  
    v_employees emp_table := emp_table('John', 'Jane', 'Mike', 'Sara');  
BEGIN  
    RETURN v_employees.COUNT;  -- Using COUNT collection method  
END get_emp_count;  
/


SELECT get_emp_count() FROM dual;


--Create a function that returns the highest salary from a nested table using the LAST method.

CREATE OR REPLACE FUNCTION get_max_salary 
RETURN NUMBER  
IS  
    TYPE salary_table IS TABLE OF NUMBER;  
    v_salaries salary_table := salary_table(3000, 5000, 7000, 10000);  
    v_max_salary NUMBER;  
BEGIN  
    v_max_salary := v_salaries.LAST;  -- Using LAST collection method  
    RETURN v_salaries(v_max_salary);  -- Returning highest salary  
END get_max_salary;  
/

SELECT get_max_salary() FROM dual;



-------------------------What Happens When You Use Both OUT Parameter and RETURN in a Function?------------------


--Example: Function with Both RETURN and OUT Parameter

CREATE OR REPLACE FUNCTION get_salary_details 
(
    p_emp_id NUMBER, 
    p_bonus OUT NUMBER  
) RETURN NUMBER  
IS  
    v_salary NUMBER;  
BEGIN  
    -- Fetch salary of employee
    SELECT salary INTO v_salary FROM hr.employees WHERE employee_id = p_emp_id;  

    -- Calculate bonus
    p_bonus := v_salary * 0.10;  

    -- Return the actual salary
    RETURN v_salary;  
END get_salary_details;  
/

DECLARE  
    v_emp_id NUMBER := 101;  
    v_salary NUMBER;  
    v_bonus NUMBER;  
BEGIN  
    v_salary := get_salary_details(v_emp_id, v_bonus);  
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);  
    DBMS_OUTPUT.PUT_LINE('Bonus: ' || v_bonus);  
END;  
/
select salary, employee_id from hr.employees where employee_id = 105 ;

----------------------table function -------------------

--Functions that return a nested table or varray.

-- Define a table function that returns a table of employee records
CREATE OR REPLACE FUNCTION get_employee_records  
RETURN SYS_REFCURSOR  
IS  
    v_cursor SYS_REFCURSOR;  
BEGIN  
    OPEN v_cursor FOR  
    SELECT employee_id, salary FROM hr.employees WHERE salary > 50000;  
    RETURN v_cursor;  
END get_employee_records;  
/



DECLARE
    v_cursor SYS_REFCURSOR;
    v_emp_id NUMBER;
    v_salary NUMBER;
BEGIN
    v_cursor := get_employee_records;
    LOOP
        FETCH v_cursor INTO v_emp_id, v_salary;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_emp_id || ', Salary: ' || v_salary);
    END LOOP;
    CLOSE v_cursor;
END;
/


--Functions that return a record consisting of multiple fields.

-- Define a record type
CREATE OR REPLACE TYPE emp_record AS OBJECT (
    empno NUMBER,
    ename VARCHAR2(50),
    salary NUMBER
);
/

-- Define the function that returns a record
CREATE OR REPLACE FUNCTION get_employee_details (p_emp_id NUMBER)  
RETURN emp_record  
IS  
    v_emp emp_record;  
BEGIN  
    SELECT employee_id, first_name, salary  
    INTO v_emp.empno, v_emp.ename, v_emp.salary  
    FROM hr.employees  
    WHERE employee_id = p_emp_id;  
    RETURN v_emp;  
END get_employee_details;  
/


DECLARE
    v_emp emp_record;
BEGIN
    v_emp := get_employee_details(101);
    DBMS_OUTPUT.PUT_LINE('Emp No: ' || v_emp.empno || ', Name: ' || v_emp.ename || ', Salary: ' || v_emp.salary);
END;


---Autonomous Transaction In Function

-- 1. Function Example: Logging Errors During Validation Without Interrupting Flow

CREATE OR REPLACE FUNCTION validate_salary(p_emp_id NUMBER, p_new_salary NUMBER)
RETURN VARCHAR2 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  IF p_new_salary < 0 THEN
    INSERT INTO error_log(log_id, error_message, log_time)
    VALUES (p_emp_id, 'Negative salary not allowed.', SYSDATE);
    COMMIT;
    RETURN 'Invalid';
  END IF;
                    
  RETURN 'Valid';
END;

select * from error_log

DECLARE
  v_result VARCHAR2(10);
BEGIN
  v_result := validate_salary(102, 500);
  DBMS_OUTPUT.PUT_LINE('Validation result: ' || v_result);
END;
--This function validates salary input, logs error autonomously, and continues flow without blocking user.

-- 2. Function Example: Tracking Report Generation Time Independently
create table activity_log (
msg varchar2(100),
log_time date
);

select * from activity_log ;

create or replace function log_activity(p_msg varchar2) return varchar2 is
  pragma autonomous_transaction;
begin
  insert into activity_log (msg, log_time) values (p_msg, sysdate);
  commit;
  return 'Activity Log';
end;

BEGIN
  -- Doing some dummy operation (you can imagine this part)
  DBMS_OUTPUT.put_line('Doing some operation...');
  
  -- Calling the autonomous function
  DBMS_OUTPUT.put_line(log_activity('Main block accessed by user'));

  -- This rollback will NOT affect the insert done inside the function
  ROLLBACK;
END;

--  2. Function Example: Tracking Report Generation Time Independently

CREATE OR REPLACE FUNCTION report_audit(p_user VARCHAR2)
RETURN VARCHAR2 IS
  PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
  INSERT INTO report_log(username, generated_on)
  VALUES (p_user, SYSDATE);
  COMMIT;
  RETURN 'Report generation logged';
END;

select * from report_log ;


---------------------------------------------------------------------------------------------------------------
***************************************************************************************************************
                                       Function
                                         
--Write a function to return the annual salary of an employee (12 × salary).

CREATE OR REPLACE FUNCTION annual_sal_f (p_emp_id NUMBER)
RETURN NUMBER
IS
  v_annual_sal NUMBER;
BEGIN
  SELECT salary * 12
  INTO   v_annual_sal
  FROM   hr.employees
  WHERE  employee_id = p_emp_id;

  RETURN v_annual_sal;
END;


BEGIN
  DBMS_OUTPUT.PUT_LINE('Annual Salary = ' || annual_sal_f(101));
END;

--Example: Function with Both RETURN and OUT Parameter

CREATE OR REPLACE FUNCTION get_salary_details 
(
    p_emp_id NUMBER, 
    p_bonus OUT NUMBER  
) RETURN NUMBER  
IS  
    v_salary NUMBER;  
BEGIN  
    -- Fetch salary of employee
    SELECT salary INTO v_salary FROM hr.employees WHERE employee_id = p_emp_id;  

    -- Calculate bonus
    p_bonus := v_salary * 0.10;  

    -- Return the actual salary
    RETURN v_salary;  
END get_salary_details;  


DECLARE  
    v_emp_id NUMBER := 101;  
    v_salary NUMBER;  
    v_bonus NUMBER;  
BEGIN  
    v_salary := get_salary_details(v_emp_id, v_bonus);  
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);  
    DBMS_OUTPUT.PUT_LINE('Bonus: ' || v_bonus);  
END;  

---Same above Q with multiple employee return
CREATE OR REPLACE FUNCTION annual_sal_multi
RETURN SYS_REFCURSOR
IS
  emp_cur SYS_REFCURSOR;  -- Cursor to return multiple rows
BEGIN
  -- Open cursor for all employees with annual salary
  OPEN emp_cur FOR
    SELECT employee_id,
           first_name || ' ' || last_name AS emp_name,
           salary * 12 AS annual_salary
    FROM hr.employees;

  RETURN emp_cur;  -- Return cursor to caller
END;

DECLARE
  v_emp_id hr.employees.employee_id%TYPE;
  v_emp_name VARCHAR2(100);
  v_annual_sal NUMBER;
  rc SYS_REFCURSOR;
BEGIN
  -- Call the function
  rc := annual_sal_multi;

  -- Fetch rows from the cursor
  LOOP
    FETCH rc INTO v_emp_id, v_emp_name, v_annual_sal;
    EXIT WHEN rc%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Emp ID: ' || v_emp_id || 
                         ' Name: ' || v_emp_name || 
                         ' Annual Salary: ' || v_annual_sal);
  END LOOP;

  CLOSE rc;  -- Close cursor
END;


--Write a function to check if a number is prime (return 'YES' or 'NO').

CREATE OR REPLACE FUNCTION f_check_prime_num(f_num NUMBER)
RETURN VARCHAR2
IS
  i NUMBER := 2;
BEGIN
  -- Handle numbers <= 1
  IF f_num <= 1 THEN
    RETURN 'NO';
  END IF;

  -- Loop from 2 to sqrt(f_num) to check divisibility
  WHILE i <= TRUNC(SQRT(f_num)) LOOP
    IF MOD(f_num, i) = 0 THEN
      RETURN 'NO'; -- Not prime
    END IF;
    i := i + 1;
  END LOOP;

  RETURN 'YES'; -- Prime
END;


DECLARE
  v_num    NUMBER := &num;
  v_result VARCHAR2(10);
BEGIN
  v_result := f_check_prime_num(v_num);
  DBMS_OUTPUT.PUT_LINE('Is ' || v_num || ' prime? → ' || v_result);
END;


--Create a function get_age(dob DATE) that returns employee’s age.

create or replace function get_age(dob date) return number is
  age number;
begin
    age := TRUNC(MONTHS_BETWEEN(SYSDATE, dob) / 12);
  --age := trunc(age/30)/12 ;
  return age;
end;

declare
  v_age  date := to_date('03-07-2003', 'DD-MM-YYYY');
  result number;
begin
  result := get_age(v_age);
  dbms_output.put_line('Employee Age is : ' || result || ' Years');
end;


--Create a function to return the grade of student based on marks.

create or replace function s_grade(v_marks number) return varchar2 is
begin
  if v_marks > 100 or v_marks < 0 then
    raise_application_error(-20001, 'Marks shoulb be between 1 to 100 ');
  end if;

  if v_marks >= 90 then
    return 'A';
  elsif v_marks >= 80 then
    return 'B';
  elsif v_marks >= 60 then
    return 'C';
  elsif v_marks >= 40 then
    return 'D';
  else
    return 'F';
  end if;
end;

declare
  get_marks number := &num;
  output    varchar2(20);
begin
  output := s_grade(get_marks);
  dbms_output.put_line('Student marks is ' || get_marks ||
                       ' and grade is ' || output);
end;


--Create a deterministic function that returns square of a number.                                      

create or replace function square_number(f_num number) return number
  DETERMINISTIC is
begin
  return f_num * f_num;
end;
                                 
declare
 v_num  number := &num;
 result number;
begin
 result := square_number(v_num);
 dbms_output.put_line('Square root of '||v_num || ' is ' || result);
end;
                                       
-- Define a table function that returns a table of employee records
CREATE OR REPLACE FUNCTION get_employee_records  
RETURN SYS_REFCURSOR  
IS  
    v_cursor SYS_REFCURSOR;  
BEGIN  
    OPEN v_cursor FOR  
    SELECT employee_id, salary FROM hr.employees WHERE salary > 50000;  
    RETURN v_cursor;  
END get_employee_records;  
/



DECLARE
    v_cursor SYS_REFCURSOR;
    v_emp_id NUMBER;
    v_salary NUMBER;
BEGIN
    v_cursor := get_employee_records;
    LOOP
        FETCH v_cursor INTO v_emp_id, v_salary;
        EXIT WHEN v_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_emp_id || ', Salary: ' || v_salary);
    END LOOP;
    CLOSE v_cursor;
END;
/


--Functions that return a record consisting of multiple fields.

-- Define a record type
CREATE OR REPLACE TYPE emp_record AS OBJECT (
    empno NUMBER,
    ename VARCHAR2(50),
    salary NUMBER
);
/

-- Define the function that returns a record
CREATE OR REPLACE FUNCTION get_employee_details (p_emp_id NUMBER)  
RETURN emp_record  
IS  
    v_emp emp_record;  
BEGIN  
    SELECT employee_id, first_name, salary  
    INTO v_emp.empno, v_emp.ename, v_emp.salary  
    FROM hr.employees  
    WHERE employee_id = p_emp_id;  
    RETURN v_emp;  
END get_employee_details;  
/


DECLARE
    v_emp emp_record;
BEGIN
    v_emp := get_employee_details(101);
    DBMS_OUTPUT.PUT_LINE('Emp No: ' || v_emp.empno || ', Name: ' || v_emp.ename || ', Salary: ' || v_emp.salary);
END;                                       
                                       
-------------------------What Happens When You Use Both OUT Parameter and RETURN in a Function?------------------


--Example: Function with Both RETURN and OUT Parameter

CREATE OR REPLACE FUNCTION get_salary_details 
(
    p_emp_id NUMBER, 
    p_bonus OUT NUMBER  
) RETURN NUMBER  
IS  
    v_salary NUMBER;  
BEGIN  
    -- Fetch salary of employee
    SELECT salary INTO v_salary FROM hr.employees WHERE employee_id = p_emp_id;  

    -- Calculate bonus
    p_bonus := v_salary * 0.10;  

    -- Return the actual salary
    RETURN v_salary;  
END get_salary_details;  
/

DECLARE  
    v_emp_id NUMBER := 101;  
    v_salary NUMBER;  
    v_bonus NUMBER;  
BEGIN  
    v_salary := get_salary_details(v_emp_id, v_bonus);  
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_salary);  
    DBMS_OUTPUT.PUT_LINE('Bonus: ' || v_bonus);  
END;  
/
select salary, employee_id from hr.employees where employee_id = 105 ;                                       
                                       
                                      


------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
                                             09-12-2025 Tuesday
------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
                                    ADVANCED PL/SQL FUNCTION PRACTICE QUESTIONS
                                    User:= shubh Pass:=shubh123 As SYSDBA
                                     commit ;
--%ROWTYPE in Function
CREATE OR REPLACE FUNCTION get_employee(p_id NUMBER) 
RETURN VARCHAR2 IS
  v_emp employees%ROWTYPE;  -- ✓ CORRECT: Can use inside function
BEGIN
  SELECT * INTO v_emp FROM employees WHERE employee_id = p_id;
  RETURN v_emp.first_name;  -- Must extract scalar to return
  -- ❌ RETURN v_emp; -- NOT ALLOWED (can't return %ROWTYPE)
END;

-- TYPE RECORD
-- ❌ This is INVALID:
CREATE OR REPLACE FUNCTION invalid_func 
RETURN RECORD IS  -- Not allowed!
BEGIN RETURN NULL; END;

-- ✓ This WORKS:
CREATE PACKAGE my_pkg AS
  TYPE my_rec IS RECORD (id NUMBER, name VARCHAR2(100));
  FUNCTION get_rec RETURN my_rec;
END;

CREATE PACKAGE BODY my_pkg AS
  FUNCTION get_rec RETURN my_rec IS
    v_rec my_rec;
  BEGIN
    v_rec.id := 1;
    v_rec.name := 'John';
    RETURN v_rec;
  END;
END;

-- OBJECT TYPE
-- ❌ This is INVALID inside function:
CREATE OR REPLACE FUNCTION invalid_func RETURN VARCHAR2 IS
  TYPE emp_obj IS OBJECT (id NUMBER, name VARCHAR2(100)); -- NOT ALLOWED
BEGIN RETURN NULL; END;

-- ✓ This is REQUIRED:
CREATE TYPE emp_obj AS OBJECT (  -- Schema-level first
  id NUMBER,
  name VARCHAR2(100)
);

CREATE OR REPLACE FUNCTION valid_func RETURN emp_obj IS
BEGIN
  RETURN emp_obj(1, 'John');  -- Then can use in function
END;

                                    
--Q1. Function With Validation + Defaulting + Exception Handling
--Write a function calc_bonus(emp_id) that:
--Fetches salary of employee
--If salary < 20,000 → return 10% bonus
--If salary between 20,000–50,000 → return 15% bonus
--If salary > 50,000 → return 20% bonus
--If employee does not exist → return 0 (instead of raising error)
--If salary is NULL or negative → return -1

create or replace function calc_bonus(emp_id number) return number is
  v_salary number;
begin
  select salary into v_salary from employee1 where employee_id = emp_id;
  IF v_salary IS NULL OR v_salary < 0 THEN
    RETURN - 1;
  END IF;

  if v_salary < 20000 then
    return v_salary * 0.10;
  elsif v_salary between 20000 and 50000 then
    return v_salary * 0.15;
  else
    return v_salary * 0.20;
  end if;

exception
  when NO_DATA_FOUND then
    return 0;
  when others then
    dbms_output.put_line(SQLERRM || dbms_utility.format_error_backtrace);
    return - 1;
end;

declare
  emp_id number := &_num;
  result number;
begin
  result := calc_bonus(emp_id);
  dbms_output.put_line('Bonus : ' || result);
end;
            

--Q2. Function Returning Multiple Values With RECORD Type
--Create a function that:
--Accepts employee_id
--Returns a custom RECORD containing
--name, salary, hire_date, job_id
--Use %ROWTYPE or user-defined TYPE
--Display result inside an anonymous block

create or replace package emp_pac is
  TYPE emp_rec_type IS RECORD(
    emp_name VARCHAR2(100),
    sal      NUMBER,
    hire     DATE,
    job      VARCHAR2(20));

  FUNCTION get_emp_details(p_emp_id NUMBER) RETURN emp_rec_type;
END emp_pac;

create or replace package body emp_pac is
  function get_emp_details(p_emp_id number)
    return emp_rec_type is v_rec emp_rec_type;
  begin
    SELECT first_name || ' ' || last_name, salary, hire_date, job_id
      INTO v_rec
      FROM employee1
     WHERE employee_id = p_emp_id;
  
    RETURN v_rec;
  exception
    when others then
      v_rec.emp_name := 'Not Found';
      v_rec.sal      := NULL;
      v_rec.hire     := NULL;
      v_rec.job      := NULL;
      return v_rec;
  end get_emp_details;
end emp_pac;

DECLARE
    v_result emp_pac.emp_rec_type;
BEGIN
    v_result := emp_pac.get_emp_details(101);

    DBMS_OUTPUT.PUT_LINE('Name: ' || v_result.emp_name);
    DBMS_OUTPUT.PUT_LINE('Salary: ' || v_result.sal);
    DBMS_OUTPUT.PUT_LINE('Hire Date: ' || v_result.hire);
    DBMS_OUTPUT.PUT_LINE('Job ID: ' || v_result.job);
END;

/*Q3. Function That Calls Another Function

Create:

Function A → returns yearly salary

Function B → accepts employee_id and returns tax based on value returned by Function A

Handle exceptions in both functions

Q4. Function Using REF CURSOR

Write a function that:

Accepts department_id

Returns a SYS_REFCURSOR

Cursor should return only employees whose salary is in top 3 of that department

If no employee exists → return empty cursor

Q5. Function Using PRAGMA AUTONOMOUS_TRANSACTION

Create a function that updates an audit table:

Function name: log_action

Inserts action_name, user, sysdate into log table

Uses PRAGMA AUTONOMOUS_TRANSACTION

Commits independently

Returns success/failure message

Call it from another function or procedure.

Q6. Function That Accepts TABLE Type (Collection)

Create:

A collection TYPE num_list IS TABLE OF NUMBER;

Function sum_numbers(num_list)

Return: total sum of all values

If list is empty → return 0

If NULL encountered → skip it

Q7. Function Doing String Processing

Write a function reverse_words(input_string) that:

Accepts a string

Reverses characters in each word

Example: "Hello World" → "olleH dlroW"

Implement manually (no built-in reverse)

Q8. Function For Data Masking

Write a function: mask_email(email)
Return:

First 2 characters visible

Rest masked with *

Example:
shubham@gmail.com → sh******@gmail.com

Q9. Function That Returns PIPELINED Table

Create a pipelined function that:

Accepts department_id

Returns each employee record one-by-one (PIPE ROW)

Use custom object + table TYPE

Query results in SQL using:

SELECT * FROM TABLE(get_dept_emps(90));

Q10. Function With DML Inside (Tricky)

Create a function that:

Increases employee salary by 5%

Updates the table

Returns updated salary

Handle “mutating table” issue if called from a trigger

(Hint: use pragma or autonomous transaction)

Q11. Function That Computes Running Total Using ANALYTIC FUNCTIONS

Write a function:

Accepts employee_id

Returns running total salary of his department using SUM() OVER(PARTITION BY ...)

If no employee → return -1

Q12. Function Using Bulk Collect + Limit

Write a function that:

Accepts department_id

Fetches employees in bulk (using BULK COLLECT with LIMIT 50)

Returns total employees fetched

Return 0 if nothing fetched

Q13. Function That Validates Data Before Inserting

Write a function:

Accepts email

Checks if email already exists in table

If yes → return 'EXISTS'

If no → insert and return 'INSERTED'

Q14. Function Using Cursor FOR Loop Inside

Write a function:

Accepts job_id

Calculates and returns average salary

Use cursor FOR loop

Skip employees with NULL salary

If no employee exists → return NULL

Q15. Function That Converts Date Format Manually

Write a function that:

Accepts a date

Returns it in format YYYY-MM-DD

Do NOT use TO_CHAR

Extract year, month, day manually

*/


  -- Q.Write a function to check prime number !
create or replace function check_prime_(f_num number) return varchar2 is
  i number := 2;
begin
  if f_num <= 1 then
    return 'Not prime';
  end if;

  while i <= trunc(sqrt(f_num)) loop
    if mod(f_num, i) = 0 then
      return 'Not prime';
    end if;
    i := i + 1;
  end loop;
  return 'prime';
end;

declare
  result varchar2(20);
begin
  result := check_prime_(7);
  dbms_output.put_line(result);
end;




























