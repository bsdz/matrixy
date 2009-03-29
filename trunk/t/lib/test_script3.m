% Test that if there is a function declaration here, we call that instead of
% other stuff in the file

printf("not ok 14\n");

function test_script3()
    printf("ok 14\n");
endfunction
