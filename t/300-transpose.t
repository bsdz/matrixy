disp("1..2")

testcount = 1;

# test transpose of square matrix
A1 = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
A1T = [1, 5, 9, 13; 2, 6, 10, 14; 3, 7, 11, 15; 4, 8, 12, 16];

B1 = transpose(A1);

if B1 == A1T
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


# test transpose of non square matrix
A2 = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16; 17, 18, 19, 20];
A2T = [1, 5, 9, 13, 17; 2, 6, 10, 14, 18; 3, 7, 11, 15, 19; 4, 8, 12, 16, 20];

B2 = transpose(A2);

if B2 == A2T
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;
