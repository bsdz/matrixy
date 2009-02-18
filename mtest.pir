
.namespace

.sub 'main' :main
    $P0 = new 'Matrix'
    $P0.'create_scalar'('a', 5)
    $P0.'print_string'()
    $P1 = new 'Matrix'
    $P1.'create_scalar'('b', 6)
    $P1.'print_string'()
    $P2 = $P0.'add'($P1)
    $P2.'print_string'()
.end

.include 'src/builtins/stdio.pir'
.include 'src/classes/Data.pir'
.include 'src/classes/matrix.pir'


    