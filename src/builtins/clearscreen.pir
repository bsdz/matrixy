.namespace []

## this doesn't work for me :-(
## once this works, Game of Life runs much nicer.
## --kjs
##
.sub 'clearscreen'
    print binary:"\027[2J"
    print binary:"\027[H"
    #print binary:"\e[2J"
    #print binary:"\e[H"
.end




