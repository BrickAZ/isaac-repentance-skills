---
name: isaac-character-switching
description: "Use when a Binding of Isaac: Repentance mechanic changes or restores a live player's actual PlayerType, including temporary identity items, ChangePlayerType calls, Lost/Keeper/Bethany health conversion, Forgotten/Soul or Jacob/Esau topology, partner ownership, failed-switch recovery, and continue behavior. Do not use for costume-only visuals, ordinary PlayerForm transformations, or character registration without an in-run identity change. 中文触发：局中换角色、切换角色、ChangePlayerType、临时身份、变回原角色、Lost 换人、双子残留、里骨魂残留、生命类型转换、换角色失败恢复。"
---

# Isaac Character Switching

## TBD Disclosure Contract

A `TBD` is a genuinely unresolved user design choice. Missing paths, API
signatures, callback owners, build identities, and tool commands are technical
facts: discover them, or report **Unverified — discovery required** with the
specific evidence gap. Do not turn research work into a request for user permission.
Existing project decisions and explicit standing user preferences remain binding.

- Whenever an active `TBD` affects this turn's recommendation, implementation, test plan, or completion claim, label it exactly as **`TBD — user decision required`** and state the consequence of leaving it unresolved.
- In every response that relies on one or more active `TBD`s, end with a concise **User decisions required** list containing every still-active item. Do not hide a decision inside code, a default value, or an implementation note.
- Give optional alternatives only as suggestions. Preserve user-owned balance, mechanics, assets, dependency policy, and persistence semantics; resolve routine technical implementation choices within the authorized scope.
- If safe discovery or validation can continue, continue it conditionally while keeping the decision visible. If the next mutation depends on the `TBD`, stop before that mutation and ask the user.
- Do not create artificial `TBD`s for facts already confirmed by the project or explicitly decided by the user. Once a decision is confirmed, remove it from later reminders.

Read `../isaac-mod-context/references/tbd-disclosure.md` for the shared user-decision and technical-discovery policy.

## Core Principle

An in-run `PlayerType` change is a migration of identity, health capabilities,
player topology, ownership, and lifecycle state. It is not proved correct merely
because `ChangePlayerType` returned or the visible body changed.

This skill owns the ordered switch protocol and its postconditions. It does not
invent character registration, universal health-exchange ratios, or an atomic
rollback guarantee that the engine cannot provide.

## Boundary

Use this skill when live gameplay actually changes or restores `PlayerType`, or
an equivalent project/API identity. Do not use it for:

- a costume, skin, Null Costume, reskin, or visual-only form;
- a vanilla/custom `PlayerForm` that leaves `PlayerType` unchanged;
- registering a selectable character without an in-run switch;
- ordinary death/revival unless revival also changes the live identity contract.

## First Move

1. Use `isaac-mod-context` in an unfamiliar project. Discover the switch owner,
   actual player lookup, registered source/target types, API/build, state store,
   SaveData policy, partner helpers, callbacks, and tests.
2. Read `references/switch-contract.md` and write one switch contract before
   mutation. Keep conversion ratios, persistence, and item-transfer policy as
   user decisions unless already established.
3. Read `references/player-topology.md` whenever either identity can own a native
   subplayer/twin or the switching item can be held by a secondary body.
4. Read `references/health-projection.md` whenever source and target may expose
   different health or charge capabilities.

## Staged Switch Protocol

Use a staged, compensating transition rather than claiming an atomic transaction:

1. **Preflight** every fact and capability needed for the destructive path.
2. **Capture** plain-data recovery state for the actual owner and any proven
   native partner that may disappear.
3. **Detach** only temporary effects/components owned by this switching mechanic.
4. **Mutate once** through the discovered identity API.
5. **Reacquire** live player/partner wrappers; pre-switch userdata may be stale.
6. **Reconcile topology** before restoring partner-owned inventory or health.
7. **Project state** only into capabilities the target identity can carry.
8. **Verify postconditions**, then make live state authoritative and persist only
   the approved stable facts.
9. **Compensate on failure** where the API permits it, but retain recovery data
   and report an unverified/failed transition if the original structure cannot be
   proved restored.

## Hard Rules

- Resolve actual types from discovered registration/API facts. Do not invent raw
  IDs or infer a Tainted/alternate type by numeric adjacency.
- Never treat player index zero, array order, or “the second player” as partner
  identity. Distinguish native subplayers/twins from independent co-op players.
- Do not call a destructive switch until required partner enumeration, inventory
  capture, removal, and restore capabilities have passed preflight.
- After a type change, reacquire live wrappers before cleanup. Never remove a
  saved userdata reference or an entity that cannot be proven to be the exact
  former native partner.
- Health migration is `source ledger + target capabilities + approved policy`.
  Do not clear all health and then hope unsupported fields are ignored; do not
  bake one mechanic's exchange ratio into generic guidance.
- A saved partner snapshot is recovery data, not permanent authority. Once a
  live partner is restored, later spending, damage, rerolls, and item loss must
  not be overwritten by an old snapshot.
- If the switching item is held by a disappearing partner, define explicit proxy
  or transfer ownership and copy counts. Do not duplicate the item or restore it
  after it was consumed, removed, or rerolled.
- Do not replay engine-owned starting kits, native grants, or automatically
  created partners as extra Lua rewards.
- Save only stable plain data. Never serialize `Player`, `Entity`, `EntityRef`,
  `Sprite`, or other live userdata.
- A compensating switch-back is best effort, not proof of atomic rollback. Keep
  recovery data until the original identity, topology, health, and owned state
  have all been revalidated.

## Companion Skills

- Use `isaac-players-characters` for registration, starting-kit intent, and
  source/target identity facts.
- Use `isaac-damage-health-contracts` for the approved health outcome and lethal
  boundary; this skill owns when that projection occurs during switching.
- Use `isaac-state-lifecycle` for stable keys, SaveData, continue, reset, and
  reconstruction; this skill owns the switch-phase authority.
- Use `isaac-transformations-forms` only to classify a form. If it changes real
  `PlayerType`, this skill becomes primary for the migration.
- Use `isaac-callback-contracts` for exact callback timing/returns and the
  matching REPENTOGON skill only when that dependency is declared.
- Read `references/validation-matrix.md` before claiming completion.

## Required Output

```markdown
## Character Switch Contract

- Source/target identity and resolution evidence:
- Actual owner and native partner topology:
- Switching item/effect ownership and proxy policy:
- Preflight capabilities and stop conditions:
- Captured recovery state:
- Health ledger, target capabilities, and approved projection policy:
- Engine-owned versus mod-owned state:
- Mutation, reacquisition, and topology reconciliation order:
- Postconditions and commit authority:
- Compensation path and retained recovery data:
- Save/continue/death/item-loss behavior:
- Static, isolated, simulated, and in-game evidence:
- User decisions required:
```

## Final Review

Report the actual source/target types, owner/partner mapping, health projection,
state authority, failure behavior, and evidence level. A passing mock does not
prove native Lost survival, partner creation/removal, controller binding,
starting-kit behavior, or save/continue in game.
