.namespace []

# TODO: Make sure all these operators are matrix-aware and string-aware.

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

