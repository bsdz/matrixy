disp("1..30")

# note: we're using squaak style indexes
#       until we get M ones.

x = zeros(1, 1);
if x(0, 0) == 0
    disp("ok 1");
else
    disp("not ok 1");
endif

x = zeros(3, 2);
if x(0, 0) + x(1, 1) + x(2, 2) == 0
    disp("ok 2");
else
    disp("not ok 2");
endif

# use squaak for loop until we have M ones
testcount = 3;
x = zeros(4, 7);
for var i = 0, 3 do
    for var j = 0, 6 do
        if x(i, j) == 0
            printf("ok %s\n", testcount);
        else
            printf("not ok %s\n", testcount);
        end 
        testcount = testcount + 1;
    end
end
