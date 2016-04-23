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

sub processResult {
	my ($libr, $resultTable, $opts, $colwidth) = @_;
	for my $entry (@$libr) {
		my $nxt = "";
		for (keys %$entry) {
			if ($_ ne "year") { 
				if ($$opts{$_} and $$opts{$_} ne $$entry{$_}) {$nxt = 1; last;}
			} else {
				if ($$opts{$_} and $$opts{$_} != $$entry{$_}) {$nxt = 1; last;}
			}
		}
		
		if ($nxt) {next};
		push @$resultTable, $entry;
		for (keys %$entry) {
			if (length $$entry{$_} > ${$colwidth}{$_}) {${$colwidth}{$_} = length $$entry{$_}}
		}
	}
}

sub printer {
	my ($table, $colwidth, $fields) = @_;
	unless (@$table) {return};
	print "/";
	for (0..$#{$fields}) {
		print "-"x($$colwidth{$$fields[$_]}+2);
		unless ($_ == $#{$fields}) {print "-"}
	}
	print "\\\n";
	
	for my $line (0..$#{$table}) {
		for (0..$#{$fields}) {
			my $str = ${${$table}[$line]}{$$fields[$_]};
			print "| ".(" "x($$colwidth{$$fields[$_]}-length($str)))."$str ";
			if ($_ == $#{$fields}) {print "|\n"}
		}
		unless ($line == $#{$table}) {
			print "|";
			for (0..$#{$fields}) {
				print "-"x($$colwidth{$$fields[$_]}+2);
				unless ($_ == $#{$fields}) {print "+"}
			}
			print "|\n";
		}
	}
	
	print "\\";
	for (0..$#{$fields}) {
		print "-"x($$colwidth{$$fields[$_]}+2);
		unless ($_ == $#{$fields}) {print "-"}
	}
	print "/\n";
}

sub printTable {
	my ($libr, $opts) = @_;
	my @resultTable;

	#initializing the array of columns result width
	my %colwidth;
	for (keys %{${$libr}[0]}) {$colwidth{$_} = 0}

	#making resultTable	
	processResult($libr, \@resultTable, $opts, \%colwidth);
	
	#sorting resultTable if needed
	if ($$opts{sort}) { 
			if ($$opts{sort} ne "year") { 
				@resultTable = sort {$$a{$$opts{sort}} cmp $$b{$$opts{sort}}} @resultTable
			} else {
				@resultTable = sort {$$a{$$opts{sort}} <=> $$b{$$opts{sort}}} @resultTable
			}
	}
	
	#printing resultTable
	if ($$opts{columns}) {
		unless (@{${$opts}{columns}}) {return}
		printer (\@resultTable, \%colwidth, $$opts{columns})
	} else {
		printer (\@resultTable, \%colwidth, ["band", "year", "album", "track", "format"]);
	}
	

}
1;
