FONTS_CREATED = false

if FONTS_CREATED then
    return
end

surface.CreateFont("Raleway", {
    font = "Raleway-Medium",
    size = 24,
    weight = 500
})

--Font = {}
--
--function Font:GetFont(name, size, weight)
--    size = size or 8
--    weight = weight or 500
--
--    local id = name .. ":" .. size .. "," .. weight
--
--    if Font[id] then
--        return id
--    end
--
--    surface.CreateFont(id, {
--        font = name,
--        size = size,
--        weight = weight
--    })
--
--    Font[id] = true
--    return id
--end

FONTS_CREATED = true