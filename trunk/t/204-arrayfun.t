plan(3)

function y = f(x) y=x+1; endfunction
A = [1 2 3; 4 5 6];
B = [2,3,4; 5,6,7];

A1 = arrayfun(@(x)f(x), A);
if A1 == B
    disp("ok 1");
else
    disp("not ok 1");
end

A2 = arrayfun("f", A);
if A2 == B
    disp("ok 2");
else
    disp("not ok 2");
end

A3 = arrayfun("f", 10);
if A3 == 11
    disp("ok 3");
else
    disp("not ok 3");
end
