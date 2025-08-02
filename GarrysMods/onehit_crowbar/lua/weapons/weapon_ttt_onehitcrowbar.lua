if SERVER then
    AddCSLuaFile()
    resource.AddFile("sound/weapons/onehit/kill1.mp3")
    resource.AddFile("sound/weapons/onehit/kill2.mp3")
    resource.AddFile("sound/weapons/onehit/kill3.mp3")
    resource.AddFile("sound/weapons/onehit/fart.mp3")
    resource.AddFile("sound/weapons/onehit/imdead.mp3")
end

SWEP.Base = "weapon_zm_improvised"
SWEP.PrintName = "One-Hit Crowbar"
SWEP.Author = "Bene"
SWEP.Purpose = "Macht Aua!"
SWEP.Instructions = "Kaufen. Schlagen. Aua"
SWEP.Category = WEAPON_EQUIP

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = false

SWEP.Kind = WEAPON_EQUIP
SWEP.Slot = 6
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "One-Hit Crowbar",
    desc = "Eine Crowbar die Aua macht. Das tut sogar Kaufland weh..",
}

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"

SWEP.RiskChance = 0.05 
SWEP.FartDashChance = 0.10
SWEP.Sounds = {
    "weapons/onehit/kill1.mp3",
    "weapons/onehit/kill2.mp3",
    "weapons/onehit/kill3.mp3"
}

function SWEP:PrimaryAttack()
    if not IsFirstTimePredicted() then return end
    if self:GetNextPrimaryFire() > CurTime() then return end

    self.Owner:SetAnimation(PLAYER_ATTACK1)
    self:SendWeaponAnim(ACT_VM_HITCENTER)

    if SERVER and math.random() < self.RiskChance then
        self.Owner:Kill()
        self.Owner:PrintMessage(HUD_PRINTTALK, "Die Waffe explodierte in deiner Hand!")
        self:SetNextPrimaryFire(CurTime() + 5)
        return
    end

    local tr = util.TraceLine({
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 75,
        filter = self.Owner
    })

    if tr.Hit and IsValid(tr.Entity) then
        local ent = tr.Entity
        if ent:IsPlayer() or ent:IsNPC() then
            local dmg = DamageInfo()
            dmg:SetDamage(ent:Health() + 10)
            dmg:SetAttacker(self.Owner)
            dmg:SetInflictor(self)
            dmg:SetDamageType(DMG_CLUB)
            ent:TakeDamageInfo(dmg)

            local snd = table.Random(self.Sounds)
            sound.Play(snd, self.Owner:GetPos(), 100, 100)

            if SERVER then
                local bfx = EffectData()
                bfx:SetOrigin(ent:GetPos() + Vector(0,0,30))
                util.Effect("bloodspray", bfx, true, true)
                local efx = EffectData()
                efx:SetOrigin(ent:GetPos())
                util.Effect("HelicopterMegaBomb", efx, true, true)
            end
        end
    end

    self:SetNextPrimaryFire(CurTime() + 5)
end

function SWEP:SecondaryAttack()
    if CLIENT then return end
    if self:GetNextSecondaryFire() > CurTime() then return end

    local fwd = self.Owner:GetAimVector()
    self.Owner:SetVelocity(-fwd * 800)

    local tr = util.TraceLine({
        start = self.Owner:GetShootPos(),
        endpos = self.Owner:GetShootPos() + fwd * 75,
        filter = self.Owner
    })
    local ent = tr.Entity

    if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC()) and math.random() < self.FartDashChance then
        sound.Play("weapons/onehit/imdead.mp3", ent:GetPos(), 100, 100)
        ent:SetVelocity(Vector(0, 0, 2500))
        timer.Simple(0.5, function()
            if IsValid(ent) then ent:Kill() end
        end)
    else
        self.Owner:EmitSound("weapons/onehit/fart.mp3", 100, 100)
    end

    self:SetNextSecondaryFire(CurTime() + 3)
end

function SWEP:OnDrop()
    if SERVER then
        local efx = EffectData()
        efx:SetOrigin(self:GetPos())
        util.Effect("HelicopterMegaBomb", efx, true, true)
    end
    return self.BaseClass.OnDrop(self)
end

function SWEP:Reload() end
