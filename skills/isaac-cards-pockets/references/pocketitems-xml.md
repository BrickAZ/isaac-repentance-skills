# Pocketitems XML

Use this when adding or reviewing `content/pocketitems.xml`.

## XML Shapes

Custom card:

```xml
<card type="special" id="580" name="Example Card" description="Short text" pickup="585" hud="ExampleCard" mimiccharge="4" />
```

Custom rune or soul stone:

```xml
<rune type="rune" id="583" name="Soul of Example" description="Short text" pickup="583" hud="SoulOfExample" mimiccharge="4" />
```

Custom pill effect:

```xml
<pilleffect id="580" name="Pill of Example" class="2" mimiccharge="3" />
```

## Fields

- `id`: content id used by `Isaac.GetCardIdByName` or pill effect lookup.
- `name`: lookup/display name. Lua must use the exact name expected by the repo.
- `description`: short pickup text.
- `pickup`: visual pickup/card face id. It may differ from `id`.
- `hud`: HUD/card icon key.
- `mimiccharge`: charge value shown for mimic effects.
- `type`: card/rune/special/object behavior class.

## Hard Rules

- Read existing ids before choosing a new id.
- Do not guess `pickup` or `hud`; check the asset pattern.
- Do not reuse an id unless the design intentionally aliases content.
- If `pocketitems.xml` is changed, ensure Lua id lookup and descriptions are updated.

