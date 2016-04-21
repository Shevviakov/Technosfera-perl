package Local::MusicLibrary;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::MusicLibrary - core music library module

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

=cut

use Exporter 'import';
our @EXPORT_OK = qw(parseEntry printTable);

sub parseEntry {
	my ($str) = @_;
	$str =~ m{^[.]/(?<band>\w+)/(?<year>\d+)\s[-]\s(?<album>\w+)/(?<track>\w+)[.](?<format>\w+)$};
	my %entry = (
		band	=> $+{band},
		year	=> $+{year},
		album 	=> $+{album},
		track	=> $+{track},
		format	=> $+{format} );
	return \%entry;
}

########
use DDP;
#######

sub printTable {
	my ($libr, $opts) = @_;
	my @resultTable;
#make with for
	my %colWidth = (
                band   => 0,
                year    => 0,
                album   => 0,
                track   => 0,
                format  => 0 );

	for (@$libr) {
		#p $$_{band};
#make with for
		if ($$opts{band} and $$opts{band} ne $$_{band}) {next}
		if ($$opts{album} and $$opts{album} ne $$_{album}) {next}
		if ($$opts{track} and $$opts{track} ne $$_{track}) {next}
		if ($$opts{format} and $$opts{format} ne $$_{format}) {next}
		if ($$opts{band} and $$opts{band} ne $$_{band}) {next}
		push @resultTable, $_;
	}
	p @resultTable;
}
1;
