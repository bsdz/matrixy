plan(30);

x = zeros(1, 1);
if x(1, 1) == 0
    disp("ok 1");
else
    disp("not ok 1");
endif

x = zeros(3, 3);
if x(1, 1) + x(2, 2) + x(3, 3) == 0
    disp("ok 2");
else
    disp("not ok 2");
endif

# use squaak for loop until we have M ones
testcount = 3;
x = zeros(4, 7);
for var i = 1, 4 do
    for var j = 1, 7 do
        if x(i, j) == 0
            printf("ok %s\n", testcount);
        else
            printf("not ok %s\n", testcount);
        end 
        testcount = testcount + 1;
    end
end
