local arrayToString, classToString = nil, nil

local function isArray(table)
    local count = 0
    for k, v in pairs(table) do
        if tonumber(k) == nil and k ~= "n" then
            return false
        end
        count = count + 1
    end

    return count ~= 0
end

local function appendValue(append, value)
    local vType = type(value)
    if vType == "string" then append("'".. value .."'")
    elseif vType == "number" then append(value)
    elseif vType == "table" then
        if isArray(value) then
            append(arrayToString(value))
        else
            local className = value.className
            if className ~= nil and type(className) ~= "string" then
                className = nil
            end
            if className == nil or value.toString == nil then
                append(classToString(className, value))
            else
                append(value:toString())
            end
        end
    else append(tostring(value)) end
end

arrayToString = function(array)
    local result = name or ""
    local function append(value)
        result = result .. value
    end

    append("[")
    local count = 0
    for _, v in ipairs(array) do
        if count ~= 0 then
            append(",")
        end
        appendValue(append, v)

        count = count + 1
    end
    append("]")

    return result
end

classToString = function(name, table)
    local result = name or ""
    local function append(value)
        result = result .. value
    end

    append("{")

    local count = 0
    for i, v in pairs(table) do
        if type(i) ~= "string" or string.len(i) < 2 or string.sub(i, 1, 2) ~= "__" then
            local vType = type(v)
            if vType ~= "function" then
                if count ~= 0 then append(",") end
                append(tostring(i))
                append("=")
                appendValue(append, v)
                count = count + 1
            end
        end
    end

    append("}")

    return result
end

local function makeClass(name, super)
    local result = {}
    if super ~= nil then
        setmetatable(result, super)
    end
    result.__index = function(table, key)
        local v = rawget(table, key)
        if v ~= nil then return v end
        v = result[key]
        if v ~= nil then return v end

        if super == nil then return nil end
        return super[key]
    end

    result.className = name
    result.superClass = super
    result.__tostring = function(self)
        return self:toString()
        --return classToString(self.className, self)
    end

    result.isSubclassOf = function(self, otherClass)
        return self == otherClass or (self.superClass and self.superClass:isSubclassOf(otherClass)) or false
    end

    return result
end

local function classBuilder(name, defaultSuper)
    return function(properties)
        local super = defaultSuper or Object
        local fields = {}
        local enumValues = {}
        for _, v in ipairs(properties) do
            local propType = v.classProperty
            if propType == "super" then
                super = v.super or Object
            elseif propType == "field" then
                table.insert(fields, {
                    name = v.name,
                    type = v.type,
                    default = v.default
                })
            elseif propType == "enumValue" then
                assert(super == Enum, "Cannot add enum value to non-enum")
                table.insert(enumValues, v)
            end
        end

        local class = makeClass(name, super)
        class.declaredFields = fields

        local allFields = {}
        local superFields = super.allFields
        if superFields ~= nil then
            for _, v in ipairs(superFields) do table.insert(allFields, v) end
        end
        for _, v in ipairs(fields) do table.insert(allFields, v) end
        class.allFields = allFields

        function class:newByList(args)
            local values = {}

            for _, v in ipairs(self.allFields) do
                values[v.name] = v.default
            end

            for i, v in ipairs(args) do
                local field = self.allFields[i]
                local vType = type(v)
                if vType == "table" and v.getClass then
                    vType = v:getClass()
                    assert(
                            vType:isSubclassOf(field.type),
                            "constructor argument type mismatch for field "
                                    .. field.name ..", expected type "
                                    .. tostring(field.type) .." got type " .. tostring(vType)
                    )
                else
                    assert(
                            vType == field.type,
                            "constructor argument type mismatch for field "
                                    .. field.name ..", expected type "
                                    .. tostring(field.type) .." got type " .. tostring(vType)
                    )
                end

                values[field.name] = v
            end

            setmetatable(values, self)
            if values.onConstruct then values:onConstruct() end
            return values
        end

        function class:new(...)
            return self:newByList({...})
        end

        if super == Enum then
            local valuesResult = {}
            for i, v in ipairs(enumValues) do
                local value = class:newByList(v.args)
                value.name = v.name
                value.ordinal = i
                class[v.name] = value
                table.insert(valuesResult, value)
            end

            class.new = nil
            class.newByList = nil
            class.values = function() return valuesResult end
        end

        _G[name] = class

        return class
    end
end

local function fieldBuilder(key)
    return function (type, default)
        return {
            classProperty = "field",
            name = key,
            type = type,
            default = default
        }
    end
end

local function enumValueBuilder(key)
    return function(...)
        return {
            classProperty = "enumValue",
            name = key,
            args = {...}
        }
    end
end

Object = makeClass("Object")
function Object:getClass()
    return getmetatable(self)
end
function Object:toString()
    return classToString(self.className, self)
end
function Object:__tostring()
    return self:toString()
    --return classToString(self.className, self)
end

function Object:is(otherClass)
    return self:getClass() == otherClass or self:getClass():isSubclassOf(otherClass)
end

Enum = makeClass("Enum", Object)
function Enum:values()
    return self.values
end

function Enum:toString()
    if not self.name then
        return Object.toString(self)
    else
        return self.className.."."..tostring(self.name)
    end
end

class = {}
setmetatable(class, {
    __index = function(_, key) return classBuilder(key) end,
    __call = function(_, key) return classBuilder(key) end,
})

field = {}
setmetatable(field, {
    __index = function(_, key) return fieldBuilder(key) end,
    __call = function(_, key) return fieldBuilder(key) end
})

enum = {}
setmetatable(enum, {
    __index = function(_, key) return classBuilder(key, Enum) end,
    __call = function(_, key) return classBuilder(key, Enum) end
})

value = {}
setmetatable(value, {
    __index = function(_, key) return enumValueBuilder(key) end,
    __call = function(_, key) return enumValueBuilder(key) end
})

function extends(super)
    return {
        classProperty = "super",
        super = super
    }
end

--class.String()
--class.Number()
--class.Table()