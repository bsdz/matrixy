plan(4);

function argsintest(varargin)
    printf("ok %d\n", nargin);
endfunction

argsintest(5);
argsintest(6, 7);
argsintest(8, 9, 10);

function x = argsouttest()
    printf("ok %d\n", 4 + nargout);
endfunction

a = argsouttest();