net.Receive("P_SetWeaponItem", function(_, _)
    local item = net.ReadItem()
    local entity = net.ReadEntity()

    entity:ApplyItem(item)

    --print("------------")
    --print(item.type.id)
    --print("------------")
    --print(entity)
    --print("------------")
    --print(entity.Weapon)
    --print("------------")

    --entity:ApplyItem(item)
end)