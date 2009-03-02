.namespace ["MatrixyCell"]

.sub 'onload' :anon :init :load
    $P0 = subclass 'MatrixyData', 'MatrixyCell'
.end

.sub 'init' :vtable
    self.'type'("MatrixyCell")
.end