# Architecture Review Checklist

Before finalizing architecture work, verify:

- The change was needed for the current task.
- File boundaries follow content identity or real shared behavior.
- Load order is explicit.
- Callback ownership is easy to trace.
- No unrelated content was refactored.
- Existing tests still pass where runnable.
- Static validators run after moving paths or XML references.
- The final report names any cleanup intentionally left for later.
