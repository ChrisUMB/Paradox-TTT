AddCSLuaFile()

ENT.PrintName = "Assault Rifle Ammo"
ENT.Category = "PWB 2"

ENT.Type = "anim"
ENT.Base = "base_ammo_ttt"
ENT.AmmoType = "Assault Rifle"
ENT.AmmoAmount = 30
ENT.AmmoMax = 90
ENT.Model = Model("models/items/357ammo.mdl")
ENT.AutoSpawnable = true

ENT.Spawnable = true
ENT.AdminOnly = false
ENT.Editable = false

function ENT:Draw()
    self.Entity:DrawModel()
end

function ENT:Initialize()
    if SERVER then
        self.Entity:SetModel("models/items/item_item_crate.mdl")
        self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
        self.Entity:SetSolid(SOLID_VPHYSICS)
        self.Entity:PhysicsInit(SOLID_VPHYSICS)
        self.Entity:SetCollisionGroup(COLLISION_GROUP_WEAPON)
    end
end

function ENT:PhysicsCollide(data)
    if SERVER then
        if data.Speed >= 300 then
            self.Entity:EmitSound("Wood.ImpactHard")
        end
        if data.Speed >= 150 and data.Speed < 300 then
            self.Entity:EmitSound("Wood.ImpactSoft")
        end
    end
end

function ENT:Use(entity)
    if SERVER and entity:IsPlayer() then
        self.User = entity
        self.Entity:Remove()
    end
end

function ENT:OnRemove()
    if SERVER and IsValid(self.User) then
        self.User:GiveAmmo(120, "Assault Rifle")
    end
end