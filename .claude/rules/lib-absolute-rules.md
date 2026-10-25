# lib-absolute House Rules

The shared house rules come from skilletor — bundle `getty-cpan-dist@getty`: engineering
discipline, the delegation lock, the publish gate, karr coordination, CPAN release. They load
as `.claude/rules/.local.*.md`; if they are missing, run `skilletor sync` and publish nothing
until they load. This file adds what is true only here, and wins where it differs.

## What this repo is

Converts all paths in `@INC` to absolute paths — one module with one `import` method.

## Agent team

| Task | Agent |
|---|---|
| Implement / refactor / debug behavior-relevant code | `lib-absolute-worker` (default) |
| Commits, `Changes`, card → done, pre-release audit | `lib-absolute-release-manager` |
| Read-only research, audit, gap analysis | `lib-absolute-worker` ("read-only, change nothing") |

Behavior-relevant = anything in `lib/`, the tests, the import contract and the `-hard` mode.
`README.md` and `Changes` wording are not.

## Deviations from the house rules

- **No `our $VERSION` in the module.** The version is derived at release time from the tags
  (last `0.100`), not carried in the repo.
- **A public-issue topic becomes an internal card.**

## Hazards — the import contract is the product, don't regress it silently

- **The contract:** everything happens in `import`. A relative `@INC` entry becomes absolute,
  `.` stays **and** its absolute form is added as well, a reference entry passes through
  untouched, `-hard` aborts when a directory is missing. A change to any of that is
  user-visible: it needs a `Changes` entry and a test. Contract table: skill
  `lib-absolute-core`.
- **The green suite pins neither the `-hard` message nor the absolute form of `.`** — a
  behavioral change needs a test that pins it.
- **The module lives in `lib/lib/`** — the `lib` segment appears twice — and the conversion
  runs at import time, so it acts on `@INC` as it looked at that moment.
- **One module, one `import` method.** A second dependency, a class or a CLI needs a card that
  asks for it.

## Perl specifics — reference, don't restate

Module loading, cpanfile pinning for Getty-authored dependencies, POD conventions and house
style live in `getty-perl-core`, `getty-perl-pod` and `getty-perl-release-author-getty`. The
import contract, the `.` special case and the `lib/lib` trap live in `lib-absolute-core`.
