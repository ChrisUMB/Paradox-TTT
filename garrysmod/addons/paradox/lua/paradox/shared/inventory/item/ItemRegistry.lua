import "WeaponType"
import "Rarity"
import "Item"
import "StatItemType"
import "StatRange"
import "StatType"

class.ItemRegistry {

}

function ItemRegistry.random()
    local length = #ALL_ITEM_TYPE_KEYS

    local key = ALL_ITEM_TYPE_KEYS[math.random(1, length)]
    local itemType = ALL_ITEM_TYPES[key]

    local rarity = Rarity.random(itemType.minimumRarity, itemType.maximumRarity)
    local item = Item:new(itemType, rarity)

    if itemType:is(StatItemType) then
        item:GenerateStats()
    end

    return item
end

WeaponType:new("ace23", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_ace23")

WeaponType:new("asval", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_asval")

WeaponType:new("famasg2", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_famasg2")

WeaponType:new("g36c", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_g36c")

WeaponType:new("m4a1", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_m4a1")

WeaponType:new("m4super90", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_m4super90")

WeaponType:new("m60", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_m60")

WeaponType:new("m249", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_m249paratrooper")

WeaponType:new("mac11", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_mac11")

WeaponType:new("mossberg590", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_mossberg590")

WeaponType:new("mp5a3", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_mp5a3")

WeaponType:new("p90", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_p90")

WeaponType:new("pkm", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_pkm")

WeaponType:new("remington970", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_remington870police")

WeaponType:new("vector", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_vectorsmg")

WeaponType:new("ksg", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_ksg")

WeaponType:new("mp7", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_mp7")

WeaponType:new("xm8lmg", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.primary, "weapon_pwb2_xm8lmg")

WeaponType:new("pl14", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.secondary, "weapon_pwb2_pl14")

WeaponType:new("revolver", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.secondary, "weapon_pwb2_revolver")

WeaponType:new("usp", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.secondary, "weapon_pwb2_usptactical")

WeaponType:new("deagle", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.secondary, "weapon_pwb2_deagle")

WeaponType:new("fiveseven", false, Rarity.common, Rarity.unusual, listOf(
        StatRange:new(StatType.rpm, 2, 8),
        StatRange:new(StatType.damage, 2, 8),
        StatRange:new(StatType.accuracy, 2, 8),
        StatRange:new(StatType.recoil, 2, 8),
        StatRange:new(StatType.magazine, 10, 16)
), LoadoutSlot.secondary, "weapon_pwb2_fiveseven")

