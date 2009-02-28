
.namespace ['Matrix']

=head1 ABOUT

This is a 2-D matrix class for matrixy. It can be used to represent numerical
matrices, vectors, or scalars. It implements a number of mathematical
manipulations for these values, and all the necessary bookkeeping routines.

=head1 Functions

=over 4

=cut

#Class hierarchy:
#   MatrixyData (Do I need this
#       Array2D
#           Numerical Matrix (strings are character vectors, and can be used in math)
#           Cell (non-numerical matrix which contains pmcs and does not concatinate)
#           String (character row vector)
#       Sparse_Matrix
#       Struct (hash)
#   Function

#TODO: Strings
#   x = ['a', 'b', 'c'] = 'abc'
#   x = [49, 50, '3'] = '123'
#   x = 'abc' * 2 = [194, 196, 198]

=item onload()

anonymous function run at load time to establish the matrix class

=cut

.sub 'onload' :anon :load :init
    $P0 = subclass 'MatrixyData', 'Matrix'
    addattribute $P0, 'size_x'
    addattribute $P0, 'size_y'
    addattribute $P0, 'numerical'
.end

=item create()

Method to instantiate a new matrix.

TODO: This could be renamed to ".sub 'init' :vtable", which requires
a change in the parser and also requires that we don't have all the
size parameters (which would need to be passed to a separate function).

=cut

.sub 'create' :method
    .param string name
    .param int sizex :optional
    .param int has_x :opt_flag
    .param int sizey :optional
    .param int has_y :opt_flag
    .local int my_sizex
    .local int my_sizey
    .local int ptr_x

    # Set the type as "matrix"
    # Create a matrix with given width and length

    $P0 = new 'String'
    $P0 = 'Matrix'
    setattribute self, 'type', $P0
    $P0 = name
    setattribute self, 'name', $P0

    #Set width and length fields

    if has_x goto save_x
    my_sizex = 1
    goto have_x
  save_x:
    my_sizex = sizex
  have_x:
    if has_y goto save_y
    my_sizey = my_sizex
    goto have_y
  save_y:
    my_sizey = sizey
  have_y:
    self.'size_x'(sizex)
    self.'size_y'(sizey)

    #create the matrix using a large ugly mesh of ResizablePMCArrays

    $P0 = new 'ResizablePMCArray'
    $P0 = sizex
    ptr_x = 0
  next_row:
    if ptr_x == sizex goto done_init
    $P1 = new 'ResizablePMCArray'
    $P1 = sizey
    $P0[ptr_x] = $P1
    ptr_x = ptr_x + 1
    goto next_row
  done_init:
    self.'data'($P0)
    .return(self)
.end

=item create_scalar(STRING name, PMC value)

Create a new scalar, which is a 1x1 matrix

=cut

.sub 'create_scalar' :method
    .param string name
    .param pmc value
    self.'create'(name, 1, 1)
    self.'set_scalar_value'(value)
.end

=item size_x(INT x :optional)

Return the x size of the matrix if no argument is given, or sets the
x size to the given integer otherwise.

=item size_y(INT y :optional)

Return the y size of the matrix if no argument is given, or sets the
y size to the given integer otherwise.

=cut

.sub 'size_x' :method
    .param int x :optional
    .param int has_x :opt_flag
    if has_x goto set_x
    $P0 = getattribute self, 'size_x'
    .return($P0)
  set_x:
    $P1 = new 'Integer'
    $P1 = x
    setattribute self, 'size_x', $P1
.end

.sub 'size_y' :method
    .param int y :optional
    .param int has_y :opt_flag
    $P0 = new 'String'
    $P0 = 'size_y'
    if has_y goto set_y
    $P0 = getattribute self, 'size_y'
    .return($P0)
  set_y:
    $P1 = new 'Integer'
    $P1 = y
    setattribute self, 'size_y', $P1
.end

=item data()

Set's the variables matrix data. For matrices, this should be a two-dimensional
set of Resizable PMC arrays.

=cut

.sub 'data' :method
    .param pmc d :optional
    .param int has_d :opt_flag
    if has_d goto set_d
    $P0 = getattribute self, 'data'
    .return($P0)
  set_d:
    setattribute self, 'data', d
.end

=item check_bounds(INT x, INT y)

Takes two integer arguments, x and y, and determines whether self
is the same size

=cut

.sub 'check_bounds' :method
    .param int x
    .param int y

    #get sizes from self 

    $P0 = new 'String'
    $P0 = 'size_x'
    $I0 = self.'size_x'()
    $I1 = self.'size_y'()

    #perform some basic bounds checks on the inputs

    if x > $I0 goto sizes_not_agree
    if y > $I1 goto sizes_not_agree
    if x < 0 goto sizes_not_agree
    if y < 0 goto sizes_not_agree
    .return(1)

  sizes_not_agree:
    .return(0)
.end

=item get_element(INT x, INT y :optional)

Returns the element at location (x, y) in the matrix. If the matrix is a
row or column vector, y is ommitted and x is the element in the array
(which may not be in the x-direction if this is a column vector).

=cut

.sub 'get_element' :method
    .param int x
    .param int y :optional
    .param int has_y :opt_flag

    if has_y goto ive_got_y

    # we need to determine if this is a row or a column vector, and 
    # access the right element, accordingly. If it's a row vector (x = 1)
    # we set y = x, and x = 1. Otherwise, if it's a column vector or a matrix,
    # we set y = 1.

    ($I0, $I1) = self.'get_size'()
    if $I0 == 1 goto row_vector
    y = 1
    goto ive_got_y

  row_vector:
    y = x
    x = 1

  ive_got_y:
    x = x - 1
    y = y - 1

    # Do some bounds-checking here

    $I0 = self.'check_bounds'(x, y)
    if $I0 == 1 goto check_bounds_ok
    $S0 = self.'name'()
    '_error_all'('Bounds error: ', $S0, '(', x, ', ', y, ') not available')
    .return(0)

  check_bounds_ok:
    $P0 = self.'data'()
    $P1 = $P0[x]
    $P2 = $P1[y]

    .return($P2)
.end

=item set_element(INT, INT y, PMC data)

Set the element at location (x, y) to value C<data>. Initially C<data> should
be a scalar, although eventually this will handle matrix concatination
as well (probably).

=cut

.sub 'set_element' :method
    .param int x
    .param int y
    .param pmc data
    x = x - 1
    y = y - 1

    # TODO: Do some bounds-checking here
    # If we need to expand the matrix, we do that here. Pad extra places with
    # zeros or something.

    # TODO: Handle matrix concatination
    # If the value to set is itself a matrix, concatinate (which may involve
    # getting creative with the matrix dimensions).
    # OTHERWISE: Throw an error here if data is not a scalar

    # Set the element at the given slot

    $P0 = self.'data'()
    $P1 = $P0[x]
    $P1[y] = data
    .return(data)
.end

=item get_size()

Return the x, y size of the matrix

=item get_vector_length()

Get the x length of the matrix, or the y length if it's a column vector

=cut

.sub 'get_size' :method
    $I0 = self.'size_x'()
    $I1 = self.'size_y'()
    .return($I0, $I1)
.end

.sub 'get_vector_length' :method
    ($I0, $I1) = self.'get_size'()
    $I2 = 1
    if $I0 == $I2 goto is_row_vec
    .return($I0)
  is_row_vec:
    .return($I1)
.end

=item get_size_string

Returns a string representation of the matrices dimensions of the form

  1 x 2

=item

prints the matrix in stringified form. Here's an example:

    myvar (4 x 2):

        1 2 3 4
        5 6 7 8

=cut

.sub 'get_size_string' :method
    ($I0, $I1) = self.'get_size'()
    $S0 = $I0
    $S0 = $S0 . ' x '
    $S1 = $I1
    $S0 = $S0 . $S1
    .return($S0)
.end

.sub 'print_string' :method
    .local int ptrx
    .local int ptry

    $S0 = self.'name'()
    $S1 = self.'get_size_string'()
    '_disp_all'($S0 , ' (' , $S1 , '):')
    print "\n"
    $P0 = self.'data'()

    ($I0, $I1) = self.'get_size'()

    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    $P2 = self.'get_element'($I2, $I3)
    print "\t"
    print $P2
    ptry = ptry + 1
    if ptry >= $I1 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    print "\n"
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    print "\n"
    .return(1)
.end

=item is_row_vector()

Returns 1 if this is a row vector, 0 otherwise

=item is_column_vector

Returns 1 if this is a column vector, 0 otherwise

=item is_scalar()

Returns 1 if this is a 1 x 1 scalar value. 0 otherwise.
=cut

.sub 'is_row_vector' :method
    ($I0, $I1) = self.'get_size'()
    if $I0 == 1 goto is_vector
    .return(0)
  is_vector:
    .return(1)
.end

.sub 'is_column_vector' :method
    ($I0, $I1) = self.'get_size'()
    if $I1 == 1 goto is_vector
    .return(0)
  is_vector:
    .return(1)
.end

.sub 'is_scalar' :method
    ($I0, $I1) = self.'get_size'()
    if $I0 != 1 goto not_scalar
    if $I1 != 1 goto not_scalar
    .return(1)
  not_scalar:
    .return(0)
.end

=item get_scalar_value()

If this is a scalar, returns the scalar's value. Otherwise, throws an
error

=item set_scalar_value()

If this is a scalar, sets it's value. Otherwise, throws an error.

=cut

.sub 'get_scalar_value' :method
    $I0 = self.'is_scalar'()
    if $I0 != 1 goto not_scalar
    $I1 = self.'get_element'(1, 1)
    .return($I1)
  not_scalar:
    'error'('not a scalar value')
.end

.sub 'set_scalar_value' :method
    .param pmc value
    $I0 = self.'is_scalar'()
    '_disp_all'('value: ', $I0)
    if $I0 != 1 goto not_scalar
    self.'set_element'(1, 1, value)
    .return()
  not_scalar:
    'error'('not a scalar value')
.end

=item is_equal(PMC a)

Returns 1 if the given matrix is equal in size and contents to self.
0 otherwise.

=cut

.sub 'is_equal'  :method
    .param pmc a
    .local pmc b
    .local int ptrx
    .local int ptry
    b = self

    # determine if matrices are the same size

    ($I0, $I1) = a.'get_size'()
    ($I2, $I3) = b.'get_size'()
    if $I0 != $I2 goto not_equal
    if $I1 != $I3 goto not_equal

    # enter a two-stage loop here, check each item for equality. Return 0 if
    # any entry is not equal. Return 1 at the end otherwise.

    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    $I4 = a.'get_element'($I2, $I3)
    $I5 = b.'get_element'($I2, $I3)
    if $I4 != $I5 goto not_equal
    ptry = ptry + 1
    if ptry >= $I1 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    print "\n"
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(1)

  not_equal:
    .return(0)

.end

=item add()

Adds two matrices together, if they are the same size

=cut

.sub 'add' :method
    .param pmc a
    .local pmc b
    .local pmc c
    .local int ptrx
    .local int ptry

    b = self
    # determine if matrices are the same size

    ($I0, $I1) = a.'get_size'()
    ($I2, $I3) = b.'get_size'()
    if $I0 != $I2 goto not_equal
    if $I1 != $I3 goto not_equal
    goto are_equal
  not_equal:
    $P0 = new 'Undef'
    'error'('matrix dimensions do not agree')
    .return($P0)

  are_equal:
    c = new 'Matrix'
    c.'create'('sum', $I2, $I3)
    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    $I4 = a.'get_element'($I2, $I3)
    $I5 = b.'get_element'($I2, $I3)
    $I6 = $I4 + $I5
    c.'set_element'($I2, $I3, $I6)
    ptry = ptry + 1
    if ptry >= $I1 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(c)
.end

=item transpose()

transpose a matrix

=cut

.sub 'transpose' :method
    .local pmc t
    .local int ptrx
    .local int ptry

    #determine if matrices are the same size

    ($I0, $I1) = self.'get_size'()
    t = new 'Matrix'
    t.'create'('transpose', $I1, $I0)

  are_equal:
    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    $I4 = self.'get_element'($I2, $I3)
    t.'set_element'($I3, $I2, $I4)
    ptry = ptry + 1
    if ptry >= $I1 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(t)
.end

=item negate

Negate all contents of a matrix

=cut

.sub 'negate' :method
    .local pmc t
    .local int ptrx
    .local int ptry

    #determine if matrices are the same size

    ($I0, $I1) = self.'get_size'()
    t = new 'Matrix'
    t.'create'('transpose', $I0, $I1)

    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    $I4 = self.'get_element'($I2, $I3)
    $I5 = - $I4
    t.'set_element'($I2, $I3, $I5)
    ptry = ptry + 1
    if ptry >= $I1 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(t)
.end

=item subtract(PMC a)

Subtract C<a> from self, if the two are the same size.

=cut

.sub 'subtract' :method
    .param pmc b
    .local pmc a
    a = self
    $P0 = b.'negate'()
    $P1  = a.'add'($P0)
    .return($P1)
.end

=item get_row

Return a row vector from a matrix

=item get_column

Return a column vector from a matrix

=cut

.sub 'get_row' :method
    .param int ptrx
    .local pmc r
    .local int ptry

    ($I0, $I1) = self.'get_size'()
    r = new 'Matrix'
    r.'create'('row', 1, $I1)
    ptry = 0
  y_loop_top:
    $I2 = ptry + 1
    $I3 = self.'get_element'(ptrx, $I2)
    r.'set_element'(1, $I2, $I3)
    ptry = ptry + 1
    if ptry >= $I1 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    .return(r)
.end

.sub 'get_column' :method
    .param int ptry
    .local pmc c
    .local int ptrx

    ($I0, $I1) = self.'get_size'()
    c = new 'Matrix'
    c.'create'('column', $I0, 1)
    ptrx = 0
  x_loop_top:
    $I2 = ptrx + 1
    $I3 = self.'get_element'($I2, ptry)
    c.'set_element'($I2, 1, $I3)
    ptrx = ptrx + 1
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(c)
.end

=item dot_product(PMC b)

Return the dot product of two vectors. Self must be a row vector and
C<b> must be a column vector.

=cut

.sub 'dot_product' :method
    .param pmc b
    .local pmc a
    .local int x
    .local int maxx
    .local int sum
    a = self

    # make sure they are all vectors of the right dimensions

    $I0 = a.'is_row_vector'()
    $I1 = b.'is_column_vector'()
    if $I0 == 0 goto size_error
    if $I1 == 0 goto size_error

    #make sure the lengths of the vectors are the same.

    $I0 = a.'get_vector_length'()
    $I1 = b.'get_vector_length'()
    if $I0 == $I1 goto vectors_agree
    goto size_error

  vectors_agree:
    x = 0
    sum = 0
    maxx = $I0
  x_loop_top:
    $I0 = x + 1
    $I1 = a.'get_element'($I0)
    $I2 = b.'get_element'($I0)
    $I3 = $I1 * $I2
    sum = sum + $I3
    x = x + 1
    if x >= maxx goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(sum)
  size_error:
    'error'('vector sizes do not agree')
    $P0 = new 'Undef'
    .return($P0)
.end

=item multiply(PMC b)

Matrix multiply self by C<b>.

=cut

.sub 'multiply' :method
    .param pmc b
    .local pmc a
    .local pmc c
    .local int ptrx
    .local int ptry
    a = self
    ($I0, $I1) = a.'get_size'()
    ($I2, $I3) = b.'get_size'()
    if $I1 != $I2 goto sizes_disagree

    c = new 'Matrix'
    c.'create'('product', $I0, $I3)

    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I4 = ptrx + 1
    $I5 = ptry + 1
    $P0 = a.'get_row'($I4)
    $P1 = b.'get_column'($I5)
    $I6 = $P0.'dot_product'($P1)
    c.'set_element'($I4, $I5, $I6)
    ptry = ptry + 1
    if ptry >= $I3 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(c)
  sizes_disagree:
    $P0 = new 'Undef'
    .return($P0)
.end

=item scalar_multiply()

Perform scalar multiplication of self by scalar C<c>.

TODO: At the moment, this takes an int scalar. It should take a normal
1x1 scalar Matrix value and extract the multiplier value from that.

=cut

.sub 'scalar_multiply' :method
    .param int c
    .local pmc p

    .local int ptrx
    .local int ptry

    ($I0, $I1) = self.'get_size'()

    p = new 'Matrix'
    p.'create'('product', $I0, $I1)

    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    $I4 = self.'get_element'($I2, $I3)
    $I5 = $I4 * c
    p.'set_element'($I2, $I3, $I5)
    ptry = ptry + 1
    if ptry >= $I1 goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    if ptrx >= $I0 goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(p)
.end

=item identity(INT n)

create an identity matrix of size nxn.

=cut

.sub 'identity'
    .param int n
    .param int m :optional
    .param int has_m :opt_flag
    .local pmc i

    .local int ptrx
    .local int ptry

    if has_m goto have_m
    m = n
  have_m:

    i = new 'Matrix'
    i.'create'('identity', n, m)

    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    if $I2 == $I3 goto on_diagonal
    i.'set_element'($I2, $I3, 0)
    goto done_set
  on_diagonal:
    i.'set_element'($I2, $I3, 1)
  done_set:
    ptry = ptry + 1
    if ptry >= m goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    if ptrx >= n goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(i)
.end

=item create_fill(INT n, INT m, INT d)

Create a new matrix of size nxm with every element having value d.

=cut

.sub 'create_fill'
    .param int n
    .param int m 
    .param int d
    .local pmc i

    .local int ptrx
    .local int ptry

    i = new 'Matrix'
    i.'create'('fill', n, m)

    ptrx = 0
  x_loop_top:
    ptry = 0
  y_loop_top:
    $I2 = ptrx + 1
    $I3 = ptry + 1
    i.'set_element'($I2, $I3, d)
    ptry = ptry + 1
    if ptry >= m goto y_loop_end
    goto y_loop_top
  y_loop_end:
    ptrx = ptrx + 1
    if ptrx >= n goto x_loop_end
    goto x_loop_top
  x_loop_end:
    .return(i)
.end

.sub 'zeros'
    .param int n
    .param int m :optional
    .param int has_m :opt_flag
    if has_m goto have_m
    m = n
  have_m:
    $P0 = 'create_fill'(n, m, 0)
    .return($P0)
.end

=item ones(INT n, INT m :optional)

Create a nxm matrix that contains all ones. If m is ommitted, the matrix will
be nxn.

=cut

.sub 'ones'
    .param int n
    .param int m :optional
    .param int has_m :opt_flag
    if has_m goto have_m
    m = n
  have_m:
    $P0 = 'create_fill'(n, m, 1)
    .return($P0)
.end

=item determinant()

Return the integer determinant of self

=cut

.sub 'determinant' :method
    #calculate the determinant of the matrix, using cofactor expansion
.end

=back

=cut 