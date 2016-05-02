package Local::JSONParser;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );

sub parse_json {
	my $source = shift;
	
	my $value;
	my $string = qr l"(?:\\["/bfnrt]|\\\\|u\d{4}|[^"\\])*"l;
	my $number = qr l-?\d+(?:\.\d+)*(?:[eE][-+]?\d+)*l;
	my $object = qr /\{(?:\s*$string\s*:\s*$value\s*)?(?:,\s*$string\s*:\s*$value\s*)*\}/;
	my $array = qr /\[(?:\s*$value\s*)?(?:,\s*$value\s*)*\]/;
	$value = qr /$string|$number|$object|$array|true|false|null/;

	use JSON::XS;
	
	# return JSON::XS->new->utf8->decode($source);
	return {};
}

1;
