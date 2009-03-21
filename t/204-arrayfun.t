plan(6)

testcount = 1;

function y = f(x) y=x+1; endfunction
A = [1 2 3; 4 5 6];
B = [2,3,4; 5,6,7];

A1 = arrayfun(@(x)f(x), A);
if A1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;


A2 = arrayfun("f", A);
if A2 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;


A3 = arrayfun("f", 10);
if A3 == 11
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;


A = [1 2; 3 4];
B = [2 2; 2 2];
C = [2 4; 6 8];
D = arrayfun(@(x,y) x*y, A, B);
if C == D
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;

function y = f1(a,b,c) y = a+b+c; endfunction 

A = [1.1 2.2; 3.3 4.4];
B = [2 2; 2 2];
C = [0.01 0.002; 0.0003 0.0004];
D = [3.11 4.2020; 5.3003 6.4004];
E = arrayfun("f1", A, B, C);
if D == E
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;

# should handle scalars too
A = 3;
B = 5;
C = 15;
D = 23;
E = arrayfun("f1", A, B, C);
if D == E
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;


