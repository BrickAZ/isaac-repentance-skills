local Visual = {}
local preload = Sprite()
preload:Load("gfx/init-only.anm2", true)

function Visual:OnRender()
    return true
end

MyMod:AddCallback(ModCallbacks.MC_POST_RENDER, Visual.OnRender)
