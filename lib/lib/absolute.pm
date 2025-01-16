package lib::absolute;
# ABSTRACT: Convert all paths in @INC to absolute paths

use strict;
use warnings;
use Path::Tiny;
use lib ();

sub import {
	my ( $self, @args ) = @_;
	my $hard = grep { $_ eq '-hard' } @args;
	lib->import( grep { $_ ne '-hard' } @args );
	@INC = map {
		if (ref $_) {
			$_;
		} else {
			my $dir = path($_)->absolute;
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

  use lib::absolute 'lib'; # adds the given path before converting @INC

  use lib::absolute -hard, 'lib'; # both can be combined

=head1 DESCRIPTION

This package converts on load all your @INC path into absolute paths, if you have "." in your path, it gets additionally
added again (and also get added as absolute path).

Any arguments that are not -hard will be added to the @INC path before converting it to absolute paths.

=head1 SUPPORT

IRC

  Join #perl-help on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-lib-absolute
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-lib-absolute/issues


