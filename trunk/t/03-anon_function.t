printf("1..4\n");

f = @(x) x+1;
if f(100) == 101 
    printf("ok 1\n");
else
    printf("not ok 1\n");
endif


g = @(x, y) x*y;
if g(10,6) == 60
    printf("ok 2\n");
else
    printf("not ok 2\n");
endif


h = @(x) x*x + 1;
if h(10) == 101
    printf("ok 3\n");
else
    printf("not ok 3\n");
endif

if h(0) == 1
    printf("ok 4\n");
else
    printf("not ok 4\n");
endif
