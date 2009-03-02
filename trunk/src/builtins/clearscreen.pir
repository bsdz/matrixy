.namespace ["_Matrixy";"builtins"]

.sub 'clearscreen'
    print binary:"\027[2J"
    print binary:"\027[H"
    #print binary:"\e[2J"
    #print binary:"\e[H"
.end

.namespace []




