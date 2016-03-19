=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, содержащий обратную польскую нотацию
Один элемент массива - это число или арифметическая операция
В случае ошибки функция должна вызывать die с сообщением об ошибке

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
use feature "switch";
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';
use FindBin;
require "$FindBin::Bin/../lib/tokenize.pl";

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @rpn;
	
	my @stck;

	for (@$source) {
		given ($_) {
			when (/^U[-+]$/) {push @stck, $_}
			when (/^\^$/) {
				while (@stck and $stck[-1] =~ /^U[-+]$/) {
					push @rpn, pop (@stck)
				}
				push @stck, $_
			}
			when (m{^[*/]$}) {
				while (@stck and $stck[-1] =~ m{U[-+]|[*/]}) {
					push @rpn, pop @stck
				}
				push @stck, $_
			}
			when (/^[-+]$/) {
				while (@stck and $stck[-1] =~ m{^(?:U[-+]|[*/]|[-+])$}) {
					push @rpn, pop @stck
				} 
				push @stck, $_
			}
			when (/^\($/) {push @stck, $_}
			when (/^\)$/) {while ($stck[-1] ne "(") {push @rpn, pop@stck} pop@stck}
			when (/\d+/) {push @rpn, $_}
		}
	}
	
	while (@stck) {push @rpn, pop @stck}
	# ...
	
	return \@rpn;
}

1;
