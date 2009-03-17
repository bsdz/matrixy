disp("1..12");

% Test indexing into vectors
function vector_tester(a, b, c)
    if a == b
        printf("ok %d\n", c);
    else
        printf("not ok %d\n", c);
    end
endfunction

a = [1 2 3 4];
vector_tester(a(1), 1, 1);
vector_tester(a(2), 2, 2);
vector_tester(a(3), 3, 3);
vector_tester(a(4), 4, 4);

b = [1;2;3;4];
vector_tester(b(1), 1, 5);
vector_tester(b(2), 2, 6);
vector_tester(b(3), 3, 7);
vector_tester(b(4), 4, 8);

% Relational operator tests
a = [1 2 3];
b = [1 2 3];
c = [4 5 6];
if a == b
    disp("ok 9");
else
    disp("not ok 9");
end

if a == c
    disp("not ok 10");
else
    disp("ok 10");
end

if a != b
    disp("not ok 11");
else
    disp("ok 11");
end

if a != c
    disp("ok 12");
else
    disp("not ok 12");
end
