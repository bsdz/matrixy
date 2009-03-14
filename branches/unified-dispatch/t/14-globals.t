plan(3);
global a;

% foo uses global variable a
function foo()
    global a;
    printf("ok %d\n", a);
endfunction

% bar uses local variable a, which should not be confused with the global one
function bar(a)
    printf("ok %d\n", a);
endfunction

a = 1;
foo();
a = 2;
foo();
bar(3);