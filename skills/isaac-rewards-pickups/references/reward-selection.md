# Reward Selection

## Choose the Source First

| Source | Validate before use |
| --- | --- |
| Fixed vanilla collectible/card/pickup | The exact type, variant, and subtype are intentional and supported by the API path. |
| Registered current-project content | The named registry entry resolves and its content/XML contract is present. |
| Item or card pool | Pool choice, exclusions, and fallback are explicit; pool output is checked before spawn. |
| Curated configuration list | Each configured value is source-appropriate and invalid entries are skipped or reported. |
| Existing pickup Morph | The replacement is valid before mutating the source pickup. |

## Candidate Rules

1. Decide whether one candidate, a pool draw, or a curated list is intended.
2. Validate at the narrowest owner boundary.
3. Apply the declared repeat boundary before spawning.
4. Only then create or morph the pickup.

`0`, `-1`, an empty table field, and a randomly chosen fallback are not neutral
values. They can make a blank pickup, a meaningless reward, or a crash-prone
content path.

Do not silently choose pool, quality, count, weight, or fallback content. Those
are user decisions unless an approved design contract already supplies them.
