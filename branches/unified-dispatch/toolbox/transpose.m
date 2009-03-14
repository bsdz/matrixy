function y = transpose(A)
%% transpose(A)
%% This function returns the transpose of A and is
%% equivalent to A' (eventually).

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

    ret = dgemm ('T', 'N', M, N, K, alpha, A, lda, B, ldb, beta, C, ldc );

    return C;

endfunction
