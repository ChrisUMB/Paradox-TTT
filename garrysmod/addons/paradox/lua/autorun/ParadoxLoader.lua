resource.AddFile("resource/fonts/Raleway-Medium.ttf")

function resource.AddDir(directory)
    local files, directories = file.Find("addons/paradox/" .. directory .. "/" .. "*", "GAME")
    for _, v in ipairs(files) do
        resource.AddFile(directory .. "/" .. v)
    end

    for _, v in ipairs(directories) do
        resource.AddDir(directory .. "/" .. v)
    end
end

local function includeDirCS(directory)
    local files, directories = file.Find(directory .. "/" .. "*", "LUA")
    for _, v in ipairs(files) do
        local p = directory .. "/" .. v
        AddCSLuaFile(p)
        include(p)
    end

    for _, v in ipairs(directories) do
        includeDirCS(directory .. "/" .. v)
    end
end

IncludeCS("lib/math.lua")
IncludeCS("lib/class-api.lua")
IncludeCS("lib/functional-api.lua")
IncludeCS("lib/list-api.lua")

if SERVER then
    resource.AddDir("materials")
    resource.AddDir("models")
    resource.AddDir("sound")
    resource.AddDir("resources")
end

local cache = {}

local function cachePaths(directory, client, server)
    local files, directories = file.Find(directory .. "/*", "LUA")

    local extension = ".lua"

    for _, v in ipairs(files) do
        if v:sub(-#extension) == extension then
            local path = directory .. "/" .. v

            local name = v:sub(0, -#extension - 1):lower()

            cache[name] = {
                path = path,
                client = client,
                server = server,
                imported = false
            }

            print("Caching " .. name .. " to '" .. path .. "'")
        end
    end

    for _, v in ipairs(directories) do
        cachePaths(directory .. "/" .. v, client, server)
    end
end

cachePaths("paradox/client", true, false)
cachePaths("paradox/shared", true, true)
cachePaths("paradox/server", false, true)

function import(class)
    class = class:lower()
    local data = cache[class]

    assert(data, class .. " does not have a cached path, failed to import.")
    local path = data.path


    if data.imported then
        return
    end

    data.imported = true

    if (data.client and CLIENT) or (data.server and SERVER) then
        print("Importing " .. class)
        include(path)
    end

    if data.client and SERVER then
        AddCSLuaFile(path)
    end
end

--Import everything!
for name, _ in pairs(cache) do
    import(name)
end

-- PWB2 Assault Rifles
includeDirCS("pwb2")

print("[Paradox-TTT] Loader ran successfully.")