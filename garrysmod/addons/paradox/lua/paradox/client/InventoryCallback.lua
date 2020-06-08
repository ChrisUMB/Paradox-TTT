import "ItemType"
import "StatItemType"
import "Item"
import "UUID"
import "Rarity"
import "Loadout"
import "Inventory"

LOCAL_INVENTORY = nil

hook.Add("InitPostEntity", "LocalInventory", function()
    LOCAL_INVENTORY = Inventory:new(LocalPlayer():SteamID64(), {}, Loadout:new({}))
end)

net.Receive("P_InventorySetItem", function(_, _)
    local item = net.ReadItem()
    local slot = net.ReadUInt(16)
    Inventory.GetLocal().items[slot] = item
end)