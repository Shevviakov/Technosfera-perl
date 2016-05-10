package Local::Iterator::Aggregator;

use strict;
use warnings;

use Moose;

extends 'Local::Iterator';

has 'iterator' => (
	is 		=> 'ro',
	required	=> 1
);

has 'chunk_length' => (
	is		=> 'ro',
	isa		=> 'Int',
	required	=> 1
);

sub next {
	my ($self) = @_;
	my @arr;
	for (1..$self->chunk_length) {
		my ($val, $end) = $self->iterator->next;
		if (!$end) {push @arr, $val}
		else {last}
	}
	if (@arr) {return (\@arr, 0)}
	else {return (undef, 1)}
}

=encoding utf8

=head1 NAME

Local::Iterator::Aggregator - aggregator of iterator

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Aggregator->new(
        chunk_length => 2,
        iterator => $another_iterator,
    );

=cut

1;
