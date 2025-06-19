CREATE OR REPLACE type T_VARARGS as Object(
	m_args_nt T_VARARG_NT,
  constructor function T_VARARGS return self as result,
  member function find_arg_index(pi_varname in varchar2) return pls_integer,
  member procedure add_arg(pi_varname in varchar2, pi_arg in ANYDATA),
  member procedure add_arg(pi_varname in varchar2, pi_arg in number),
  member procedure add_arg(pi_varname in varchar2, pi_arg in varchar2),
  member procedure add_arg(pi_varname in varchar2, pi_arg in date),
  member procedure add_arg(pi_varname in varchar2, pi_arg in boolean),
  --
  member function get_arg(pi_varname in varchar2) return ANYDATA,
  member function get_number(pi_varname in varchar2) return number,
  member function get_varchar2(pi_varname in varchar2) return varchar2,
  member function get_date(pi_varname in varchar2) return date,
  member function get_boolean(pi_varname in varchar2) return boolean,
  --
  member procedure get_arg(pi_varname in varchar2, po_arg out number),
  member procedure get_arg(pi_varname in varchar2, po_arg out varchar2),
  member procedure get_arg(pi_varname in varchar2, po_arg out date),
  member procedure get_arg(pi_varname in varchar2, po_arg out boolean)
);
/
