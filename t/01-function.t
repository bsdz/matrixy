printf("1..5\n");

function bar
    printf("ok 1\n");
end
bar();


function foo(x)
    printf(x);
end
foo("ok 2\n");


function foo2(x)
    printf(x);
endfunction
foo2("ok 3\n");


function y = foo3(x)
    printf("%s\n", x);
end
foo3("ok 4\n");


function y = foo4(x)
    y = 5;
    r = 100;
end
myret = foo4("dummy");
if myret == 5
    printf("ok 5\n");
else
    printf("not ok 5\n");
endif
