package Local::GetterSetter;

use strict;
use warnings;

=encoding utf8

=head1 NAME

Local::GetterSetter - getters/setters generator

=head1 VERSION

Version 1.00

=cut

our $VERSION = '1.00';

=head1 SYNOPSIS

    package Local::SomePackage;
    use Local::GetterSetter qw(x y);

    set_x(50);
    print our $x; # 50

    our $y = 42;
    print get_y(); # 42
    set_y(11);
    print get_y(); # 11

=cut

sub import {
        my ($selfpkg, @vars) = @_;
        my $pkg = caller;
        for my $var (@vars) {
                no strict 'refs';
                *{$pkg."::get_".$var} = sub {return  ${$pkg."::".$var}};
                *{$pkg."::set_".$var} = sub {${$pkg."::".$var} = shift}
        }
}       

1;
