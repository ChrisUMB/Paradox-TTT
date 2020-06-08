import "InventoryMenu"

local lastPress = os.clock()
local delayTime = 0.5
local frame

local function KeyPress()

    local currentTime = os.clock()
    if currentTime <= (lastPress + delayTime) then
        return
    end

    if input.IsKeyDown(KEY_I) then
        lastPress = currentTime

        if frame ~= nil and frame:IsValid() then

            local cx, cy = frame:GetPos()
            local fw, _ = frame:GetSize()

            frame:AlphaTo(0, .25)
            frame:MoveTo(surface.ScreenWidth(), cy, .25, 0, -1, function(data, panel)
                panel:Remove()
                panel = nil
            end)


            return
        end

        if vgui.CursorVisible() then
            return
        end

        frame = open()
    end

end

hook.Add("Think", "pManageInventoryKey", KeyPress)