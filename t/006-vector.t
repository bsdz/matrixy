disp("1..8");

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
