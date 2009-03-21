.namespace []

=head1 Matrix-Aware Operators

These operators properly act on matrix arguments.

=cut

.sub 'infix:=='
    .param pmc a
    .param pmc b
    $S0 = typeof a
    if $S0 == 'ResizablePMCArray' goto compare_matrices
    $S1 = typeof b
    if $S1 == 'ResizablePMCArray' goto compare_matrices
    iseq $I0, a, b
    .return ($I0)
  compare_matrices:
    $P0 = get_hll_global ['_Matrixy';'builtins'], 'isequal'
    $I0 = $P0(1, 2, a, b)
    .return ($I0)
.end

.sub 'infix:!='
    .param pmc a
    .param pmc b
    $S0 = typeof a
    if $S0 == 'ResizablePMCArray' goto compare_matrices
    $S1 = typeof b
    if $S1 == 'ResizablePMCArray' goto compare_matrices
    isne $I0, a, b
    .return ($I0)
  compare_matrices:
    $P0 = get_hll_global ['_Matrixy';'builtins'], 'isequal'
    $I0 = $P0(1, 2, a, b)
    $I0 = not $I0
    .return($I0)
.end

# TODO: would linking to M file slow these down?
# leave until proper benchmarking function exists.
.sub 'infix:+'
    .param pmc a
    .param pmc b

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = add a, b
    .return($P0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end


.sub 'infix:-'
    .param pmc a
    .param pmc b

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = sub a, b
    .return($P0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end

.sub 'infix:.^'
    .param pmc a
    .param pmc b

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = pow a, b
    .return($P0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end


.sub 'infix:.*'
    .param pmc a
    .param pmc b

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = mul a, b
    .return($P0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end

.sub 'infix:./'
    .param pmc a
    .param pmc b

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = div a, b
    .return($P0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end


.sub 'infix:.\'
    .param pmc a
    .param pmc b

$S0 = <<"EOS"
.sub '' :anon
    .param int nargout
    .param int nargin
    .param pmc a
    .param pmc b
    $P0 = div b, a
    .return($P0)
.end
EOS

    $P0 = compreg "PIR"
    $P1 = $P0($S0)
    $P2 = $P1[0]
    $P3 = '!lookup_function'('arrayfun')
    $P4 = $P3(1,1,$P2,a,b)
    .return($P4)
.end

=head1 Matrix-Unaware Operators

TOD0: These all need to be fixed!

=cut

# TODO: link to mtimes as soon as
#    it can handle scalar args
.sub 'infix:*'
    .param pmc a
    .param pmc b
    $P0 = a * b
    .return($P0)
.end

.sub 'infix:^'
    .param pmc a
    .param pmc b
    $P0 = pow a, b
    .return($P0)
.end

.sub 'infix:/'
    .param pmc a
    .param pmc b
    $P0 = a / b
    .return($P0)
.end

.sub 'prefix:-'
    .param pmc a
    $P0 = neg a
    .return($P0)
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

.sub 'ternary:: :'
    .param pmc start
    .param pmc step
    .param pmc stop
    .tailcall '!range_constructor_three'(start, step, stop)
.end

.sub 'infix::'
    .param pmc start
    .param pmc stop
    .tailcall '!range_constructor_two'(start, stop)
.end

