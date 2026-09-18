# XML loading and ambush.xml

Reference target: REPENTOGON **1.1.2g**. Read the actual XML surface before choosing a folder; content addition and resource replacement are different operations.

## Loader roots and precedence

For the documented items, players, achievements and ambush surfaces, `content/<file>.xml` adds supported registrations; `resources/<file>.xml` replaces the original file. Individual merge algorithms differ. Do not generalize the ambush-specific merge into an arbitrary XML merge rule, or replace the full vanilla file merely to append one registration.

REPENTOGON **1.1.1** added these conditional roots with precedence:

- `resources-repentogon > resources-dlc3 > resources`
- `content-repentogon > content-dlc3 > content`

For a content XML filename, the 1.1.2g loader chooses the first existing matching file in this order for each enabled mod; it does not append all three same-mod copies together. A higher-priority file therefore needs the complete intended registration set for that surface. Different mods' selected content is then processed by the relevant merge. This is an engine file-selection rule, not a callback priority.

The source's ProcessModEntry recognizes /content/, /content-dlc3/ and /content-repentogon/ as content. Its content merge selects one path before parsing and appending. Sources: [1.1.1 release entry](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/changelog.txt#L339), [XMLData.cpp path classification](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/XMLData.cpp#L270), [content-file selection](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/XMLData.cpp#L3471).

**A Lua `if REPENTOGON then` cannot prevent incompatible XML from being parsed.** The engine loads XML outside that branch. Required/optional dependency mode, supported loader version and fallback packaging must agree before shipping. Conditional folders isolate the applicable files on supported engines; they do not implement a missing gameplay fallback or prove the installed build supports them. Use the existing decision and `isaac-repentogon-compat`, inspect duplicate paths, and verify selected content on the actual launch target.

## ambush.xml supports Boss Rush waves only

`content/ambush.xml` adds new **Boss Rush** waves, using the vanilla Boss Rush XML structure. The engine reads the lowercase `<bossrush>` section. The tagged native merge selects `resourcesdoc->first_node("bossrush")` and appends its child wave nodes to the base `<bossrush>` section.

Ordinary challenge-room entries in ambush.xml were **deprecated in Repentance** and are not used. Do not recommend adding or replacing those entries to control regular challenge rooms, boss challenge rooms, floor-specific challenge waves or scheduling. A parsed file, scanner hit or XMLData entry is not evidence that deprecated sections affect gameplay. Placing the file in resources does not reactivate this mechanic.

Use `content/ambush.xml` to append Boss Rush wave definitions. Use `resources/ambush.xml` only for an explicitly intended whole-file replacement, preserving a valid Boss Rush structure. Do not invent a `<challenge>` workaround. For a regular challenge-room requirement, inspect room configuration and the actual Ambush/runtime API path through `isaac-repentogon-world` and `isaac-rooms-stages`; avoid duplicating live wave-control logic in XML or claiming an unverified preview API is pure.

The first historical REPENTOGON version adding content Boss Rush merge is not established here; the supported scope and merge are directly verified in 1.1.2g. Challenge-entry deprecation is a Repentance limitation, not a new 1.1.2g change.

Primary evidence:

- [Official ambush.xml page](https://repentogon.com/xml/ambush.html): resource replacement, content addition, Boss Rush-only support and obsolete challenge entries.
- [Same-tag ambush.xml documentation](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/xml/ambush.md): fixed offline contract.
- [XMLData.cpp ambush merge](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/Patches/XMLData.cpp#L3668): selects only the bossrush section and appends children.
- [Vanilla ambush.xml schema](https://wofsauge.github.io/IsaacDocs/rep/xml/ambush.html): structure reference, subject to the scope restriction above.

## Targeted validation

Check the selected file under root precedence, required `<bossrush>` structure, child entity references and intended append-versus-replace scope. Test Boss Rush spawning and confirm ordinary challenge rooms retain their intended independent behavior. XML parsing and static path checks alone do not prove live wave selection, weights, timing, or cross-mod composition.
