
-- a package is a collection of related procedures, functions, variables, cursors, 
-- and exceptions grouped together under one name. It helps in modularizing code, reusing logic, 
-- and organizing programs efficiently.


--syntax
CREATE OR REPLACE PACKAGE package_name IS
  -- Public procedure/function declarations
  FUNCTION get_square(n NUMBER) RETURN NUMBER;
  PROCEDURE greet_user(name VARCHAR2);
END package_name;
/

CREATE OR REPLACE PACKAGE BODY package_name IS

  FUNCTION get_square(n NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN n * n;
  END;

  PROCEDURE greet_user(name VARCHAR2) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Hello, ' || name || '!');
  END;

END package_name;
/
DECLARE
  res NUMBER;
BEGIN
  res := package_name.get_square(5);
  DBMS_OUTPUT.PUT_LINE('Square is: ' || res);

  package_name.greet_user('Shubham');
END;
/
--ex
CREATE OR REPLACE PACKAGE emp_pkg IS
  FUNCTION get_salary(eid NUMBER) RETURN NUMBER;
  PROCEDURE show_employee(eid NUMBER);
END emp_pkg;
/

CREATE OR REPLACE PACKAGE BODY emp_pkg IS

  FUNCTION get_salary(eid NUMBER) RETURN NUMBER IS
    sal NUMBER;
  BEGIN
    SELECT salary INTO sal FROM hr.employees WHERE employee_id = eid;
    RETURN sal;
  END;

  PROCEDURE show_employee(eid NUMBER) IS
    fname hr.employees.first_name%TYPE;
  BEGIN
    SELECT first_name INTO fname FROM hr.employees WHERE employee_id = eid;
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || fname);
  END;

END emp_pkg;
/
BEGIN
  DBMS_OUTPUT.PUT_LINE('Salary: ' || emp_pkg.get_salary(100));
  emp_pkg.show_employee(100);
END;
/
--------overloading
CREATE OR REPLACE PACKAGE emp_logger_pkg IS
  PROCEDURE log_emp(eid NUMBER);
  PROCEDURE log_emp(ename VARCHAR2, sal NUMBER);
END emp_logger_pkg;
/
CREATE OR REPLACE PACKAGE BODY emp_logger_pkg IS

  PROCEDURE log_emp(eid NUMBER) IS
    v_name hr.employees.first_name%TYPE;
    v_salary hr.employees.salary%TYPE;
  BEGIN
    SELECT first_name, salary INTO v_name, v_salary
    FROM hr.employees
    WHERE employee_id = eid;

    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || eid || ', Name: ' || v_name || ', Salary: ' || v_salary);
  END;

  PROCEDURE log_emp(ename VARCHAR2, sal NUMBER) IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Employee Name: ' || ename || ', Salary: ' || sal);
  END;

END emp_logger_pkg;
/
BEGIN
  emp_logger_pkg.log_emp(100); -- Using ID
  --emp_logger_pkg.log_emp('Shubham', 50000); -- Using Name and Salary
END;


---------  Package 

--A package is a collection of related procedures, functions, variables, cursors, 
--and other PL/SQL constructs grouped together in a single unit.
--**It has two parts:
-- 1. Package Specification (what is available publicly)
-- 2. Package Body (actual code/logic for those procedures/functions)

-- Basic Syntax
-- 1. Package Specification
CREATE OR REPLACE PACKAGE emp_pkg AS
  PROCEDURE add_employee(p_id NUMBER, p_name VARCHAR2, p_salary NUMBER);
  FUNCTION get_total_employees RETURN NUMBER;
END emp_pkg;

-- 2. Package Body
CREATE OR REPLACE PACKAGE BODY emp_pkg AS

  PROCEDURE add_employee(p_id NUMBER, p_name VARCHAR2, p_salary NUMBER) IS
  BEGIN
    INSERT INTO employee (emp_id, name, salary)
    VALUES (p_id, p_name, p_salary);
  END;

  FUNCTION get_total_employees RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT COUNT(*) INTO v_total FROM employee;
    RETURN v_total;
  END;

END emp_pkg;
-----
-- Example 1: Package for Employee Operations
CREATE OR REPLACE PACKAGE employee_pkg AS
  PROCEDURE raise_salary(p_emp_id NUMBER, p_percent NUMBER);
  FUNCTION get_salary(p_emp_id NUMBER) RETURN NUMBER;
END employee_pkg;
--Package Body:
CREATE OR REPLACE PACKAGE BODY employee_pkg AS

  PROCEDURE raise_salary(p_emp_id NUMBER, p_percent NUMBER) IS
  BEGIN
    UPDATE employee
    SET salary = salary + (salary * p_percent / 100)
    WHERE emp_id = p_emp_id;
  END;

  FUNCTION get_salary(p_emp_id NUMBER) RETURN NUMBER IS
    v_salary NUMBER;
  BEGIN
    SELECT salary INTO v_salary
    FROM employee
    WHERE emp_id = p_emp_id;
    RETURN v_salary;
  END;

END employee_pkg;
--Call from SQL*Plus or PL/SQL:
BEGIN
  employee_pkg.raise_salary(107, 10);
  DBMS_OUTPUT.PUT_LINE('New Salary: ' || employee_pkg.get_salary(107));
END;

-- Example 2: Package with Global Variable
CREATE OR REPLACE PACKAGE session_pkg AS
  g_user_name VARCHAR2(100); -- Global variable
  PROCEDURE set_user(p_name VARCHAR2); 
  PROCEDURE show_user;
END session_pkg;

CREATE OR REPLACE PACKAGE BODY session_pkg AS

  PROCEDURE set_user(p_name VARCHAR2) IS
  BEGIN
    g_user_name := p_name;
  END;

  PROCEDURE show_user IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('Current User: ' || g_user_name);
  END;

END session_pkg;

BEGIN
  session_pkg.set_user('Shubham');
  session_pkg.show_user;
END;

--Practice
-- Q1: Math Utility Package
--Create a package math_utils_pkg with:
--A function square(p_number NUMBER) RETURN NUMBER
--A function cube(p_number NUMBER) RETURN NUMBER
--A procedure show_result(p_number NUMBER) that prints both square and cube

create or replace package math_utils_pkg as
  function square(p_number number) return number;
  function cube1(p_number number) return number;
  procedure show_result(p_number number);
  v_num  number;
  v_num1 number;
end;

create or replace package body math_utils_pkg as
function square(p_number number) return number is
begin
-- v_num := p_number * p_number;
return p_number * p_number;
end;

function cube1(p_number number) return number is
begin
--v_num1 := p_number * p_number * p_number;
return p_number * p_number * p_number;
end;

procedure show_result(p_number number) is
square1 number; cube11 number;
begin
square1 := square(p_number); cube11 := cube1(p_number);

dbms_output.put_line('Square : ' || square1); dbms_output.put_line('Cube : ' || cube11);
end;
end math_utils_pkg;

begin
math_utils_pkg.show_result(5);
end;

----06-06-2025  Friday-----------------------------------------------------------------------------------

CREATE TABLE student1 (
  rollno NUMBER PRIMARY KEY,
  name   VARCHAR2(50),
  marks  NUMBER
);

select * from student1;

--Create a package student_pkg with:
--A procedure add_student(p_id NUMBER, p_name VARCHAR2, p_marks NUMBER)
--A function get_grade(p_id NUMBER) RETURN VARCHAR2
--(Return A/B/C based on marks: A ≥ 75, B ≥ 50, C otherwise)

create or replace package student_pkg as
procedure  add_student (p_id NUMBER, p_name VARCHAR2, p_marks NUMBER) ;
function  get_grade (p_id NUMBER) RETURN VARCHAR2 ;
end ;

create or replace package body student_pkg as
  procedure add_student(p_id NUMBER, p_name VARCHAR2, p_marks NUMBER) is
  begin
    insert into student1
      (rollno, name, marks)
    values
      (p_id, p_name, p_marks);
  end;

  function get_grade(p_id NUMBER) RETURN VARCHAR2 is
    v_grade varchar2(1);
    v_marks number;
  begin
    select marks into v_marks from student1 where rollno = p_id;
    if v_marks >= 75 then
      v_grade := 'A';
    elsif v_marks >= 50 then
      v_grade := 'B';
    else
      v_grade := 'C';
    end if;
    return v_grade;
  end;

end student_pkg;

begin
  student_pkg.add_student(101, 'Ravi', 95);
  dbms_output.put_line(student_pkg.get_grade(101));
end;


--���� Q3: Global Counter Package
--Create a package counter_pkg with:
--A global variable g_counter (initial value 0)
--A procedure increment_counter
--A procedure reset_counter
--A function get_counter RETURN NUMBER

create or replace package counter_pkg as
  -- g_counter number := 0;
  procedure increment_counter;
  procedure reset_counter;
  function get_counter RETURN NUMBER;
end;

 create or replace package body counter_pkg as
   g_counter number := 0;

   procedure increment_counter is
     v_count number := 1;
   begin
     g_counter := g_counter + v_count;
     dbms_output.put_line('Counter increment : ' || g_counter);
   end;
 
   procedure reset_counter is
   begin
     g_counter := 0;
     dbms_output.put_line('Counter reset : ' || g_counter);
   end;
 
   function get_counter return number is
   begin
     return g_counter;
   end;
 end counter_pkg;

begin
  counter_pkg.increment_counter;
  counter_pkg.increment_counter;
  dbms_output.put_line('current counter : ' || counter_pkg.get_counter);
  counter_pkg.reset_counter;
  dbms_output.put_line('After reset : ' || counter_pkg.get_counter);
end;

--���� Q4: Salary Validation Package
--Given this table:
CREATE TABLE employe1 (
    emp_id   NUMBER PRIMARY KEY,
    name     VARCHAR2(50),
    salary   NUMBER
);
INSERT INTO employe1 (emp_id, name, salary) VALUES (101, 'Shubham', 50000);
INSERT INTO employe1 (emp_id, name, salary) VALUES (102, 'Nikita', 60000);
INSERT INTO employe1 (emp_id, name, salary) VALUES (103, 'Rohan', 45000);
INSERT INTO employe1 (emp_id, name, salary) VALUES (104, 'Priya', 70000);
INSERT INTO employe1 (emp_id, name, salary) VALUES (105, 'Amit', 55000);
--Create a package salary_pkg with:
--A procedure update_salary(p_id NUMBER, p_new_salary NUMBER)
--Raise error if new salary < 10000
--A function get_salary(p_id NUMBER) RETURN NUMBER

create or replace package salary_pkg as
procedure update_salary(p_id NUMBER, p_new_salary NUMBER);
function get_salary(p_id NUMBER) RETURN NUMBER ;
end;

create or replace package body salary_pkg as
  procedure update_salary(p_id NUMBER, p_new_salary NUMBER) is
  begin
    if p_new_salary < 10000 then
      RAISE_APPLICATION_ERROR(-20001, 'Salary must be at least 10000');
    --  DBMS_OUTPUT.PUT_LINE('p_new_salary < 10000 not allowed ' || p_id);
    end if;
    update employe1 set salary = p_new_salary where emp_id = p_id; 
        DBMS_OUTPUT.PUT_LINE('Salary updated for emp_id ' || p_id);

  end;

  function get_salary(p_id NUMBER) RETURN NUMBER is
    v_sal number;
  begin
    select salary into v_sal from employe1 where emp_id = p_id;
    return v_sal;
  end;
end salary_pkg;
      
begin
  salary_pkg.update_salary(101, 9000);
  dbms_output.put_line('current salary is : ' || salary_pkg.get_salary(101) );
end;

select * from employe1 where emp_id = 101 ;



-- Q5: Bank Account Package
Given this table:
CREATE TABLE account (
    acc_no   NUMBER PRIMARY KEY,
    name     VARCHAR2(50),
    balance  NUMBER
);

--Create a package bank_pkg with:
--A procedure deposit(p_acc_no NUMBER, p_amount NUMBER)
--A procedure withdraw(p_acc_no NUMBER, p_amount NUMBER)
--Raise error if withdrawal amount > balance
--A function get_balance(p_acc_no NUMBER) RETURN NUMBER

create or replace package bank_pkg as 
procedure deposit(p_acc_no NUMBER, p_amount NUMBER) ;
 procedure withdraw(p_acc_no NUMBER, p_amount NUMBER);
function get_balance(p_acc_no NUMBER) RETURN NUMBER;
end;

create or replace package body bank_pkg is

  procedure deposit(p_acc_no NUMBER, p_amount NUMBER) is
    v_balance number;
    v_total number := 0 ;
  begin
    select balance into v_balance from account where acc_no = p_acc_no;
    update account
       set balance = balance + p_amount
     where acc_no = p_acc_no;
     v_total := v_balance + p_amount ;
    dbms_output.put_line('Blance succesfully updated : ' || v_total);
  end;

  procedure withdraw(p_acc_no NUMBER, p_amount NUMBER) is
    -- v_with number ;
    v_bal number;
  begin
    select balance into v_bal from account where acc_no = p_acc_no;
    if p_amount > v_bal then
      RAISE_APPLICATION_ERROR(-20001, 'Amount must be less than balance');
      --dbms_output.put_line('Amount should be less that current balance');
    else
      --v_bal < p_amount then --v_with := v_bal - p_amount ;
      update account
         set balance = balance - p_amount
       where acc_no = p_acc_no;
      dbms_output.put_line('Balance sucessfully withdraw : ' || p_amount);
    
    end if;
  end;

  function get_balance(p_acc_no NUMBER) RETURN NUMBER is
    v_balance number;
  begin
    select balance into v_balance from account where acc_no = p_acc_no;
    return v_balance;
  end;
end bank_pkg;

begin
  bank_pkg.deposit(201,10000) ;
  bank_pkg.withdraw(201,15000);
  dbms_output.put_line('Current balance is : ' || bank_pkg.get_balance(201));
end;

select balance from account where acc_no = 201;


CREATE OR REPLACE PACKAGE pkg_employee AS
    PROCEDURE add_employee(p_emp_id NUMBER, p_name VARCHAR2, p_salary NUMBER);
    PROCEDURE update_salary(p_emp_id NUMBER, p_new_salary NUMBER);
    PROCEDURE get_employee_details(p_emp_id NUMBER);
END pkg_employee;
/
 
CREATE OR REPLACE PACKAGE BODY pkg_employee AS
 
    -- Procedure to add a new employee
    PROCEDURE add_employee(p_emp_id NUMBER, p_name VARCHAR2, p_salary NUMBER) IS
    BEGIN
        INSERT INTO employees (employee_id, first_name, salary) VALUES (p_emp_id, p_name, p_salary);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
    END add_employee;
 
    -- Procedure to update employee salary
    PROCEDURE update_salary(p_emp_id NUMBER, p_new_salary NUMBER) IS
    BEGIN
        UPDATE employees SET salary = 120/0 WHERE employee_id = p_emp_id;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('Salary updated successfully.');
        exception when others
        then 
        DBMS_OUTPUT.PUT_LINE('Err:-'||dbms_utility.format_error_stack||
            dbms_utility.format_error_backtrace);
    END update_salary;
 
    -- Procedure to fetch employee details
    PROCEDURE get_employee_details(p_emp_id NUMBER) IS
        v_name employees.first_name%TYPE;
        v_salary employees.salary%TYPE;
    BEGIN
        SELECT first_name, salary INTO v_name, v_salary FROM employees WHERE employee_id = p_emp_id;
        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || v_name || ', Salary: ' || v_salary);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('No employee found with ID ' || p_emp_id);
    END get_employee_details;
 
END pkg_employee;
/
 
CREATE OR REPLACE PACKAGE pkg_salary_manager AS
    PROCEDURE increase_salary(p_emp_id NUMBER, p_increment NUMBER);
END pkg_salary_manager;
/
 
CREATE OR REPLACE PACKAGE BODY pkg_salary_manager AS
 
    PROCEDURE increase_salary(p_emp_id NUMBER, p_increment NUMBER) IS
        v_current_salary employees.salary%TYPE;
    BEGIN
        -- Fetch current salary
        SELECT salary INTO v_current_salary FROM employees WHERE employee_id = p_emp_id;
 
        -- Increase salary
        pkg_employee.update_salary(p_emp_id, v_current_salary + p_increment);
        DBMS_OUTPUT.PUT_LINE('Salary increased successfully.');
    EXCEPTION
        WHEN others THEN
            DBMS_OUTPUT.PUT_LINE('Err:-'||dbms_utility.format_error_stack||
            dbms_utility.format_error_backtrace);
    END increase_salary;
 
END pkg_salary_manager;
/
 
 
BEGIN
    --pkg_employee.add_employee(101, 'John Doe', 50000);
    pkg_salary_manager.increase_salary(110, 5000);
    --pkg_employee.get_employee_details(101);
END;


-- 1. Package Example: Audit Utility Package
CREATE OR REPLACE PACKAGE audit_pkg IS
  PROCEDURE log_event(p_msg VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY audit_pkg IS
  PROCEDURE log_event(p_msg VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO event_log(msg, log_time) VALUES (p_msg, SYSDATE);
    COMMIT;
  END;
END;

-- 2. Package Example: Tracking Access from UI
CREATE OR REPLACE PACKAGE user_track_pkg IS
  PROCEDURE record_access(p_user VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY user_track_pkg IS
  PROCEDURE record_access(p_user VARCHAR2) IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO user_access_log(username, access_time)
    VALUES (p_user, SYSDATE);
    COMMIT;
  END;
END;


--PRAGMA SERIALLY_REUSABLE

1-scenario
You want to reduce memory usage for frequently called packages.

--Use for global variables that don’t need to retain state between calls (especially in high-load systems).

create or replace package pkg_test is
  pragma serially_reusable;
  procedure p1;
end;

create or replace package body pkg_test is
  pragma serially_reusable;
  g_counter number := 0;

  procedure p1 is
  begin
    g_counter := g_counter + 1;
    dbms_output.put_line('Counter : ' || g_counter);
  exception
    when others then
      dbms_output.put_line(DBMS_UTILITY.FORMAT_ERROR_STACK ||
                           DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
  end;
end ;

select * from user_objects where object_name = upper('memory_test_package') ;

begin
  pkg_test.p1;
  pkg_test.p1;
  pkg_test.p1;
end;

begin
  pkg_test.p1;
end ;

begin
  pkg_test.p1;
end ;

-- Example 2: Shared Package State – Reset Happens on Each Call

create or replace package sharde_pkg is
  pragma serially_reusable;
  v_data varchar2(100);
  procedure p1(v_val varchar2);
  procedure p2;
end;

create or replace package body sharde_pkg is
  pragma serially_reusable;

  procedure p1(v_val varchar2) is
  begin
    v_data := v_val;
  end;

  procedure p2 is
  begin
    dbms_output.put_line(v_data);
  end;
end;

BEGIN
  sharde_pkg.p1('ABC');
  sharde_pkg.p2;
  -- Will print: Data:
  -- Because g_data resets on next call
END;

begin
  sharde_pkg.p2;
end;

-- Example 3: Save Memory When Handling Bulk Data

select * from user_objects where object_name = upper('memory_test_package') ;

CREATE OR REPLACE PACKAGE memory_test_pkg IS
  PRAGMA SERIALLY_REUSABLE;
  TYPE arr IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
  g_arr arr;
  PROCEDURE load_data;
  PROCEDURE print_data;
END;
/

CREATE OR REPLACE PACKAGE BODY memory_test_pkg IS
  PRAGMA SERIALLY_REUSABLE;

  PROCEDURE load_data IS
  BEGIN
    FOR i IN 1..1000 LOOP
      g_arr(i) := i * 2;
    END LOOP;
  END;

  PROCEDURE print_data IS
  BEGIN
    DBMS_OUTPUT.PUT_LINE('g_arr(10) = ' || g_arr(10)); -- Likely NULL
  END;
END;

BEGIN
  memory_test_pkg.load_data;
  memory_test_pkg.print_data;
END;
/

-- First call
BEGIN
  memory_test_pkg.load_data;
END;
/

-- Second call
BEGIN
  memory_test_pkg.print_data; -- Will likely raise NO_DATA_FOUND or show NULL
END;
/





--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------
                              PL/SQL PACKAGE – Practical Interview Questions (Advanced Level)


--Q1. Employee Salary Audit Package
--Create a package pkg_salary_audit for the employees table that:
--Specification Requirements:
--Procedure update_salary(p_emp_id, p_new_salary)
--Update employee salary.
--Validate: new salary must be greater than old salary.
--If invalid → raise custom exception.
--Procedure get_salary_history(p_emp_id)
--Display all old salary changes from an audit table.
--Function get_total_hikes(p_emp_id)
--Return number of salary hikes done so far.
--Additional Conditions:
--Maintain an audit table emp_salary_audit with:
--emp_id, old_salary, new_salary, changed_by, changed_on
--Use PRAGMA AUTONOMOUS_TRANSACTION in the audit-insert part.

create table emp_salary_audit(
emp_id number ,
old_salary number,
new_salary number,
changed_by varchar2(80),
changed_on date
);

select * from emp_salary_audit ;


create or replace package pkg_salary_audit is

  procedure update_salary(p_emp_id number, p_new_salary number);
  Procedure get_salary_history(p_emp_id number);
  Function get_total_hikes(p_emp_id number) return number;
end pkg_salary_audit;

create or replace package body pkg_salary_audit is
  PROCEDURE log_audit(p_emp_id NUMBER, p_old_sal NUMBER, p_new_sal NUMBER) IS
    PRAGMA AUTONOMOUS_TRANSACTION; 
  BEGIN
    INSERT INTO emp_salary_audit
      (emp_id, old_salary, new_salary, changed_by, changed_on)
    VALUES
      (p_emp_id, p_old_sal, p_new_sal, USER, SYSDATE);
  
    COMMIT; 
  END log_audit;

  procedure update_salary(p_emp_id number, p_new_salary number) is
    v_old_sal number;
    sal_not_greater EXCEPTION;
  begin
    select salary
      into v_old_sal
      from employee1
     where employee_id = p_emp_id;
    if p_new_salary < v_old_sal then
      raise sal_not_greater;
    end if;
  
    update employee1
       set salary = p_new_salary
     where employee_id = p_emp_id;
    dbms_output.put_line('Salary successfully updated !');
  
    log_audit(p_emp_id, v_old_sal, p_new_salary);
     
    commit;
    
  exception
    when sal_not_greater then
      dbms_output.put_line('Salary must be greater that old salary \n and old salary is: ' ||
                           v_old_sal || ' Ans new salary is: ' ||
                           p_new_salary);
    when others then
      dbms_output.put_line(SQLERRM || dbms_utility.format_error_backtrace);
  end;

  Procedure get_salary_history(p_emp_id number) is
    cursor cur is
      select emp_id, old_salary, new_salary, changed_by, changed_on
        from emp_salary_audit
       where emp_id = p_emp_id;
  
    v_emp_id     number;
    v_old_salary number;
    v_new_salary number;
    v_changed_by varchar2(90);
    v_changed_on date;
  
  begin
    open cur;
    loop
      fetch cur
        into v_emp_id,
             v_old_salary,
             v_new_salary,
             v_changed_by,
             v_changed_on;
      exit when cur%notfound;
      dbms_output.put_line('emp_id: ' || v_emp_id || ' old_sal: ' ||
                           v_old_salary || ' New_sal: ' || v_new_salary ||
                           ' Who_changes: ' || v_changed_by ||
                           ' Which_time: ' || TO_CHAR(v_changed_on, 'DD-MON-YYYY HH24:MI:SS'));
    
    end loop;
    close cur;
  exception
    when others then
      dbms_output.put_line(SQLERRM || dbms_utility.format_error_backtrace);
  end;

  FUNCTION get_total_hikes(p_emp_id NUMBER) RETURN NUMBER IS
    v_count NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO v_count
      FROM emp_salary_audit
     WHERE emp_id = p_emp_id;
  
    RETURN v_count;
  
  exception
    when others then
    
      dbms_output.put_line(SQLERRM || dbms_utility.format_error_backtrace);
      return 0;
  END get_total_hikes;
end pkg_salary_audit;

--  Calling package

DECLARE
    v_hikes NUMBER;
BEGIN
    pkg_salary_audit.update_salary(102, 55002);

    pkg_salary_audit.get_salary_history(102);

    v_hikes := pkg_salary_audit.get_total_hikes(101);
    DBMS_OUTPUT.PUT_LINE('Total salary hikes: ' || v_hikes);
END;

DECLARE
  v_hikes NUMBER;
begin
  v_hikes := pkg_salary_audit.get_total_hikes(102);
  DBMS_OUTPUT.PUT_LINE('Total salary hikes: ' || v_hikes);
END;

/*Q2. Bank Transaction Package (Medium–Hard)

Create a package pkg_bank_txn for a bank system:

Inside the Package:

Procedure deposit(p_acc_no, p_amount)

Procedure withdraw(p_acc_no, p_amount)

Function check_balance(p_acc_no) → returns number.

Rules:

Prevent withdrawal if balance is insufficient.

Log every transaction into bank_txn_log using an autonomous transaction.

Show meaningful custom exceptions (ex: insufficient balance, invalid account).

Ensure balance can't go negative even in concurrent sessions → use FOR UPDATE.

Q3. Inventory Reorder Package (Tricky)

Create a package pkg_inventory for table products(product_id, product_name, qty, reorder_level).

Package Tasks:

Procedure update_stock(p_id, p_qty_change)

If qty falls below reorder level → write a message "Reorder needed" into a log table.

Function is_reorder(p_id)

Returns TRUE/FALSE based on quantity.

Procedure generate_reorder_report

Display all products that need reorder.

Conditions:

Must use a REF CURSOR in report procedure.

Must use collection (BULK COLLECT) for faster fetch.

Must handle exceptions at package level.

Q4. Student Result System Package

Create a package pkg_result for table marks(student_id, subject, marks).

Package Should Have:

Function get_total_marks(p_id)

Function get_percentage(p_id)

Procedure update_marks(p_id, p_subject, p_new_marks)

Validate marks should be ≤ 100.

Log old & new marks in a log table.

Special Requirement:

Use function overloading inside the package:

get_total_marks(p_id)

get_total_marks(p_id, p_subject) (return marks only for that subject)

Q5. Order Management Package (Advanced)

You have tables:

orders(order_id, customer_id, amount, status)

order_log(order_id, old_status, new_status, changed_on)

Task:

Create a package pkg_order_mgmt with:

Procedure place_order(p_cust_id, p_amount)

Insert order with status "PENDING".

Return generated order_id.

Procedure update_status(p_order_id, p_new_status)

Allowed status flow:

PENDING → APPROVED → SHIPPED → DELIVERED


If invalid flow → raise custom exception.

Log every status change.

Function get_order_history(p_order_id)

Return all log details using REF CURSOR.

Extra Rules:

Use %TYPE and %ROWTYPE variables.

Use user-defined exception for invalid status flow.

Q6. Attendance Management Package (Hard)

For table attendance(emp_id, attend_date, status) create a package:

Package Contains:

Procedure mark_attendance(p_emp_id, p_status)

Function get_monthly_attendance(p_emp_id, p_month, p_year)

Return present % of the employee.

Procedure generate_monthly_report(p_month, p_year)

Should output attendance summary of all employees.

Use BULK COLLECT + FORALL to insert into a report table.

Special Conditions:

Status allowed: P, A, L.

If duplicate marking for same date → raise custom exception.*/












