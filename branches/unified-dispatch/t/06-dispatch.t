plan(9);

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
test5();

% feval with a builtin function
feval('disp', 'ok 6');
feval('disp', ['ok ', '7']);
feval('feval', 'disp', 'ok 8');
feval(['disp'], 'ok 9');