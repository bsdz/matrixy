disp("1..19");

% First, test that we can index a matrix like a vector using the same semantics
% as Octave has
function matrix_tester1(a, b, c)
    if a(b) == c
        printf("ok %d\n", b);
    else
        printf("not ok %d\n", b);
    end
endfunction

foo = [1 2 3;4 5 6];
matrix_tester1(foo, 1, 1);
matrix_tester1(foo, 2, 4);
matrix_tester1(foo, 3, 2);
matrix_tester1(foo, 4, 5);
matrix_tester1(foo, 5, 3);
matrix_tester1(foo, 6, 6);

% Test that we can index matrices using matrix indices
function matrix_tester2(a, b)
    if a == b
        printf("ok %d\n", b + 6);
    else
        printf("not ok %d\n", b + 6);
    end
endfunction

bar = [1 2 3;4 5 6;7 8 9];
matrix_tester2(bar(1, 1), 1);
matrix_tester2(bar(1, 2), 2);
matrix_tester2(bar(1, 3), 3);
matrix_tester2(bar(2, 1), 4);
matrix_tester2(bar(2, 2), 5);
matrix_tester2(bar(2, 3), 6);
matrix_tester2(bar(3, 1), 7);
matrix_tester2(bar(3, 2), 8);
matrix_tester2(bar(3, 3), 9);

% Relational operator tests
a = [1 2 3;4 5 6];
b = [1 2 3;4 5 6];
c = [4 5 6;7 8 9];
if a == b
    disp("ok 16");
else
    disp("not ok 16");
end

if a == c
    disp("not ok 17");
else
    disp("ok 17");
end

if a != b
    disp("not ok 18");
else
    disp("ok 18");
end

if a != c
    disp("ok 19");
else
    disp("not ok 19");
end