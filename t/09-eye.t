disp("1..18")

# note: we're using squaak style indexes
#       until we get M ones.

x = eye(1);
if x[0][0] == 1
    disp("ok 1");
else
    disp("not ok 1");
endif

x = eye(3);
if x[0][0] + x[1][1] + x[2][2] == 3
    disp("ok 2");
else
    disp("not ok 2");
endif

# use squaak for loop until we have M ones
testcount = 3;
x = eye(4);
for var i = 0, 3 do
    for var j = 0, 3 do
        if i == j
            if x[i][j] == 1
                printf("ok %s\n", testcount);
            else
                printf("not ok %s\n", testcount);
            end 
        else
            if x[i][j] == 0
                printf("ok %s\n", testcount);
            else
                printf("not ok %s\n", testcount);
            end
        end
        testcount = testcount + 1;
    end
end
