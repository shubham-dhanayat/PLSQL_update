---------------------------------------------------------------------------------------------------------------
                                                Alter
---------------------------------------------------------------------------------------------------------------
select * from employees ;

--Add Column.
alter table employees add joining_date date default sysdate;

--Modify existing column
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
alter table employees disable constraint SYS_C008718 ;
alter table employees enable constraint SYS_C008718 ;

--Add default value
alter table employees modify dept_id default 100;

--Remove default value
alter table employees modify dept_id default null ;

--Set column to NOT NULL/NULL
alter table employees modify dept_id not null / null ;

--Move tablespace to another tablespace
alter table employees move tablespace SYSTEM ;

--Partition management ADD/DROP/SPLIT
alter table employees add partition p_name values ;
alter table employees drop partition p_name ;
alter table employees split partition p_name ;

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


select * from employees ;

rollback ;
