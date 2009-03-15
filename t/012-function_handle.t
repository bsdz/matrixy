plan(5);

% TODO: Test taking function handles to existing functions with @

% Test anonymous function with no arguments
foo = @() 5;
if foo() == 5
    disp("ok 1");
else
    disp("not ok 1");
end

% Test an anonymous function with one argument
f = @(x) x+1;
if f(100) == 101
    disp("ok 2");
else
    disp("not ok 2");
endif

% Test anonymous function with two arguments
g = @(x, y) x*y;
if g(10,6) == 60
    disp("ok 3");
else
    disp("not ok 3");
endif

% Anonymous function with two references to the input argument
h = @(x) x*x + 1;
if h(10) == 101
    disp("ok 4");
else
    disp("not ok 4");
endif

% Anonymouse function test base case
if h(0) == 1
    disp("ok 5");
else
    disp("not ok 5");
endif
