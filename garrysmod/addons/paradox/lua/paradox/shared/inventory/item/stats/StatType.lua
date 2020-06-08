STAT_TYPE_REGISTRY = {}

enum.StatTypeDisplay {
    value.percentage(),
    value.number()
}

enum.StatType {
    field.display(StatTypeDisplay),

    value.rpm(StatTypeDisplay.percentage),
    value.damage(StatTypeDisplay.percentage),
    value.accuracy(StatTypeDisplay.percentage),
    value.recoil(StatTypeDisplay.percentage),
    value.magazine(StatTypeDisplay.number)

}
