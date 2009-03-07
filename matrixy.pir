=head1 TITLE

matrixy.pir - A Matrixy compiler.

=head2 Description

This is the base file for the Matrixy compiler. Matrixy
is intended to be a clone of MATLAB/Octave for Parrot. See
F<README.POD> for more information about this language.

This file includes the parsing and grammar rules from
the src/ directory, loads the relevant PGE libraries,
and registers the compiler under the name 'Matrixy'.

=head2 Functions

=over 4

=item onload()

Creates the Matrixy compiler using a C<PCT::HLLCompiler>
object.

=cut

#.HLL 'matrixy'

#.include 'src/gen_classes.pir'

.namespace [ 'Matrixy';'Compiler' ]

.loadlib 'matrixy_group'

# .sub '' :anon :load :init
    # load_bytecode 'PCT.pbc'

    # .local pmc parrotns, hllns, exports
    # parrotns = get_root_namespace ['parrot']
    # hllns = get_hll_namespace
    # exports = split ' ', 'PAST PCT PGE'
    # parrotns.'export_to'(hllns, exports)
# .end


.sub 'onload' :anon :load :init
    load_bytecode 'PCT.pbc'

    $P0 = get_hll_global ['PCT'], 'HLLCompiler'
    $P1 = $P0.'new'()
    $P1.'language'('matrixy')
    $P0 = get_hll_namespace ['Matrixy';'Grammar']
    $P1.'parsegrammar'($P0)
    $P0 = get_hll_namespace ['Matrixy';'Grammar';'Actions']
    $P1.'parseactions'($P0)

    $P1.'commandline_prompt'("\nmatrixy:1> ")
    $P1.'commandline_banner'("Matrixy, version 0.1.\nCopyright (C) 2009 Blair Sutton and Andrew Whitworth.\n\n")
.end

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the Matrixy compiler.

=cut

.sub 'main' :main
    .param pmc args

    $P0 = compreg 'matrixy'
    $P1 = $P0.'command_line'(args)
.end

.include 'src/gen_builtins.pir'
.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'

.include 'src/classes/Data.pir'
.include 'src/classes/Matrix.pir'

.namespace []

.sub 'initlist' :anon :load :init
    $P0 = new 'ResizablePMCArray'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?BLOCK', $P0

    $P1 = new 'Hash'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS', $P1

    # default path is set to current directory
    $P2 = new 'ResizablePMCArray'
    $P2[0] = "."
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?PATH', $P2
.end

.namespace []

# Basic array row constructor.
# TODO: Move this into it's own separate file somewhere
.sub '!array_row'
    .param pmc fields :slurpy
    .local pmc myiter
    myiter = iter fields
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0
    unless $S0 == "String" goto loop_top
    .tailcall '!array_compress_strings'(fields)
  loop_bottom:
    .return (fields)
.end

.sub '!array_col'
    .param pmc fields :slurpy
    .local pmc myiter
    myiter = iter fields
  loop_top:
    unless myiter goto just_exit
    $P0 = shift myiter
    $S0 = typeof $P0
    unless $S0 == "String" goto loop_top

    # fall through. If any row is a string, the whole matrix is treated as
    # an array of strings. each row has to be converted now.
    .tailcall '!array_col_force_strings'(fields)
  just_exit:
    .return (fields)
.end

.sub '!array_col_force_strings'
    .param pmc fields
    .local pmc myiter
    .local pmc newarray
    newarray = new 'ResizablePMCArray'
    myiter = iter fields
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0
    if $S0 == 'String' goto push_string_pmc
    $S0 = '!array_compress_strings'($P0)
    $P0 = box $S0
  push_string_pmc:
    push newarray, $P0
    goto loop_top
  loop_bottom:
    .return(newarray)
.end

# String array constructor.
# Strings and numbers cannot really coexist in a single matrix. If strings
# are present, all numbers are converted to their ASCII character
# represenations. All strings or characters in a given row are concatenated
# together into a single string. Array indexing into a string is the same
# as character addressing.
# If a Num is passed instead of an Int, it is rounded down and the integer
# value is used to look up the character.
.sub '!array_compress_strings'
    .param pmc fields
    .local pmc myiter
    .local string s
    myiter = iter fields
    s = ""

    # Iterate over the input array
  loop_top:
    unless myiter goto loop_bottom
    $P0 = shift myiter
    $S0 = typeof $P0

    # If it's a string, add it to the running concatination.
    # Otherwise, get the ASCII character representation and add that
    if $S0 == 'String' goto have_string_pmc
    $I0 = $P0
    $S1 = chr $I0
    s .= $S1
    goto loop_top
  have_string_pmc:
    $S1 = $P0
    s .= $S1
    goto loop_top

  loop_bottom:
    .return(s)
.end

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end

=back

=cut


