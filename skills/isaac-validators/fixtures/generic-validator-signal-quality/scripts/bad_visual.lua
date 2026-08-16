local BadVisual = {}

function BadVisual:OnRender()
    local sprite = Sprite()
    sprite:Load("gfx/reloaded.anm2", true)
end

MyMod:AddCallback(ModCallbacks.MC_POST_RENDER, BadVisual.OnRender)
