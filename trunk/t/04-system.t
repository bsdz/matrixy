disp("1..9")

% System shell tests
if getenv('WINDIR') != ''
    % Windows tests
    system("cmd /c echo ok 1");
    system(["cmd /c echo ok 2"]);
    !cmd /c echo ok 3
else
    % Non-windows tests
    system("echo ok 1");
    system(["echo ok 2"]);
    !echo "ok 3"
end

% Parrot tests
pir(".sub _tempa\nsay 'ok 4'\n.end")
pir(".sub _tempb\n.param string a\nsay a\n.end", "ok 5")

if parrot_typeof(1) == "Integer"
    disp("ok 6");
else
    disp("not ok 6");
end

if parrot_typeof(1.2) == "Float"
    disp("ok 7")
else
    disp("not ok 7")
end

if parrot_typeof("hello") == "String"
    disp("ok 8")
else
    disp("not ok 8")
end

if parrot_typeof([1 2]) == "ResizablePMCArray"
    disp("ok 9")
else
    disp("not ok 9")
end



