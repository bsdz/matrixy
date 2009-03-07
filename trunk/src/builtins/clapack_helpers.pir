=head1 DESCRIPTION

These utility functions are for transfering 
Matrixy row-major ResizablePMCArrays to the
Clapack column-major ManagedStructs and back.

Tested manually using the following code: -

    Matrixy (.M):
    ============
    A = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
    B = test(A);
    print A;
    print B;


    PIR (.pir):
    ===========
    .sub 'test'
    A1 = _matrixy_to_clapack_array(A)
    A = _clapack_to_matrixy_array(A1, 4, 4)
    .return(A)
    .sub

Running the M file above should print two identical arrays. These will
be incorporated into a unit test once inline PIR is complete.

=cut

.include 'datatypes.pasm'

.sub '_matrixy_to_clapack_array'
    .param pmc a :optional
    .param int has_a :opt_flag
    .param int xsize :optional
    .param int has_xsize :opt_flag
    .param int ysize :optional
    .param int has_ysize :opt_flag

    # should check for both params
    unless has_xsize goto discover_size
    goto construct_array

    # be very naive
  discover_size:
    xsize = a
    ysize = a[0]

  construct_array:
    .local int realsize
    realsize = xsize * ysize
    .local pmc a_rma, a_n
    a_rma = new 'ResizablePMCArray'
    push a_rma, .DATATYPE_DOUBLE
    push a_rma, realsize
    push a_rma, 0
    a_n = new 'ManagedStruct', a_rma

    unless has_a goto return_array
    
    .local int i,j, k
    j = -1
  next_j:
    j = j + 1
    unless j < ysize goto return_array
    i = -1
    next_i:
      i = i + 1
      unless i < xsize goto next_j
      k = i* xsize
      k = k + j
      $P0 = a[i;j]
      $N0 = $P0
      a_n[0;k] = $N0
      goto next_i

  return_array:
    .return (a_n)

.end

.sub '_clapack_to_matrixy_array'
    .param pmc a 
    .param int xsize
    .param int ysize

    .local int realsize
    realsize = xsize * ysize

    .local pmc a_n
    a_n = new 'ResizablePMCArray'

    
    .local int i,j, k
    j = -1
  next_j:
    j = j + 1
    unless j < ysize goto return_array
    $P10 = new 'ResizablePMCArray'
    $P10 = xsize
    push a_n, $P10
    i = -1
    next_i:
      i = i + 1
      unless i < xsize goto next_j
      k = j* xsize
      k = k + i
      $N0 = a[0;k]
      a_n[j;i] = $N0
      goto next_i

  return_array:
    .return (a_n)

.end
