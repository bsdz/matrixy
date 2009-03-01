
=head1 Function/Variable dispatch routines

The routines in this function deal with dispatching function calls or variable
lookups. This issue is complicated slightly by the fact that that both
subroutines and variables use the same syntax for dispatching and array lookup.
Given the code C<x(5)>, if x is a variable it performs an array lookup.
Otherwise, attempts to dispatch to the subroutine x with the argument list
C<(5)>.

Rules:

=over 4

=item*

Look up the name in the list of local variables. If we find it, dispatch
the request to the variable as a table lookup.

=item*

If a variable is not found, dispatch as a subroutine call. Look up the
subroutine name locally.

=item*

If a subroutine with that name isn't already loaded, it might exist in a
library file somewhere. For instance, the function C<x()> might be defined
in file C<x.m>, so search there

=item*

If all else fails, print a warning saying that C<x> is undefined.

=back

TODO: To make all this work, we may require that local variable names and
subroutines be stored in different namespaces so we don't get them confused
and can share names between them.

=cut

.sub '_dispatch'
    .param string name
    .param pmc args

    # determine which namespace we have to look this up in
    # also determine whether we need to find_global or find_lex here.
    #$P0 = find_global name
    #$I0 = defined $P0
    #if $I0 goto _dispatch_found

    # Here, we haven't found an entry in the local symbol table, so
    # we need to search for it.
    '_error_all'(name, " is undefined and search is not implemented")
    .return(0)

  _dispatch_found:
    # We have a value, it should be a MatrixData value, so we can test whether
    # it's a subroutine or a variable.
    #$S0 = typeof $P0
    #if $S0 = 'Sub' goto
    .return(1)
.end

# Search for the function in the library. Load the file and return a handle
# to it if found. Return undef otherwise.
.sub '_search_for_function'
    .param string name
    .local pmc subroutine
    subroutine = null
    .return(subroutine)
.end

# A built-in function. Search for the file where the builtin is implemented,
# and display any documentation from that file.
.sub 'help'
    .param string name
    $P0 = '_search_for_function'(name)
    $I0 = defined $P0
    .return()
.end

=head1 set_nargin/set_nargout

These functions are called by the caller to set the number of input and
output arguments it's using in the subroutine call.

=cut

.sub 'set_nargin'
.end

.sub 'set_nargout'
.end

=head1 get_nargin/get_nargout

These functions are called by the callee to get the number of input and output
arguments that the caller is expecting

=cut

.sub 'get_nargin'
.end

.sub 'get_nargout'
.end