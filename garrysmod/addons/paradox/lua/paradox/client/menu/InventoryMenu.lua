import "PScrollPanel"
import "PInventoryItemEntry"
import "ItemRender"

import "PanelUtil"
import "Loadout"
import "LoadoutSlot"
import "Inventory"
import "Font"

local backgroundImage = Material("paradox/triangles.png", "noclamp")

function open()
    local player = LocalPlayer()

    local mainPanel = vgui.Create("DPanel")
    local mainPanelWidthPercent = 35
    local mainPanelWidth = vw(35)
    mainPanel:SetAlpha(0)
    mainPanel:SetSize(mainPanelWidth, vh(100))
    mainPanel:Center()

    local cx, cy = mainPanel:GetPos()
    mainPanel:SetPos(mainPanelWidth * 100 / mainPanelWidthPercent, cy)
    mainPanel:MakePopup()
    mainPanel:MoveTo(cx * 2, cy, .25)
    mainPanel:AlphaTo(255, .25)

    mainPanel.Paint = function(_, w, h)
        surface.SetDrawColor(255, 255, 255, 230)
        surface.SetMaterial(backgroundImage)
        surface.DrawTexturedRectUV(0, 0, w, h, 0, 0, w / h, 1)
    end

    local titlePanel = vgui.Create("DPanel", mainPanel)
    titlePanel:SetSize(pw(mainPanel, 100), vh(4))
    titlePanel:Dock(TOP)
    titlePanel:SetBackgroundColor(Color(45, 45, 45, 235))

    local titleText = vgui.Create("DLabel", titlePanel)
    titleText:SetText("Inventory")

    titleText:SetFont("Raleway")
    titleText:Center()
    titleText:SizeToContents()

    local closeButton = vgui.Create("DButton", titlePanel)
    closeButton:SetSize(vh(4), vh(4))
    closeButton:SetText("")
    closeButton:Dock(RIGHT)
    closeButton.Paint = function()
        surface.SetDrawColor(255, 45, 45, 255)

        if closeButton:IsHovered() then
            surface.SetDrawColor(255, 5, 5, 255)
        end

        surface.DrawRect(0, 0, closeButton:GetWide(), closeButton:GetTall())
    end

    closeButton.DoClick = function()
        mainPanel:Remove()
    end

    local modelFrame = vgui.Create("DPanel", mainPanel)
    modelFrame:SetSize(pw(mainPanel, 30), vh(50))
    modelFrame:SetPos(titlePanel:GetWide() - modelFrame:GetWide(), titlePanel:GetTall())
    modelFrame:SetBackgroundColor(Color(255, 0, 0, 45))

    local modelPanel = vgui.Create("DModelPanel", modelFrame)
    modelPanel:SetSize(modelFrame:GetSize())
    modelPanel:Dock(FILL)

    modelPanel:SetModel(player:GetModel())
    local ent = modelPanel:GetEntity()
    ent:SetAngles(Angle(0, 45, 0))
    ent:SetPos(Vector(0, 0, -25))

    modelPanel:SetFOV(60)

    modelPanel.LayoutEntity = function(ent)
    end

    local scrollFrame = vgui.Create("DPanel", mainPanel)
    scrollFrame:SetSize(pw(mainPanel, 100), vh(50) - titlePanel:GetTall())
    scrollFrame:SetBackgroundColor(Color(5, 5, 5, 215))
    scrollFrame:Dock(BOTTOM)


    local scrollPanel = vgui.Create("PScrollPanel", scrollFrame)
    scrollPanel:SetSize(pw(scrollFrame, 95), ph(scrollFrame, 95))
    scrollPanel:Center()

    local items = Inventory.GetLocal().items

    for _, item in pairs(items) do
        local entry = vgui.Create("PInventoryItemEntry", scrollPanel)
        entry:SetSize(pw(scrollPanel, 100),  ph(scrollPanel, 8))
        entry:SetItem(item)
        entry:Dock(TOP)
        entry:DockMargin(0, 5, 0, 5)

        entry:PostInit()
    end

    local loadoutFrame = vgui.Create("DPanel", mainPanel)
    loadoutFrame:SetSize(pw(mainPanel, 45), vh(50))
    loadoutFrame:SetPos(0, titlePanel:GetTall())
    loadoutFrame:SetBackgroundColor(Color(255, 0, 0, 0))

    return mainPanel
end
