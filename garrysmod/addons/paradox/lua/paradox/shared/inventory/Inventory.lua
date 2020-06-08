import "Loadout"
import "Item"

PLAYER_INVENTORIES = {}

if SERVER then
    util.AddNetworkString("P_InventorySetItem")
end

class.Inventory {
    field.owner("string"),
    field.items("table"),
    field.loadout(Loadout, Loadout:new({}))
}

function Inventory.Get(player)
    local id = player:SteamID64()

    if PLAYER_INVENTORIES[id] then
        return PLAYER_INVENTORIES[id]
    end

    PLAYER_INVENTORIES[id] = Inventory:new(id, {})
    return PLAYER_INVENTORIES[id]
end

function Inventory.GetLocal()
    if CLIENT then
        return Inventory.Get(LocalPlayer())
    end
end

function Inventory:SetItem(index, item)
    self.items[index] = item
    if SERVER then
        local player = player.GetBySteamID64(self.owner)

        if player then
            net.Start("P_InventorySetItem")

            net.WriteItem(item)
            net.WriteUInt(index, 16)
            net.Send(player)
        end
    end
end