=head1 DESCRIPTION

Эта функция должна принять на вход арифметическое выражение,
а на выходе дать ссылку на массив, состоящий из отдельных токенов.
Токен - это отдельная логическая часть выражения: число, скобка или арифметическая операция
В случае ошибки в выражении функция должна вызывать die с сообщением об ошибке

Знаки '-' и '+' в первой позиции, или после другой арифметической операции стоит воспринимать
как унарные и можно записывать как "U-" и "U+"

Стоит заметить, что после унарного оператора нельзя использовать бинарные операторы
Например последовательность 1 + - / 2 невалидна. Бинарный оператор / идёт после использования унарного "-"

=cut

use 5.010;
use strict;
use warnings;
use diagnostics;
BEGIN{
	if ($] < 5.018) {
		package experimental;
		use warnings::register;
	}
}
no warnings 'experimental';

sub tokenize {
	chomp(my $expr = shift);
	my @res;
	
	@res = ($expr =~ /[*^]|[-+]|[\/]|[(]|[)]|\d*[.]?\d(?:[eE][-+]?\d+)?/g);
	
	for (0..$#res) { #string processing
	
		#Unary operators processing
		if ($res[$_] =~ /^[-+]$/ and (!$_ or $res[$_-1] =~ m|^[-+*^/(]|)) {$res[$_] = 'U'.$res[$_];}

		#Is unary operators correct?
		if ($res[$_] =~ /^U[-+]$/ and ($_ == $#res or $res[$_+1] =~ m|[-+*^/)]|)) {die "Not a number after unary operator (".($_+2)." element of expression)"}

		#Numbers processing
		if ($res[$_] =~ /\d*[.]?\d+(?:[eE][-+]?\d+)?/) {
			$res[$_] += 0;
			if (($_ != $#res and $res[$_+1] =~ /\d/) or ($_ and $res[$_-1] =~ /\d/)) {die "Too many operands but no operators ($_ element)"}
		} 

		#Is binary operators correct?
		if ($res[$_] =~ m|^[-+*^/]$| and (($_ == $#res or $res[$_+1] !~ /\(|\d|\U[-+]/) or (!$_ or $res[$_-1] !~ /\)|\d/))) {die "Binary operator has less then 2 operands (".($_+1)." element)"} 

	}

	return \@res;
}

1;
