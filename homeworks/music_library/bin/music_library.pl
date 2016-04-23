#!/usr/bin/env perl

use strict;
use warnings;

use FindBin '$Bin';
use lib "$Bin/../lib";

use Local::MusicLibrary qw(parseEntry printTable);
use Getopt::Long;

#taking parameters from command line
my %opts;
GetOptions (
	'band=s'	=> \$opts{band},
	'year=s'	=> \$opts{year},
	'album=s'	=> \$opts{album},
	'track=s'	=> \$opts{track},
	'format=s'	=> \$opts{format},
	'sort=s'	=> \$opts{sort},
	'columns=s@'	=> \$opts{columns} );
if ($opts{columns}) {@{$opts{columns}} = split (/,/, join (',', @{$opts{columns}}))}

#reading STDIN
my @libr;
while (<>) {
	push @libr, parseEntry($_);
}

#printing result
printTable (\@libr, \%opts);
