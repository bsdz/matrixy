disp("1..5")

% Defined in t/lib/test1.m
addpath('t/lib/')
test1()

% Defined in t/lib/test2.m
test2("ok 2");

% Defined in t/lib/test3.m
test3(1, 2);

% Defined in t/lib/test4.m
disp(test4());

% Defined in t/test5.m
addpath("t/")
test5()