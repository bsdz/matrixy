plan(4);

A = [1, 2, 3, 4; 5, 6, 7, 8];
ret = _test_fortran_array_conversions(A);
ok(ret, "_test_fortran_array_conversions() 1");

A = [1, 2, 3, 4; 5, 6, 7, 8; 9, 10, 11, 12; 13, 14, 15, 16];
ret = _test_fortran_array_conversions(A);
ok(ret, "_test_fortran_array_conversions() 2");

A = zeros(10,3);
ret = _test_fortran_array_conversions(A);
ok(ret, "_test_fortran_array_conversions() 3");

A = eye(10);
ret = _test_fortran_array_conversions(A);
ok(ret, "_test_fortran_array_conversions() 4");
