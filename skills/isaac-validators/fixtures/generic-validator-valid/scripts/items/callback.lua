function Item:OnUse()
end

MyMod:AddCallback(ModCallbacks.MC_USE_ITEM, Item.OnUse, 1)
