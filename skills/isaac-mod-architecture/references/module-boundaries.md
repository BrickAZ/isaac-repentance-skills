# Module Boundaries

Use module boundaries to reduce confusion, not to decorate the codebase.

## Good Boundaries

- One content type per module family: items, trinkets, cards, entities, challenges.
- Shared helpers only when at least two real call sites need them.
- Content registration separate from behavior when the file grows hard to scan.
- Test files named after behavior or content.

## Bad Boundaries

- Splitting every small item into a new architecture before patterns stabilize.
- Hiding callbacks behind generic magic.
- Moving code only because a file is long, without reducing repeated logic.
- Creating helpers that know about every item.

## Review Question

Can a future agent find the relevant code from the content identity in less than a minute?
