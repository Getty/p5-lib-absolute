package lib::absolute;
# ABSTRACT: Convert all paths in @INC to absolute paths

use strict;
use warnings;
use Carp qw( croak );
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

  use lib::absolute 'lib'; # adds the given path before converting @INC

  use lib::absolute -hard, 'lib'; # both can be combined

=head1 DESCRIPTION

This package converts on load all your @INC path into absolute paths, if you have "." in your path, it gets additionally
added again (and also get added as absolute path).

Any argument other than C<-hard> is a directory that gets added to C<@INC>
first, exactly as C<use lib> would add it, and is then converted together
with the rest.

With C<-hard> a missing directory aborts the import. The error names the
absolute path that does not exist and the C<@INC> entry it came from. This
covers the directories given as arguments, too.

=head1 SUPPORT

IRC

  Join #perl-help on irc.perl.org. Highlight Getty for fast reaction :).

Repository

  http://github.com/Getty/p5-lib-absolute
  Pull request and additional contributors are welcome
 
Issue Tracker

  http://github.com/Getty/p5-lib-absolute/issues


