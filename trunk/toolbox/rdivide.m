function rdivide(A,B)
%% rdivide(A, B)
%% This function returns the matrix arraywise right division of A and B.
%% Equivalent to A./B

    return arrayfun(@(x,y) x/y, A,B)

endfunction
