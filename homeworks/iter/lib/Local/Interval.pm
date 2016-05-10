package Local::Interval;

use strict;
use warnings;

use Moose;

use DateTime;
use DateTime::Duration;

has 'from' => (
        is => 'ro'
);

has 'to' => (
        is => 'ro'
);

=encoding utf8

=head1 NAME

Local::Interval - time interval

=head1 SYNOPSIS

    my $interval = Local::Interval->new('...');

    $interval->from(); # DateTime
    $interval->to(); # DateTime

=cut

1;

