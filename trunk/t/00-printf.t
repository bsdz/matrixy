printf("1..7\n");

% Basic sanity test
printf("ok 1\n");

disp("ok 2");

% Tests for arguments
printf("ok %s\n", 3);

printf("ok %s\n", 3 + 1);

printf("%s %s\n", "ok", 3 + 2);

% Call to printf without a trailing semicolon
printf("ok 6\n")

disp("ok 7");