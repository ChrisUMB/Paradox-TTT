import "UUID"

function OverrideInitialize(self)
    self.Weapon:SetWeaponHoldType(self.HoldType)
    self.Idle = 0
    self.Sprint = 0
    self.IdleTimer = CurTime() + 2
end

function InitializeItem(self, item)
    self.item = item
    local stats = item.stats

    local rpm = stats.rpm or 0
    local mag = stats.magazine or 0
    local acc = stats.accuracy or 0
    local dmg = stats.damage or 0

    self.Primary.Damage = self.Primary.Damage * (1.0 + dmg / 100)

    local newMag = math.ceil(self.Primary.ClipSize * (1.0 + mag / 100))
    self.Primary.ClipSize = newMag
    self.Primary.DefaultClip = newMag
    self.Weapon:SetClip1(newMag)

    local newRpm = self.Primary.Delay * (1.0 - rpm / 100)
    self.Primary.Delay = newRpm

    local newSpreadMin = self.Primary.SpreadMin * (1.0 - acc / 100)
    local newSpreadMax = self.Primary.SpreadMax * (1.0 - acc / 100)
    self.Primary.SpreadMin = newSpreadMin
    self.Primary.SpreadMax = newSpreadMax
end

function OverridePrimaryAttack(self)
    --local uuidString = self.Weapon:GetNWString("uuid")
    --local item = ITEM_DATA[uuidString]

    if self.Reloading == 1 then
        self.Reloading = 2
    else
        if self.Reloading > 0 then
            return
        end

        if self.Weapon:Clip1() <= 0 or (self.FiresUnderwater == false and self.Owner:WaterLevel() == 3) then
            if SERVER then
                self.Owner:EmitSound("Weapon_PWB2.Empty")
            end
            self.Weapon:SetNextPrimaryFire(CurTime() + 0.1)
        end
        if self.Weapon:Clip1() <= 0 or (self.FiresUnderwater == false and self.Owner:WaterLevel() == 3) then
            return
        end

        local tr = util.TraceLine({
            start = self.Owner:GetShootPos(),
            endpos = self.Owner:GetShootPos() + (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles()):Forward() * 56756,
            filter = self.Owner,
            mask = MASK_SHOT_HULL
        })

        local bullet = {}
        bullet.Num = self.Primary.NumberofShots
        bullet.Src = self.Owner:GetShootPos()
        bullet.Dir = (tr.HitPos - self.Owner:GetShootPos()):GetNormalized()
        bullet.Spread = Vector(self.Primary.Spread, self.Primary.Spread, 0)
        bullet.Tracer = 0
        bullet.Force = self.Primary.Force
        bullet.Damage = self.Primary.Damage
        bullet.AmmoType = self.Primary.Ammo
        self.Owner:FireBullets(bullet)

        self.Weapon:ShootEffects()
        self.Weapon:TakePrimaryAmmo(self.Primary.TakeAmmo)
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Primary.Delay)

        self.Primary.SpreadTimer = CurTime() + self.Primary.SpreadTime / 7

        if self.ShotgunReload then
            self.PumpTimer = CurTime() + self.Primary.Delay
        end

        self.ReloadingTimer = CurTime() + self.Primary.Delay
        self.Idle = 0
        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    end
end

function OverrideShootEffects(self)
    self.Weapon:EmitSound(self.Primary.Sound)
    if not self.Owner:KeyDown(IN_ATTACK2) then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    end
    if self.Owner:KeyDown(IN_ATTACK2) then
        self.Weapon:SendWeaponAnim(ACT_VM_PRIMARYATTACK_DEPLOYED)

        if self.Sight then
            self.Weapon:SetNWBool("Sight", true)
        end

    end
    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self.Owner:MuzzleFlash()

    local punch = self.ViewPunch or 1.0

    if CLIENT then
        local item = self.item
        local recoil = item.stats.recoil or 0
        punch = punch * (1.0 - recoil / 100)
        self.Owner:ViewPunch(Angle(-punch, 0, math.Rand((-punch * 0.25), punch * 0.25)))
        self.Owner:SetEyeAngles(self.Owner:EyeAngles() + Angle((-punch * 0.25), math.Rand(-(punch * 0.25), punch * 0.25), 0))
    end
end

function OverrideSecondaryAttack(self)
    if self.Iron == 0 then
        self.Weapon:IronIn()
    end
end

function OverrideIronIn(self)
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
    self.Weapon:SetNWBool("Sight", true)
end

function OverrideIronOut(self)
    self.Weapon:SendWeaponAnim(ACT_VM_UNDEPLOY)
    self.Iron = 0
    self.Idle = 0
    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Owner:SetFOV(0, 0.4)
    self.Owner:SetWalkSpeed(200)
    self.Weapon:SetNWInt("MouseSensitivity", 1)
    self.Weapon:SetNWBool("Iron", false)
    self.Weapon:SetNWBool("Sight", false)
end

function OverrideReload(self)
    if self.ShotgunReload then
        if self.Reloading == 0 and self.ReloadingTimer <= CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
            self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
            self.Iron = 0
            self.Reloading = 1
            self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
            self.Sprint = 0
            self.Idle = 2
            self.Owner:SetFOV(0, 0.2)
            self.Owner:SetWalkSpeed(200)
            self.Weapon:SetNWInt("MouseSensitivity", 1)
            self.Weapon:SetNWBool("Iron", false)
        end
        return
    end

    if self.Reloading == 0 and self.ReloadingTimer <= CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
        self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
        self.Owner:SetAnimation(PLAYER_RELOAD)
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.Iron = 0
        self.Reloading = 1
        self.ReloadingTimer = CurTime() + 2
        self.Sprint = 0
        self.Idle = 0
        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Owner:SetFOV(0, 0.2)
        self.Owner:SetWalkSpeed(200)
        self.Weapon:SetNWInt("MouseSensitivity", 1)
        self.Weapon:SetNWBool("Iron", false)
    end
end

function ReloadInsert(self)
    self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
    self.Owner:SetAnimation(PLAYER_RELOAD)
    self.Weapon:SetClip1(self.Weapon:Clip1() + 1)
    self.Owner:RemoveAmmo(1, self.Primary.Ammo, false)
    self.Reloading = 1
    self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
    self.Idle = 2
end

function OverrideReloadEnd(self)

    if self.ShotgunReload then
        self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
        self:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
        self.PumpTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Reloading = 0
        self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Idle = 0
        self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        return
    end

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

function OverrideBobbing(self)
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

function OverrideIdleAnimation(self)
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

                if self.Sight then
                    self.Weapon:SetNWBool("Sight", true)
                end
            end
        end

        if self.Sprint == 1 then
            self.Weapon:SendWeaponAnim(ACT_VM_IDLE_DEPLOYED_1)
        end
    end

    self.IdleTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
end

function OverrideEquip(self)
end

function OverrideDeploy(self)
    self.Weapon:SetWeaponHoldType(self.HoldType)
    self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
    self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration())
    self.Iron = 0

    if self.ShotgunReload then
        self.PumpTimer = CurTime()
    end

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
    self.Weapon:SetNWBool("Sight", false)
    self.Weapon:SetNWBool("Iron", false)
    self.Weapon:SetNWBool("Holster", false)
    return true
end

function OverrideGetViewModelPosition(self, pos, ang)
    if self and self:IsValid() and self.Owner and self.Owner:IsValid() and self.Owner:IsOnGround() then
        --if self.Sprint == 0 then
        if self.Owner:GetVelocity():Length() < 200 then
            pos = pos + (ang:Right() * math.sin(self.BobX) * 0.25 + ang:Up() * math.sin(self.BobY) * 0.25) * self.Owner:GetVelocity():Length() / 200
            ang = ang + Angle(math.sin(self.BobY) * self.Owner:GetVelocity():Length() / 200, math.cos(self.BobX) * self.Owner:GetVelocity():Length() / 200, 0)
        end
        if self.Owner:GetVelocity():Length() >= 200 then
            pos = pos + ang:Right() * math.sin(self.BobX) * 0.25 + ang:Up() * math.sin(self.BobY) * 0.25
            ang = ang + Angle(math.sin(self.BobY), math.cos(self.BobX), 0)
        end
    end
    --pos = pos + Vector(0, 0, -.5)
    return pos, ang
end

function OverrideHolster(self, wep)
    if IsValid(wep) and wep:IsValid() and self.Owner:Alive() and self.Weapon:GetNWBool("Holster") == false then
        self.Weapon:SendWeaponAnim(ACT_VM_HOLSTER)
        self.Weapon:SetNextPrimaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() * 2)
        self.Weapon:SetNextSecondaryFire(CurTime() + self.Owner:GetViewModel():SequenceDuration() * 2)

        if self.Iron == 1 then
            self.Owner:SetFOV(0, 0.4)
        end

        if self.ShotgunReload then
            self.PumpTimer = CurTime()
        end

        self.Iron = 0
        self.DrawTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.Reloading = 0
        self.ReloadingTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration() * 2
        self.Holstering = 1
        self.HolsteringTimer = CurTime() + self.Owner:GetViewModel():SequenceDuration()
        self.HolsteringWeapon = wep:GetClass()
        --self.Sprint = 0
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
    if not IsValid(wep) or self.Weapon:GetNWBool("Holster") == true then
        return true
    end
end

function OverrideHolsterEnd(self)
    self.Holstering = 0

    if SERVER then
        self.Owner:SelectWeapon(self.HolsteringWeapon)
    end
end

function OverrideDynamicSpread(self)
    if not self.Owner then
        return
    end

    if not self.Owner:IsOnGround() then
        self.Primary.Spread = self.Primary.SpreadMax
        return
    end

    local spreadMin = self.Primary.SpreadMin
    local spreadMax = self.Primary.SpreadMax
    local velocity = self.Owner:GetVelocity()
    local timer = self.Primary.SpreadTimer - CurTime()
    local time = self.Primary.SpreadTime / 7

    local velocitySpread = math.min(math.max(velocity:Length() / self.Owner:GetWalkSpeed(), 0), 1)
    local shotSpread = math.min(math.max(timer / time, 0), 1) * 0.5

    self.Primary.Spread = (spreadMax - spreadMin) * math.max(shotSpread, velocitySpread) + spreadMin

    if self.Iron == 1 then
        self.Primary.Spread = self.Primary.Spread / 2
    end

    if self.Owner:Crouching() then
        self.Primary.Spread = self.Primary.Spread / 2
    end
end

function OverrideDrawHUD(self)
    local gap = 4
    local length = 5

    local dist1 = self.Primary.Spread / self.Primary.SpreadMax * 50 + gap
    local dist2 = self.Primary.Spread / self.Primary.SpreadMax * 50 + length + gap

    local viewpunch1 = self.Owner:GetViewPunchAngles().y * 6.67
    local viewpunch2 = self.Owner:GetViewPunchAngles().x * -6.67

    if self.Weapon:GetNWBool("Iron") == false then
        surface.SetDrawColor(GetConVar("pwb2_crosshair_red"):GetInt(), GetConVar("pwb2_crosshair_green"):GetInt(), GetConVar("pwb2_crosshair_blue"):GetInt(), GetConVar("pwb2_crosshair_alpha"):GetInt())
    end

    if self.Weapon:GetNWBool("Iron") == true then
        surface.SetDrawColor(GetConVar("pwb2_crosshair_red"):GetInt(), GetConVar("pwb2_crosshair_green"):GetInt(), GetConVar("pwb2_crosshair_blue"):GetInt(), 255)
    end

    surface.DrawLine(
            ScrW() / 2 - dist1 + viewpunch1, ScrH() / 2 + viewpunch2,
            ScrW() / 2 - dist2 + viewpunch1, ScrH() / 2 + viewpunch2
    )

    surface.DrawLine(
            ScrW() / 2 + dist2 + viewpunch1, ScrH() / 2 + viewpunch2,
            ScrW() / 2 + dist1 + viewpunch1, ScrH() / 2 + viewpunch2
    )

    surface.DrawLine(
            ScrW() / 2 + viewpunch1, ScrH() / 2 - dist1 + viewpunch2,
            ScrW() / 2 + viewpunch1, ScrH() / 2 - dist2 + viewpunch2
    )

    surface.DrawLine(
            ScrW() / 2 + viewpunch1, ScrH() / 2 + dist2 + viewpunch2,
            ScrW() / 2 + viewpunch1, ScrH() / 2 + dist1 + viewpunch2
    )
end

function OverrideViewModelDrawn(self)
    local attachment = self.Owner:GetViewModel():GetAttachment(self.Owner:GetViewModel():LookupAttachment(1))
    render.SetMaterial(Material("pwb2/vgui/sight"))
    if self.Weapon:GetNWBool("Sight") == true then
        render.DrawSprite(self.Owner:GetShootPos() + attachment.Ang:Forward() * 30, 0.5, 0.5, Color(255, 255, 255, 255))
    end
end

function OverrideAdjustMouseSensitivity(self)
    return self.Weapon:GetNWInt("MouseSensitivity", 1)
end

function OverrideThink(self)
    if not self.item then
        local uuidString = self.Weapon:GetNWString("uuid")
        local item = ITEM_DATA[uuidString]
        if item then
            InitializeItem(self, item)
        end
    end

    if self.Weapon:GetNWBool("Iron") == false then
        self.SwayScale = 0.5
    end
    if self.Weapon:GetNWBool("Iron") == true then
        self.SwayScale = 0.2
    end
    self.Weapon:DynamicSpread()

    if self.ShotgunReload then
        if self.Iron == 1 and self.PumpTimer <= CurTime() and not self.Owner:KeyDown(IN_ATTACK2) then
            self.Weapon:IronOut()
        end

        if self.PumpTimer >= CurTime() + 0.5 then
            self.Owner:ViewPunch(Angle(0.05, -0.05, 0.025))
        end
        if self.PumpTimer >= CurTime() + 0.25 and self.PumpTimer < CurTime() + 0.5 then
            self.Owner:ViewPunch(Angle(0.035, -0.035, 0.0125))
        end
        if self.PumpTimer >= CurTime() and self.PumpTimer < CurTime() + 0.25 then
            self.Owner:ViewPunch(Angle(0.015, 0, 0))
        end
        if self.DrawTimer >= CurTime() + 0.5 then
            self.Owner:ViewPunch(Angle(-0.05, -0.05, 0.025))
        end
        if self.DrawTimer >= CurTime() + 0.25 and self.DrawTimer < CurTime() + 0.5 then
            self.Owner:ViewPunch(Angle(-0.035, -0.035, 0.0125))
        end
        if self.DrawTimer >= CurTime() and self.DrawTimer < CurTime() + 0.25 then
            self.Owner:ViewPunch(Angle(-0.015, 0, 0))
        end
        if self.Reloading == 1 then
            if self.ReloadingTimer >= CurTime() + 0.25 then
                self.Owner:ViewPunch(Angle(0.05, 0.025, 0.05))
            end
            if self.ReloadingTimer >= CurTime() and self.ReloadingTimer < CurTime() + 0.25 then
                self.Owner:ViewPunch(Angle(0.025, 0.05, 0.025))
            end
            if self.ReloadingTimer <= CurTime() and self.Weapon:Clip1() < self.Primary.ClipSize and self.Weapon:Ammo1() > 0 then
                ReloadInsert(self.Weapon)
            end
            if self.ReloadingTimer <= CurTime() and (self.Weapon:Clip1() == self.Primary.ClipSize and not (self.Weapon:Clip1() > 0 and self.Weapon:Ammo1() <= 0)) then
                self.Weapon:ReloadEnd()
            end
        end
        if self.Reloading == 2 and self.ReloadingTimer <= CurTime() then
            self.Weapon:ReloadEnd()
        end
        if self.Reloading == 3 and self.ReloadingTimer <= CurTime() then
            self.Reloading = 0
        end
        if self.Holstering == 1 and self.HolsteringTimer <= CurTime() then
            self.Weapon:HolsterEnd()
        end
        if self.Reloading == 0 and self.ReloadingTimer <= CurTime() then
            if self.Sprint == 0 and self.Owner:IsOnGround() and self.Owner:GetVelocity():Length() >= 100 and self.Owner:KeyDown(IN_SPEED) and (self.Owner:KeyDown(IN_FORWARD) and not self.Owner:KeyDown(IN_BACK) and not self.Owner:KeyDown(IN_MOVELEFT) and not self.Owner:KeyDown(IN_MOVERIGHT)) then
                self.Weapon:SprintStart()
            end
            if self.Sprint == 1 and (not self.Owner:IsOnGround() and not self.Owner:GetVelocity():Length() < 100 and not not self.Owner:KeyDown(IN_SPEED) and not (self.Owner:KeyDown(IN_FORWARD) and not self.Owner:KeyDown(IN_BACK) and not self.Owner:KeyDown(IN_MOVELEFT) and not self.Owner:KeyDown(IN_MOVERIGHT))) then
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
        return
    end

    if self.Weapon:Clip1() <= 0 or self.Owner:WaterLevel() == 3 then
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
        self.Owner:ViewPunch(Angle(-0.035, -0.035, 0.0125))
    end
    if self.DrawTimer >= CurTime() and self.DrawTimer < CurTime() + 0.25 then
        self.Owner:ViewPunch(Angle(-0.015, 0, 0))
    end
    if self.Reloading == 1 then
        if self.ReloadingTimer >= CurTime() + 1.75 then
            self.Owner:ViewPunch(Angle(-0.01, 0, 0.01))
        end
        if self.ReloadingTimer >= CurTime() + 1.5 and self.ReloadingTimer < CurTime() + 1.75 then
            self.Owner:ViewPunch(Angle(-0.025, 0.025, 0.05))
        end
        if self.ReloadingTimer >= CurTime() + 1.25 and self.ReloadingTimer < CurTime() + 1.5 then
            self.Owner:ViewPunch(Angle(-0.05, 0.05, 0.05))
        end
        if self.ReloadingTimer >= CurTime() + 1 and self.ReloadingTimer < CurTime() + 1.25 then
            self.Owner:ViewPunch(Angle(-0.015, 0.035, 0.035))
        end
        if self.ReloadingTimer >= CurTime() + 0.75 and self.ReloadingTimer < CurTime() + 1 then
            self.Owner:ViewPunch(Angle(0, -0.025, 0))
        end
        if self.ReloadingTimer >= CurTime() + 0.5 and self.ReloadingTimer < CurTime() + 0.75 then
            self.Owner:ViewPunch(Angle(-0.025, -0.015, 0.05))
        end
        if self.ReloadingTimer >= CurTime() + 0.25 and self.ReloadingTimer < CurTime() + 0.5 then
            self.Owner:ViewPunch(Angle(0.05, 0.025, 0.05))
        end
        if self.ReloadingTimer >= CurTime() and self.ReloadingTimer < CurTime() + 0.25 then
            self.Owner:ViewPunch(Angle(0.025, 0.05, 0.025))
        end
        if self.ReloadingTimer <= CurTime() then
            self.Weapon:ReloadEnd()
        end
    end
    if self.Holstering == 1 and self.HolsteringTimer <= CurTime() then
        self.Weapon:HolsterEnd()
    end

    if self.Owner:IsOnGround() then
        self.Weapon:Bobbing()
    end
    if self.IdleTimer <= CurTime() then
        self.Weapon:IdleAnimation()
    end
end