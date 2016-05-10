package Local::Iterator::Array;

use strict;
use warnings;

use Moose;

extends 'Local::Iterator';

has 'array' => (
	is		=> 'ro',
	isa		=> 'ArrayRef',
	required 	=> 1
);

has 'pos' => (
	is 	=> 'rw',
	isa 	=> 'Int',
	default => 0
);

sub next {
	my ($self) = @_;
	if ($self->pos <= $#{$self->array}) {
		my $val = ${$self->array}[$self->pos];
		$self->pos($self->pos+1);
		return ($val, 0);
	}
	else {return (undef, 1)}
}

=encoding utf8

=head1 NAME

Local::Iterator::Array - array-based iterator

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Array->new(array => [1, 2, 3]);

=cut

1;
