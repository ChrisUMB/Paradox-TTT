hook.Add("Initialize", "initAmmoTypes", function()
    game.AddAmmoType({
        name = "Deagle",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 2000,
        minsplash = 10,
        maxsplash = 5
    })

    game.AddAmmoType({
        name = "Revolver",
        dmgtype = DMG_BULLET,
        tracer = TRACER_LINE,
        plydmg = 0,
        npcdmg = 0,
        force = 2000,
        minsplash = 10,
        maxsplash = 5
    })
end)