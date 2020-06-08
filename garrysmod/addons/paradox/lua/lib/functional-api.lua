it = { it_value = true }
local it_mt = { }
setmetatable(it, it_mt)
setmetatable(it_mt, {
    __index = function(table, key)
    end
})

function it_mt.__index(tbl, key)
    return setmetatable({ operation = "__index", a = tbl, b = key}, it_mt)
end
function it_mt.__call(tbl, ...)
    return setmetatable({ operation = "__call", a = tbl, b = table.pack(...)}, it_mt)
end
function it_mt.__add(a, b)
    return setmetatable({ operation = "__add", a = a, b = b }, it_mt)
end
function it_mt.__sub(a, b)
    return setmetatable({ operation = "__sub", a = a, b = b }, it_mt)
end
function it_mt.__mul(a, b)
    return setmetatable({ operation = "__mul", a = a, b = b }, it_mt)
end
function it_mt.__div(a, b)
    return setmetatable({ operation = "__div", a = a, b = b }, it_mt)
end

local operations = {
    __add = function(a, b)
        return a + b
    end,
    __sub = function(a, b)
        return a - b
    end,
    __mul = function(a, b)
        return a * b
    end,
    __div = function(a, b)
        return a / b
    end,
    __index = function(a, b)
        return a[b]
    end,
    __call = function(a, b)
        return a(table.unpack(b))
    end
}

function unpackIt(tbl, value)
    local result = tbl
    if type(tbl) == "table" then
        if tbl.it_value == true then
            tbl = value
        elseif tbl.operation ~= nil then
            tbl = eval(tbl, value)
        else
            result = {}
            for i, v in pairs(tbl) do
                result[i] = unpackIt(v, value)
            end
            return result
        end
    end

    return tbl
end

function eval(ast, value)
    local op = ast.operation
    local opf = operations[op]
    local a = unpackIt(ast.a, value)
    local b = unpackIt(ast.b, value)

    local result = opf(a, b)
    if type(result) == "table" and result.it_value == true then
        return value
    end
    return result
end

function f(ast)
    return function(value)
        return eval(ast, value)
    end
end
