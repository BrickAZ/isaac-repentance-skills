# Evidence and Compatibility Reference

Checked 2026-09-05 against **1.1.2g**. This is an offline reference, not a claim
about the installed game.

## Environment

REPENTOGON is a community script extender. At this check the launcher install
instructions accepted latest Steam files or Repentance+ 1.9.7.12.J273 and ran the
supported J273 base. Do not equate "latest Steam accepted as input" with native
support for every latest executable. Recheck the
[installation instructions](https://repentogon.com/install.html) for install/launch
tasks. Mod development alone does not request changing game installation.
Record actual launch route and log identities.

[Docs index](https://repentogon.com/docs.html) and
[release 1.1.2g](https://github.com/TeamREPENTOGON/REPENTOGON/releases/tag/1.1.2g)
are discovery sources; this release is not a blanket project minimum.

## Source Precedence

User/project decisions define support and mechanics. Existing code shows project
intent, not API correctness. Match the game build and REPENTOGON tag/commit to
documentation, binding, Lua wrapper and call sites. When same-tag docs conflict
with code, explain the matching implementation and cite the discrepancy.
Runtime tests prove behavior on the actual build; source inference is not a
played test. Official live docs can move beyond a release. Translations are
reading aids; verify signatures, warnings and version statements at their origin.
Never merge signatures from different versions.

## Version Trap

The [1.1.2g Lua wrapper](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/repentogon/resources/scripts/main_ex.lua)
creates `REPENTOGON.Version` and static `REPENTOGON.MeetsVersion(required)`.
MeetsVersion compares numeric chunks, ignores letters and accepts a dev build.
Thus 1.1.2a can pass a request for 1.1.2g. Official docs additionally warn that
versions through 1.0.10b always returned true.

The minimum-direction examples in
[tagged Repentogon.md](https://github.com/TeamREPENTOGON/REPENTOGON/blob/1.1.2g/docs/docs/Repentogon.md)
are reversed relative to the matching Lua implementation.
The [current API page](https://repentogon.com/Repentogon.html) gives the intended
direction. Do not blindly prefer installed docs; shipped prose can also be wrong.
Use full-release comparison for suffix fixes and verified identity for dev builds.

## Conflicts Carried into Focused References

| Surface | Issue and treatment |
| --- | --- |
| Familiar multiplier callback | Table says void, but prose/source accept a positive number; see callbacks/content. |
| CustomCache initial value | Ordinary tags start at 0; built-ins use native values; see content. |
| ImGui coordinates | Some documented void returns are Vectors in Lua wrappers; UI records scale limits. |
| Ambush.GetNextWaves | Matching code has loop and early-return weight restoration defects; world does not promise pure preview. |
| TryPlaceRoom failure | Some argument failures return false rather than nil; world checks truthiness. |
| LootList versions | RNG/Player and POST appear in d; preview RNG fix f and Eternal Chest fix g also affect support. |

The [general changes](https://repentogon.com/changes/General.html) describe Lua5.4
and advise avoiding 5.4-only features where practical because of possible future
LuaJIT migration. Conditional XML/resource roots need exact target-build proof;
Lua gating does not control earlier engine parsing.
