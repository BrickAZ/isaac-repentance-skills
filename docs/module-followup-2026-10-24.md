# Module And Callback Follow-up - 2026-10-24

## Scope

This follow-up changes five existing skills; no new skill, plugin-version bump
or external publication is included.

| Skill | Follow-up |
| --- | --- |
| `isaac-mod-architecture` | Actual class-helper semantics, shallow prototype copies, private-name versus returned-reference ownership, method versus instance replacement. |
| `isaac-callback-contracts` | Method-name adapters versus native function registration; exact argument/return/filter/priority forwarding and wrapper removal; native unload versus same-instance imports. |
| `isaac-rng-determinism` | Independent prediction streams, canonical input order, pool side effects and preview-frequency comparisons. |
| `isaac-repentogon-ui` | Explicit normal-start/restart/reload support scope; restart-only development does not require a full hot-reload system. |
| `isaac-testing-debugging` | Execute registered wrappers, distinguish replacement boundaries and test the support scope actually promised. |

Three focused references, two executable documentation-example tests and nine
eval definitions were added. The five affected eval collections contain 50
definitions in total, up from 41. Eval definitions are not executed test runs.

The generic package does not require a reference mod's Class/Component framework.
Normal native Mod callback cleanup is explicitly distinguished from repeated
registration in one live instance and from external EID/ImGui registration.

## Executed Checks

Commands were run from this repository with the discovered local Lua runner.
All four exited 0:

```text
lua skills/isaac-mod-architecture/tests/test-module-contracts.lua       33 checks
lua skills/isaac-repentogon-ui/tests/test-developer-panel.lua           22 checks
lua skills/isaac-callback-contracts/tests/test-method-adapter.lua       18 checks
lua skills/isaac-rng-determinism/tests/test-prediction-query.lua        19 checks
```

That is 92 pure-Lua/example and explicit-double checks. The two new tests were
first run before their example resources existed and failed for that missing
implementation, then passed after the examples were added.

Three in-memory mutations were also rejected by these tests: dropping a `false`
return, removing the target method instead of the registered wrapper, and
mutating the caller's candidate array. These controls changed no source file.

`tests/test-skill-repository.ps1` passed for 55 skills, exit 0.
`git diff --check` passed, exit 0; Windows LF/CRLF notices are not errors.
`tests/test-installed-skill-parity.ps1` passed for 55 skills, exit 0, after
synchronizing the 19 changed skill files to the local installed copies. The
sync checked existing destinations against the repository baseline first.

## Independent Application Check

One fresh-context baseline agent received five raw cases without reading skills.
Two separate fresh-context agents then applied only the selected updated skills
and references to the corresponding cases. They were not given expected answers,
prior conclusions or test/eval/report contents. They were instructed to remain
read-only and not run the game. The coordinating agent read their returned text
and checked these outcomes:

| Raw case | Baseline | With selected updated skills |
| --- | --- | --- |
| Two live imports versus verified native unload/reload | Correct distinction | Correct distinction, native/external ownership kept separate |
| Dynamic method lookup, owner replacement and cleanup by wrong function | Correct | Correct forwarding, captured-owner and wrapper-removal analysis |
| Shallow class-copy method snapshot and nested shared state | Correct | Correct; no compulsory reference framework introduced |
| Private prediction RNG plus real pool writes and mismatched candidate order | Correct | Correct; proposed zero/one/many preview comparisons and negative controls |
| Explicit restart-only menu support | Correct | Correct; unsupported hot reload not invented or claimed as tested |

Both arms satisfied 5/5 scenarios. The baseline was already correct, so this is
not evidence of an accuracy uplift. It demonstrates that the added material is
retrievable and usable in this small, skill-selected sample. It does not measure
automatic skill selection, statistical reliability or independent GUI tasks in
the skill-test project.

A subsequent user-requested run did create three independent tasks in that
project. Its separate outcomes and audit limits are recorded in
[module-blindtest-2026-10-24.md](module-blindtest-2026-10-24.md); those results do
not retroactively change the earlier baseline comparison above.

## Native Evidence Limit

No live Isaac/REPENTOGON reload, native RNG/pool mutation, EID rendering or ImGui
delivery test was run. The documentation examples and doubles do not establish
those engine behaviors. Actual game/build-specific acceptance remains separate.
