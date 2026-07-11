# SaveData And Reload Safety

Use saved data only for state that really must survive save/reload.

## What To Save

- Plain numbers, strings, booleans, and simple tables.
- Versioned data when the shape may change later.
- Enough identity to reconstruct runtime behavior after load.

## What Not To Save

- `Entity`, `EntityPlayer`, `Sprite`, `Room`, `RNG`, function references, callback handles, or any live userdata.
- Temporary room visuals.
- Pure UI selection modes unless the design explicitly requires restoration.

## Load Pattern

1. Load plain data.
2. Validate shape and version.
3. Rebuild runtime tables lazily when callbacks see valid players/entities again.
4. Drop stale references when the target entity/player no longer exists.

## Caution

If the mechanic does not need to survive reload, do not add SaveData just because it is stateful. Runtime-only state is safer for most visual effects, temporary active item modes, and one-room mechanics.
