# Status Effect Contract Reference

## Route Selection

| Route | Use when | Main risk |
| --- | --- | --- |
| Built-in status | The discovered API exposes the intended behavior and target class | Wrong signature, duration unit, immunity, or implicit periodic damage |
| Entity flag | A verified flag itself represents the required state | Flag may be a symptom/visual marker rather than a complete timed effect |
| Custom timed state | Built-in behavior cannot express stacking, ownership, or custom logic | Per-target state leaks, expensive scans, stale entities, reload mismatch |
| Presentation only | The request is feedback with no gameplay consequence | Accidentally coupling visuals to damage or AI |

Do not silently fall back from one route to another. If a built-in status is
unsupported for a target, report that branch and preserve the original event.

## Application Edge

Separate these moments:

1. attack/projectile creation;
2. collision or candidate hit;
3. damage callback entry;
4. accepted damage result;
5. status application;
6. status-owned tick or update;
7. expiry/removal.

Choose one authoritative application edge. Registering both collision and
damage handlers for the same proc commonly duplicates the status.

## Repeat Policies

- **Reject**: keep the current instance unchanged.
- **Refresh**: reset expiry without increasing magnitude.
- **Extend**: add time, normally with a user-approved cap.
- **Replace**: overwrite owner, magnitude, or carrier according to precedence.
- **Stack magnitude**: one timer with a count/magnitude.
- **Independent stacks**: separate owner/timer instances; use only when cleanup
  and performance costs are justified.

Never derive a repeat policy from the status name. Poison, burn, slow, marks,
and custom control effects can each use different policies.

## Source And Target Identity

For custom state, use a stable project-proven target key and store only
serializable source identity if persistence is required. During runtime, validate
entity existence before every delayed operation. A source becoming invalid must
follow the approved fallback: cancel future ticks, retain unattributed status,
or use another explicitly chosen owner.

Do not treat every entity with the same type/variant as one target. Do not use a
room-wide table keyed only by subtype or InitSeed without checking the project's
identity and recreation behavior.

## Periodic Damage And Control

- Decide whether built-in periodic damage is sufficient before adding custom
  damage.
- Mark owned custom ticks so the damage handler rejects only its own recursion.
- Keep tick damage and status duration independent fields.
- Confirm whether slowing/freezing/fear/charm affects the intended NPC, Boss,
  player, familiar, projectile, or segmented target.
- Do not freeze or rewrite AI state globally when only one target is marked.

## Review Checklist

- Exact status API/flag and version are proven.
- Target eligibility and exclusions precede mutation.
- Applicator, damage source, and kill credit are explicit.
- Duration unit, start, expiry, and pause behavior are explicit.
- Repeat policy and caps are explicit.
- Built-in and custom periodic damage do not double-apply.
- Boss, champion, friendly/charmed, segmented, dead, and invulnerable branches
  are tested or declared unsupported.
- Co-op and simultaneous targets do not share state.
- Removal touches only this mod's owned state.
- Static, mock, and in-game evidence are reported separately.

## Common Failures

- Applying on both collision and accepted damage.
- Assuming every duration argument is measured in frames.
- Treating a tint or flag as proof of gameplay behavior.
- Assigning every proc to player zero.
- Clearing foreign statuses during room cleanup.
- Serializing entity userdata for a timed effect.
- Letting cosmetic RNG advance proc chance.
