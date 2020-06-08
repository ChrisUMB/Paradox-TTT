import "ItemType"
import "LoadoutSlot"
import "StatItemType"

class.LoadoutItemType {
    extends(StatItemType),
    field.loadoutSlot(LoadoutSlot)
}