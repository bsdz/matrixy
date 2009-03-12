plan(2);

testcount = 1;

A1 = [1,2;3,4];
B1 = [5,6;7,8];
C1 = [19,22;43,50];
D1 = mtimes(A1, B1);
if isequal(C1, D1) == 1
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;

A2 = [1,2;3,4;5,6];
B2 = [7,8,9;10,11,12];
C2 = [27,30,33;61,68,75;95,106,117];
D2 = mtimes(A2, B2);
if isequal(C2, D2) == 1
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;
