plan(14);

% sanity checks

1 + i;
disp("ok 1")

1.0 + i;
disp("ok 2")

2.0 + 10j;
disp("ok 3")

20 + 5.5i;
disp("ok 4")

31.5 - 20.7j;
disp("ok 5")

if parrot_typeof(1 + 2i) == "Complex"
    disp("ok 6");
else
    disp("not ok 6");
end

if parrot_typeof(1 + 2j) == "Complex"
    disp("ok 7");
else
    disp("not ok 7");
end

if 1 + 2i + 4 == 5+2i
    disp("ok 8")
else 
    disp("not ok 8")
end

if 1+2i == 1+2i
    disp("ok 9")
else 
    disp("not ok 9")
end

if 1 + 2i + 4 +3j == 5+5i
    disp("ok 10")
else 
    disp("not ok 10")
end


if (1+2j)*(2+3j) == -4+7i
    disp("ok 11")
else 
    disp("not ok 11")
end

if sprintf("%s", 1+2i) == "1+2i"
    disp("ok 12")
else 
    disp("not ok 12")
end

if sprintf("%s", 20+5.5i) == "20+5.5i"
    disp("ok 13")
else 
    disp("not ok 13")
end

if 1+2i == 10
    disp("not ok 14")
else 
    disp("ok 14")
end
