CREATE OR REPLACE type body T_VARARGS as
  --
  constructor function T_VARARGS return self as result AS
  begin
    self.m_args_nt := T_VARARG_NT();
    return;
  end;
  --
  member function find_arg_index(pi_varname in varchar2) return pls_integer is
    v_ix pls_integer := m_args_nt.first;
    v_varname varchar2(40 char) := upper(pi_varname);
  begin
	  loop
		  exit when v_ix is null;
		  -- check content name
		  exit when m_args_nt(v_ix).NAME=v_varname;
	  	v_ix := m_args_nt.next(v_ix);
	  end loop;
	  return v_ix;
  end find_arg_index;
  --
  member procedure add_arg(pi_varname in varchar2, pi_arg in ANYDATA) as
    v_vargs_ix pls_integer := find_arg_index(pi_varname);
	  v_arg T_VARARG := T_VARARG(upper(pi_varname), pi_arg);
  begin
    if v_vargs_ix is null then
		  m_args_nt.extend;
		  m_args_nt(m_args_nt.last) := v_arg;
  	else
	  	m_args_nt(v_vargs_ix) := v_arg;
	  end if;
  end;
  --
  member procedure add_arg(pi_varname in varchar2, pi_arg in number) as
  begin
	  add_arg(pi_varname, ANYDATA.ConvertNumber(pi_arg));
  end add_arg;
  --
  member procedure add_arg(pi_varname in varchar2, pi_arg in varchar2) as
  begin
	  add_arg(pi_varname, ANYDATA.ConvertVarchar2(pi_arg));
  end add_arg;
  --
  member procedure add_arg(pi_varname in varchar2, pi_arg in date) as
  begin
	  add_arg(pi_varname, ANYDATA.ConvertDate(pi_arg));
  end add_arg;
  --
  member procedure add_arg(pi_varname in varchar2, pi_arg in boolean) as
  begin
    if pi_arg = True then
      add_arg(pi_varname, ANYDATA.ConvertChar('J'));
    end if;
    if pi_arg = False then
      add_arg(pi_varname, ANYDATA.ConvertChar('N'));
    end if;
    if pi_arg is null then
      add_arg(pi_varname, ANYDATA.ConvertChar('-'));
    end if;
  end add_arg;
  --
  member function get_arg(pi_varname in varchar2) return ANYDATA as
    v_ix pls_integer;
  begin
    v_ix := find_arg_index(pi_varname);
	  if v_ix is null then
		  raise NO_DATA_FOUND;
	  else
		  return m_args_nt(v_ix).value;
	  end if;
  end;
  --
  member function get_number(pi_varname in varchar2) return number as
  begin
	  return get_arg(pi_varname).AccessNumber();
  end;
  --
  member function get_varchar2(pi_varname in varchar2) return varchar2 as
  begin
	  return get_arg(pi_varname).AccessVarchar2();
  end;
  --
  member function get_date(pi_varname in varchar2) return date as
  begin
	  return get_arg(pi_varname).AccessDate();
  end;
  --
  member function get_boolean(pi_varname in varchar2) return boolean is
    v_jn char;
  begin
	  v_jn := get_arg(pi_varname).ACCESSCHAR();
	  if v_jn = 'J' then
		  return True;
	  end if;
	  if v_jn = 'N' then
		  return False;
	  end if;
  	return null;
  end;
  --
  member procedure get_arg(pi_varname in varchar2, po_arg out number) as
  begin
    po_arg := get_number(pi_varname);
  end;
  --
  member procedure get_arg(pi_varname in varchar2, po_arg out varchar2) as
  begin
    po_arg := get_varchar2(pi_varname);
  end;
  --
  member procedure get_arg(pi_varname in varchar2, po_arg out date) as
  begin
    po_arg := get_date(pi_varname);
  end;
  --
  member procedure get_arg(pi_varname in varchar2, po_arg out boolean) as
  begin
    po_arg := get_boolean(pi_varname);
  end;

end;
/
