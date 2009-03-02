disp("1..5")

% Defined in lib/test1.m
test1()

% Defined in lib/test2.m
test2("ok 2");

% Defined in lib/test3.m
test3(1, 2);

% Defined in lib/test4.m
disp(test4());

% Defined in t/test5.m
path("t/")
test5()