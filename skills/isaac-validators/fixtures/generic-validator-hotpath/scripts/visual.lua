local Visual = {}

function Visual:OnRender()
    local player = Isaac.GetPlayer(0)
    local sprite = player:GetSprite()
    sprite:Load("gfx/player.anm2", true)
    sprite:ReplaceSpritesheet(0, "gfx/player.png")
    sprite:LoadGraphics()
    return sprite:IsEventTriggered("MissingEvent")
end

MyMod:AddCallback(ModCallbacks.MC_POST_PLAYER_RENDER, Visual.OnRender)
