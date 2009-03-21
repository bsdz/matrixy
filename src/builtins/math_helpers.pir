=head1 DESCRIPTION

These utility functions are for calculating the min
or max of two integers.

=cut

.namespace ['_Matrixy';'builtins']

.sub '!max'
  .param int i
  .param int j
  
  $I1 = i - j
  $I2 = i + j
  $I3 = abs $I1
  $I4 = $I2 + $I3
  $I5 = $I4 / 2
  
  .return( $I5 )
.end

.sub '!min'
  .param int i
  .param int j
  
  $I1 = i - j
  $I2 = i + j
  $I3 = abs $I1
  $I4 = $I2 - $I3
  $I5 = $I4 / 2
  
  .return( $I5 )
.end



