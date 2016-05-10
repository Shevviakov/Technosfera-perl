package Local::Iterator;

use strict;
use warnings;

use Moose;

sub all {
	my ($self) = @_;
	my @arr;
	my ($val, $end) = $self->next;
	while (!$end) {
		push @arr, $val;
		($val, $end) = $self->next;
	}
	return \@arr;
}

=encoding utf8

=head1 NAME

Local::Iterator - base abstract iterator

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

1;
