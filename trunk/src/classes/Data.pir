.namespace ['MatrixyData']

=head1 ABOUT

This is a basic superclass for all values in Matrixy.

=head1 Functions

=over 4

=item onload

=cut

.sub 'onload' :anon :load :init
    newclass $P0, "MatrixyData"
    addattribute $P0, 'name'
    addattribute $P0, 'type'
    addattribute $P0, 'data'
    addattribute $P0, 'othertype'
.end

=item new()

=cut

.sub 'new' :method :vtable("init")
    $P1 = new 'Undef'
    setattribute self, 'data', $P1
    setattribute self, 'name', $P1
    $P1 = box "Data"
    setattribute self, 'type', $P1
.end

=item data()

=cut

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

=item type()

=cut

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

=item name()

=cut

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

=item assign()

=cut

.sub 'assign' :method :vtable
    .param pmc x
    $S0 = typeof x
    if $S0 == 'String' goto _convert_string
    if $S0 == 'Integer' goto _convert_int
    if $S0 == 'Float' goto _convert_float
    if $S0 == 'Sub' goto _convert_sub
.end

=back

=cut