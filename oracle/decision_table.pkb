CREATE OR REPLACE package body decision_table is

--
function execute_function(pi_function_name in varchar2, pio_args in out nocopy T_VARARGS) return char is
	v_sql varchar2(1000 char);
	v_result char;
begin
	-- generate SQL to call the function
  v_sql := 'BEGIN :retval:=' || pi_function_name || '(:param); END;';
	DBMS_OUTPUT.put_line(v_sql);
  execute immediate v_sql using
	 out v_result
	,in out pio_args
	;
	return v_result;
end execute_function;
--
procedure execute_procedure(pi_procedure_name in varchar2, pio_args in out nocopy T_VARARGS) is
	v_sql varchar2(1000 char);
	v_result char;
begin
	-- generate SQL to call the function
  v_sql := 'BEGIN ' || pi_procedure_name || '(:param); END;';
	DBMS_OUTPUT.put_line(v_sql);
  execute immediate v_sql using	in out pio_args	;
end execute_procedure;


/* execute_et

Execute a ET. We assume:
a) the "et" is dence (no missing entries)
b) each T_ET_REC.T_FLAG_NT contains the same number of elements
*/
procedure execute_et(pi_et in T_ET_REC_NT, pio_args in out T_VARARGS) is
  v_rows number := pi_et.count;
  v_cols number := pi_et(1).flags.count;
	v_row number;
	v_col number;
	v_flag char;
	v_function_result char;
begin
	v_col := 1;
	-- loop table from left to right
	loop
		-- loop row from top to bottom
		v_row := 1;
		loop
			dbms_output.put_line('MX:' || to_char(v_col) || '/' || to_char(v_row));
			-- get current entry
			v_flag := pi_et(v_row).flags(v_col);
			if v_flag in ('J','N') then
				-- call with parameters
				v_function_result := execute_function(pi_et(v_row).method, pio_args);
				-- process output - function result must match the flag
				if v_function_result != v_flag then
					-- abort this rule
					exit;
				end if;
			end if;
			if v_flag = 'X' then
				execute_procedure(pi_et(v_row).method, pio_args);
			end if;
			v_row := v_row + 1;
			exit when v_row > v_rows;
	  end loop;
		-- one rule has been executed - check the outcome.
		if v_row > v_rows then
		  -- if the last row of the rule has been passed, we
		  -- have a result and we leave the ET.
			exit;
		else
			v_col := v_col + 1;
		end if;
		exit when v_col > v_cols;
	end loop;
end;

--
begin
	null;
end;
/
