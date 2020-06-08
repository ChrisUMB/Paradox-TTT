if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("pwb2/vgui/weapons/deserteagle")
    SWEP.DrawWeaponInfoBox = false
    SWEP.BounceWeaponIcon = false
    killicon.Add("weapon_pwb2_deserteagle", "pwb2/vgui/weapons/deserteagle", Color(255, 255, 255, 255))
end

SWEP.PrintName = "Desert Eagle"
SWEP.Category = "PWB 2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 85
SWEP.ViewModel = "models/pwb2/weapons/v_deserteagle.mdl"
SWEP.WorldModel = "models/pwb2/weapons/w_deserteagle.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 0
SWEP.SwayScale = 0.5

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 5
SWEP.Slot = 1
SWEP.SlotPos = 0

SWEP.UseHands = false
SWEP.HoldType = "pistol"
SWEP.HoldTypeSprint = "normal"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1

SWEP.Base = "weapon_tttbase"
SWEP.Kind = WEAPON_PISTOL
SWEP.AmmoEnt = "item_ammo_deagle_ttt"

SWEP.Iron = 0
SWEP.DrawTimer = CurTime()
SWEP.Reloading = 0
SWEP.ReloadingTimer = CurTime()
SWEP.Holstering = 0
SWEP.HolsteringTimer = CurTime()
SWEP.HolsteringWeapon = 0
SWEP.Sprint = 0
SWEP.BobX = 0
SWEP.BobDirectionX = 0
SWEP.BobY = 0
SWEP.BobDirectionY = 0
SWEP.Idle = 0
SWEP.IdleTimer = CurTime()

SWEP.Primary.Sound = Sound("Weapon_PWB2_DesertEagle.Single")
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Deagle"

SWEP.Primary.Damage = 35
SWEP.Primary.TorsoDamageMultiplier = 1.0
SWEP.Primary.LimbDamageMultiplier = 0.5
SWEP.Primary.HeadDamageMultiplier = 4.0

SWEP.Primary.TakeAmmo = 1

SWEP.Primary.Spread = 0.001
SWEP.Primary.SpreadMin = 0.001
SWEP.Primary.SpreadKick = 0.035
SWEP.Primary.SpreadKickIron = 0.015
SWEP.Primary.SpreadMax = 0.07

SWEP.Primary.SpreadTimer = CurTime()
SWEP.Primary.SpreadTime = 5
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Delay = 0.2
SWEP.Primary.Force = 10

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

SWEP.Initialize = function(self)
    return OverrideInitialize(self)
end

SWEP.ApplyItem = function(self, item)
    return OverrideApplyItem(self, item)
end

SWEP.GetViewModelPosition = function(self, pos, ang)
    return OverrideGetViewModelPosition(self, pos, ang)
end

SWEP.DrawHUD = function(self)
    return OverrideDrawHUD(self)
end

SWEP.AdjustMouseSensitivity = function(self)
    return OverrideAdjustMouseSensitivity(self)
end

SWEP.Deploy = function(self)
    return OverrideDeploy(self)
end

SWEP.Holster = function(self, wep)
    return OverrideHolster(self, wep)
end

SWEP.HolsterEnd = function(self)
    return OverrideHolsterEnd(self)
end

SWEP.PrimaryAttack = function(self)
    return OverridePrimaryAttack(self)
end

SWEP.ShootEffects = function(self)
    return OverrideShootEffects(self)
end

SWEP.DynamicSpread = function(self)
    return OverrideDynamicSpread(self)
end

SWEP.SecondaryAttack = function(self)
    return OverrideSecondaryAttack(self)
end

SWEP.IronIn = function(self)
    return OverrideIronIn(self)
end

SWEP.IronOut = function(self)
    return OverrideIronOut(self)
end

SWEP.Reload = function(self)
    return OverrideReload(self)
end

SWEP.ReloadEnd = function(self)
    return OverrideReloadEnd(self)
end

SWEP.Bobbing = function(self)
    return OverrideBobbing(self)
end

SWEP.IdleAnimation = function(self)
    return OverrideIdleAnimation(self)
end

SWEP.Think = function(self)
    return OverrideThink(self)
end