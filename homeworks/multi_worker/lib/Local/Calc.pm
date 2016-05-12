use v5.10;
use feature 'switch';
package Local::Calc;
no warnings;

sub tokenize {
	chomp(my $expr = shift);
	my @res;
	
	@res = ($expr =~ /[*^]|[-+]|[\/]|[(]|[)]|\d*[.]?\d(?:[eE][-+]?\d+)?/g);
	
	for (0..$#res) { #string processing
	
		#Unary operators processing
		if ($res[$_] =~ /^[-+]$/ and (!$_ or $res[$_-1] =~ m{^(?:[-+*^/(]|U[-+])$})) {$res[$_] = 'U'.$res[$_];}
		}

	for (0..$#res) {
		
		#Is unary operators correct?
		if ($res[$_] =~ /^U[-+]$/ and ($_ == $#res or $res[$_+1] =~ m|^[-+*^/)]$|)) {die "Not a number after unary operator (".($_+2)." element of expression)"}

		#Numbers processing
		if ($res[$_] =~ /\d*[.]?\d+(?:[eE][-+]?\d+)?/) {
			$res[$_] += 0;
			if (($_ != $#res and $res[$_+1] =~ /\d/) or ($_ and $res[$_-1] =~ /\d/)) {die "Too many operands but no operators ($_ element)"}
		} 

		#Is binary operators correct?
		if ($res[$_] =~ m|^[-+*^/]$| and ($_ == $#res or $res[$_+1] !~ /\(|\d|U[-+]/) and ($_ == 0 or $res[$_-1] =~ /\)|\d/)) {die "Binary operator has less then 2 operands (".($_+1)." element)"} 

	}

	return \@res;
}

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
