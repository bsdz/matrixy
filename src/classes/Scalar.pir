.namespace ['Scalar']

=head1 ABOUT

This file implements a basic scalar class. This might not be necessary,
since scalars are basically treated as 1x1 matrices in Matlab/Octave.
So, we might treat them all as matrices like that instead of having a
separate class for these.

=cut

.sub 'onload' :anon :load :init
    $P0 = subclass 'MatrixyData', 'Matrix'
.end

.sub 'new':vtable :method
    .param string name
    self.'name'(name)
.end

