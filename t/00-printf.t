printf("1..5\n");

% Basic sanity test
printf("ok 1\n");

% Tests for arguments
printf("ok %s\n", 2);

printf("ok %s\n", 2 + 1);

printf("%s %s\n", "ok", 2 + 2);

% Call to printf without a trailing semicolon
printf("ok 5\n")