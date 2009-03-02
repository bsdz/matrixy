
=head1 Function/Variable dispatch routines

The routines in this function deal with dispatching function calls or variable
lookups. This issue is complicated slightly by the fact that that both
subroutines and variables use the same syntax for dispatching and array lookup.
Given the code C<x(5)>, if x is a variable it performs an array lookup.
Otherwise, attempts to dispatch to the subroutine x with the argument list
C<(5)>.

Rules:

=over 4

=item*

Look up the name in the list of local variables. If we find it, dispatch
the request to the variable as a table lookup. This should already be done
in the grammar.

=item*

If a variable is not found, dispatch as a subroutine call. Look up the
subroutine name locally.

=item*

If a subroutine with that name isn't already loaded, it might exist in a
library file somewhere. For instance, the function C<x()> might be defined
in file C<x.m>, so search there

=item*

If all else fails, print a warning saying that C<x> is undefined.

=back

TODO: To make all this work, we may require that local variable names and
subroutines be stored in different namespaces so we don't get them confused
and can share names between them.

=cut

.namespace []

.sub '_dispatch'
    .param string name
    .param pmc args :slurpy
    .local pmc sub_obj
    .local pmc var_obj

    # First, look for a builtin function.
    sub_obj = get_hll_global ["_Matrixy";"builtins"], name
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Second, look for a locally-defined function
    sub_obj = find_name name
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Third, look for a list of already-loaded external functions
    .local pmc func_list
    func_list = get_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS'
    sub_obj = func_list[name]
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Fourth, search for the file "name".m in the /lib
    sub_obj = '_find_file_in_path'(name)
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # At this point, if we can't find anything, bork
    '_error_all'(name, " undefined")
    $P0 = null
    .return($P0)

  _dispatch_found_sub:
    $P0 = sub_obj(args :flat)
    .return($P0)
  _dispatch_found_var:
    .tailcall _variable_indexed_arg(var_obj, args)
.end

.sub '_variable_indexed_arg'
    .param pmc obj
    .param pmc args
    $P0 = obj.'get_element'(args :flat)
    .return($P0)
.end

.sub '_find_file_in_path'
    .param string name
    .local string filename
    .local pmc path
    .local pmc myiter
    .local pmc filehandle
    path = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"

    filename = name . ".m"
    myiter = iter path

  _loop_top:
    unless myiter goto _loop_not_found
    $P0 = shift myiter
    $S0 = $P0
    $S0 .= filename

    push_eh _find_no_file
    filehandle = open $S0, "r"
    goto _find_found_file

  _find_no_file:
    pop_eh
    goto _loop_top

  _loop_not_found:
    $P0 = null
    .return($P0)

  _find_found_file:
    .local pmc code
    .local pmc func_list
    .local pmc sub_obj
    code = filehandle.'readall'()
    $P0 = compreg "matrixy"
    $P1 = $P0.'compile'(code)
    # Add this to the loaded function hash
    sub_obj = $P1[1]
    func_list = get_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS'
    func_list[name] = sub_obj
    .return(sub_obj)
.end

=head1 set_nargin/set_nargout

These functions are called by the caller to set the number of input and
output arguments it's using in the subroutine call.

=cut

.sub 'set_nargin'
.end

.sub 'set_nargout'
.end

=head1 get_nargin/get_nargout

These functions are called by the callee to get the number of input and output
arguments that the caller is expecting

=cut

.sub 'get_nargin'
.end

.sub 'get_nargout'
.end

=head1 path

If no argument is provided, print the path. If an argument is provided, add
it to the end of the path list

=cut

.namespace ["_Matrixy";"builtins"]

.sub 'path'
    .param pmc addpath :optional
    .param int has_addpath :opt_flag
    .local pmc path
    path = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"

    if has_addpath goto _add_to_path
    .local pmc myiter
    myiter = iter path
  _iter_loop:
    unless myiter goto _iter_end
    $S0 = shift myiter
    say $S0
    goto _iter_loop
  _iter_end:
    .return()

  _add_to_path:
    push path, addpath
    set_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH", path
    .return()
.end

.namespace []
