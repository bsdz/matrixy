printf("1..4\n");

if getenv('PATH') != ''
    printf("ok 1\n");
else
    printf("not ok 1\n");
end

setenv('_TESTVAR', 'some data')
if getenv('_TESTVAR') == 'some data'
    printf("ok 2\n");
else
    printf("not ok 2\n");
end

setenv('_TESTVAR')
if getenv('_TESTVAR') == ''
    printf("ok 3\n");
else
    printf("not ok 3\n");
end

if getenv('__SOME__NONEXISTENT__VAR__') == ''
    printf("ok 4\n");
else
    printf("not ok 4\n");
end