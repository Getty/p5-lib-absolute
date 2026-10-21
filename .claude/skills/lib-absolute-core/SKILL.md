---
name: lib-absolute-core
description: "Load before editing lib-absolute — the @INC-absolute-path distribution: one module (lib::absolute), the import contract that rewrites @INC, the '.', the coderef and the '-hard' rules, and the trap that the module lives in lib/lib."
---

# lib::absolute — core

A one-purpose module: at import time it rewrites every entry of `@INC` into an
absolute path, so that later `chdir` calls cannot change what a relative `@INC`
entry points to.

The distribution is called `lib-absolute`, the module is `lib::absolute`, and it
ships **one module and three test files**:

| File | Role |
|---|---|
| `lib/lib/absolute.pm` | the whole implementation — one `import` method, no classes, no functions to call |
| `t/load.t` | load test — `use_ok('lib::absolute')` |
| `t/basic.t` | pins the conversion: relative entries become absolute, `.` stays |
| `t/hard.t` | pins the `-hard` mode: a missing `@INC` directory aborts the import |

There is no CLI, no `bin/`, no other module. If a change touches anything but
`lib/lib/absolute.pm`, it is probably not this distribution.

## The import contract

Everything the module does happens in `import`. There is no other public
interface — no `->new`, no exported function, no attribute.

```perl
use lib::absolute;         # convert every @INC entry
use lib::absolute -hard;   # same, but abort when a directory is missing
```

`import` receives the import arguments (`-hard` is the only one understood) and
then rewrites `@INC` in place:

| `@INC` entry | becomes |
|---|---|
| a plain relative path (`t`, `lib`, `foo/bar`) | its absolute path, resolved against the **current working directory at import time** |
| `.` | the absolute path of the cwd **and** `.` itself — both entries, in that order |
| a non-plain scalar (a coderef, a `File::Spec` object) | passed through unchanged |

Two rules deserve their own attention:

- **The `.` special case is deliberate.** The pod says: "if you have `.` in your
  path, it gets additionally added again (and also get added as absolute path)".
  So `use lib::absolute` turns `.` into *two* entries: the absolute cwd and the
  literal `.`. That is the documented behaviour, not a bug — but it means a
  caller can find the same directory twice in `@INC`, and a fix that collapses
  the two changes the contract.
- **The `ref` check is the escape hatch.** `@INC` may hold coderefs and other
  references; `path($_)` would stringify them into nonsense. The `ref $_` branch
  keeps them untouched.

## The `-hard` mode

`-hard` turns a missing directory into a fatal error:

```perl
die $dir.' of @INC doesn\'t exist' unless -d $dir;
```

`-hard` is the mode for build and deploy tooling, where a `@INC` entry pointing
at a non-existent directory must not be silently tolerated — it would surface
much later as a confusing "Can't locate Foo.pm" instead of the real cause.

The current message names the **absolute path** that was missing but not the
`@INC` entry it came from, and it does not say which mode failed. Whoever
touches the message has to keep it fatal and has to keep it inside `import`.

## The trap: the module lives in `lib/lib/`

`lib::absolute` is installed as `lib/lib/absolute.pm` — the path has a `lib`
segment twice. Two consequences:

1. `use lib::absolute;` finds the module through the **`lib`** entry of `@INC`,
   not through a `lib/lib` entry. Nothing else needs to be on `@INC`.
2. The module **converts its own `@INC` entries while it is being loaded**. The
   `use lib::absolute` statement runs `import` *after* the module is compiled,
   so the conversion applies to whatever `@INC` looked like at that moment —
   including the entries the caller added before the `use`.

Anything that wants to *observe* the converted `@INC` has to look at it after
the `use lib::absolute` statement. A test that checks `@INC` from inside the
module sees the pre-conversion state.

## Tests

- `t/load.t` — the module loads. Nothing more.
- `t/basic.t` — the contract: a relative entry becomes absolute, `.` survives.
- `t/hard.t` — the `-hard` contract: a missing directory aborts the import.

`basic.t` and `hard.t` both `chdir` and both mutate the global `@INC`; they
restore both at the end (`chdir($dir)`, `@INC = @INC_BACKUP`). A new test that
touches `@INC` or the working directory has to restore them the same way, or it
breaks the tests that run after it.

The `eval 'use lib::absolute'` in both files is deliberate: the import has to be
observed *inside* an `eval`, because the import dies in `-hard` mode.

Note what the tests do **not** pin: the exact wording of the `-hard` error, and
the absolute form of `.` (only that `.` is still present). A change to the
message or to the `.` handling is therefore invisible to the suite — that is a
gap, not a licence to change it.

Run with `prove -lr t/` or `dzil test`.

## Distribution conventions

- `dist.ini` uses `[@Author::GETTY]`, so the POD follows that bundle's shortcut
  commands (`=synopsis`, `=description`, `=seealso`) and every file carries a
  `# ABSTRACT:` line. The module has one.
- `dist.ini` still carries its prerequisites in a `[Prereqs]` block. The house
  standard is a `cpanfile` — see `getty-perl-core`.
- The CPAN name is `lib-absolute`; the repo is `p5-lib-absolute`.
- The package name `lib::absolute` is lowercase, unlike almost every other Perl
  distribution. It is the shipped name and cannot be changed without breaking
  every caller that does `use lib::absolute`.
- The distribution has **no** `Changes` file and **no** `README.md` yet; the
  `Changes` file starts with the current work, not with a historical release
  list. See `getty-perl-release-author-getty` for how the version is derived.
