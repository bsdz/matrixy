plan(3);

a = sprintf("%d", 5);
if a == "5"
    disp("ok 1");
else
    disp("not ok 1");
end

a = sprintf("%s world", "hello");
if a == "hello world"
    disp("ok 2");
else
    disp("not ok 2");
end

a = sprintf("%.2f", 123.456789);
if a == "123.46"
    disp("ok 3");
else
    disp("not ok 3");
end