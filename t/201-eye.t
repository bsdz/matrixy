plan(3);

X1 = eye(1);
Y1 = [1];

% Test that eye(1) does what we think it should
if isequal(X1, Y1) == 1
    disp("ok 1");
else
    disp("not ok 1");
endif

% Test that eye(3) does what we think it does
X2 = eye(3);
Y2 = [1,0,0;0,1,0;0,0,1];
if isequal(X2, Y2) == 1
    disp("ok 2");
else
    disp("not ok 2");
endif

% Test eye(4)
X3 = eye(4);
Y3 = [1,0,0,0;0,1,0,0;0,0,1,0;0,0,0,1];
if isequal(X3, Y3) == 1
    disp("ok 3");
else
    disp("not ok 3");
endif
