function y = mtimes(A, B)
%% mtimes(A, B)
%% This function returns the matrix product of A times B
%% and is equivalent to A * B (eventually).

    M = rows(A);
    N = columns(B);
    K = columns(A);
    C = zeros(M, N);
    alpha = 1;
    beta = 0;
    lda = N;
    ldb = K;
    ldc = M;

    # could use a modifier to specify double routine for speed?
    #ret = dgemm ('N', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );
    ret = zgemm ('N', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );

    return C;

endfunction
