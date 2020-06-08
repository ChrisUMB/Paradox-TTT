-- Deagle ammo override

AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "Revolver"
ENT.AmmoAmount = 12
ENT.AmmoMax = 36
ENT.Model = Model("models/items/357ammo.mdl")
ENT.AutoSpawnable = true

function ENT:Initialize()
    -- Differentiate from rifle ammo
    self:SetColor(Color(255, 100, 100, 255))

    return self.BaseClass.Initialize(self)
end

function ENT:Use(entity)
    if SERVER and entity:IsPlayer() then
        self.User = entity
        self.Entity:Remove()
    end
end

function ENT:OnRemove()
    if SERVER and IsValid(self.User) then
        self.User:GiveAmmo(self.AmmoAmount, self.AmmoType)
    end
end