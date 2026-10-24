# Project-local Independent Task Blind Review - 2026-10-24

## Setup

The user requested separate Codex tasks in the existing `skill-test` project.
Three new tasks were created directly in that project, without forking earlier
conversation history or specifying a model override. The supplied prompts named
the skills and contained raw cases and review questions, not expected answers.
Evaluators were restricted to project-local skill entrypoints/references and
instructed not to read globals, evals, tests, reports, other projects/tasks or
the network, and not to edit files or run the game.

Before dispatch, the public skill snapshot was refreshed: 84 files differed
from the old project copy. Existing changed files were backed up locally before
replacement. `test-installed-skill-parity.ps1` passed for all 55 public skills,
exit 0. The project fixture's gameplay code was not part of the refresh.

## Tasks And Outcome

| Task title | Skills selected | Outcome |
| --- | --- | --- |
| 盲测：Class与回调绑定 | `isaac-mod-architecture`, `isaac-callback-contracts` | Passed the eight checks below. |
| 盲测：预测查询与随机流 | `isaac-rng-determinism`, `isaac-eid-compat` | Passed the eight checks below. |
| 盲测：重启范围与验证证据 | `isaac-repentogon-ui`, `isaac-testing-debugging` | Passed the six checks below, with the audit-output limit noted below. |

The coordinating agent read the complete final responses and reviewed their
observable command records. This is a semantic review of three application
answers, not an executed gameplay test or a statistical effect measurement.

### Class And Callback Checks

| Check | Observed result |
| --- | --- |
| Lua outputs and object identity | Correctly computed `false, nil, 7`; old count becomes 7, replacement count stays 50. |
| Dynamic method versus object replacement | Same captured object's current method is used; assigning a new registry object does not rebind it. |
| Native registration versus project adapter | Rejected passing the method-name string directly to the native Mod registration API. |
| Removal identity | Required removing the saved wrapper, then binding the new object when needed. |
| Shallow class copy | Identified copied method snapshots and nested table aliases; qualified instance sharing by the actual constructor/metatable chain. |
| Framework scope | Did not require all Isaac mods to adopt the reference class system or a global dispatcher. |
| Duplicate import versus unload | Separated repeated registration on a live Mod from the specifically guaranteed native unload path. |
| Evidence boundary | Did not infer callback-specific engine return semantics or claim a performed reload. |

### Prediction Checks

| Check | Observed result |
| --- | --- |
| Production versus fixture RNG | Accepted the supplied independent production factory while identifying the shared-RNG test double as a separate defect. |
| Pool side effects | Identified real pool depletion despite an independent random stream. |
| Returned aliases | Identified that in-place sorting can modify the cached plan despite its local variable name. |
| Ordered inputs | Rejected same-seed-only equivalence; did not claim every unspecified algorithm must produce different results. |
| Observable comparison | Proposed equal-start-state zero/one/many-preview comparisons, gameplay-state observations and contamination controls. |
| User-owned decision | Left candidate locking versus qualification-based updates as an explicit user decision, with consequences and a final decision list. |
| API scope | Did not invent a non-depleting native API, target build or reward-reservation guarantee. |
| Evidence boundary | Did not treat no-throw fixtures or this paper review as executed native RNG/pool/EID validation. |

### UI And Evidence Checks

| Check | Observed result |
| --- | --- |
| Restart-only support | Accepted the explicit normal-start/restart scope without imposing a complete hot-reload system. |
| Unsupported operations | Did not mark untested manual `luamod` as passed merely because it is a developer operation. |
| Same IDs, old closures | Identified that `ElementExists` alone cannot authorize a disposed instance to operate on a replacement. |
| Required observations | Required invoking saved old closures and observing world reads, writes, current UI and cleanup behavior. |
| Native evidence | Rejected mock-only claims about Chinese rendering, native interaction and unload timing. |
| Independent case scopes | Kept the restart-only project's promise separate from the second project's explicit reconstruction promise. |

## Read-boundary Audit

The first task made eight visible `Get-Content` commands, the second three,
and the UI task four; all exited 0. Visible commands read only the permitted
project-local skill entrypoints and references. No visible command edited files,
executed tests or accessed another project, global skills, evals or reports.

The audit API returns at most 20,000 characters for an individual command output.
Two UI command records exceed that cap (original lengths 24,497 and 23,487
characters). The full 18,098-character panel reference and the task's explicit
tail reread are visible in the audit. This retrieval cap does not establish
exactly how much of those long outputs the evaluator originally saw, so this
report does not claim byte-complete consumption of every entrypoint. The final
responses and the case-relevant findings above were available for review.

Local raw evidence retains task identities, supplied prompts, complete final
answers and visible command metadata outside the public skill package. Tasks
remain available in the user's `skill-test` project.

## Limits

The outcome is 3/3 task answers meeting 22/22 reviewed application checks in this
small sample. It is distinct from the earlier subagent-only application check
in [module-followup-2026-10-24.md](module-followup-2026-10-24.md).
Skill names were supplied, so automatic routing was not tested. No source repair,
native game reload, RNG/pool behavior, EID rendering or ImGui interaction was
performed by these tasks. No additional skill defect requiring a patch was
found in these answers. This review is not publication authorization.
