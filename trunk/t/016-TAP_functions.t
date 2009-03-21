plan(8);

ok(1, "first");
ok(2 == 2, "second");
is(3, 3, "third");

start_todo("functions expected to fail");

ok(0, "fourth");
ok(1 == 2, "fifth");
is(3, 4, "sixth");

end_todo();

x = 1;
ok(x, "seventh");
is(x, 1, "eighth");

