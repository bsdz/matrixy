.namespace []

.sub 'initlist' :anon :load :init
    subclass $P0, "ResizablePMCArray", "List"
.end

.namespace ['List']

.sub 'shift' :method
    shift $P0, self
    .return ($P0)
.end

.sub 'unshift' :method
    .param pmc obj
    unshift self, obj
.end

.namespace []

.sub '!array'
    .param pmc fields :slurpy
    .return (fields)
.end

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end
