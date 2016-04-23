package Local::MusicLibrary::Parser;

use strict;
use warnings;

sub parse {
        my ($str) = @_;
        $str =~ m{^[.]/(?<band>\w+)/(?<year>\d+)\s[-]\s(?<album>\w+)/(?<track>\w+)[.](?<format>\w+)$};
        my %entry = (
                band    => $+{band},
                year    => $+{year},
                album   => $+{album},
                track   => $+{track},
                format  => $+{format} );
        return \%entry;
}

1;
