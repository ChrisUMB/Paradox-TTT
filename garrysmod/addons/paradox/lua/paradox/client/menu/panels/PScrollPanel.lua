-- Pretty Scroll Panel
local PScrollPanel = {}

function PScrollPanel:Init()
    self:SetSize(100, 100)
    self:Center()
    self:SetMouseInputEnabled(true)

    local sbar = self:GetVBar()

    function sbar:Paint(w, h)
        draw.RoundedBox(10, 0, 0, w, h, Color(25, 25, 25, 255))
    end

    function sbar.btnUp:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(15, 15, 15, 255))
    end

    function sbar.btnDown:Paint(w, h)
        draw.RoundedBox(0, 0, 0, w, h, Color(15, 15, 15, 255))
    end

    function sbar.btnGrip:Paint(w, h)
        if sbar.btnGrip:IsHovered() then
            sbar.btnGrip:SetCursor("hand")
        end
        draw.RoundedBox(10, 0, 0, w, h, Color(55, 55, 55, 255))
    end
end

vgui.Register("PScrollPanel", PScrollPanel, "DScrollPanel")