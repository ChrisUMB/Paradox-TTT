local disabledHUDs = {
    ["TTTInfoPanel"] = false,
    ["CHudHealth"] = true,
    ["CHudBattery"] = true,
    ["CHudAmmo"] = true,
    ["CHudSecondaryAmmo"] = true
}

hook.Add("HUDShouldDraw", "DisableDefaultHUD", function(id)
    if(disabledHUDs[id] == true) then
        return false
    end
end)