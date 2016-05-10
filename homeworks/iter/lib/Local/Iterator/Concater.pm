package Local::Iterator::Concater;

use strict;
use warnings;

use Moose;

extends 'Local::Iterator';

has 'iterators' => (
	is		=> 'ro',
	isa 		=> 'ArrayRef',
	required	=> 1
);

has 'iter' => (
	is	=> 'rw',
	isa	=> 'Int',
	default	=> 0
);
	
has 'pos' => (
	is	=> 'rw',
	isa 	=> 'Int',
	default	=> 0
);

sub next {
	my ($self) = @_;
	my ($val, $end) = ${$self->iterators}[$self->iter]->next;
	if (!$end) {return ($val, 0)}
	else {
		if ($self->iter < $#{$self->iterators}) {
			$self->iter($self->iter+1);
			return $self->next;
		} else {
			return (undef, 1);
		}
	}
}

=encoding utf8

=head1 NAME

Local::Iterator::Concater - concater of other iterators

=head1 SYNOPSIS

    my $iterator = Local::Iterator::Concater->new(
        iterators => [
            $another_iterator1,
            $another_iterator2,
        ],
    );

=cut

1;
