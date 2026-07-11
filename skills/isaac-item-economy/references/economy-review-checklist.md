# Economy Review Checklist

Use this table for a proposed item or a batch review:

| Item | User decisions (locked) | Missing fields | Suggestions needing approval | Why | Excluded pools | Unlock/availability |
| --- | --- | --- | --- | --- | --- | --- |

## Decision Authority

- Copy user-provided quality, pools, weights, tags, depletion, and unlocks into **User decisions (locked)** exactly.
- Put omitted values in **Missing fields**.
- Put any AI proposal in **Suggestions needing approval**, with a short reason and optional alternative.
- Do not edit XML from a suggestion alone. An explicit user confirmation or an already-recorded upstream approval may authorize execution.

## Static Checks

Run the validator after XML changes. It verifies:

- every pool entry names an item in the matching language `items.xml`;
- positive weights and valid numeric depletion fields;
- no duplicate pool names;
- no duplicate item inside one pool;
- base/en/zh pool order, entry counts, and numeric values stay aligned.

## Manual Checks

- Is the quality justified by reliability as well as peak power?
- Does the item appear in a pool whose identity it supports?
- Did a low weight hide a wrong pool decision?
- Does adding this item noticeably dilute a small or specialized pool?
- Are tags and unlocks reflected in player-facing text where needed?
