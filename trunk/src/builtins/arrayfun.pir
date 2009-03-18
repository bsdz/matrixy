=item arrayfun(func, A)

Apply a function 'func' to each element of an array 'A'.

=cut

.namespace ["_Matrixy";"builtins"]


.sub 'arrayfun'
    .param int nargout
    .param int nargin
    .param pmc f
    .param pmc A

    $S0 = typeof f
    if $S0 == 'Sub' goto main
    $S1 = f
    f = '!lookup_function'($S1)

    main:

    .local int rows, cols
    $P0 = '!get_matrix_sizes'(A)
    rows = $P0[0]
    cols = $P0[1]

    .local int size
    size = rows * cols

    .local pmc B
    B = new 'ResizablePMCArray'

    .local int i, j, n
    i = -1
    next_i:
        i = i + 1
        unless i < rows goto return_array
        $P0 = new 'ResizablePMCArray'
        $P0 = cols
        push B, $P0
        j = -1
        next_j:
            j = j + 1
            unless j < cols goto next_i
            $P0 = A[i;j]
            $P1 = f(1,1,$P0)
            B[i;j] = $P1
            goto next_j

  return_array:
    .return (B)

.end


