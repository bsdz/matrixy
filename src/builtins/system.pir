=head1 NAME

F<src/builtins/system.pir> - built-in system functions

=head1 DESCRIPTION

These functions interact with the system in some way, and
do secret system stuff.

=head1 Functions

=over 4

=cut

.namespace []

=item _system_call

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

=item feval(STRING name, PMC args :slurpy)

Calls the function with name C<name> and arguments C<args>.

If the function isn't loaded yet, it should be looked up. Does
not currently perform any lookups however.

=cut

.sub 'feval'
    .param string func
    .param pmc args :slurpy
    $P0 = find_name func
    .tailcall $P0(args :flat)
.end

=item quit()

Exits the program.

=item exit()

Same

=cut

.sub 'quit'
    end
.end

.sub 'exit'
    end
.end


