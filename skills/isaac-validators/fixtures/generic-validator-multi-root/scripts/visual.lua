local Visual = {}

function Visual:OnUpdate(familiar)
    if familiar:GetSprite():IsEventTriggered("Ready") then
        return
    end
end

MyMod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, Visual.OnUpdate)
