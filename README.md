# lib::absolute

Convert all paths in `@INC` to absolute paths.

## Synopsis

```perl
use lib::absolute;

use lib::absolute -hard;          # dies on non-existing directories

use lib::absolute 'lib';          # adds the given path before converting @INC

use lib::absolute -hard, 'lib';   # both can be combined
```

## Description

`lib::absolute` converts every path in `@INC` into an absolute path when it is
loaded, so a later `chdir` cannot change what a relative entry points to. If
`.` is in `@INC`, it stays there and its absolute form is added as well.
Reference entries in `@INC` (code refs, objects) pass through untouched.

## Usage

### Make `@INC` absolute

```perl
use lib::absolute;
```

### Abort on missing directories

```perl
use lib::absolute -hard;
```

With `-hard` a missing directory aborts the import. The error names the
absolute path that does not exist and the `@INC` entry it came from. This
covers the directories given as arguments, too.

### Add directories first

```perl
use lib::absolute 'lib', 'local/lib/perl5';
```

Every argument other than `-hard` is added to `@INC` exactly as `use lib`
would add it, and is then converted together with the rest.

## Installation

```bash
cpanm lib::absolute
```

## Support

- Repository: <https://github.com/Getty/p5-lib-absolute>
- Issues: <https://github.com/Getty/p5-lib-absolute/issues>
- IRC: `#perl-help` on irc.perl.org

## License

This software is copyright (c) 2012-2025 by Torsten Raudssus
<torsten@raudssus.de>.

This is free software; you can redistribute it and/or modify it under the
same terms as the Perl 5 programming language system itself.
