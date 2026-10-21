# lib-absolute House Rules

Apply to every task in this repo unless explicitly overridden. Bias: caution over speed on
non-trivial work; use judgment on trivial tasks. Loaded automatically at launch, same priority
as `CLAUDE.md`. The subagents get their conventions from the force-loaded skills — this file is
for the orchestrating agent.

## Engineering discipline

1. **Think before coding** — State assumptions. When uncertain, ask rather than guess.
   Push back when a simpler approach exists. Name what is unclear.
2. **Simplicity first** — This is one module with one `import` method. A second
   dependency, a class or a CLI needs a card that asks for it.
3. **Surgical changes** — Touch only what you must. Don't "improve" adjacent code,
   comments or formatting. Match the existing layout.
4. **Tests verify intent, not just behavior** — A behavioral change needs a test that pins
   it. The green suite pins neither the `-hard` message nor the absolute form of `.`.
5. **Match the codebase's conventions, even if you disagree** — Conformance > taste.
   Surface a harmful convention; don't fork silently.
6. **Fail loud** — "Done" is wrong if anything was skipped silently. "Tests pass" is
   wrong if any were skipped. Surface uncertainty, don't hide it.
7. **A red test is a claim before it is a failure** — Before changing code to turn a
   test green, say what it asserts and whether the fix keeps or replaces that claim.

## Delegation

- **You can spawn subagents** (orchestrating main agent): Do NOT touch behavior-relevant
  code yourself — delegate. Your lane: coordinate, inspect, plan, review diffs, run
  tests, edit non-behavioral docs. Why: only the `lib-absolute-*` agents get their skills
  force-loaded via `briefing.skills`; you get no briefing and would touch the import
  contract with too little context.

  | Task | Agent |
  |---|---|
  | Implement / refactor / debug behavior-relevant code | `lib-absolute-worker` (default) |
  | Commits, `Changes`, card → done, pre-release audit | `lib-absolute-release-manager` |

- **You cannot spawn subagents** (you ARE a `lib-absolute-*` agent): The
  delegation lock does not apply — implement, refactor, debug and test per these rules.

Behavior-relevant = anything in `lib/`, the tests, the import contract and the `-hard`
mode. `README.md` and `Changes` wording are not.

**Only `lib-absolute-release-manager` commits**: a worker leaves a commit-ready tree and
hands its card to `review`; the release-manager cuts the commit and closes it.

## The import contract is the product — don't regress it silently

Everything this distribution does happens in `import`. A relative `@INC` entry becomes absolute,
`.` stays **and** its absolute form is added as well, a reference entry passes through
untouched, `-hard` aborts when a directory is missing. A change to any of that is a
user-visible change: it needs a `Changes` entry and a test. The module lives in `lib/lib/` —
the `lib` segment appears twice — and the conversion runs at import time, so it acts on the
`@INC` as it looked at that moment. Contract table: skill `lib-absolute-core`.

## Coordination — karr board (always in scope)

Ticket coordination is the orchestrating agent's job, so `karr` is always in scope — just
use it, don't invoke the skill first. Board state lives in `refs/karr/*`.

- `karr list --compact` / `karr board` — open work · `karr show ID` — detail
- `karr create "Title" --priority high --tags a,b --body '…'` — new ticket
- `karr edit ID -a "note"` · `--claim NAME` · `--block "why"` — update
- `karr move ID in-progress --claim NAME` — start · `karr handoff ID --claim NAME --note "…"` — to review
- mutating commands auto-sync; `karr sync --pull|--push` for explicit exchange

Life cycle: claim and hand out → the worker notes and ends at `review` → the release-manager commits and moves it to `done`.

**Serialize board mutations when fanning out.** Keep implementation work parallel, then
loop the board writes one after another — N at once is a resource event, not cheap.

## Release — never without permission

`dzil build` / `dzil test` / `prove -lr t/` are fine anytime. `dzil release` and any CPAN
upload are STRICTLY forbidden without the maintainer's explicit go-ahead — even if a plan
lists "release" as the next step. Stop and ask. The version is not written in the module
— there is no `our $VERSION`; it is derived at release time from the tags, last `0.100`.

## Public issues — never act without instruction

`karr` is the internal agent board, churned freely. The GitHub issue tracker carries
real people's reports under the maintainer's account. Never act on a public issue on
your own initiative — not even to read it. Listing, viewing, commenting and closing
are off without an explicit instruction; the topic becomes an internal card.

## Perl specifics — reference, don't restate

Module loading, cpanfile pinning for Getty-authored dependencies, POD conventions and house
style live in `getty-perl-core`, `getty-perl-pod` and `getty-perl-release-author-getty`. The
import contract, the `.` special case and the `lib/lib` trap live in `lib-absolute-core`.
