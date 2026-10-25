#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Path::Tiny;
use Cwd;

my @INC_BACKUP = @INC;

my $dir = getcwd;
my $mydir = path(__FILE__)->parent->absolute;

my $missing = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

chdir($mydir);
unshift @INC, $missing;

eval 'use lib::absolute -hard';

like($@,qr/xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx of \@INC doesn't exist/,'Checking for -hard error');

like($@,qr/^\Q$mydir\E\/\Q$missing\E of \@INC doesn't exist \(\@INC entry '\Q$missing\E'\)/,'-hard error names the absolute path and the @INC entry it came from');

chdir($dir);
@INC = @INC_BACKUP;

done_testing;
