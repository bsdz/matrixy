# $Id$

=begin comments

Actions file for the Octave Grammar

=end comments

=cut

#TODO:
#   they've updated the way scope blocks are handled, and how variables
#   are scoped. Remove all references to @?BLOCK and $?BLOCK and $?INFUNC
#   Remove stuff that doesn't belong
#   Refactor things to be prettier
#   Get matrices working

class Octave::Grammar::Actions;

method TOP($/, $key) {
    our @?BLOCK;	#scope stack
    our $?BLOCK;	#current scope pointer

    if $key eq 'open' {
        $?BLOCK := PAST::Block.new( :blocktype('declaration'), :node($/) );
        @?BLOCK.unshift($?BLOCK);
    }
    else {
        my $past := @?BLOCK.shift();

        for $<stat_or_def> {
            $past.push($($_));
        }
        make $past;
    }
}

method stat_or_def($/, $key) {
    make $( $/{$key} );
}

method system_call($/) {
	my $string := PAST::Val.new( 
		:value( ~$<bare_words> ), 
		:returns('String'), 
		:node($/) 
	);
	my $past := PAST::Op.new( 
		:name("_system_call"),
		:pasttype('call'),
		:node($/)
	);
	$past.push($string);
	make $past;
}

#TODO:
#   All this needs to get fixed. To initialize, create a new  OctaveData
#   object with name ~$<ident>.

method identifier($/) {
    our @?BLOCK;
	our $?INFUNC;
	
    my $name  := ~$<ident>;
    my $scope := 'package';
	if $?INFUNC == 1 {
		$scope := 'lexical';
	}

    for @?BLOCK {
        if $_.symbol( $name ) {
            $scope := 'lexical';
        }
    }

    make PAST::Var.new( :name($name),
                        :scope($scope),
                        :viviself('OctaveData'),
                        :node($/) );
}

method statement($/, $key) {
    
	#TODO: If it's an expression or a sub_call, I want to assign the 
	#  result value to "ans", regardless of whether i terminate
	#  the expression or not. I may need to declare ans as a global
	
	my $past;
	if $key eq 'assignment' {
		my $node := $( $<assignment> );
		my $term := PAST::Val.new( :value(~$<statement_terminator>), :returns('String'));
		$past := PAST::Op.new(:pasttype('inline'));
		$past.inline("_print_result_a(%0, %1, %2)");
		$past.unshift($term);
		$past.unshift($node);
		my $name := PAST::Val.new( :value( ~$node.name() ), :returns('String'));
		$past.unshift($name);
	} elsif $key eq 'expression' {
		$past := PAST::Op.new(:pasttype('inline'));
		my $term := PAST::Val.new( :value(~$<statement_terminator>), :returns('String'));
		$past.inline("_print_result_e(%0, %1)");
		$past.unshift($term);
		$past.unshift($( $<expression> ));
		#Assign the return value to global variable "ans"
	} else {
		$past := $( $/{$key} );
	}
	make $past;
}

method if_statement($/) {
    my $cond := $( $<expression> );
    my $then := $( $<block> );
    my $past := PAST::Op.new( $cond, $then, :pasttype('if'), :node($/) );

    ## if there's an else clause, add it to the PAST node.
    if $<else> {
        $past.push( $( $<else>[0] ) );
    }
    make $past;
}

method while_statement($/) {
    my $cond := $( $<expression> );
    my $body := $( $<block> );
    make PAST::Op.new( $cond, $body, :pasttype('while'), :node($/) );
}

#TODO: 
#   Fix FOR loops to use the right syntax, and to operate correctly.

method for_statement($/) {
    our $?BLOCK;
    our @?BLOCK;

    my $init := $( $<for_init> );
    my $itername := $init.name();
    my $iter := PAST::Var.new( :name($itername), :scope('lexical'), :node($/) );
    my $body := @?BLOCK.shift();
    $?BLOCK  := @?BLOCK[0];
    for $<statement> {
        $body.push($($_));
    }
    my $step;
    if $<step> {
        my $stepsize := $( $<step>[0] );
        $step := PAST::Op.new( $iter, $stepsize, :pirop('add'), :node($/) );
    }
    else { ## default is increment by 1
        $step := PAST::Op.new( $iter, :pirop('inc'), :node($/) );
    }
    $body.push($step);
    my $cond := PAST::Op.new( $iter, $( $<expression> ), :name('infix:<=') );
    my $loop := PAST::Op.new( $cond, $body, :pasttype('while'), :node($/) );
    make PAST::Stmts.new( $init, $loop, :node($/) );
}

#TODO: 
#   This needs to be updated

method for_init($/) {
    our $?BLOCK;
    our @?BLOCK;
    
    $?BLOCK := PAST::Block.new( :blocktype('immediate'), :node($/) );
    @?BLOCK.unshift($?BLOCK);
    my $iter := $( $<identifier> );
    $iter.isdecl(1);
    $iter.scope('lexical');
    $iter.viviself( $( $<expression> ) );
    $?BLOCK.symbol($iter.name(), :scope('lexical'));
    make $iter;
}

method try_statement($/) {
    my $try := $( $<try> );
    my $catch := PAST::Stmts.new( :node($/) );
    for $<statement> {
        $catch.push($($_));
    }
    my $exc := $( $<exception> );
    $exc.isdecl(1);
    $exc.scope('lexical');
    my $pir := "    .get_results (%r, $S0)\n"
             ~ "    store_lex '" ~ $exc.name() ~ "', %r";

    $catch.unshift( PAST::Op.new( :inline($pir), :node($/) ) );
    $catch.unshift( $exc );

    make PAST::Op.new( $try, $catch, :pasttype('try'), :node($/) );
}

#TODO:
#   Redo to avoid using $?BLOCK and whatever. 
#   Parrot exceptions have been redone recently, make sure this still works.

method exception($/) {
    our $?BLOCK;
    my $exc := $( $<identifier> );
    $?BLOCK.symbol($exc.name(), :scope('lexical'));
    make $exc;
}

method throw_statement($/) {
    make PAST::Op.new( $( $<expression> ), :pirop('throw'), :node($/) );
}

#TODO: 
#   I might not even need a "block" parser token type. Remove if not needed
#   I don't think Octave has block-level scope

method block($/, $key) {
    our $?BLOCK; 
    our @?BLOCK; 

    if $key eq 'open' {
        $?BLOCK := PAST::Block.new( :blocktype('immediate'), :node($/) );
        @?BLOCK.unshift($?BLOCK);
    }
    else {
        my $past := @?BLOCK.shift();
        $?BLOCK  := @?BLOCK[0];

        for $<statement> {
            $past.push($($_));
        }
        make $past
    }
}

#TODO:
#   Octave doesnt have do blocks or do-while blocks (that I know of)
#   Remove this

method do_block($/) {
    make $( $<block> );
}

method assignment($/) {
    my $rhs := $( $<expression> );
    my $lhs := $( $<primary> );
    $lhs.lvalue(1);
    make PAST::Op.new( $lhs, $rhs, :pasttype('bind'), :name($lhs.name()), :node($/) );
}

#TODO:
#   Redo this, remove @?BLOCK, $?BLOCK, and $?INFUNC
#   Update return value type to use OctaveData class instead of being a scalar value
#   Make sure parameters are OctaveData

method sub_definition($/, $key) {
    our @?BLOCK;
    our $?BLOCK;
	our $?INFUNC;
	if $key eq 'open' {
		$?INFUNC := 1;
	} else {
		
		$?INFUNC := 0;
		my $past := $( $<parameters> );
		my $name := $( $<name> );
		my $rnode := PAST::Op.new(:pasttype('pirop'), :pirop('return'));
		for $<identifier> {
			my $retval := PAST::Var.new( :name($($_).name()),
										 :scope('lexical'),
										 :viviself('Undef'),
										 :isdecl(1),
										 :lvalue(1)
									   );
			$past.push($retval);			
			$past.symbol($retval.name(), :scope('lexical'));
			my $ret := PAST::Var.new( :scope('lexical'), :name($retval.name()));
			$rnode.push($ret);
		}
		$past.name( $name.name() );
		for $<statement> {
			$past.push($($_));
		}
		$past.push($rnode);
		@?BLOCK.shift();
		$?BLOCK := @?BLOCK[0];
		make $past;
	}
}

#TODO:
#   Remove @?BLOCK and $?BLOCK
#   Ensure parameters are OctaveData

method parameters($/) {
    our $?BLOCK;
    our @?BLOCK;

    my $past := PAST::Block.new( :blocktype('declaration'), :node($/) );
    for $<identifier> {
        my $param := $( $_ );
        $param.scope('parameter');
        $past.push($param);
        $past.symbol($param.name(), :scope('lexical'));
    }
    $?BLOCK := $past;
    @?BLOCK.unshift($past);

    make $past;
}

method sub_call($/) {
    my $invocant := $( $<identifier> );
    my $past     := $( $<arguments> );
	$invocant.scope('package');
    $past.unshift( $invocant );
    make $past;
}

method arguments($/) {
    my $past := PAST::Op.new( :pasttype('call'), :node($/) );
    for $<expression> {
        $past.push($($_));
    }
    make $past;
}

method primary($/) {
    my $past := $( $<identifier> );
    for $<postfix_expression> {
        my $expr := $( $_ );
        $expr.unshift($past);
		$expr.name($past.name());
        $past := $expr;
    }
    make $past;
}

method postfix_expression($/, $key) {
    make $( $/{$key} );
}

method key($/) {
    my $key := $( $<expression> );
    make PAST::Var.new( $key, :scope('keyed'),
                              :vivibase('Hash'),
                              :viviself('Undef'),
                              :node($/) );

}

#TODO:
#   In octave, I dont think x{'y'} exists, no hashes.

method member($/) {
    my $member := $( $<identifier> );
    my $key    := PAST::Val.new( :returns('String'), :value($member.name()), :node($/) );
    make PAST::Var.new( $key, :scope('keyed'),
                              :vivibase('Hash'),
                              :viviself('Undef'),
                              :node($/) );
}

#TODO:
#   use OctaveData/Matrix instead of ResizablePMCArray

method index($/) {
    my $index := $( $<expression> );
    make PAST::Var.new( $index, :scope('keyed'),
                                :vivibase('ResizablePMCArray'),
                                :viviself('Undef'),
                                :node($/) );
}

method named_field($/) {
    my $past := $( $<expression> );
    my $name := $( $<string_constant> );
    $past.named($name);
    make $past;
}

#TODO: 
#   Rename to "Matrix Constructor". Create a OctaveData/Matrix instead
#   of an array.

method array_constructor($/) {
    my $past := PAST::Op.new( :name('!array'), :pasttype('call'), :node($/) );
    for $<expression> {
        $past.push($($_));
    }
    make $past;
}

#TODO:
#   Octave doesn't have hashes. Remove

method hash_constructor($/) {
    ## use the parrot calling conventions to create a hash, using the
    ## "anonymous" sub !hash (which is not a valid Squaak name)
    my $past := PAST::Op.new( :name('!hash'), :pasttype('call'), :node($/) );
    for $<named_field> {
        $past.push($($_));
    }
    make $past;
}

method term($/, $key) {
    make $( $/{$key} );
}

#TODO:
#   Create a new OctaveData Scalar object with the specified value
#   Do this for integer_constant and float_constant

method integer_constant($/) {
    make PAST::Val.new( :value( ~$/ ), :returns('Integer'), :node($/) );
}

method float_constant($/) {
    make PAST::Val.new( :value( ~$/ ), :returns('Float'), :node($/) );
}

method string_constant($/) {
    make PAST::Val.new( :value( $($<string_literal>) ), :returns('String'), :node($/) );
}


method expression($/, $key) {
    if ($key eq 'end') {
        make $($<expr>);
    }
    else {
        my $past := PAST::Op.new( :name($<type>),
                                  :pasttype($<top><pasttype>),
                                  :pirop($<top><pirop>),
                                  :lvalue($<top><lvalue>),
                                  :node($/)
                                );
        for @($/) {
            $past.push( $($_) );
        }
        make $past;
    }
}



# Local Variables:
#   mode: cperl
#   cperl-indent-level: 4
#   fill-column: 100
# End:
# vim: expandtab shiftwidth=4: