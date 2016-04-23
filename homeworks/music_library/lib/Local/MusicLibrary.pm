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

use Local::MusicLibrary::Parser;
use Local::MusicLibrary::Printer;

use Exporter 'import';
our @EXPORT_OK = qw(parseEntry printTable);

sub parseEntry {
	goto &Local::MusicLibrary::Parser::parse;
}

sub printTable {
	goto &Local::MusicLibrary::Printer::printTable;
}
1;
