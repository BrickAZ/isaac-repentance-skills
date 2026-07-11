# Callback Review Checklist

Before code:

- Does the callback observe the intended moment?
- Is the registration filter as narrow as possible?
- Does the handler signature match the callback family?
- Are relevant source, flag, ownership, and state guards inside the handler?
- Is the return policy verified for this exact callback type?
- Does a changed state request the correct cache refresh?

After code, test:

- registration exists and handler is callable;
- eligible event fires once;
- wrong item/entity/card does not fire;
- important excluded event does not fire;
- return/cancellation behavior matches the contract;
- duplicate registration is absent;
- state/cache refresh occurs when required.
