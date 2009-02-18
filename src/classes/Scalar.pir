.namespace ['Scalar']

.sub 'onload' :anon :load :init
	$P0 = subclass 'OctaveData', 'Matrix'
.end

.sub 'new':vtable :method
	.param string name
	self.'name'(name)
.end

