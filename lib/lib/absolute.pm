package lib::absolute;
# ABSTRACT: Convert all paths in @INC to absolute paths

use strict;
use warnings;
use Carp qw( croak );
use Path::Tiny;

sub import {
	my ( $self, @args ) = @_;
	my $hard = grep { $_ eq '-hard' } @args;
	@INC = map {
		if (ref $_) {
			$_;
		} else {
			my $dir = path($_)->absolute;
			if ($hard) {
				croak $dir.' of @INC doesn\'t exist (@INC entry \''.$_.'\')' unless -d $dir;
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

With C<-hard> a missing directory aborts the import. The error names the
absolute path that does not exist and the C<@INC> entry it came from.

=head1 SUPPORT

IRC

  Join #perl-help on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-lib-absolute
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-lib-absolute/issues


