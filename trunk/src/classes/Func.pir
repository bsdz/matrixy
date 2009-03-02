.namespace ["MatrixyFunc"]

.sub 'onload' :anon :init :load
    $P0 = subclass 'MatrixyData', 'MatrixyFunc'
.end

.sub 'init' :vtable
    self.'type'("MatrixyFunc")
.end

.sub 'invoke' :vtable
    .param pmc args :slurpy
    .local pmc me
    .local pmc data
    me = interpinfo .INTERPINFO_CURRENT_INVOCANT
    data = me.'data'()
    data(args :flat)
.end
