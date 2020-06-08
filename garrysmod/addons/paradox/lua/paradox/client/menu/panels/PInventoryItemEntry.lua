import "PItemIcon"
import "StatType"

import "PanelUtil"

-- Inventory Slot
local PInventoryItemEntry = {}

local expansionTime = .25

function PInventoryItemEntry:Init()
    self:Center()
    self:SetMouseInputEnabled(true)
    self:SetText("")
    self.Expanded = false
end

function PInventoryItemEntry:PostInit()
    self.NormalSize = {}
    local size = { self:GetSize() }
    self.NormalSize.Width = size[1]
    self.NormalSize.Height = size[2]

    self.ExpandedSize = {
        Width = size[1],
        Height = size[2] * 5
    }
end

--function PInventoryItemEntry:Paint()
--    surface.SetDrawColor(255, 45, 45, 255)
--
--    --if self:IsHovered() then
--    --    surface.SetDrawColor(255, 5, 5, 255)
--    --end
--
--    surface.DrawRect(0, 0, self:GetWide(), self:GetTall())
--end

function PInventoryItemEntry:OnClick()
    if self.Expanded then
        self:Unexpand()
    else
        self:Expand()
    end
end

function PInventoryItemEntry:Expand()
    self.Expanded = true
    self:SizeTo(self.ExpandedSize.Width, self.ExpandedSize.Height, expansionTime)

    local icon = self.ItemIcon
    local dimension = self.ExpandedSize.Height * 95 / 100
    icon:SizeTo(dimension, dimension, expansionTime)
end

function PInventoryItemEntry:Unexpand()
    self.Expanded = false
    self:SizeTo(self.NormalSize.Width, self.NormalSize.Height, expansionTime)

    local icon = self.ItemIcon
    local dimension = self.NormalSize.Height * 95 / 100
    icon:SizeTo(dimension, dimension, expansionTime)
end

function PInventoryItemEntry:SetItem(item)
    self.Item = item

    self:SetBackgroundColor(Color(40, 40, 40, 255))

    if not self.ItemIcon then
        local icon = vgui.Create("PItemIcon", self)
        icon:SetItem(item)
        icon:SetSize(ph(self, 95), ph(self, 95))
        icon:SetPos(ph(self, 5), 0)
        icon:CenterVertical()

        self.ItemIcon = icon
    end

    if not self.Header then
        local header = vgui.Create("DButton", self)
        header:SetText("")

        header.Paint = function()
            local c = item.rarity.color

            surface.SetDrawColor(c:GetGColor())

            if header:IsHovered() then
                surface.SetDrawColor(c:Multiply(.9):GetGColor())
            end

            surface.DrawRect(0, 0, header:GetWide(), header:GetTall())
        end

        header.DoClick = function()
            self:OnClick()
        end

        header:CenterVertical()
        header.Height = ph(self, 90)

        local itemIcon = self.ItemIcon
        local ix, iy = itemIcon:GetPos()
        local iw, _ = itemIcon:GetSize()
        local pad = pw(self, 1)

        header:SetSize(pw(self, 99.5) - iw - pad, header.Height)

        header.Think = function()
            itemIcon = self.ItemIcon
            ix, iy = itemIcon:GetPos()
            iw, _ = itemIcon:GetSize()
            pad = pw(self, 1)

            header:SetSize(pw(self, 99.5) - iw - pad, header.Height)
            header:SetPos(ix + iw + pad, iy)
        end

        self.Header = header
    end

    if not self.ItemLabel then
        local header = self.Header
        local label = vgui.Create("DLabel", header)
        label:SetSize(pw(header, 50), ph(header, 90))
        label:SetPos(pw(header, 1), 0)
        label:SetText(item.type.DisplayName)
        label:SetColor(Color(0, 0, 0, 255))
        label:CenterVertical()

        self.ItemLabel = label
    end

    if not self.RarityLabel then
        local header = self.Header
        local label = vgui.Create("DLabel", header)

        label:Dock(RIGHT)
        label:SetText(item.rarity.DisplayName)
        label:SetColor(Color(0, 0, 0, 255))
        label:CenterVertical()
    end

    if not self.DropdownPanel then
        local header = self.Header

        local panel = vgui.Create("DPanel", self)

        panel.Think = function()
            local itemIcon = self.ItemIcon
            local ix, iy = itemIcon:GetPos()
            local iw, ih = itemIcon:GetSize()
            local wPad = pw(self, 1)
            local hPad = pw(self, 1)

            panel:SetSize(pw(self, 99.5) - iw - wPad, ih - header.Height - hPad)
            panel:SetPos(ix + iw + hPad, iy + header.Height + hPad)
        end

        panel:SetBackgroundColor(Color(0, 0, 0, 150))

        --local stats = vgui.Create("DLabel", panel)
        --stats:SetText("Stats")
        --
        --
        --
        --local values = StatType:values()
        --
        --local i = 1
        --for _, type in pairs(values) do
        --    local l = vgui.Create("DLabel", panel)
        --    l:SetText(type.name .. ": +" .. item.stats[type.name] or 0 .. "%")
        --    l:SetPos(0, i * 12)
        --
        --    i = i + 1
        --end

        self.DropdownPanel = panel
    end
end

vgui.Register("PInventoryItemEntry", PInventoryItemEntry, "DPanel")