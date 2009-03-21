disp("1..24")

testcount = 1;

a = 123;
b = 789;
A = [4 25; 9 16]; 
B = [1 2; 3 4];

# plus
#
X = [5 27; 12 20];
Y = plus(A,B);
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

Y = A + B;
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


x = 912;
y = plus(a,b);
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

y = a + b;
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


# minus
#
X = [3 23; 6 12];
Y = minus(A,B);
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

Y = A-B;
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


x = -666;
y = minus(a,b);
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

y = a-b;
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


# times
#
X = [4 50; 27 64];
Y = times(A,B);
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

Y = A.*B;
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


x = 97047;
y = times(a,b);
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

y = a.*b;
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


# rdivide
#
X = [4.0 12.5; 3.0 4.0];
Y = rdivide(A, B);
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


Y = A./B;
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


x = 4;
y = rdivide(20, 5);
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

y = 20./5;
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;



# ldivide
#
m100 = [100 100; 100 100];
X = [0.25 0.08; 0.333333 0.25];
Y = ldivide(A, B);
if floor(times(X, m100)) == floor(times(Y, m100))
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

# TODO: syntax error currently
printf("not ok %s # TODO\n", testcount);
#Y = A.\B;
#if floor(times(X, m100)) == floor(times(Y, m100))
#    printf("ok %s\n", testcount);
#else
#    printf("not ok %s\n", testcount);
#end 
testcount = testcount + 1;


x = 9;
y = ldivide(3, 27);
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

# TODO: syntax error currently
printf("not ok %s # TODO\n", testcount);
#y = 3.\27;
#if x == y
#    printf("ok %s\n", testcount);
#else
#    printf("not ok %s\n", testcount);
#end 
testcount = testcount + 1;



# power
#
X = [4 625; 729 65536];
Y = power(A, B);
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

Y = A.^B;
if X == Y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


x = 15129;
y = power(a, 2);
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;


y = a.^2;
if x == y
    printf("ok %s\n", testcount);
else
    printf("not ok %s\n", testcount);
end 
testcount = testcount + 1;

