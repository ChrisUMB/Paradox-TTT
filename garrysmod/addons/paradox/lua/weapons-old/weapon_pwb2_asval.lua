if CLIENT then
    SWEP.WepSelectIcon = surface.GetTextureID("pwb2/vgui/weapons/asval")
    SWEP.DrawWeaponInfoBox = false
    SWEP.BounceWeaponIcon = false
    killicon.Add("weapon_pwb2_asval", "pwb2/vgui/weapons/asval", Color(255, 255, 255, 255))
end

SWEP.PrintName = "AS Val"
SWEP.Category = "PWB 2"
SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AdminOnly = false

SWEP.ViewModelFOV = 85
SWEP.ViewModel = "models/pwb2/weapons/v_asval.mdl"
SWEP.WorldModel = "models/pwb2/weapons/w_asval.mdl"
SWEP.ViewModelFlip = false
SWEP.BobScale = 0
SWEP.SwayScale = 0.5

SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Weight = 10
SWEP.Slot = 2
SWEP.SlotPos = 0

SWEP.UseHands = false
SWEP.HoldType = "ar2"
SWEP.HoldTypeSprint = "passive"
SWEP.FiresUnderwater = true
SWEP.DrawCrosshair = false
SWEP.DrawAmmo = true
SWEP.CSMuzzleFlashes = 1
SWEP.Base = "weapon_base"

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

SWEP.Primary.Sound = Sound("Weapon_PWB2_ASVal.Single")
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Damage = 36
SWEP.Primary.TakeAmmo = 1
SWEP.Primary.Spread = 0.001
SWEP.Primary.SpreadMin = 0.001
SWEP.Primary.SpreadKick = 0.02
SWEP.Primary.SpreadKickIron = 0.005
SWEP.Primary.SpreadMax = 0.04
SWEP.Primary.SpreadTimer = CurTime()
SWEP.Primary.SpreadTime = 3
SWEP.Primary.NumberofShots = 1
SWEP.Primary.Delay = 0.075
SWEP.Primary.Force = 4.5

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
    self.Weapon:SetWeaponHoldType(self.HoldType)
    self.Idle = 0
    self.IdleTimer = CurTime() + 2
end

function SWEP:GetViewModelPosition(pos, ang)
    if self.Owner:IsOnGround() then
        if self.Sprint == 0 then
            if self.Owner:GetVelocity():Length() < 200 then
                pos = pos + (ang:Right() * math.sin(self.BobX) * 0.25 + ang:Up() * math.sin(self.BobY) * 0.25) * self.Owner:GetVelocity():Length() / 200
                ang = ang + Angle(math.sin(self.BobY) * self.Owner:GetVelocity():Length() / 200, math.cos(self.BobX) * self.Owner:GetVelocity():Length() / 200, 0)
            end
            if self.Owner:GetVelocity():Length() >= 200 then
                pos = pos + ang:Right() * math.sin(self.BobX) * 0.25 + ang:Up() * math.sin(self.BobY) * 0.25
                ang = ang + Angle(math.sin(self.BobY), math.cos(self.BobX), 0)
            end
        end
        if self.Sprint == 1 then
            pos = pos + ang:Right() * math.sin(self.BobX) + ang:Up() * math.sin(self.BobY) * 0.25
            ang = ang + Angle(math.sin(self.BobY), math.cos(self.BobX) * 1.5, 0)
        end
    end
    return pos, ang
end

function SWEP:DrawHUD()
    local dist1 = self.Primary.Spread / self.Primary.SpreadMax * 50
    local dist2 = self.Primary.Spread / self.Primary.SpreadMax * 50 + 10
    local viewpunch1 = self.Owner:GetViewPunchAngles().y * 6.67
    local viewpunch2 = self.Owner:GetViewPunchAngles().x * -6.67
    if self.Weapon:GetNWBool("Iron") == false then
        surface.SetDrawColor(GetConVar("pwb2_crosshair_red"):GetInt(), GetConVar("pwb2_crosshair_green"):GetInt(), GetConVar("pwb2_crosshair_blue"):GetInt(), GetConVar("pwb2_crosshair_alpha"):GetInt())
    end
    if self.Weapon:GetNWBool("Iron") == true then
        surface.SetDrawColor(GetConVar("pwb2_crosshair_red"):GetInt(), GetConVar("pwb2_crosshair_green"):GetInt(), GetConVar("pwb2_crosshair_blue"):GetInt(), 0)
    end
    surface.DrawLine(ScrW() / 2 - dist1 + viewpunch1, ScrH() / 2 + viewpunch2, ScrW() / 2 - dist2 + viewpunch1, ScrH() / 2 + viewpunch2)
    surface.DrawLine(ScrW() / 2 + dist2 + viewpunch1, ScrH() / 2 + viewpunch2, ScrW() / 2 + dist1 + viewpunch1, ScrH() / 2 + viewpunch2)
    surface.DrawLine(ScrW() / 2 + viewpunch1, ScrH() / 2 - dist1 + viewpunch2, ScrW() / 2 + viewpunch1, ScrH() / 2 - dist2 + viewpunch2)
    surface.DrawLine(ScrW() / 2 + viewpunch1, ScrH() / 2 + dist2 + viewpunch2, ScrW() / 2 + viewpunch1, ScrH() / 2 + dist1 + viewpunch2)
end

function SWEP:AdjustMouseSensitivity()
    return self.Weapon:GetNWInt("MouseSensitivity", 1)
end

function SWEP:Deploy()
    self.Weapon:SetWeaponHoldType(self.HoldType)
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self.Iron = 0
    self.DrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Reloading = 0
    self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Holstering = 0
    self.HolsteringTimer = CurTime()
    self.HolsteringWeapon = 0
    self.Sprint = 0
    self.BobX = 0
    self.BobDirectionX = 0
    self.BobY = 0
    self.BobDirectionY = 0
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Owner:SetWalkSpeed(200)
    self.Weapon:SetNWInt("MouseSensitivity", 1)
    self.Weapon:SetNWBool("Iron", false)
    self.Weapon:SetNWBool("Holster", false)
    return true
end

function SWEP:Holster(wep)
    if IsValid(wep) and self.Owner:Alive() and self.Weapon:GetNWBool("Holster") == false then
        self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER)
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() * 2)
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() * 2)
        self.Iron = 0
        self.DrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Reloading = 0
        self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration() * 2
        self.Holstering = 1
        self.HolsteringTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.HolsteringWeapon = wep:GetClass()
        self.Sprint = 0
        self.BobX = 0
        self.BobDirectionX = 0
        self.BobY = 0
        self.BobDirectionY = 0
        self.Idle = 2
        self.Owner:SetWalkSpeed(200)
        self.Weapon:SetNWInt("MouseSensitivity", 1)
        self.Weapon:SetNWBool("Iron", false)
        self.Weapon:SetNWBool("Holster", true)
        return
    end
    if not IsValid(wep) and not self.Weapon:GetNWBool("Holster") == true then
        return true
    end
end

function SWEP:HolsterEnd()
    self.Holstering = 0
    if SERVER then
        self.Owner:SelectWeapon(self.HolsteringWeapon)
    end
end

function SWEP:PrimaryAttack()
    if self.Weapon:Clip1() <= 0 and not (self.FiresUnderwater == false and self.Owner:WaterLevel() == 3) then
    if SERVER then
    self.Owner:EmitSound("Weapon_PWB2.Empty")
    end
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.1)
    end
    if self.Weapon:Clip1() <= 0 and not (self.FiresUnderwater == false and self.Owner:WaterLevel() == 3) then
    return
    end
    local tr = util.TraceLine( {
    start = self.Owner:GetShootPos(),
    endpos = self.Owner:GetShootPos() + (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward() * 56756,
    filter = self.Owner,
    mask = MASK_SHOT_HULL
    } )
    local bullet = {}
    bullet.Num = self.Primary.NumberofShots
    bullet.Src = self.Owner:GetShootPos()
    bullet.Dir = (tr.HitPos - self.Owner:GetShootPos()):GetNormalized()
    bullet.Spread = Vector(self.Primary.Spread, self.Primary.Spread, 0 )
    bullet.Tracer = 0
    bullet.Force = self.Primary.Force
    bullet.Damage = self.Primary.Damage
    bullet.AmmoType = self.Primary.Ammo
    self.Owner:FireBullets(bullet )
    self.Weapon:ShootEffects()
    self.Weapon:TakePrimaryAmmo(self.Primary.TakeAmmo)
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
    self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
    if self.Primary.Spread < self.Primary.SpreadMax then
    if self.Iron == 0 then
    self.Primary.Spread = self.Primary.Spread + self.Primary.SpreadKick
    end
    if self.Iron == 1 then
    self.Primary.Spread = self.Primary.Spread + self.Primary.SpreadKickIron
    end
    end
    self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime
    self.ReloadingTimer = CurTime() + self.Primary.Delay
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:ShootEffects()
    self.Weapon:EmitSound(self.Primary.Sound)
    if not self.Owner:KeyDown(IN_ATTACK2) then
    self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    end
    if self.Owner:KeyDown(IN_ATTACK2) then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_DEPLOYED)
    end
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self.Owner:ViewPunch(Angle(-1, 0, math.Rand(-1, 1)))
    self.Owner:SetEyeAngles(self.Owner:EyeAngles() + Angle(-1, math.Rand(-0.25, 0.25), 0))
end

function SWEP:DynamicSpread()
    if self.Owner:IsOnGround() then
        if self.Owner:GetVelocity():Length() <= 125 then
            if self.Primary.SpreadTimer <= CurTime() then
                self.Primary.Spread = self.Primary.SpreadMin
            end
            if self.Primary.Spread > self.Primary.SpreadMin then
                self.Primary.Spread = ((self.Primary.SpreadTimer - CurTime()) / self.Primary.SpreadTime) * self.Primary.Spread
            end
        end
        if self.Owner:GetVelocity():Length() <= 125 and self.Primary.Spread > self.Primary.SpreadMax then
            self.Primary.Spread = self.Primary.SpreadMax
        end
        if self.Owner:GetVelocity():Length() > 125 then
            self.Primary.Spread = self.Primary.SpreadMax
            self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime
            if self.Primary.Spread > self.Primary.SpreadMax then
                self.Primary.Spread = ((self.Primary.SpreadTimer - CurTime()) / self.Primary.SpreadTime) * self.Primary.SpreadMax
            end
        end
    end
    if not self.Owner:IsOnGround() then
    self.Primary.Spread = self.Primary.SpreadMax
    self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime
    if self.Primary.Spread > self.Primary.SpreadMin then
    self.Primary.Spread = ((self.Primary.SpreadTimer - CurTime()) / self.Primary.SpreadTime) * self.Primary.SpreadMax
        end
    end
end

function SWEP:SecondaryAttack()
    if self.Iron == 0 then
        self.Weapon:IronIn()
    end
end

function SWEP:IronIn()
    if SERVER then
        self.Owner:EmitSound("Weapon_PWB2.Iron")
    end
    self.Weapon:SendWeaponAnim(ACT_VM_DEPLOY)
    self.Iron = 1
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Owner:SetFOV(0, 0)
    self.Weapon:SetNWInt("MouseSensitivity", (self.Owner:GetFOV() - 25) / self.Owner:GetFOV())
    self.Owner:SetFOV(self.Owner:GetFOV() - 25, 0.4)
    self.Owner:SetWalkSpeed(100)
    self.Weapon:SetNWBool("Iron", true)
end

function SWEP:IronOut()
    self.Weapon:SendWeaponAnim(ACT_VM_UNDEPLOY)
    self.Iron = 0
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Owner:SetFOV(0, 0.4)
    self.Owner:SetWalkSpeed(200)
    self.Weapon:SetNWInt("MouseSensitivity", 1)
    self.Weapon:SetNWBool("Iron", false)
end

function SWEP:Reload()
    if self.Reloading == 0 and self.ReloadingTimer <= CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
        self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
        self.Owner:SetAnimation(PLAYER_RELOAD)
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.Iron = 0
        self.Reloading = 1
        self.ReloadingTimer = CurTime() + 3.25
        self.Sprint = 0
        self.Idle = 0
        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Owner:SetFOV(0, 0.2)
        self.Owner:SetWalkSpeed(200)
        self.Weapon:SetNWInt("MouseSensitivity", 1)
        self.Weapon:SetNWBool("Iron", false)
    end
end

function SWEP:ReloadEnd()
    if self.Weapon:Ammo1() > (self.Primary.ClipSize - self.Weapon:Clip1()) then
        self.Owner:SetAmmo(self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1(), self.Primary.Ammo)
        self.Weapon:SetClip1(self.Primary.ClipSize)
    end
    if (self.Weapon:Ammo1() - self.Primary.ClipSize + self.Weapon:Clip1()) + self.Weapon:Clip1() < self.Primary.ClipSize then
        self.Weapon:SetClip1(self.Weapon:Clip1() + self.Weapon:Ammo1())
        self.Owner:SetAmmo(0, self.Primary.Ammo)
    end
    self.Reloading = 0
end

function SWEP:SprintStart()
    if SERVER then
        self.Weapon:SendWeaponAnim(ACT_VM_DEPLOY_1)
    end
    self.Iron = 0
    self.Sprint = 1
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Owner:SetFOV(0, 0.2)
    self.Owner:SetWalkSpeed(200)
    self.Weapon:SetNWInt("MouseSensitivity", 1)
    self.Weapon:SetNWBool("Iron", false)
end

function SWEP:SprintFinish()
    if SERVER then
        self.Weapon:SendWeaponAnim(ACT_VM_UNDEPLOY_1)
    end
    self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Sprint = 0
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:Bobbing()
    if self.BobX >= -90 and self.BobDirectionX == 0 then
        if self.Sprint == 0 then
            self.BobX = self.BobX - FrameTime() * (self.Owner:GetVelocity():Length() / 200) * 4 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
        if self.Sprint == 1 then
            self.BobX = self.BobX - FrameTime() * (self.Owner:GetVelocity():Length() / 400) * 5 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
    end
    if self.BobX < -90 then
        self.BobDirectionX = 1
    end
    if self.BobX <= 90 and self.BobDirectionX == 1 then
        if self.Sprint == 0 then
            self.BobX = self.BobX + FrameTime() * (self.Owner:GetVelocity():Length() / 200) * 4 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
        if self.Sprint == 1 then
            self.BobX = self.BobX + FrameTime() * (self.Owner:GetVelocity():Length() / 400) * 5 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
    end
    if self.BobX > 90 then
        self.BobDirectionX = 0
    end
    if self.BobY >= -45 and self.BobDirectionY == 0 then
        if self.Sprint == 0 then
            self.BobY = self.BobY - FrameTime() * (self.Owner:GetVelocity():Length() / 200) * 8 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
        if self.Sprint == 1 then
            self.BobY = self.BobY - FrameTime() * (self.Owner:GetVelocity():Length() / 400) * 10 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
    end
    if self.BobY < -45 then
        self.BobDirectionY = 1
    end
    if self.BobY <= 45 and self.BobDirectionY == 1 then
        if self.Sprint == 0 then
            self.BobY = self.BobY + FrameTime() * (self.Owner:GetVelocity():Length() / 200) * 8 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
        if self.Sprint == 1 then
            self.BobY = self.BobY + FrameTime() * (self.Owner:GetVelocity():Length() / 400) * 10 * GetConVar("pwb2_viewmodel_bobbing"):GetInt()
        end
    end
    if self.BobY > 45 then
        self.BobDirectionY = 0
    end
    if self.Sprint == 0 then
        if self.Owner:GetVelocity():Length() < 200 then
            self.Owner:ViewPunch(Angle(math.sin(self.BobY) * 0.025 * self.Owner:GetVelocity():Length() / 200, math.sin(self.BobX) * 0.025 * self.Owner:GetVelocity():Length() / 200, 0))
        end
        if self.Owner:GetVelocity():Length() >= 200 then
            self.Owner:ViewPunch(Angle(math.sin(self.BobY) * 0.025, math.sin(self.BobX) * 0.025, 0))
        end
    end
    if self.Sprint == 1 then
        self.Owner:ViewPunch(Angle(math.sin(self.BobY) * 0.0375, math.sin(self.BobX) * 0.075, 0))
    end
end

function SWEP:IdleAnimation()
    if self.Idle == 0 then
        self.Idle = 1
    end
    if SERVER and self.Idle == 1 then
        if self.Sprint == 0 then
            if self.Iron == 0 then
                self.Weapon:SendWeaponAnim(ACT_VM_IDLE)
            end
            if self.Iron == 1 then
                self.Weapon:SendWeaponAnim(ACT_VM_IDLE_DEPLOYED)
            end
        end
        if self.Sprint == 1 then
            self.Weapon:SendWeaponAnim(ACT_VM_IDLE_DEPLOYED_1)
        end
    end
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function SWEP:Think()
    if self.Weapon:GetNWBool("Iron") == false then
        self.SwayScale = 0.5
    end
    if self.Weapon:GetNWBool("Iron") == true then
        self.SwayScale = 0.2
    end
    self.Weapon:DynamicSpread()
    if self.Weapon:Clip1() <= 0 and not self.Owner:WaterLevel() == 3 then
    self.Primary.Automatic = false
    end
    if self.Weapon:Clip1() > 0 and self.Owner:WaterLevel() <= 3 then
    self.Primary.Automatic = true
    end
    if self.Iron == 1 and not self.Owner:KeyDown(IN_ATTACK2) then
    self.Weapon:IronOut()
    end
    if self.DrawTimer >= CurTime() + 0.5 then
    self.Owner:ViewPunch(Angle(-0.05, -0.05, 0.025))
    end
    if self.DrawTimer >= CurTime() + 0.25 and self.DrawTimer < CurTime() + 0.5 then
    self.Owner:ViewPunch(Angle( -0.035, -0.035, 0.0125))
    end
    if self.DrawTimer >= CurTime() and self.DrawTimer < CurTime() + 0.25 then
    self.Owner:ViewPunch(Angle(-0.015, 0, 0))
    end
    if self.Reloading == 1 then
    if self.ReloadingTimer >= CurTime() + 3 then
    self.Owner:ViewPunch( Angle(-0.025, 0.025, 0.025))
    end
    if self.ReloadingTimer >= CurTime() + 2.75 and self.ReloadingTimer < CurTime() + 3 then
    self.Owner:ViewPunch(Angle( -0.05, 0.05, 0.05))
    end
    if self.ReloadingTimer >= CurTime() + 2.5 and self.ReloadingTimer < CurTime() + 2.75 then
    self.Owner:ViewPunch(Angle(-0.05, 0.05, 0.05))
    end
    if self.ReloadingTimer >= CurTime() + 2.25 and self.ReloadingTimer < CurTime() + 2.5 then
    self.Owner:ViewPunch(Angle(0, 0.025, 0))
    end
    if self.ReloadingTimer >= CurTime() + 2 and self.ReloadingTimer < CurTime() + 2.25 then
    self.Owner:ViewPunch(Angle(-0.015, 0.035, 0.035) )
    end
    if self.ReloadingTimer >= CurTime() + 1.75 and self.ReloadingTimer < CurTime() + 2 then
    self.Owner:ViewPunch(Angle(-0.05, -0.015, 0.025))
    end
    if self.ReloadingTimer >= CurTime() + 1.5 and self.ReloadingTimer < CurTime() + 1.75 then
    self.Owner:ViewPunch(Angle( -0.025, -0.025, 0.05))
    end
    if self.ReloadingTimer >= CurTime() + 1.25 and self.ReloadingTimer < CurTime() + 1.5 then
    self.Owner:ViewPunch(Angle(-0.05, 0, 0.05))
    end
    if self.ReloadingTimer >= CurTime() + 1 and self.ReloadingTimer < CurTime() + 1.25 then
    self.Owner:ViewPunch(Angle(-0.015, 0.035, 0.035))
    end
    if self.ReloadingTimer >= CurTime() + 0.75 and self.ReloadingTimer < CurTime() + 1 then
    self.Owner:ViewPunch(Angle(0, 0.015, 0 ))
    end
    if self.ReloadingTimer >= CurTime() + 0.5 and self.ReloadingTimer < CurTime() + 0.75 then
    self.Owner:ViewPunch( Angle(-0.025, -0.015, 0.05) )
    end
    if self.ReloadingTimer >= CurTime() + 0.25 and self.ReloadingTimer < CurTime() + 0.5 then
    self.Owner:ViewPunch(Angle(0.05, -0.025, 0.05))
    end
    if self.ReloadingTimer >= CurTime() and self.ReloadingTimer < CurTime() + 0.25 then
    self.Owner:ViewPunch(Angle(0.025, -0.05, 0.025))
    end
    if self.ReloadingTimer <= CurTime() then
    self.Weapon:ReloadEnd()
    end
    end
    if self.Holstering == 1 and self.HolsteringTimer <= CurTime() then
    self.Weapon:HolsterEnd()
    end
    if self.Reloading == 0 and self.ReloadingTimer <= CurTime() then
    if self.Sprint == 0 and self.Owner:IsOnGround() and self.Owner:GetVelocity():Length() >= 100 and self.Owner:KeyDown(IN_SPEED) and (self.Owner:KeyDown(IN_FORWARD) and not self.Owner:KeyDown(IN_BACK) and not self.Owner:KeyDown(IN_MOVELEFT) and not self.Owner:KeyDown(IN_MOVERIGHT)) then
    self.Weapon:SprintStart()
    end
    if self.Sprint == 1 and (not self.Owner:IsOnGround() and not self.Owner:GetVelocity():Length() < 100 and not not self.Owner:KeyDown(IN_SPEED ) and not (self.Owner:KeyDown(IN_FORWARD) and not self.Owner:KeyDown(IN_BACK) and not self.Owner:KeyDown(IN_MOVELEFT) and not self.Owner:KeyDown(IN_MOVERIGHT))) then
    self.Weapon:SprintFinish()
    end
    end
    if self.Sprint == 0 then
    self.Weapon:SetHoldType(self.HoldType)
    end
    if self.Sprint == 1 then
    self.Weapon:SetHoldType(self.HoldTypeSprint)
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.33)
    self.Weapon:SetNextSecondaryFire(CurTime() + 0.33)
    end
    if self.Owner:IsOnGround() then
    self.Weapon:Bobbing()
    end
    if self.IdleTimer <= CurTime() then
    self.Weapon:IdleAnimation()
    end
end