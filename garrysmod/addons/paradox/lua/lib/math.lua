function math.round(value, places)
    local v = 10 ^ (places or 0)
    return math.floor(value * v + 0.5) / v
end

function math.drandom(min, max, roundPlaces)
    local intMin = math.floor(min)
    local intMax = math.floor(max)
    local intResult = math.random(intMin, intMax)
    local clampedResult = math.max(intResult, min)
    local missing = math.min(1.0, max - clampedResult)
    local result = clampedResult + math.random() * missing
    if roundPlaces then
        return math.round(result, roundPlaces)
    else
        return result
    end
end