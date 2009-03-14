

.namespace ['_Matrixy';'builtins']

.include 'library/dumper.pir'

.sub 'dgesvd'
    .param int nargout
    .param int nargin
    .param pmc jobu
    .param pmc jobvt
    .param pmc m
    .param pmc n
    .param pmc a
    .param pmc lda
    .param pmc s
    .param pmc u
    .param pmc ldu
    .param pmc vt
    .param pmc ldvt
    .param pmc work
    .param pmc lwork
    .param pmc info

    load_bytecode 'extern/pbc/clapack.pbc'

    $P0 = get_hll_global ['clapack';'RAW'], 'dgesvd'
    $I0 = defined $P0
    if $I0 goto do_fn

    print 'cannot find dgesvd!'
    .return ()

  do_fn:
    .local pmc u1, vt1, a1, s1, work1
    u1 = _matrixy_to_clapack_array(u)
    vt1 = _matrixy_to_clapack_array(vt)
    a1 = _matrixy_to_clapack_array(a)
    s1 = _matrixy_to_clapack_array(s)
    work1 = _matrixy_to_clapack_array(work)

    #.local pmc stdin
    #stdin= getstdin
    #$S0 = readline stdin

    $I1 = $P0(jobu,jobvt,m,n,a1,lda,s1,u1,ldu,vt1,ldvt,work1,lwork,info)
    a = _clapack_to_matrixy_array(a1, 4, 4)
    say $I1

    .return(a)

.end

.namespace []

