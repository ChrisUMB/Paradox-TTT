function ph(self, percentage)
    local _, height = self:GetSize()
    return height * (percentage / 100)

end

function pw(self, percentage)
    local width, _ = self:GetSize()
    return width * (percentage / 100)
end

function vh(percentage)
    return surface.ScreenHeight() * (percentage / 100)
end

function vw(percentage)
    return surface.ScreenWidth() * (percentage / 100)
end