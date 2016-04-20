=head1 DESCRIPTION

Эта функция должна принять на вход ссылку на массив, который представляет из себя обратную польскую нотацию,
а на выходе вернуть вычисленное выражение

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

sub evaluate {
	my $rpn = shift;
	my $value;
	my @stck;

	for (@$rpn) {
		given ($_) {
			when (/\d+/) {push @stck, $_}
			when (/^U-$/) {$stck[-1] = -$stck[-1]}
			when (/^U\+$/) {$stck[-1] = +$stck[-1]}
			when (/^\^$/) {my ($y, $x) = (pop @stck, pop @stck); push @stck, ($x**$y) }
			when (/^\*$/) {my ($y, $x) = (pop @stck, pop @stck); push @stck, ($x*$y) }
			when (/^\/$/) {my ($y, $x) = (pop @stck, pop @stck); push @stck, ($x/$y) }
			when (/^\-$/) {my ($y, $x) = (pop @stck, pop @stck); push @stck, ($x-$y) }
			when (/^\+$/) {my ($y, $x) = (pop @stck, pop @stck); push @stck, ($x+$y) }
		}
	}
	
	$value = shift @stck;

	return $value;
}

1;
