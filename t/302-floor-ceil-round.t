disp("1..7")

testcount = 1;


A = [2.3 4.5; 6.7 8.9];
B = [2 4; 6 8];
B1 = floor(A);
if B1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


A = 10.2;
B = 10;
B1 = floor(A);
if B1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


A = [2.3 4.5; 6.7 8.9];
B = [3 5; 7 9];
B1 = ceil(A);
if B1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


A = 20.3;
B = 21;
B1 = ceil(A);
if B1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


A = [2.3 4.5; 4.49 9.51];
B = [2 5; 4 10];
B1 = round(A);
if B1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


A = 10.49;
B = 10;
B1 = round(A);
if B1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;



A = 10.50;
B = 11;
B1 = round(A);
if B1 == B
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


