CREATE OR REPLACE package pkg_test is

no_parameter_exception Exception;
PRAGMA EXCEPTION_INIT(no_parameter_exception,-20200);

-- Type used to pass arguments to the method

function check_number(v_args in out T_VARARGS ) return char;
procedure add_numbers(v_args in out nocopy T_VARARGS );
procedure run_test;
--
function check_n2_0(v_args in out nocopy T_VARARGS) return char;
procedure handle_0(v_args in out nocopy T_VARARGS);
procedure do_div(v_args in out nocopy T_VARARGS) ;

procedure test_et;

end pkg_test;
/
