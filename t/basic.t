#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Path::Tiny;
use Cwd;

my @INC_BACKUP = @INC;

my $dir = getcwd;
my $mydir = path(__FILE__)->parent->absolute;
my $mylib = path("lib")->parent->absolute;

chdir($mydir->parent);
unshift @INC, 't';
unshift @INC, '.';

eval 'use lib::absolute "lib"';

ok(grep { $_ eq $mydir } @INC, 'Checking for absolute t directory in @INC');
ok(grep { $_ eq '.' } @INC, 'Still having . in @INC');
ok(grep { $_ eq $mylib } @INC, 'Argument was added to @INC');

chdir($dir);
@INC = @INC_BACKUP;

done_testing;
