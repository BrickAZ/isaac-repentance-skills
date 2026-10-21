# Health Projection Across Player Types

Health switching is a capability projection, not a generic numeric copy.

## Source Ledger

Discover and capture only fields supported by the target project/build. Relevant
surfaces can include:

- max red-heart containers and current red hearts;
- soul-heart amount and black-heart color/mask information;
- bone, rotten, eternal, golden, and broken hearts;
- target heart limit and native health type;
- Lost-like hidden/native survival state;
- soul charge, blood charge, or another character-specific resource;
- death, revival, and special survival state.

Preserve the distinction between capacity, current survivability, attached
secondary counters, and resources that are not HP.

## Target Capability Contract

For each target identity, discover:

- which health types it can carry;
- which APIs reject, transform, or reinterpret a field;
- its heart/capacity limit;
- whether an associated native partner carries part of the health;
- whether adding health also changes a charge/resource;
- which native initialization must remain engine-owned.

Do not infer this solely from a mock or a visual HUD result.

## Projection Policy

The user/mechanic owns exchange ratios, overflow, minimum survival, and whether
unrepresentable health is parked for a later switch. Keep any undecided policy as
`TBD — user decision required`.

Implementation should:

1. read the current source ledger before mutation;
2. derive the target representation from approved policy and proven capability;
3. avoid clearing target-native survival state before the replacement is ready;
4. apply containers/capacity before dependent health where required;
5. restore special resources independently from HP;
6. read the result back and verify valid survivability and limits;
7. update the ledger from live deltas so later switches do not heal spent health.

## Failure Cases To Reject

- red-heart-only source becomes soul-only target with zero represented health;
- soul-only source becomes red/coin-only target with zero represented health;
- Lost-like target loses its native hidden survival state;
- adding unsupported soul hearts fabricates Bethany-like charge;
- a Forgotten/Soul-like pair restores health to the wrong body;
- switching back restores health already lost during the temporary identity;
- a continue path reloads the original snapshot over newer live damage.

An isolated test double must model rejection/side effects for the relevant target
capability. A permissive `AddSoulHearts` stub cannot prove a restrictive target.
