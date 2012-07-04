package lib::absolute;
# ABSTRACT: Convert all paths in @INC to absolute paths

use strict;
use warnings;
use Path::Class;

sub import {
	my ( $self, @args ) = @_;
	my $hard = grep { $_ eq '-hard' } @args;
	@INC = map {
		if (ref $_) {
			$_;
		} else {
			my $dir = dir($_)->absolute;
			if ($hard) {
				die $dir.' of @INC doesn\'t exist' unless -d $dir;
			}
			$dir->stringify, $_ eq '.' ? '.' : ();
		}
	} @INC;
	return;
}

1;
