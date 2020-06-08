import "PColor"
import "Rarity"

import "Config"

enum.Rarity {
    field.weight("number"),
    field.multiplier("number"),
    field.color(PColor),

    value.common(50000, 1.0, PColor:new(157, 157, 157)),
    value.uncommon(7000, 1.5, PColor:new(147, 196, 125)),
    value.rare(2000, 2.0, PColor:new(255, 229, 153)),
    value.odd(500, 3.0, PColor:new(142, 124, 195)),
    value.strange(50, 4.0, PColor:new(70, 189, 198)),
    value.unusual(1, 6.0, PColor:new(0, 85, 255))
}

local totalWeightMax = 0
for _, r in ipairs(Rarity.values()) do

    r.DisplayName = Config.RarityNames[r.name]

    r.rangeMin = totalWeightMax
    totalWeightMax = totalWeightMax + r.weight
    r.rangeMax = totalWeightMax
end

function Rarity.trueRandom()
    return Rarity.values()[math.random(#Rarity.values())]
end

function Rarity.random(minRarity, maxRarity)
    minRarity = minRarity or Rarity.common
    maxRarity = maxRarity or Rarity.unusual
    local value = math.random(minRarity.rangeMin, maxRarity.rangeMax - 1)
    for _, r in ipairs(Rarity.values()) do
        if value >= r.rangeMin and value < r.rangeMax then
            return r
        end
    end

    assert(false, "Rarity random didn't work! (value "..value.."/"..totalWeightMax..")")
end