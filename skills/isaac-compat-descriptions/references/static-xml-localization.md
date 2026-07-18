# Static XML Localization At Launch

Use this optional pattern only when a project already maintains explicit
per-locale XML templates and needs Isaac's native static surfaces, such as
collectible names, descriptions, or pool entries, to be localized before the
game loads them. It is not a runtime language switcher.

## Choose This Pattern Only When

- The project has discovered locale template files and a project-owned launch
  or build entrypoint.
- Native XML-owned text must change with the selected language.
- The user accepts that changing language requires synchronization before
  launch and a game restart.

Do not introduce this pattern for a few Lua HUD strings, an unknown project,
or merely because a reference mod uses it. Use `isaac-localization-runtime` for
runtime text, fonts, and localized visual assets instead.

## Contract

Discover and report before editing:

- Supported game-language codes and their template-locale mapping.
- Source templates and generated active targets for every synchronized XML
  surface, such as `items`, matching `itempools`, or another discovered pair.
- The single project-owned launcher/build entrypoint that performs the sync.
- Default locale, unsupported-language behavior, and fallback.
- A checker that reports one locale, `mixed`, or `unknown` rather than allowing
  templates for different languages to become active together.
- Which descriptions remain runtime-only or optional integrations.
- Whether localized registration names need a semantic-key-to-candidate resolver.

Treat locale templates as source files. Treat active game-read XML targets as
generated launch artifacts. Do not hand-edit one active target and call the
translation complete.
## Localized Registration Names And Runtime IDs

When locale templates translate an XML registration name and Lua resolves the
content with a name lookup, retain one semantic project key and an explicit
locale-name candidate map or discovered resolver. Resolve the current runtime
ID from the actually loaded template, then verify every supported template
resolves the same semantic item/card/trinket.

Keep these identities separate:

- Declared local XML `id`: the stable project registration key where the
  project uses one.
- Localized XML `name`: a display/lookup spelling that may vary by template.
- Runtime ID returned by `Isaac.GetItemIdByName` or another official lookup:
  load-order-dependent runtime data, not a replacement for the local key.

Do not hard-code a current runtime/global number into a locale template or use
one locale's spelling as the universal lookup name. If the project keeps names
stable across templates, record that discovery instead of adding needless
candidate logic.

## Implementation Rules

1. Discover actual locale codes, template names, and game-read XML paths; do
   not assume `en_us`, `zh_cn`, `items.xml`, or `itempools.xml`.
2. Resolve the selected language once in the project-owned entrypoint. Normalize
   only codes that the project explicitly maps.
3. Synchronize every coupled XML surface as one operation. Do not leave an item
   catalogue in one locale and a name-based pool file in another.
4. Validate the resulting active files before launching. Abort on `mixed`,
   `unknown`, a missing template, or an unsupported language.
5. State the restart boundary plainly: changing a game setting after launch
   cannot update already loaded static XML.
6. Keep runtime text, EID, MCM, and other optional descriptions synchronized
   through their own discovered routes. Do not assume copying XML updates them.
7. Do not conceal the direct-launch risk. If users can launch the game without
   the project entrypoint, report that the active XML may not match the current
   game setting and give the discovered synchronization command or status check.

## Review Checklist

- Every locale template contains matching content keys and mechanics.
- Coupled name-based XML surfaces select the same locale.
- Every locale whose XML registration names differ resolves the same semantic runtime IDs.
- The launcher rejects unsupported or unmapped locale codes.
- The checker distinguishes a valid locale from `mixed` and `unknown`.
- XML, EID, HUD, and metadata text are each either synchronized or explicitly
  listed as intentionally unchanged.
- Test each supported locale in game after a fresh launch; test the fallback and
  one direct-launch mismatch path separately.
