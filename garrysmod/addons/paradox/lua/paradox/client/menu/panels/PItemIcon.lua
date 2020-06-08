import "ItemRender"

-- Inventory Slot
local PItemIcon = {}

function PItemIcon:Init()
    self:Center()
    self:SetMouseInputEnabled(true)

    self.OldPaint = self.Paint
    self.Paint = self.NewPaint
end

function PItemIcon:Think()
    --TODO: Delete
    self:SetItem(self.item)
end

function PItemIcon:SetItem(item)
    self.item = item

    if item then
        self.OldText = self:GetText()
        self:SetText("")

        local render = RENDER_REGISTRY[item.type.id]

        self:SetModel(render.path)
        self:SetAmbientLight(Color(255, 255, 255))
        self:SetFOV(60)

        self.LayoutEntity = function(_)
            if (self.bAnimated) then
                self:RunAnimation()
            end
        end

        local entity = self.Entity

        local pOffset = render.posOffset --PVector:new(18, 2.5, 6)
        local aOffset = render.angleOffset --PAngle:new(20, -50, 0)

        local camPOffset = render.cameraPosOffset
        local camAOffset = render.cameraAngleOffset

        entity:SetAngles(ItemRender.OFFSETS.ENTITY_ANGLE + aOffset:GetGAngle())
        entity:SetPos(ItemRender.OFFSETS.ENTITY_POSITION + pOffset:GetGVector())

        self:SetCamPos(ItemRender.OFFSETS.CAMERA_POSITION + camPOffset:GetGVector())
        self:SetLookAng(ItemRender.OFFSETS.CAMERA_ANGLE + camAOffset:GetGAngle())

    else
        self:SetModel("")

        local name = ""

        if self.LoadoutSlot then
            name = self.LoadoutSlot.name
        end

        self:SetText(name)

    end
end


function PItemIcon:NewPaint(w, h)
    local cr = 3
    local bw = 2

    local color = PColor:new(45, 45, 45, 255)

    if self.item then
        color = self.item.rarity.color:Multiply(.90)

    end

    --if self:IsHovered() then
    --    color = color:Multiply(.9)
    --end

    draw.RoundedBox(cr, 0, 0, w, h, color:Multiply(.8):GetGColor())
    draw.RoundedBox(cr, bw, bw, w - bw * 2, h - bw * 2, color:GetGColor())

    self:OldPaint(w, h)
end

vgui.Register("PItemIcon", PItemIcon, "DModelPanel")