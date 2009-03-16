disp("1..39")

# note: we're using squaak style indexes
#       until we get M ones.

testcount = 1;

# test transpose of square matrix
A = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
AT = [1, 5, 9, 13; 2, 6, 10, 14; 3, 7, 11, 15; 4, 8, 12, 16];

B = transpose(A);

#disp(B);
#disp(AT);

ATc = columns(AT);
ATr = rows(AT);

Bc = columns(B);
Br = rows(B);

if ATr == Br
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end

testcount = testcount + 1;

if ATc == Bc
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end

testcount = testcount + 1;

# for some bizzare reason for loops break here!
i = 0;
j = 0;
while i <= ATr do
    while j <= ATc do
        if AT[i][j] == B[i][j]
            printf("ok %s\n", testcount);
        else
            printf("not ok %s\n", testcount);
        end 
        testcount = testcount + 1;
        j = j + 1;
    end
    i = i + 1;
end


# test transpose of non square matrix
A1 = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16; 17, 18, 19, 20];
A_T = [1, 5, 9, 13, 17; 2, 6, 10, 14, 18; 3, 7, 11, 15, 19; 4, 8, 12, 16, 20];

B = transpose(A1);

#disp(B);
#disp(A_T);


if rows(A_T) == rows(B)
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end

testcount = testcount + 1;

if columns(A_T) == columns(B)
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end
    
testcount = testcount + 1;

for var i = 0, rows(A_T) do
    for var j = 0, columns(A_T) do
        if A_T[i][j] == B[i][j]
            printf("ok %s\n", testcount);
        else
            printf("not ok %s\n", testcount);
        end 
        testcount = testcount + 1;
    end
end
