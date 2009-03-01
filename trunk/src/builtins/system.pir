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

.sub 'system'
    .param string cmd
    .param int flags :optional
    .param int has_flags :opt_flag

    if has_flags goto capture_output

    $I0 = spawnw cmd
    .return ($I0)

  capture_output:
    'error'("Function 'system' does not support capturing output")
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

=item getenv

Returns underlying OS's enviroment for variable 'name'.

=cut

.sub 'getenv'
    .param string name
    .local pmc env

    env = new 'Env'

    $S0 = env[name]
    .return (  $S0 )
.end

=item setenv

Sets underlying OS's enviroment for variable 'name' with value 'value'.

=cut

.sub 'setenv'
    .param string name
    .param string value :optional
    .param int has_value :opt_flag

    .local pmc env

    if has_value goto setenv
    value = ''

  setenv:
    env = new 'Env'
    env[name] = value

.end