package Local::MusicLibrary::Printer;

use strict;
use warnings;

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

sub printTop {
	my ($colwidth, $fields) = @_;
	print "/";
	for (0..$#{$fields}) {
		print "-"x($$colwidth{$$fields[$_]}+2);
		unless ($_ == $#{$fields}) {print "-"}
	}
	print "\\\n";
}

sub printBottom {
	my ($colwidth, $fields) = @_;
	print "\\";
	for (0..$#{$fields}) {
		print "-"x($$colwidth{$$fields[$_]}+2);
		unless ($_ == $#{$fields}) {print "-"}
	}
	print "/\n";
}

sub printSeparator {
	my ($colwidth, $fields) = @_;	
	print "|";
	for (0..$#{$fields}) {
		print "-"x($$colwidth{$$fields[$_]}+2);
		unless ($_ == $#{$fields}) {print "+"}
	}
	print "|\n";
}


sub printer {
	my ($table, $colwidth, $fields) = @_;
	unless (@$table) {return};
	
	printTop ($colwidth, $fields);
	
	for my $line (0..$#{$table}) {
		for (0..$#{$fields}) {
			my $str = ${${$table}[$line]}{$$fields[$_]};
			print "| ".(" "x($$colwidth{$$fields[$_]}-length($str)))."$str ";
			if ($_ == $#{$fields}) {print "|\n"}
		}
		unless ($line == $#{$table}) {
			printSeparator($colwidth, $fields);
		}
	}
	
	printBottom ($colwidth, $fields)
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
