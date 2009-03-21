plan(5);

testcount = 1;

x1 = 1;
x2 = [ 1 ];
x3 = [ 1 1 ];
x4 = [ 1; 1];
x5 = ones(2,3);

if isscalar(x1)
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

if isscalar(x2)
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

if isscalar(x3) == 0
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

if isscalar(x4) == 0
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

if isscalar(x5) == 0
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;
