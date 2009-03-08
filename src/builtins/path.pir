=head1 NAME

F<src/builtins/path.pir> - built-in path functions

=head1 DESCRIPTION

These functions are for manipulating search path.

=head1 Functions

=over 4

=cut

.namespace ["_Matrixy";"builtins"]

=item path([<path string>])

Returns path or sets path by splitting on ';'. (TODO use pathsep)

=cut

.sub 'path'
    .param int nargout
    .param int nargin
    .param string pathlist :optional
    .param int has_pathlist :opt_flag

    unless has_pathlist goto end

    $P1 = new ['ResizablePMCArray'] # stores new searchpath
    $P1 = split ';', pathlist
    set_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH", $P1

  end:
    .local pmc searchpath
    searchpath = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"
    $S1 = join ';', searchpath

    .return($S1)

.end

=item addpath(dir1 [, dir2, dir3, ..])

Adds path. For now only handles a single path.

=cut

.sub 'addpath'
    .param int nargout
    .param int nargin
    .param string path
    .param pmc args :slurpy

    .local pmc searchpath
    searchpath = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"
    push searchpath, path

    $P0 = iter args
  loop:
    unless $P0 goto end
    $P1 = shift $P0
    $S0 = $P1
    push searchpath, $S0
    goto loop

  end:
    .return()
.end

=item rmpath(dir1 [, dir2, ...])

Removes path(s).

=cut

.sub 'rmpath'
    .param int nargout
    .param int nargin
    .param string path
    .param pmc args :slurpy

    .local pmc searchpath
    searchpath = get_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH"

    $P0 = new ['ResizablePMCArray'] # what we want to remove
    $I1 = args
    splice $P0, args, 0, $I1
    push $P0, path

    $P1 = iter $P0

    $P2 = new ['ResizablePMCArray'] # stores new searchpath


    $P3 = new 'Hash' # stores current path
    $P4 = iter searchpath
  buildhash_lp:
    unless $P4 goto check_lp
    $P5 = shift $P4
    $S0 = $P5
    set $P3[$S0], 0
    goto buildhash_lp


  check_lp:
    unless $P1 goto build_sp
    $P6 = shift $P1
    $S1 = $P6
    $I1 = exists $P3[$P6]
    if $I1 goto delete_from_hash
    goto check_lp


  delete_from_hash:
    delete $P3[$S1]
    goto check_lp


  build_sp:
    $P7 = iter $P3

  build_sp_lp:
    unless $P7 goto end
    $S2 = shift $P7
    say $S1
    push $P2, $S2
    goto build_sp_lp

  end:
    set_hll_global ["Matrixy";"Grammar";"Actions"], "@?PATH", $P2

    .return()
.end

.namespace []

