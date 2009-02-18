
.namespace ['OctaveData']

.sub 'onload' :anon :load :init
	newclass $P0, "OctaveData"
	addattribute $P0, 'name'
	addattribute $P0, 'type'
	addattribute $P0, 'data'
	addattribute $P0, 'othertype'
.end

.sub 'new' :method
	$P1 = new 'Undef'
	setattribute self, 'data', $P1
	setattribute self, 'type', $P1
	setattribute self, 'name', $P1
.end

.sub 'data' :method
    .param pmc d :optional
    .param int has_d :opt_flag
    if has_d goto set_d
	$P0 = getattribute self, 'data'
	.return($P0)
  set_d: 
    setattribute self, 'data', d
    .return()
.end

.sub 'type' :method
    .param string t :optional
    .param int has_t :opt_flag
    if has_t goto set_t
	$P0 = getattribute self, 'type'
	.return($P0)
  set_t: 
    $P0 = new 'String'
    $P0 = t
    setattribute self, 'type', $P0
    .return()
.end

.sub 'name' :method
    .param string name :optional
    .param int has_name :opt_flag
    if has_name goto set_name
	$P0 = getattribute self, 'name'
	.return($P0)
  set_name: 
    $P0 = new 'String'
    $P0 = name
    setattribute self, 'name', $P0
    .return()
.end

