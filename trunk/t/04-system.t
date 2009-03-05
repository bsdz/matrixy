disp("1..4")

pir(".sub _tempa\nsay 'ok 1'\n.end")

pir(".sub _tempb\n.param string a\nsay a\n.end", "ok 2")

if getenv('WINDIR') != ''
    system("cmd /c echo ok 3");
    system("cmd /c echo ok 4");
    quit();
end

system("echo ok 3")
!echo "ok 4"
