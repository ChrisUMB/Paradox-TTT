local function uuid()
    local template = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function(c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

class.UUID {
    field.value("string")
}

function UUID:toString()
    return self.value
end

function UUID.fromString(str)
    return UUID:new(str)
end

function UUID.random()
    local s = uuid()
    return UUID:new(s)
end

