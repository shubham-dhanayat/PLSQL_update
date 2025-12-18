---------------------------------------------------------------------------------------------------------------
                                                Alter
---------------------------------------------------------------------------------------------------------------
select * from employees ;

--Add Column.
alter table employees add joining_date date default sysdate;

--Modify existing column
-- ‚úî Works only if data is compatible
-- ‚ùå Fails if column has incompatible data
alter table employees modify joining_date timestamp ;

--Drop/Remove column
alter table employees drop column joining_date ;
 
--Rename table
alter table mployee rename to employees ;

--Rename column
alter table employees rename column emp_id to employee_id ;

--Add constraint
alter table employees add constraint un_first_name unique(emp_name);

--Drop constraint
alter table employees drop constraint un_first_name ;

--Enable/Disable constraint
--              ‚ö†Ô∏è Technically correct but NOT recommended
--             Ì†ΩÌ¥¥ SYS_C... = system-generated
--             ‚úî Better to use actual constraint name
alter table employees disable constraint SYS_C008718 ;
alter table employees enable constraint SYS_C008718 ;

--Add default value
alter table employees modify dept_id default 100;

--Remove default value
alter table employees modify dept_id default null ;

--Set column to NOT NULL/NULL
alter table employees modify dept_id not null ;
alter table employees modify dept_id null ;

--Move tablespace to another tablespace
--       Ì†ΩÌ∫´ Never move user tables to SYSTEM
--       ‚úî Use USERS or custom tablespace
alter table employees move tablespace SYSTEM ;

--Partition management ADD/DROP/SPLIT
ALTER TABLE employees
ADD PARTITION p2025 VALUES LESS THAN (DATE '2026-01-01');

ALTER TABLE employees DROP PARTITION p2025;

ALTER TABLE employees
SPLIT PARTITION p2025
AT (DATE '2025-07-01')
INTO (PARTITION p1, PARTITION p2);

--Index  REBUILD/RENAME/UNUSABLE/MOVE
alter index SYS_C008718 rebuild ;
alter index uniq_indx rename to SYS_C008718 ;
alter index uniq_indx unusable ; -- Disable index temporary
alter index SYS_C008718 move tablespace tb_name ;

--Recompile a view
alter view v_emp_complex compile ;

--Procedure Function recompile
alter procedure pro_name compile ;
alter procedure fun_name compile ;

--Package / package body compile 
alter package pkg_name compile ;
alter package pkg_name compile body ;

--Trigger enable/disable/compile
alter trigger trg_v_emp_ins enable ;
alter trigger trg_v_emp_ins disable ;
alter trigger trg_v_emp_ins compile ;

--User
alter user user_name identified by new_pass ; --Change the pass
alter user user_name account lock ;
alter user user_name account unlock ;
alter user user_name default tablespace tb_name ;


select * from employees ;

rollback ;
