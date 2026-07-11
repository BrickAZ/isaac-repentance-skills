# Mechanic Review Checklist

Before implementation, verify the contract answers:

- What exact event starts the mechanic?
- What happens on an ineligible attempt?
- What is changed immediately?
- What persists, and why?
- What can trigger it again?
- What is excluded and why?
- What ends, interrupts, or settles it?
- What belongs to gameplay and what belongs to presentation?
- Which targets are owned by the current project versus another mod?
- Which existing reference and tests cover the same risk?

After implementation, test at minimum:

- eligible success;
- ineligible failure/no-op;
- each important exclusion;
- repeated or recursive trigger;
- state interruption/reset;
- normal-run or other-mod non-interference when relevant.
