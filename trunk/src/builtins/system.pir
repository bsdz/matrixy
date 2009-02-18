# $Id$

=head1 System Functions

=head2 About

These functions interact with the system in some way, and
do secret system stuff.

=head2 Functions

=cut

.namespace

=head3 _system_call

This function handles the MATLAB/Octave behavior where
prefixing a line with '!' passes that entire line to the
system shell. For instance, on a Windows machine, typing:

	!echo hello
	
Will cause the word "hello" to be printed to the terminal.

=cut

.sub '_system_call'
	.param string cmd
	.local int res
	spawnw res, cmd
    .return (1)
.end

=head3 feval(STRING name, PMC args :slurpy)

Calls the function with name C<name> and arguments C<args>. 

If the function isn't loaded yet, it will be looked up. 
Currently, however, this function does not do any lookups.
It will, eventually. 

=cut

.sub 'feval'
	.param string func
	.param pmc args :slurpy
	
	$P0 = find_name func
	.return $P0(args :flat)
.end

=head3 eval(STRING line)

Evaluates the line of MATLAB/Octave code given by C<line>. 
Will return the value of that statement or expression, if
any. 

Currently, this function is unimplemented.

=cut

.sub 'eval'
	.param string eval_s
	'error'("'eval' not implemented")
	.return(1)
.end

=head3 end()

quits the program. I don't think this is the right name for
it.

=cut

.sub 'end'
	end
.end

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

