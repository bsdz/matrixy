function y = transpose(A)
%% transpose(A)
%% This function returns the transpose of A and is equivalent to A.'

    # this could use a pir routine and was originally done using BLAS
    # as a simple dev case. we need to have a benchmarking utility
    # before we swap it out to ensure we don't lose an performance.

    M = columns(A);
    N = rows(A);
    K = rows(A);
    B = eye(K);
    C = zeros(M, N);
    alpha = 1;
    beta = 0;
    lda = N;
    ldb = K;
    ldc = M;

    # could use a modifier to specify double routine for speed?
    # ret = dgemm ('T', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );

    ret = zgemm ('T', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );

    return C;

endfunction
