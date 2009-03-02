.namespace ["_Matrixy";"builtins"]

.sub 'sprintf'
    .param pmc fmt
    .param pmc args     :slurpy
    $P0 = new 'String'
    sprintf $P0, fmt, args
    .return ($P0)
.end

.namespace[]
