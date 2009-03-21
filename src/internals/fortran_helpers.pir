=head1 DESCRIPTION

These utility functions are for transfering 
Matrixy row-major ResizablePMCArrays to the
Fortran/Clapack column-major ManagedStructs and back.

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
    A1 = '!matrixy_to_fortran_array'(A)
    A = '!clapack_to_fortran_array'(A1, 4, 4)
    .return(A)
    .sub

Running the M file above should print two identical arrays. These will
be incorporated into a unit test once inline PIR is complete.

=cut

.namespace ['_Matrixy';'builtins']

.include 'datatypes.pasm'

.sub '_test_fortran_array_conversions'
    .param int nargout
    .param int nargin
    .param pmc A

    .local int rows, cols
    .local pmc B, C
    rows = 'rows'(1,1,A)
    cols = 'columns'(1,1,A)
    B = '!matrixy_to_fortran_array'(A)
    C = '!fortran_to_matrixy_array'(B, rows, cols)

    .local int i, j
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto success
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i
            $P0 = A[i;j]
            $P1 = C[i;j]
            #$N0 = $P0
            #N1 = $P1
            #if $N0 != $N1 goto failure
            if $P0 != $P1 goto failure
            goto next_j

  success:
    .return(1)

  failure:
    .return(0)

.end

.namespace []

.macro say_indexes(i, j, n, v)
    $P100 = new 'ResizablePMCArray'
    push $P100, .i
    push $P100, .j
    push $P100, .n
    push $P100, .v
    $S100 = sprintf "(%s,%s) -> %s = %s", $P100
    say $S100
.endm

.sub '!matrixy_to_fortran_array'
    .param pmc a 
    .param string type :optional
    .param int has_type :opt_flag

    unless has_type goto set_type_float
    if type == 'Integer' goto set_type_int 
    if type == 'Float' goto set_type_float 

    set_type_int:
        $P1 = '!matrixy_to_fortran_array_int'(a)
        .return ($P1)

    set_type_float:
        $P1 = '!matrixy_to_fortran_array_float'(a)
        .return ($P1)
.end

.sub '!fortran_to_matrixy_array'
    .param pmc a 
    .param int rows
    .param int cols
    .param string type :optional
    .param int has_type :opt_flag

    unless has_type goto set_type_float
    if type == 'Integer' goto set_type_int 
    if type == 'Float' goto set_type_float 

    set_type_int:
        $P1 = '!fortran_to_matrixy_array_int'(a, rows, cols)
        .return ($P1)

    set_type_float:
        $P1 = '!fortran_to_matrixy_array_float'(a, rows, cols)
        .return ($P1)
.end

# float array conversion

.sub '!matrixy_to_fortran_array_float'
    .param pmc a 

    .local int rows, cols
    $P0 = '!get_matrix_sizes'(a)
    rows = $P0[0]
    cols = $P0[1]

    .local int size
    size = rows * cols

    .local pmc a_rma, a_n
    a_rma = new 'ResizablePMCArray'
    push a_rma, .DATATYPE_DOUBLE
    push a_rma, size
    push a_rma, 0

    a_n = new 'ManagedStruct', a_rma

    #say 'matrixy -> fortran'

    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto return_array
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i
            n = j * rows
            n = n + i
            $P0 = a[i;j]
            $N0 = $P0
            #.say_indexes(i, j, n, $N0)
            a_n[0;n] = $N0
            goto next_j

  return_array:
    .return (a_n)

.end

.sub '!fortran_to_matrixy_array_float'
    .param pmc a 
    .param int rows
    .param int cols

    .local int size
    size = rows * cols

    .local pmc A
    A = new 'ResizablePMCArray'

    #say 'fortran -> matrixy'
    
    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto return_array
        $P0 = new 'ResizablePMCArray'
        $P0 = cols
        push A, $P0
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i
            n = j * rows
            n = n + i
            $N0 = a[0;n]
            #.say_indexes(i, j, n, $N0)
            A[i;j] = $N0
            goto next_j

  return_array:
    .return (A)

.end



# int array conversion

.sub '!matrixy_to_fortran_array_int'
    .param pmc a 

    .local int rows, cols
    $P0 = '!get_matrix_sizes'(a)
    rows = $P0[0]
    cols = $P0[1]

    .local int size
    size = rows * cols

    .local pmc a_rma, a_n
    a_rma = new 'ResizablePMCArray'
    push a_rma, .DATATYPE_INT
    push a_rma, size
    push a_rma, 0

    a_n = new 'ManagedStruct', a_rma

    #say 'matrixy -> fortran'

    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto return_array
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i
            n = j * rows
            n = n + i
            $P0 = a[i;j]
            $I0 = $P0
            #.say_indexes(i, j, n, $I0)
            a_n[0;n] = $I0
            goto next_j

  return_array:
    .return (a_n)

.end

.sub '!fortran_to_matrixy_array_int'
    .param pmc a 
    .param int rows
    .param int cols

    .local int size
    size = rows * cols

    .local pmc A
    A = new 'ResizablePMCArray'

    #say 'fortran -> matrixy'
    
    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto return_array
        $P0 = new 'ResizablePMCArray'
        $P0 = cols
        push A, $P0
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i
            n = j * rows
            n = n + i
            $I0 = a[0;n]
            #.say_indexes(i, j, n, $I0)
            A[i;j] = $I0
            goto next_j

  return_array:
    .return (A)

.end


