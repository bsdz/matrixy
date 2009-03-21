function times(A,B)
%% times(A, B)
%% This function returns the matrix arraywise product of A and B.
%% Equivalent to A.*B

    return arrayfun(@(x,y) x*y, A,B)

endfunction
