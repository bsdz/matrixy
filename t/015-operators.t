plan(5);

testcount = 1

x1 = 10^2;
if x1 == 100
    printf("ok %s", testcount);
else
    printf("not ok %s", testcount);
end
testcount = testcount + 1

x2 = 10*10^2;
if x2 == 1000
    printf("ok %s", testcount);
else
    printf("not ok %s", testcount);
end
testcount = testcount + 1


x3 = 10+10^2;
if x3 == 110
    printf("ok %s", testcount);
else
    printf("not ok %s", testcount);
end
testcount = testcount + 1


x4 = 10-10^2;
if x4 == -90
    printf("ok %s", testcount);
else
    printf("not ok %s", testcount);
end
testcount = testcount + 1

x5 = 2^3^4;
if x5 == 4096
    printf("ok %s", testcount);
else
    printf("not ok %s", testcount);
end
testcount = testcount + 1