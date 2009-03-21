

.namespace ['_Matrixy';'builtins']

.include 'library/dumper.pir'

.sub 'dgetri'
    .param int nargout
    .param int nargin
    .param int N
    .param pmc A
    .param int lda
    .param pmc IPIV
    .param pmc WORK
    .param num lwork
    .param pmc info

    .local string error_message

    load_bytecode 'extern/pbc/clapack.pbc'

    $P0 = get_hll_global ['clapack';'RAW'], 'dgetri'
    $I0 = defined $P0
    if $I0 goto do_fn
    error_message =  'cannot find clapack::RAW::dgetri!'
    goto fail


  do_fn:
    .local pmc A1, IPIV1, WORK1
    A1 = '!matrixy_to_fortran_array'(A)
    IPIV1 = '!matrixy_to_fortran_array'(IPIV, 'Integer')
    WORK1 = '!matrixy_to_fortran_array'(WORK)

    $I0 = $P0(N,A1,lda,IPIV1,WORK1,lwork,info)

  success:
    A1 = '!fortran_to_matrixy_array'(A1, N, N)
    setref A, A1

    WORK1 = '!fortran_to_matrixy_array'(WORK1, lwork, 1)
    setref WORK, WORK1

    setref info, info

    .return($I0)

  fail:
    printerr error_message
    .return()

.end


.sub 'dgetrf'
    .param int nargout
    .param int nargin
    .param int M
    .param pmc N
    .param pmc A
    .param int lda
    .param pmc IPIV
    .param pmc info

    .local string error_message

    load_bytecode 'extern/pbc/clapack.pbc'

    $P0 = get_hll_global ['clapack';'RAW'], 'dgetrf'
    $I0 = defined $P0
    if $I0 goto do_fn
    error_message =  'cannot find clapack::RAW::dgetrf!'
    goto fail


  do_fn:
    .local pmc A1, IPIV1
    .local int IPIV_dim
    IPIV_dim = '!min'(M, N)

    A1 = '!matrixy_to_fortran_array'(A)
    IPIV1 = '!matrixy_to_fortran_array'(IPIV, 'Integer')

    $I0 = $P0(M,N,A1,lda,IPIV1,info)

  success:
    A1 = '!fortran_to_matrixy_array'(A1, M, N)
    setref A, A1

    IPIV1 = '!fortran_to_matrixy_array'(IPIV1, IPIV_dim, 1, 'Integer')
    setref IPIV, IPIV1

    setref info, info

    .return($I0)

  fail:
    printerr error_message
    .return()

.end

.namespace []



