import "Rarity"
import "Config"

ALL_ITEM_TYPES = {}
ALL_ITEM_TYPE_KEYS = {}
MATERIAL_CACHE = {}

class.ItemType {
    field.id("string"),
    field.stackable("boolean", false),
    field.minimumRarity(Rarity, Rarity.common),
    field.maximumRarity(Rarity, Rarity.unusual)
}

function ItemType:GetIconMaterial()
    if not MATERIAL_CACHE[self.id] then
        local material = Material(self.iconPath)
        MATERIAL_CACHE[self.id] = material
        return material
    end

    return MATERIAL_CACHE[self.id]
end

function ItemType:onConstruct()
    ALL_ITEM_TYPES[self.id] = self
    table.insert(ALL_ITEM_TYPE_KEYS, self.id)

    self.DisplayName = Config.ItemNames[self.id]
end