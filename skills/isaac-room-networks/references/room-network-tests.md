# Room Network Test Matrix

Run the smallest available check for each case, then distinguish scripted proof from normal-floor in-game proof.

| Case | Expected result |
| --- | --- |
| Valid entry and first node | Player reaches the owned first room and origin/return state is recorded. |
| Valid next edge | The intended next node is reachable without mutating unrelated doors or rooms. |
| Invalid local candidate | No owned edge is created and no success/charge is consumed. |
| No allocatable node or edge | Explicit failed-entry/partial-network policy occurs; no silent no-op. |
| Return | Player returns to the correct origin/context and owned state cleans up. |
| Reload, death, or unexpected room change | State follows the user-approved interruption policy without stale owned rooms or live userdata. |
| Debug/console room | May exercise a local branch only; it is not proof of map topology. |

For a network inside a special Dimension, repeat valid entry, return, and cleanup checks after `isaac-dimensions` proves the Dimension context.
