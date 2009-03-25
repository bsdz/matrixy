
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

.sub '!dispatch'
    .param string name
    .param pmc var
    .param int nargout
    .param int nargin
    .param int parens
    .param pmc args :slurpy
    .local pmc sub_obj
    .local pmc var_obj

    # if we have a variable value, dispatch that
    if null var goto not_a_var
    .tailcall '!index_variable'(var, nargout, nargin, parens, args)

    # if it's not a variable, treat it like a sub and look that up.
  not_a_var:
    sub_obj = '!lookup_function'(name)
    unless null sub_obj goto found_sub
    _error_all("'", name, "' undefined")

  found_sub:
    .tailcall sub_obj(nargout, nargin, args :flat)
.end

.sub '!lookup_function'
    .param string name
    .local pmc sub_obj
    .local pmc var_obj

    # First, look for a builtin function.
    sub_obj = get_hll_global ["_Matrixy";"builtins"], name
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Second, look for a locally-defined function
    sub_obj = get_hll_global ["Matrixy::functions"], name
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Third, look for a list of already-loaded external functions
    # TODO: This might not be necessary, since we are loading subs into their
    #       own namespace now
    .local pmc func_list
    func_list = get_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS'
    sub_obj = func_list[name]
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

    # Fourth, search for the file "name".m in the /lib
    .local pmc filehandle
    filehandle = '!find_file_in_path'(name)
    $I0 = defined filehandle
    if $I0 goto _dispatch_found_file
    goto _dispatch_not_found

  _dispatch_found_file:
    sub_obj = '!get_sub_from_code_file'(filehandle, name)
    close filehandle
    $I0 = defined sub_obj
    if $I0 goto _dispatch_found_sub

  _dispatch_not_found:
    $P0 = null
    .return($P0)

  _dispatch_found_sub:
    .return(sub_obj)
.end

.sub '!index_variable'
    .param pmc var
    .param int nargout
    .param int nargin
    .param int parens
    .param pmc args

    $S0 = typeof var

    # If it's a function handle variable, dispatch it.
    unless $S0 == 'Sub' goto its_a_variable
    if parens == 1 goto execute_sub_handle
    .return(var)
  execute_sub_handle:
    .tailcall var(nargout, nargin, args :flat)

    # If it's an ordinary variable, do the indexing
  its_a_variable:

    # If we only have a 1-ary index, we need to use a separate vector indexing
    # algorithm instead of the nested matrix indexing.
    $I0 = args
    unless $I0 == 1 goto matrix_indexing
    $I1 = args[0]
    dec $I1 # Make sure it's 0-indexed
    .tailcall '!index_vector'(var, $I1)

  matrix_indexing:
    .local pmc myiter
    myiter = iter args
    $P1 = var
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $I0 = $P0
    dec $I0   # M Matrices are 1-based, not 0-based like Parrot arrays
    if $I0 < 0 goto negative_index_attempt
    $P2 = $P1[$I0]
    $P1 = $P2
    goto loop_top
  loop_bottom:
    .return($P1)
  negative_index_attempt:
    _error_all("invalid index")
.end

.sub '!index_vector'
    .param pmc var
    .param int idx
    .local int rows
    .local int cols

    $P0 = '!get_matrix_sizes'(var)
    rows = $P0[0]
    cols = $P0[1]
    if cols == 1 goto column_vector
    if rows == 1 goto row_vector

    # here, it's a matrix that's being indexed like a vector
    .local int row
    .local int col
    row = idx % rows
    col = idx / rows
    $P1 = var[row]
    $P2 = $P1[col]
    .return($P2)

  column_vector:
    $P1 = var[idx]
    $P2 = $P1[0]
    .return($P2)

  row_vector:
    $P1 = var[0]
    $P2 = $P1[idx]
    .return($P2)
.end

.sub '!indexed_assign'
    .param pmc var
    .param pmc value
    .param pmc indices :slurpy
    $I0 = indices
    if $I0 == 0 goto assign_scalar
    # TODO: Check if the value is a scalar. If we have indices, autopromote
    #       to a matrix of the appropriate size and zero-pad it.
    if $I0 == 1 goto assign_vector
    if $I0 == 2 goto assign_matrix
    _error_all("Number of indices is too great, only 2D matrices are supported")
  assign_scalar:
    .return(value)
  assign_vector:
    $P0 = indices[0]
    $I1 = $P0
    .tailcall '!indexed_assign_vector'(var, value, $I1)
  assign_matrix:
    # TODO: Check the current size of the matrix. If the indices are larger,
    #       expand the matrix and zero-pad it.
    $P0 = indices[0]
    $P1 = indices[1]
    $I1 = $P0
    $I2 = $P1
    dec $I1
    dec $I2
    var[$I1;$I2] = value
    .return(var)
.end

.sub '!indexed_assign_vector'
    .param pmc var
    .param pmc value
    .param int index
    # TODO: If we have a row or column vector, assign to the spot directly.
    # TODO: If we have a matrix, dollow the same indexing algorithm as we use
    #       for indexed fetch.
    # TODO: If the index is larger then the matrix/vector, extend it.
    _error_all("1-ary indexing not implemented!")
.end
.sub '!generate_string'
    .param pmc args :slurpy
    .local pmc myiter
    .local string s
    $I0 = args
    print "found "
    print $I0
    say " args"

    s = ""
    myiter = iter args
    unless myiter goto loop_bottom
    $P0 = shift myiter
    s = $P0

  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = $P0
    s .= " "
    s .= $S0
    goto loop_top
  loop_bottom:
    .return(s)
.end

.sub '!find_file_in_path'
    .param string name
    .local string filename
    .local pmc path
    .local pmc myiter
    .local pmc filehandle
    path = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"

    filename = name . ".m"
    myiter = iter path
    $P0 = shift myiter  # get rid of "."
    push_eh _find_no_file
    filehandle = open filename, "r"
    goto _find_found_file

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
    .return(filehandle)
.end

# TODO: We need to be able to handle two types of files: Function files
#       and bare scripts. The former is $P1[1], the later will be $P1[0].
#       Also, the later will not take any args (so throw an error if any
#       are passed).
.sub '!get_sub_from_code_file'
    .param pmc filehandle
    .param string name
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


.namespace []

