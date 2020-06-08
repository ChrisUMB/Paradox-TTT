import "LoadoutSlot"
import "Item"
import "UUID"

class.Loadout {
    field.slots("table")
}

if SERVER then
    util.AddNetworkString("P_SetItemData")
end

function Loadout:equip(player)
    local slots = self.slots

    player:StripWeapons()
    player:StripAmmo()

    for _, item in pairs(slots) do
        if item then
            if item.type:is(WeaponType) then

                ITEM_DATA[item.uuid:toString()] = item
                local weapon = player:Give(item.type.swepId)
                weapon:SetNWString("uuid", item.uuid:toString())

                net.Start("P_SetItemData")
                net.WriteItem(item)
                net.Broadcast()

                --weapon:SetClip1(math.ceil(weapon:GetClip1() * (1.0 + item.stats.magazine / 100)))

                local primary = weapon.Primary
                player:GiveAmmo(primary.ClipSize * 2, primary.Ammo)
            end
        end
    end
end

function Loadout:Get(ttt_slot)
    for key, item in pairs(self.slots) do
        if key.tttMatch == ttt_slot then
            return item
        end
    end

    return nil
end