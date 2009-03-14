=head1 NAME


F<src/builtins/stdio.pir> - built-in stdio functions

=head1 DESCRIPTION

This file contains some of the basic functions for I/O on 
the console and in files.

=head1 Functions

=over 4

=cut

.namespace ["_Matrixy";"builtins"]

=item disp(PMC msg)

prints a single string or value to the terminal. Eventually,
this function will be able to print all the entries in a
row matrix as well.

=cut

.sub 'disp'
    .param int nargout
    .param int nargin
    .param pmc msg
    $S0 = '!get_matrix_string'(msg)
    say $S0
    .return()
.end

=item error(STRING msg)

raises an exception with the supplied message

=cut

.sub 'error'
    .param int nargout
    .param int nargin
    .param pmc msg
    $S0 = '!get_first_string'(msg)
    $S1 = "error: " . $S0
    $P1 = new 'Exception'
    $P1['message'] = $S1
    throw  $P1
    .return ()
.end

=item parrot_typeof(PMC a)

Return a string representing the Parrot type of the parameter a

=cut

.sub 'parrot_typeof'
    .param int nargout
    .param int nargin
    .param pmc a
    $S0 = typeof a
    .return($S0)
.end

.namespace []

=item _disp_all(PMC args :slurpy)

This is similar to the disp() function above, accept that
it prints out a slurpy list of arguments to the terminal.

This is non-standard, so it begins with an underscore.

=cut

.sub '_disp_all'
    .param pmc args :slurpy
    # TODO: Update this to call '!get_matrix_string'
    .local pmc iter
    iter = new 'Iterator', args
  iter_loop:
    unless iter goto iter_end
    $S0 = shift iter
    print $S0
    goto iter_loop
  iter_end:
    print "\n"
    .return (1)
.end


=item _error_all(PMC args :slurpy)

raises an exception with the message which is given
piecewise. The arguments are stringified and concatinated,
and the resulting message is used to raise an exception.

=cut

.sub '_error_all'
    .param pmc args :slurpy
    .local pmc iter
    # TODO: Update this to call '!get_matrix_string'
    iter = new 'Iterator', args
    $S0 = ''
  iter_loop:
    unless iter goto iter_end
    $S1 = shift iter
    $S0 = $S0 . $S1
    goto iter_loop
  iter_end:
    $S0 = $S0 . "\n\n"
    $S1 = "??? " . $S0 
    $P1 = new 'Exception'
    $P1['message'] = $S1
    throw  $P1
    .return()
.end

=item _print_result_a(PMC name, PMC value, STRING term)

Handles the MATLAB/Octave behavior where the value of an
assigment is printed to the terminal, unless the statement
is postfixed with a ';'. If the ';' exists, nothing is
printed. Otherwise, the name of the variable and the value
that has been assigned to it is printed.

For example, typing C<x = 5> at the prompt without a
semicolor will cause Octave to print:

    x =

        5

=item _print_result_e(PMC value, STRING term)

Handles the MATLAB/Octave behavior where the value of an
expression is printed to the terminal unless the statement
is postfixed with a ';'. If the ';' exists, nothing is
printed. Otherwise, the value of the expression is assigned
to the C<ans> variable, and it is printed to the terminal.

For example, typing C<5 + 4> at the prompt without a
semicolon will cause Octave to print

    ans =

        9

In this way, Matrixy can be used as a sort of desk calculator.

=item _print_result_a(PMC value, STRING term)

Prints the value of a bare variable or subroutine call name. So writing

  x(5)

Will print out

  ans =
  
      9

if the result of the variable x, or the subroutine call x() returns the value
"9" with argument "5".

=cut

.sub '_print_result_a'
    .param pmc name
    .param pmc value
    .param string term
    iseq $I0, term, ';'
    if $I0 goto end_p_r_a
    print name
    say " = "
    $S0 = '!get_matrix_string'(value)
    say $S0
  end_p_r_a:
    .return()
.end

.sub '_print_result_e'
    .param pmc value
    .param string term

    # If the value isn't defined, don't do anything

    $I0 = defined value
    if $I0 goto print_value
    goto end_print_result

    if term == ';' goto end_print_result

    #If the statement is terminated, don't print, but do
    # set "ans"
  print_value:
    if term goto end_p_r_e

    print "ans = "
    $S0 = '!get_matrix_string'(value)
    say $S0

  end_p_r_e:
    set_hll_global "ans", value
  end_print_result:
    .return()
.end

.sub '_print_result_s'
    .param pmc value
    .param string term
    $I0 = defined value
    if $I0 goto print_value
    goto end_print_result
  print_value:
    iseq $I0, term, ';'
    if $I0 goto end_p_r_s
    print "ans = "
    $S0 = '!get_matrix_string'(value)
    say $S0
  end_p_r_s:
    set_hll_global "ans", value
  end_print_result:
    .return()
.end

=back

=cut
