disp("1..6")

testcount = 1;

A1 = [1,2;3,4];
B1 = [5,6;7,8];
if isequal(A1, B1) == 0
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;
    

A2 = [1,2;3,4;5,6];
B2 = [1,2;3,4;5,6];
if isequal(A2, B2) == 1
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;

A3 = [1,2;3,4;5,6];
B3 = [1,2;3,4;5,6];
C3 = [1,2;3,4;5,6];
if isequal(A3, B3, C3) == 1
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;

A4 = [1,2;3,4;5,6];
B4 = [1,2;0,0;5,6];
C4 = [1,2;3,4;5,6];
if isequal(A4, B4, C4) == 0
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;

A5 = [1,2;3,4;5,6;7,8];
B5 = [1,2;3,4;5,6];
C5 = [1,2;3,4;5,6];
if isequal(A5, B5, C5) == 0
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;

A6 = [1,2;5,6;7,8];
B6 = [1,2;5,6];
if isequal(A6, B6) == 0
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
testcount = testcount + 1;
