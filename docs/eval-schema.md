# Eval Case Schema

Every `skills/<name>/evals/evals.json` file is a static prompt contract. It is
not evidence that a fictional target mod, path, callback, asset, or dependency
exists on the user's computer.

## Document

```json
{
  "skill_name": "isaac-example",
  "evals": []
}
```

- `skill_name` must exactly match the containing skill directory.
- Each skill must have at least two cases.
- Case `id` values must be unique inside the skill.

## Case Fields

- `id`: stable string or numeric identifier, unique inside the skill.
- `prompt`: the blind task presented to the Agent.
- `expected_output`: observable contract behavior, not an exact prose answer.
- `files`: one or more repository-relative files that actually exist and give
  the evaluator the skill instructions/reference context. Public-package evals
  use `skills/...` paths.
- `fixture_files` (optional): fictional or target-project paths named by the
  prompt, such as `main.lua` or `content/items.xml`. They describe the scenario
  and are deliberately not resolved inside this repository.

## Evidence Boundary

An eval can prove that an Agent follows a written contract. It cannot prove
that an Isaac callback, userdata value, room transition, render coordinate,
asset crop, load order, or third-party API works in game. Report static eval,
mock/runtime harness, and in-game evidence separately.
