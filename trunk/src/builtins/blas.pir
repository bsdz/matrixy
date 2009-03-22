


.namespace ['_Matrixy';'builtins']

.include 'library/dumper.pir'

.sub 'dgemm'
    .param int nargout
    .param int nargin
    .param pmc transA
    .param pmc transB
    .param int M
    .param int N
    .param int K
    .param num alpha
    .param pmc A
    .param int lda
    .param pmc B
    .param int ldb
    .param num beta
    .param pmc C
    .param int ldc

    .local string error_message

    load_bytecode 'extern/pbc/cblas.pbc'

    $P0 = get_hll_global ['cblas';'RAW'], 'dgemm'
    $I0 = defined $P0
    if $I0 goto do_fn
    error_message =  'cannot find cblas::RAW::dgemm!'
    goto fail


  do_fn:
    .local pmc A1, B1, C1
    A1 = '!matrixy_to_fortran_array'(A)
    B1 = '!matrixy_to_fortran_array'(B)
    C1 = '!matrixy_to_fortran_array'(C)

    $I0 = $P0(transA,transB,M,N,K,alpha,A1,lda,B1,ldb,beta,C1,ldc)

  success:
    C1 = '!fortran_to_matrixy_array'(C1, M, N)
    setref C, C1
    .return($I0)

  fail:
    printerr error_message
    .return()

.end


.sub 'zgemm'
    .param int nargout
    .param int nargin
    .param pmc transA
    .param pmc transB
    .param int M
    .param int N
    .param int K
    .param num alpha
    .param pmc A
    .param int lda
    .param pmc B
    .param int ldb
    .param num beta
    .param pmc C
    .param int ldc

    .local string error_message

    load_bytecode 'extern/pbc/cblas.pbc'

    $P0 = get_hll_global ['cblas';'RAW'], 'zgemm'
    $I0 = defined $P0
    if $I0 goto do_fn
    error_message =  'cannot find cblas::RAW::zgemm!'
    goto fail


  do_fn:
    .local pmc A1, B1, C1, alpha1, beta1
    A1 = '!matrixy_to_fortran_array'(A, 'Complex')
    B1 = '!matrixy_to_fortran_array'(B, 'Complex')
    C1 = '!matrixy_to_fortran_array'(C, 'Complex')
    alpha1 = '!matrixy_to_fortran_array'(alpha, 'Complex')
    beta1 = '!matrixy_to_fortran_array'(beta, 'Complex')

    $I0 = $P0(transA,transB,M,N,K,alpha1,A1,lda,B1,ldb,beta1,C1,ldc)

  success:
    C1 = '!fortran_to_matrixy_array'(C1, M, N, 'Complex')
    setref C, C1
    .return($I0)

  fail:
    printerr error_message
    .return()

.end

.namespace []




