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

sub priority {
	my $op = shift;
	given ($op) {
		when (/^U[-+]$/) {return 3}
		when (/^\^$/) {return 3}
		when (m{^[*/]$}) {return 2}
		when (/^[-+]$/) {return 1}
		when (/^[()]$/) {return 0}
	}
	
}

sub rpn {
	my $expr = shift;
	my $source = tokenize($expr);
	my @rpn;

	my @stck;

	for (@$source) {
		if (/\d+/) {push @rpn, $_; next}
		if (/^\($/) {push @stck, $_; next}
		if (/^\)$/) {while (@stck and $stck[-1] ne '(') {push @rpn, pop @stck} pop @stck; next}
		while (@stck and priority($stck[-1]) >= priority($_)) {
			if (priority($stck[-1]) == priority ($_) and priority($_) > 2) {last} #right... ops condition
			push @rpn, pop @stck;
		}
		push @stck, $_;
	}
	while (@stck) {push @rpn, pop @stck}
	# ...
	
	return \@rpn;
}

1;
