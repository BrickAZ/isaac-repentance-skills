# Shader Params

Use this when touching `shaders.xml` or `MC_GET_SHADER_PARAMS`.

Shaders are high-risk feedback because a plausible shader can obscure the game, cause black screen, or be too expensive.

## Hard Rules

- Do not introduce shader feedback for a small local effect; use a sprite or render overlay instead.
- The shader name in Lua must match `content/shaders.xml`.
- `MC_GET_SHADER_PARAMS` should return params only when the effect is active.
- Provide a fallback path or easy disable switch when the shader is risky.
- Reset shader state on game end, new run, or effect cancellation when needed.

## Review Checklist

- Shader XML exists.
- Shader name matches exactly.
- Activation state is explicit.
- Params cannot leak after effect ends.
- Black-screen or visibility risk is reported.

