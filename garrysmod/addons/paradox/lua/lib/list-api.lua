class.List {
    field.values("table", {})
}

function List:toString()
    if not self.values then
        return "List"
    end

    local result = "["
    for _, v in ipairs(self.values) do
        if #result ~= 1 then
            result = result..", "
        end
        result = result .. tostring(v)
    end
    return result .. "]"
end

function List:add(value)
    table.insert(self.values, value)
end

function List:removeAt(index)
    table.remove(self.values, index)
end

function List:get(index)
    return self.values[index]
end

function List:size()
    return #self.values
end

function List:__len()
    return self:size()
end

function List:forEach(func)
    if type(func) == "table" then func = f(func) end
    for _, v in ipairs(self.values) do
        func(v)
    end
end

function List:filter(func)
    local filterFunc = func
    if type(filterFunc) == "table" then
        filterFunc = f(filterFunc)
    end

    local result = List:new({})
    self:forEach(function(value)
        if filterFunc(value) then
            result:add(value)
        end
    end)

    return result
end

function List:first(func)
    if type(func) == "table" then func = f(func) end
    for _, v in ipairs(self.values) do
        if func == nil or func(v) then
            return v
        end
    end
end

function List:last(func)
    if type(func) == "table" then func = f(func) end
    local result = nil
    for _, v in ipairs(self.values) do
        if func == nil or func(v) then
            result = v
        end
    end
    return result
end

function List:map(func)
    if type(func) == "table" then func = f(func) end
    local result = List:new({})
    for _, v in ipairs(self.values) do
        result:add(func(v))
    end
    return result
end

function List:reversed()
    local result = List:new({})
    local values = self.values
    for i, _ in ipairs(values) do
        result:add(values[#values - i + 1])
    end
    return result
end

function List:clone()
    local result = List:new({})
    for _, v in ipairs(self.values) do
        result:add(v)
    end
    return result
end

function List:shuffled()
    local result = self:clone()
    local values = result.values
    for i = 0, #values do
        local swap = math.random(#values)
        local a = values[i]
        values[i] = values[swap]
        values[swap] = a
    end
    return result
end

---@return any a random element from the list
function List:random()
    return self:get(math.random(self:size()))
end

---@vararg any list values
function listOf(...)
    return List:new({...})
end