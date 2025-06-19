-- Enter SqlPlus commands here. Press [Ym] to execute.
set serveroutput on size 1000000
set linesize 1024
--set autotrace on explain STATISTICS
--alter session set timed_statistics=true;
set timing ON
begin
	dbms_output.put_line('Testing division by zero');
	declare
		v_num1 number := 10;
		v_num2 number := 0;
		v_result number;
	begin
		v_result := v_num1 / v_num2;
		dbms_output.put_line('Result: ' || v_result);
	exception
		when zero_divide then
			dbms_output.put_line('Caught division by zero error');
	end;
end;
/
