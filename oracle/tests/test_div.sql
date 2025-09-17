set serveroutput on size 1000000
set linesize 1024
set timing ON
begin
	dbms_output.put_line('Testing division by zero');
	declare
		v_result number;
	begin
		PKG_TEST.test_et;
	end;
end;
/
