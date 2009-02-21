.namespace []

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
