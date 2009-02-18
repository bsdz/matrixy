
=head1 Mathematical Builtins

=head2 About

The functions in this file, F<src/builtins/math.pir> are
functions for performing basic mathematical computations. 
These functions do not operate on matrices, only scalars 
(integers and floating point numbers) functions that operate 
on matrices should be included in F<src/classes/Matrix.pir>
or should be written somewhere else and included later.

Eventually, most of the functions here will be moved into 
the appropriate class files (Matrix.pir, Scalar.pir, etc).

=head2 Functions

=cut

.namespace

=head3 sum(PMC args :slurpy)

this is a simple proof-of-concept function that returns
the sum of a list of numbers. I don't think this is even
a canonical MATLAB function, so it will probably get deleted
eventually.

=cut

.sub 'sum'
	.param pmc args :slurpy
	.local pmc iter
	iter = new 'Iterator', args
	$N0 = 0.0
  loop_top:
	unless iter goto loop_end
	$N1 = shift iter
	$N0 = $N0 + $N1
	goto loop_top
  loop_end:
    .return($N0)
.end

=head3 pi()

Returns the value of PI to as many decimal places as I can
remember off the top of my head.

=cut

.sub 'pi'
	.return(3.1415926535898)
.end

.sub 'infix:+'
.end

.sub 'infix:-'
.end

.sub 'prefix:-'
.end

.sub 'infix:*'
.end

.sub 'infix:/'
.end

.sub 'infix:<'
    .param pmc a
    .param pmc b
    islt $I0, a, b
    .return ($I0)
.end


.sub 'infix:<='
    .param pmc a
    .param pmc b
    isle $I0, a, b
    .return ($I0)
.end

.sub 'infix:>'
    .param pmc a
    .param pmc b
    isgt $I0, a, b
    .return ($I0)
.end

.sub 'infix:>='
    .param pmc a
    .param pmc b
    isge $I0, a, b
    .return ($I0)
.end

.sub 'infix:=='
    .param pmc a
    .param pmc b
    iseq $I0, a, b
    .return ($I0)
.end

.sub 'infix:!='
    .param pmc a
    .param pmc b
    isne $I0, a, b
    .return ($I0)
.end
