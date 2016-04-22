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
#use DDP;
use Data::Dumper;
use feature 'say';
#######

sub printTable {
	my ($libr, $opts) = @_;
	my @resultTable;
#make with for
#	print Dumper ($libr);
	my %colwidth;
	for (keys %$libr[0]) {$colwidth{$_} = 0}
	print Dumper ( %colwidth);

	for my $entry (@$libr) {
#		#p $$_{band};
#		print Dumper ($entry);
		my $nxt = "";
		for (keys %$entry) {
			if ($_ ne "year") { 
				if ($$opts{$_} and $$opts{$_} ne $$entry{$_}) {$nxt = 1; last;}
			} else {
				if ($$opts{$_} and $$opts{$_} != $$entry{$_}) {$nxt = 1; last;}
			}
		}
		
		if ($nxt) {next};
		push @resultTable, $entry;
		for (keys %$entry) {
			if (length $$entry{$_} > $colwidth{$_}) {$colwidth{$_} = length $$entry{$_}}
		}
	}
	print Dumper (%colwidth);
	
	if ($$opts{sort}) { 
			say "sort by $$opts{sort}";
			if ($$opts{sort} ne "year") { 
				@resultTable = sort {$$a{$$opts{sort}} cmp $$b{$$opts{sort}}} @resultTable
			} else {
				@resultTable = sort {$$a{$$opts{sort}} <=> $$b{$$opts{sort}}} @resultTable
			}
	}
	
	
	
	print Dumper (@resultTable);

}
1;
