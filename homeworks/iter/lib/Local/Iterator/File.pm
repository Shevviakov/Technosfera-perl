package Local::Iterator::File;

use strict;
use warnings;

use Moose;

extends 'Local::Iterator';

has 'filename' => (
	is	=> 'ro',
	isa	=> 'Str'
);

has 'fh' => (
	is 	=> 'ro',
	isa	=> 'FileHandle',
	lazy	=> 1,
	default	=> sub {
		my ($self) = @_;
		my $fh;
		open ($fh, '<', $self->filename) if $self->filename;
		return $fh;
	}
);

sub next {
	my ($self) = @_;
	my $fh = $self->fh;
	my $line;
	if ($line = <$fh>) {chomp $line; return ($line, 0)}
	else {return (undef, 1)}
}

=encoding utf8

=head1 NAME

Local::Iterator::File - file-based iterator

=head1 SYNOPSIS

    my $iterator1 = Local::Iterator::File->new(filename => '/tmp/file');

    open(my $fh, '<', '/tmp/file2');
    my $iterator2 = Local::Iterator::File->new(fh => $fh);

=cut

1;
