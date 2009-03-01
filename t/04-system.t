!echo "1..5"

!echo "ok 1"

!echo "ok 2"

system("echo ok 3")

pir(".sub _tempa\nsay 'ok 4'\n.end")

pir(".sub _tempb\n.param string a\nsay a\n.end", "ok 5")
