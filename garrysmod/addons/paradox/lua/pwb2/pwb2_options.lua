CreateClientConVar("pwb2_crosshair_red", 255, true, true)
CreateClientConVar("pwb2_crosshair_green", 255, true, true)
CreateClientConVar("pwb2_crosshair_blue", 255, true, true)
CreateClientConVar("pwb2_crosshair_alpha", 255, true, true)
CreateClientConVar("pwb2_viewmodel_bobbing", 1, true, true)
hook.Add("PopulateToolMenu", "PWB2Options", function()
    spawnmenu.AddToolMenuOption("Options", "PWB 2", "pwb2_crosshair", "Crosshair", "", "", function(panel)
        panel:AddControl("Color", {
            Label = "Color",
            Red = "pwb2_crosshair_red",
            Green = "pwb2_crosshair_green",
            Blue = "pwb2_crosshair_blue",
            Alpha = "pwb2_crosshair_alpha"
        })
    end)
    spawnmenu.AddToolMenuOption("Options", "PWB 2", "pwb2_viewmodel", "View Model", "", "", function(panel)
        panel:AddControl("Slider", {
            Label = "Bobbing speed",
            Command = "pwb2_viewmodel_bobbing",
            Type = "Integer",
            Min = "0.0",
            Max = "4.0"
        })
    end)
end)