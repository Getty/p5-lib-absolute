# lib-absolute

Makes every path in `@INC` absolute at import time, so that a later `chdir` cannot
change what a relative `@INC` entry points to. One module — `lib::absolute` — with a
single `import` method: `use lib::absolute` converts, `use lib::absolute -hard`
converts and aborts when a directory is missing.

Released to CPAN as `lib-absolute`, built with `Dist::Zilla` via `[@Author::GETTY]`.

The import contract, the `.` special case and the `lib/lib` trap live in skill
`lib-absolute-core` — they are not repeated here.

## Delegation

Delegate behavior-relevant code to the right agent instead of touching it yourself —
the principle is the shared rule `getty-agent-delegation` (skilletor bundle
`getty-cpan-dist@getty`); lanes and hazards are in `.claude/rules/lib-absolute-rules.md`.

| Task | Agent |
|---|---|
| Implement / refactor / debug behavior-relevant code | `lib-absolute-worker` (default) |
| Commits, `Changes`, card → done, pre-release audit | `lib-absolute-release-manager` |

The agents carry their skills via `briefing.skills` (see `.claude/agents/`); the main
agent delegates rather than loading them. Skill sources live under `.claude/skills/` —
`getty-perl-core`, `getty-perl-pod` and the karr skills are installed from the shared
sources; `lib-absolute-core` is owned by this repo.

Work is coordinated on the repo's `karr` board (`karr board`).

## State of the code

The module carries `our $VERSION`; `[@Author::GETTY]` rewrites it at release through
`[RewriteVersion::Transitional]` and `[BumpVersionAfterRelease]`. The prerequisites
live in `cpanfile`, `dist.ini` holds the header and the bundle, `LICENSE`, `Changes`
and `README.md` are tracked, and CI runs as a GitHub Actions workflow
(`.github/workflows/ci.yml`). `Changes` collects the current work under `{{$NEXT}}`
above the `0.100` release.
