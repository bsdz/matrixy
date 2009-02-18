
=head1 All Builtins

=head2 Purpose

This file is used to simplify the addition of new files to
the build without having to modify the makefile. This has
some benefits, but also prevents make from building a 
complete dependency tree. If you modify any of the files
included here, you must C<make clean> first, and then 
C<make>. 

=end

=cut

.include 'src/builtins/stdio.pir'
.include 'src/builtins/math.pir'
.include 'src/builtins/system.pir'