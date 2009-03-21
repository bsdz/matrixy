plan(3);

x = ones(1, 1);
if x(1, 1) == 1
    disp("ok 1");
else
    disp("not ok 1");
endif

x = ones(3, 3);
if x(1, 1) + x(2, 2) + x(3, 3) == 3
    disp("ok 2");
else
    disp("not ok 2");
endif

testcount = 3;
x = ones(4, 7);
y = [ 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1; 1 1 1 1 1 1 1 ];
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
