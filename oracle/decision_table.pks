CREATE OR REPLACE package decision_table is

no_parameter_exception Exception;
PRAGMA EXCEPTION_INIT(no_parameter_exception,-20200);

-- Type used to pass arguments to the method

-- Type used to the "ET". The values are: J,N,X,-
type T_FLAG_NT is table of char;

-- one record of the "ET".
-- "method" contains the method that is called.
-- "T_FLAG_NT" contain the flags
type T_ET_REC is record (method varchar2(40 char), flags T_FLAG_NT);
type T_ET_REC_NT is table of T_ET_REC;

procedure execute_et(pi_et in T_ET_REC_NT, pio_args in out T_VARARGS);
function execute_function(pi_function_name in varchar2, pio_args in out nocopy T_VARARGS) return char;
procedure execute_procedure(pi_procedure_name in varchar2, pio_args in out nocopy T_VARARGS);


end decision_table;
/
