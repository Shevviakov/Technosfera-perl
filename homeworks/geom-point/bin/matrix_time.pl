#!/usr/bin/perl

use strict;
use warnings;
use v5.10;

use FindBin;
use lib "$FindBin::Bin/../lib/";
use Local::perlxs;
use Time::HiRes;

use DDP;

sub matrix_multiply {
	my ($mtx1, $mtx2) = @_;
	my $ans = [];
	for my $i (0..$#{$mtx1}) {
		my $row = [];
		for my $j (0..$#{$$mtx2[0]}){
			my $value = 0;
			for my $k (0.. $#{$mtx2}) {
				$value += $$mtx1[$i][$k] * $$mtx2[$k][$j];
			}
			push $row, $value;
		}
		push $ans, $row;
	}
	return $ans;
}


open (my $fh1, '<', 'matrix1.dat');
open (my $fh2, '<', 'matrix2.dat');

my $AoA1 = []; 
my $AoA2 = [];

while(<$fh1>) {
	my @tmp = (split ' ', $_); 
	push $AoA1, \@tmp
}

while(<$fh2>) {
	my @tmp = (split ' ', $_); 
	push $AoA2, \@tmp
}

my $start;
my $var;

$start = Time::HiRes::time;
$var = Local::perlxs::matrix_multiply($AoA1, $AoA2);
say "Perl::XS: ", (Time::HiRes::time - $start);

$start = Time::HiRes::time;
$var = matrix_multiply($AoA1, $AoA2);
say "Clear Perl: ", (Time::HiRes::time - $start);
