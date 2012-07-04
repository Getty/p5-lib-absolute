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

=encoding utf8

=head1 SYNOPSIS

  use lib::absolute;

  use lib::absolute -hard; # crashs on non existing directories

=head1 DESCRIPTION

This package converts on load all your @INC path into absolute paths, if you have "." in your path, it gets additionally
added again (and also get added as absolute path).

=head1 SUPPORT

IRC

  Join #perl-help on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-lib-absolute
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-lib-absolute/issues


