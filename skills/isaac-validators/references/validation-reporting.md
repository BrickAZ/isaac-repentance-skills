# Validation Reporting

Use concise, factual reporting.

## Template

```markdown
## Validation

- Command:
- Result:
- Failures:
- Warnings:
- Pre-existing/unrelated:
- Manual checks:
```

## Language

- Say "static validation passed" only when the validator exits successfully.
- Say "in-game verification still needed" for render, input, collision, shader, and callback-timing behavior.
- If failures are outside the current task, do not hide them. Mark them as unrelated so the user is not surprised later.
