
.namespace []

=head1 ABOUT

This file implements some basic routines for working with multidimensional
matrix objects. These are, at least at first, nested ResizablePMCArray objects.

=head2 Caveats

At the moment, only covers matrices with a dimension of 1 or 2. No 3-D matrices.

=head1 FUNCTIONS

=over 4

=item _get_matrix_string(m)

Gets a string that represents the contents of the variable m.

=item _verify_matrix(m)

Verify that the matrix is square (or cube, or whatever). Zero pad it out
otherwise.

=item _get_matrix_dimensions

Return the dimensions of the matrix

=item _get_matrix_size

Return the sizes of the matrix along each dimension

=cut

.sub '_get_matrix_string'
    .param pmc col
    .local string s
    s = ""
    $S0 = typeof col
    if $S0 == 'ResizablePMCArray' goto _its_a_matrix

    # Here, we don't have a matrix, it's something else. We should probably
    # differentiate between other types, but right now we'll just do things
    # the easy way.
    $S0 = col
    $S1 = "\t" . $S0
    .return($S1)

    # TODO: This is all a bit of a hack. Clean this all up, and maybe delegate
    #       some of the logic to recursive sub-functions to make all the evil
    #       go away. Plus, this only handles Vectors and 2-D matrices, so that
    #       needs to be generalized.
  _its_a_matrix:
    .local pmc iter_col
    .local pmc iter_row
    #col = '_verify_matrix'(col)
    iter_col = iter col
  _outer_loop_top:
    unless iter_col goto _outer_loop_bottom
    $P0 = shift iter_col

    $S0 = typeof $P0
    if $S0 == 'ResizablePMCArray' goto _its_two_d
    $S0 = $P0
    s .= $S0
    s .= "\n"
    goto _outer_loop_top

  _its_two_d:
    iter_row = iter $P0
  _inner_loop_top:
    unless iter_row goto _inner_loop_bottom
    $P1 = shift iter_row
    $S0 = $P1
    s .= "\t"
    s .= $S0
    goto _inner_loop_top
  _inner_loop_bottom:
    s .= "\n"
    goto _outer_loop_top
  _outer_loop_bottom:
   .return(s)
.end

.sub '_verify_matrix'
    .param pmc m
    .local pmc myiter
    .local pmc sizes
    .local int max

    # TODO: This function ONLY handles 2-D matrices right now, it doesn't work
    #       for 1xN vectors yet. Fix that, and maybe generalize it so it will
    #       work for N-D vectors

    # We're only handling square matrices right now.
    $I0 = elements m
    myiter = iter m
    sizes = new 'ResizableIntegerArray'
    max = 0

    # Iterate over the rows of the matrix. Get the length of each row and store
    # that in another array. Also, keep track of the maximum value seen, so
    # we can zero-pad everything later if needed.
  _loop_top:
    unless myiter goto _loop_bottom
    $P0 = shift myiter
    $I1 = $P0
    unless $I1 > max goto _not_max
    max = $I1
  _not_max:
    push sizes, $I0
    goto _loop_top
  _loop_bottom:

    # Now we have an array of all the row lengths. Iterate through that
    # looking for any rows that don't have at least a length of max
    .local int idx
    idx = sizes
    idx = idx - 1
  _loop_topb:
    if idx < 0 goto _loop_bottomb
    $I0 = sizes[idx]
    idx = idx - 1
    if $I0 == max goto _loop_topb
    $P0 = m[idx]
    $P0 = max
    m[idx] = $P0
    goto _loop_topb
    $I0 = $P0
  _loop_bottomb:

    # Okay, the matrix should be square now. At least, I hope so. Return
    .return(m)
.end

.sub '_get_matrix_dimensions'
    .param pmc m
    $S0 = typeof m
    if $S0 == 'ResizablePMCArray' goto _its_a_matrix
    .return(1)

    # This function should be sufficiently generalized for matrices of any
    # dimension, assuming we keep with the strategy of nesting RPAs
  _its_a_matrix:
    .local int dims
    dims = 1
    m = '_verify_matrix'(m)
    $P0 = m[0]

  _loop_top:
    $S0 = typeof $P0
    if $S0 == 'ResizablePMCArray' goto _another_dim
    .return(dims)
  _another_dim:
    dims = dims + 1
    goto _loop_top
.end

.sub '_get_matrix_sizes'
    .param pmc m

    # TODO: This needs to be tested. I don't use it (because it probably
    #       doesn't work.
    .local pmc sizes
    sizes = new 'ResizableIntegerArray'
    $S0 = typeof m
    if $S0 == 'ResizablePMCArray' goto _its_a_matrix
    sizes[0] = 1
    .return(sizes)

  _its_a_matrix:
    .local int dims
    dims = '_get_matrix_dimensions'(m)
    $P0 = m

  _loop_top:
    if dims == 0 goto _loop_bottom
    $I0 = $P0
    sizes[dims] = $I0
    dims = dims - 1
    goto _loop_top
  _loop_bottom:
    .return(sizes)
.end

=item !array_row(PMC fields :slurpy)

Construct an array row from the variadic argument list. If the row contains
any strings, compress the whole thing into a single String PMC. Otherwise,
create a ResizablePMCArray for the row.

=cut

.sub '!array_row'
    .param pmc fields :slurpy
    .local pmc myiter
    myiter = iter fields
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0
    unless $S0 == "String" goto loop_top
    .tailcall '!array_compress_strings'(fields)
  loop_bottom:
    .return (fields)
.end

=item !array_col(PMC fields :slurpy)

Create a new array column from a variadic argument list. If any of the rows
are String PMCs, converts all rows in the matrix to string PMCs and returns
the list of them. Otherwise, builds a simple array of the row PMCs.

=cut

.sub '!array_col'
    .param pmc fields :slurpy
    .local pmc myiter
    myiter = iter fields
  loop_top:
    unless myiter goto just_exit
    $P0 = shift myiter
    $S0 = typeof $P0
    unless $S0 == "String" goto loop_top

    # fall through. If any row is a string, the whole matrix is treated as
    # an array of strings. each row has to be converted now.
    .tailcall '!array_col_force_strings'(fields)
  just_exit:
    .return (fields)
.end

=item !array_col_force_strings(PMC m)

Force all rows in matrix m to become String PMCs

=cut

.sub '!array_col_force_strings'
    .param pmc m
    .local pmc myiter
    .local pmc newarray
    newarray = new 'ResizablePMCArray'
    myiter = iter m
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0
    if $S0 == 'String' goto push_string_pmc
    $S0 = '!array_compress_strings'($P0)
    $P0 = box $S0
  push_string_pmc:
    push newarray, $P0
    goto loop_top
  loop_bottom:
    .return(newarray)
.end

=item !aray_compress_strings(PMC m)

String array constructor. Strings and numbers cannot really coexist in a
single matrix. If strings are present, all numbers are converted to their
ASCII character representations. All strings or characters in a given row
are concatenated together into a single string. If a Num is passed instead
of an Int, it is rounded down and the integer value is used to look up the
character.

=cut

.sub '!array_compress_strings'
    .param pmc fields
    .local pmc myiter
    .local string s
    myiter = iter fields
    s = ""

    # Iterate over the input array
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0

    # If it's a string, add it to the running concatination.
    # Otherwise, get the ASCII character representation and add that
    if $S0 == 'String' goto have_string_pmc
    $I0 = $P0
    $S1 = chr $I0
    s .= $S1
    goto loop_top
  have_string_pmc:
    $S1 = $P0
    s .= $S1
    goto loop_top

  loop_bottom:
    .return(s)
.end


=back

=cut
