import "LoadoutItemType"

class.WeaponType {
    extends(LoadoutItemType),
    field.swepId("string")
}

function WeaponType:swep()
    return weapons.Get(self.swepId)
end