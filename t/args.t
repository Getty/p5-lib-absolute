#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Path::Tiny;
use Cwd;

my @INC_BACKUP = @INC;
my $dir = getcwd;

my $tmp = Path::Tiny->tempdir;
$tmp->child('mylib')->mkpath;
chdir($tmp);
my $mylib = path('mylib')->absolute->stringify;

subtest 'an argument is added to @INC and converted' => sub {
  eval 'use lib::absolute "mylib"; 1' or die $@;
  is($INC[0], $mylib, 'the argument leads @INC as an absolute path');
  ok(!(grep { $_ eq 'mylib' } @INC), 'the relative form is gone');
  @INC = @INC_BACKUP;
};

subtest '-hard and an existing argument combine' => sub {
  @INC = grep { !ref && -d } @INC_BACKUP;
  ok(eval 'use lib::absolute -hard, "mylib"; 1', 'the import succeeds') or diag $@;
  is($INC[0], $mylib, 'the argument leads @INC');
  ok(!(grep { $_ eq '-hard' } @INC), '-hard is never added to @INC');
  @INC = @INC_BACKUP;
};

subtest '-hard rejects a missing argument' => sub {
  @INC = grep { !ref && -d } @INC_BACKUP;
  ok(!eval 'use lib::absolute -hard, "missing-dir"; 1', 'the import fails');
  like($@, qr/^\Q$tmp\E\/missing-dir of \@INC doesn't exist \(\@INC entry 'missing-dir'\)/,
    'the error names the argument');
  @INC = @INC_BACKUP;
};

chdir($dir);
@INC = @INC_BACKUP;

done_testing;
