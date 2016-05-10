package Local::Iterator::Interval;

use strict;
use warnings;

use Moose;

extends 'Local::Interval';

has 'step' => (
	is 	 => 'ro',
	required => 1
);

has 'length' => (
	is => 'ro'
);

has 'cur' => (
	is 	=> 'rw',
	lazy 	=> 1,
	default	=> sub {
		my ($self) = @_;
		return $self->from;
	}
);

sub next {
	my ($self) = @_;
	if ($self->length) {
		if (DateTime->compare($self->to, $self->cur+$self->length) >=0) {
			my $answer = Local::Interval->new (
				from => $self->cur,
				to => ($self->cur+$self->length)
			);
			$self->cur ($self->cur+$self->step);
			return ($answer, 0);
		} else {
			return (undef, 1);
		}
	} else {
		if (DateTime->compare($self->to, $self->cur+$self->step) >=0) {
			my $answer = Local::Interval->new (
				from => $self->cur,
				to => ($self->cur+$self->step)
			);
			$self->cur ($self->cur+$self->step);
			return ($answer, 0);
		} else {
			return (undef, 1);
		}
	}
}

=encoding utf8

=head1 NAME

Local::Iterator::Interval - interval iterator

=head1 SYNOPSIS

    use DateTime;
    use DateTime::Duration;

    my $iterator = Local::Iterator::Interval->new(
      from   => DateTime->new('...'),
      to     => DateTime->new('...'),
      step   => DateTime::Duration->new(seconds => 25),
      length => DateTime::Duration->new(seconds => 35),
    );

=cut

1;
