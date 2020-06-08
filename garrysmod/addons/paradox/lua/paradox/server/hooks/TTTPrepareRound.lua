import "Loadout"
import "Inventory"
import "LoadoutSlot"
import "ItemRegistry"

util.AddNetworkString("P_ClearItemData")

hook.Add("TTTBeginRound", "prepareLoadout", function()
    local players = player.GetAll()

    for _, player in pairs(players) do
        player:RemoveAllItems()
        local inventory = Inventory.Get(player)

        for i = 1, 25 do
            inventory:SetItem(i, ItemRegistry.random())
        end

        local item = Item:new(ALL_ITEM_TYPES["ksg"], Rarity.random(), 1)-- ItemRegistry.random()
        item:GenerateStats()

        local loadout = inventory.loadout

        net.Start("P_ClearItemData")
        net.Send(player)

        loadout.slots[item.type.loadoutSlot] = item
        loadout:equip(player)
    end
end)