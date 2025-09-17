CREATE OR REPLACE package body PKG_TEST is

function check_number(v_args in out T_VARARGS ) return char is
  v_num number := v_args.get_number('num');
begin
  DBMS_OUTPUT.put_line('in check_number: ' || to_char(v_num));
	if v_num = 42 then
		return 'J';
	else
		return 'N';
	end if;
end;

procedure add_numbers(v_args in out nocopy T_VARARGS )is
  v_n1 number := v_args.get_number('N1');
  v_n2 number := v_args.get_number('N2');
	v_result number;
begin
  DBMS_OUTPUT.put_line('in add_numbers: ' || to_char(v_n1) || '+' || to_char(v_n2));
  v_result := v_n1 + v_n2;
	v_args.add_arg('RESULT',v_result);
end;

procedure run_test is
v_args T_VARARGS := T_VARARGS(T_VARARG_NT());
v_result char;
v_add_result number;
begin
	v_args.add_arg('num',41);
	v_args.add_arg('N1',1);
	v_args.add_arg('N2',1);
	v_result := PKG_UTL_MATRIX.execute_function('PKG_TEST.check_number', v_args);
	DBMS_OUTPUT.put_line('v_result = ' || v_result);
	PKG_UTL_MATRIX.execute_procedure('PKG_TEST.add_numbers', v_args);
	v_args.get_arg('RESULT',v_add_result);
	DBMS_OUTPUT.put_line('v_add_result = ' || v_add_result);
end run_test;
--
function check_n2_0(v_args in out nocopy T_VARARGS) return char is
begin
  if v_args.get_number('n2') = 0 then
		return 'J';
	end if;
	return 'N';
end;
--
procedure handle_0(v_args in out nocopy T_VARARGS) is
begin
	v_args.add_arg('result','*division by zero');
end;
--
procedure do_div(v_args in out nocopy T_VARARGS) is
  v_n1 number := v_args.get_number('n1');
  v_n2 number := v_args.get_number('n2');
	v_result varchar2(32 char);
begin
	v_result := to_char(v_n1/v_n2);
	v_args.add_arg('result',v_result);
end;
--
procedure test_et is
  v_args T_VARARGS := T_VARARGS;
	--
	v_et PKG_UTL_MATRIX.T_ET_REC_NT := PKG_UTL_MATRIX.T_ET_REC_NT(
		 PKG_UTL_MATRIX.T_ET_REC('PKG_TEST.check_n2_0',PKG_UTL_MATRIX.T_FLAG_NT('N','-'))
		,PKG_UTL_MATRIX.T_ET_REC('PKG_TEST.handle_0'  ,PKG_UTL_MATRIX.T_FLAG_NT('-','X'))
		,PKG_UTL_MATRIX.T_ET_REC('PKG_TEST.do_div',    PKG_UTL_MATRIX.T_FLAG_NT('X','-'))
	);
begin
	-- load data
  v_args.add_arg('n1',42);
  v_args.add_arg('n2',0);
	PKG_UTL_MATRIX.execute_et(v_et, v_args);
  DBMS_OUTPUT.put_line(v_args.get_varchar2('result'));
end;
--
begin
	null;
end;
/
