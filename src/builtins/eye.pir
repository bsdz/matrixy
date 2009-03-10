=item eye(n)

Creates an identity matrix of dimension n.

=cut


.sub 'eye'
    .param int nargout
    .param int nargin
    .param int dim

    .local pmc a_n
    a_n = new 'ResizablePMCArray'

    .local int i,j, k
    j = -1
  next_j:
    j = j + 1
    unless j < dim goto return_array
    $P10 = new 'ResizablePMCArray'
    $P10 = dim
    push a_n, $P10
    i = -1
    next_i:
      i = i + 1
      unless i < dim goto next_j
      k = j* dim
      k = k + i
      if i == j goto set_as_one
      $N0 = 0
      goto set_element
     set_as_one:
      $N0 = 1
     set_element:
      a_n[j;i] = $N0
      goto next_i

  return_array:
    .return (a_n)

.end


