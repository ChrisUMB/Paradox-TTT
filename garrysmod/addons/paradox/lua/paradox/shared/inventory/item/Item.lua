import "ItemType"
import "StatItemType"
import "Item"
import "UUID"
import "Rarity"
import "Loadout"

class.Item {
    field.type(ItemType),
    field.rarity(Rarity),
    field.stackSize("number", 1),
    field.stats("table")
}

function Item:onConstruct()
    self.uuid = UUID.random()
    if not self.type.stackable then
        self.stackSize = nil
    end
    -- If there are already stats, assume that the item was spawned in with stats
    -- for some reason.
    if self.type:is(StatItemType) and not self.stats then
        self.stats = {}
    end
end

function Item:GenerateStats()
    if self.type:is(StatItemType) then
        local m = self.rarity.multiplier
        self.type.statRanges:forEach(function(it)
            local value = math.drandom(it.minimum * m, it.maximum * m, 1)
            self.stats[it.type.name] = value
        end)
    end
end

function net.WriteItem(item)
    net.WriteString(item.type.id)
    net.WriteString(item.uuid.value)
    net.WriteUInt(item.rarity.ordinal, 3)
    net.WriteUInt(item.stackSize or 0, 8)

    if item.type:is(StatItemType) then
        net.WriteTable(item.stats)
    end
end

function net.ReadItem()
    local typeId = net.ReadString()
    local uuidString = net.ReadString()
    local rarityOrdinal = net.ReadUInt(3)
    local stackSize = net.ReadUInt(8)

    local type = ALL_ITEM_TYPES[typeId]
    local uuid = UUID.fromString(uuidString)
    local rarity = Rarity:values()[rarityOrdinal]

    if stackSize == 0 then
        stackSize = nil
    end

    local item = Item:new(type, rarity, stackSize)
    item.uuid = uuid

    if item.type:is(StatItemType) then
        item.stats = net.ReadTable()
    end

    return item
end