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

.namespace []

.sub 'initglobals' :anon :load :init
    $P0 = new 'ResizablePMCArray'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?BLOCK', $P0
    $P0 = new 'Undef'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '$?BLOCK', $P0

    $P1 = new 'Hash'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '%?FUNCTIONS', $P1

    # default path is set to current directory
    $P2 = new 'ResizablePMCArray'
    $P2[0] = "."
    $P2[1] = "toolbox/"
    set_hll_global ['Matrixy';'Grammar';'Actions'], '@?PATH', $P2

    $P3 = new 'Integer'
    $P3 = 0
    set_hll_global ['Matrixy';'Grammar';'Actions'], '$?NARGIN', $P3

    $P4 = new 'Integer'
    $P4 = 0
    set_hll_global ['Matrixy';'Grammar';'Actions'], '$?NARGOUT', $P4

    $P4 = new 'Hash'
    set_hll_global ['Matrixy';'Grammar';'Actions'], '%?GLOBALS', $P5
.end

.namespace []

.sub '!hash'
    .param pmc fields :slurpy :named
    .return (fields)
.end

=back

=cut

