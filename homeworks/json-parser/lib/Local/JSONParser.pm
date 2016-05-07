package Local::JSONParser;

use strict;
use warnings;
use base qw(Exporter);
our @EXPORT_OK = qw( parse_json );
our @EXPORT = qw( parse_json );

sub parse_json {
	my $source = shift;

	my $ans;
	my $JSON = qr /
		(?: (?&OBJECT) | (?&ARRAY) )(?{ $ans = $^R->[1] })
		(?(DEFINE)
			(?<VALUE>
				\s*( (?&OBJECT) | (?&ARRAY) | (?&NUMBER) | (?&STRING) 
					| true (?{ [$^R, 1] })
					| false (?{ [$^R, ""] })
					| null (?{ [$^R, undef] })
				)\s*
				
			)
			(?<OBJECT>
				\{\s* (?{ [$^R, {}] })
				(?: (?&KEYVALUE) #[[$^R, {}], "string", value]
					(?{ [$^R->[0][0], {$^R->[1] => $^R->[2]}] })
				 )?
				(?> \s*,\s* (?&KEYVALUE)
					(?{ $^R->[0][1]{$^R->[1]} = $^R->[2]; $^R->[0] })
				)*
				\s*\}
			)
			(?<KEYVALUE>
				(?&STRING) #[$^R, "string"]
				\s* : \s* (?&VALUE) #[[$^R, "string"], value]
				(?{ [$^R->[0][0], $^R->[0][1], $^R->[1]] })
			)
			(?<ARRAY>
				\[\s* (?{ [$^R, []] })
				((?&VALUE) #[[$^R, []], value]
				(?{ [$^R->[0][0], [$^R->[1]]] }))? \s*
				
				(?: ,\s* (?&VALUE) (?{ push @{$^R->[0][1]}, $^R->[1]; $^R->[0] }) )*
				\s* \]
			)
			(?<STRING>
				(" (?: \\["\/bnfrt] | \\u\d{4} | [^"\\] )* ")
				(?{my $str = $^N; $str =~ s{\\u(\d{4})}(\\x\{$1\})g; [$^R, eval $str ] })
			)
			(?<NUMBER>
				( -?\d+(?:\.\d+)? (?:[eE][-+]?\d+)? )
				(?{ [$^R, 0+$^N] })
			)
		)
	/x;

	use JSON::XS;
	
	unless ($source =~ $JSON) {die "incorrect JSON";}
	
	# return JSON::XS->new->utf8->decode($source);
	return $ans;
}

1;
