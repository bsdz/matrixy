


.namespace ['_Matrixy';'builtins']

.include 'library/dumper.pir'

.sub 'dgemm'
  .param pmc transA
  .param pmc transB
  .param pmc M
  .param pmc N
  .param pmc K
  .param pmc alpha
  .param pmc A
  .param pmc lda
  .param pmc B
  .param pmc ldb
  .param pmc beta
  .param pmc C
  .param pmc ldc

    load_bytecode 'extern/pbc/blas.pbc'

    $P0 = get_hll_global ['blas';'RAW'], 'dgemm'
    $I0 = defined $P0
    if $I0 goto do_fn

    print 'cannot find dgemm!'
    .return ()

  do_fn:
    .local pmc A1, B1, C1
    A1 = _matrixy_to_clapack_array(A)
    B1 = _matrixy_to_clapack_array(B)
    C1 = _matrixy_to_clapack_array(C)

    #.local pmc stdin
    #stdin= getstdin
    #$S0 = readline stdin

    $I1 = $P0(transA,transB,M,N,K,alpha,A1,lda,B1,ldb,beta,C1,ldc)
    C = _clapack_to_matrixy_array(C1, 4, 4)
    say $I1

    .return(C)

.end

.sub 'transpose'
    .local pmc A

    load_bytecode 'extern/pbc/blas.pbc'

    $P0 = get_hll_global ['blas';'RAW'], 'dgemm'
    $I0 = defined $P0
    if $I0 goto do_fn

    print 'cannot find dgemm!'
    .return ()

  do_fn:
    .local pmc A1, B1, C1
    A1 = _matrixy_to_clapack_array(A)
    #B1 = _matrixy_to_clapack_array(B)
    #C1 = _matrixy_to_clapack_array(C)

    #$I1 = $P0(transA,transB,M,N,K,alpha,A1,lda,B1,ldb,beta,C1,ldc)
    A = _clapack_to_matrixy_array(A1, 4, 4)

    .return(A)


.end


.namespace []



