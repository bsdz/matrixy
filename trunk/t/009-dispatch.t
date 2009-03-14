plan(11);

% Dispatch to a function with no args and no returns
% Defined in t/lib/test1.m
addpath('t/lib/')
test1()

% Dispatch to a funtion with 1 arg but no returns
% Defined in t/lib/test2.m
test2("ok 2");

% Dispatch to a function with two args and no returns
% Defined in t/lib/test3.m
test3(1, 2);

% Dispatch to a function with no args but one return value
% Defined in t/lib/test4.m
disp(test4());

% Dispatch to a function in a different folder
% Defined in t/test5.m
addpath("t/")
test5();

% feval with a builtin function
feval('disp', 'ok 6');
feval('disp', ['ok ', '7']);
feval('feval', 'disp', 'ok 8');
feval(['disp'], 'ok 9');

% Show that variables overshadow functions of the same name:
disp = [10, 11];

if disp(1) == 10
    printf("ok 10\n");
else
    printf("not ok 10\n");
end

% Show that we can still feval a function if we've overridden it with a variable
% of the same name
feval('disp', "ok 11");
