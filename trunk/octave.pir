=head1 TITLE

squaak.pir - A Squaak compiler.

=head2 Description

This is the base file for the Octave compiler.

This file includes the parsing and grammar rules from
the src/ directory, loads the relevant PGE libraries,
and registers the compiler under the name 'Octave'.

=head2 Functions

=over 4

=item onload()

Creates the Octave compiler using a C<PCT::HLLCompiler>
object.

=cut

.include 'src/classes/all_classes.pir'
.loadlib 'octave_group'
.namespace [ 'Octave::Compiler' ]

#TODO:
#   Kill @?BLOCK, $?BLOCK, and $?INFUNC. Maybe kill @?TOPLEVEL too
#   Kill List.pir, use Matrix.pir instead.

.sub 'onload' :anon :load :init
    load_bytecode 'PCT.pbc'

    $P0 = get_hll_global ['PCT'], 'HLLCompiler'
    $P1 = $P0.'new'()
    $P1.'language'('Octave')
    $P1.'parsegrammar'('Octave::Grammar')
    $P1.'parseactions'('Octave::Grammar::Actions')

    $P1.'commandline_banner'("Octave for Parrot VM\n")
    $P1.'commandline_prompt'('> ')
	
	#Create the scope block
	$P0 = new "List"
    set_hll_global ['Octave';'Grammar';'Actions'], '@?BLOCK', $P0
	
	#Create a list of top-level variables
	$P0 = new "List"
    set_hll_global ['Octave';'Grammar';'Actions'], '@?TOPLEVEL', $P0
	
	#Create a list of global variables
	$P0 = new "List"
    set_hll_global ['Octave';'Grammar';'Actions'], '@?GLOBALS', $P0

.end

=item main(args :slurpy)  :main

Start compilation by passing any command line C<args>
to the Squaak compiler.

=cut

.sub 'main' :main
    .param pmc args

    $P0 = compreg 'Octave'
    $P1 = $P0.'command_line'(args)
.end

.include 'src/gen_builtins.pir'
.include 'src/gen_grammar.pir'
.include 'src/gen_actions.pir'



=back

=cut

# Local Variables:
#   mode: pir
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4 ft=pir:

