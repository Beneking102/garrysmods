if SERVER then
    AddCSLuaFile()
    resource.AddFile("sound/weapons/rebooter/activate.mp3")
    resource.AddFile("sound/weapons/rebooter/zap.mp3")
end

SWEP.Base = "weapon_tttbase"
SWEP.PrintName = "DNA Rebooter"
SWEP.Author = "Bene"
SWEP.Instructions = "Linksklick auf eine frische Leiche (<10s), um dem Täter 30 Schaden zuzufügen. Einweg-Tool."
SWEP.Purpose = "DNA-Rache-Tool"
SWEP.Category = WEAPON_EQUIP

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = false
SWEP.AllowDrop = true

SWEP.Kind = WEAPON_EQUIP
SWEP.Slot = 7
SWEP.CanBuy = { ROLE_DETECTIVE }
SWEP.LimitedStock = true

SWEP.ViewModel = "models/weapons/v_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Slot = -1
SWEP.Secondary.Ammo = "none"

SWEP.HasUsed = false
local FRESH_TIME = 10

function SWEP:PrimaryAttack()
    if CLIENT then return end
    if self.HasUsed then return end
    if self:GetNextPrimaryFire() > CurTime() then return end

    local owner = self.Owner
    local tr = owner:GetEyeTrace()
    local ent = tr.Entity

    if not IsValid(ent) or not ent:IsRagdoll() then return end
    if tr.HitPos:Distance(owner:GetPos()) > 100 then return end

    local ply = CORPSE.GetPlayer and CORPSE.GetPlayer(ent)
    if not IsValid(ply) or not ply:IsPlayer() then
        owner:PrintMessage(HUD_PRINTCENTER, "Keine gültige Leiche.")
        return
    end

    if not ent.time or (CurTime() - ent.time) > FRESH_TIME then
        owner:PrintMessage(HUD_PRINTCENTER, "Leiche ist zu alt für DNA-Scan.")
        return
    end

    local attacker = ply:GetNWEntity("killer_ent")
    if not IsValid(attacker) or not attacker:IsPlayer() then
        owner:PrintMessage(HUD_PRINTCENTER, "Keine DNA des Täters gefunden.")
        return
    end

    owner:EmitSound("weapons/rebooter/activate.mp3", 75, 100)
    owner:PrintMessage(HUD_PRINTCENTER, "DNA-Scan gestartet: Täter = " .. attacker:Nick())

    timer.Simple(2, function()
        if not IsValid(attacker) then return end
        local dmg = DamageInfo()
        dmg:SetDamage(30)
        dmg:SetAttacker(owner)
        dmg:SetInflictor(self)
        dmg:SetDamageType(DMG_SHOCK)
        attacker:TakeDamageInfo(dmg)
        attacker:EmitSound("weapons/rebooter/zap.mp3", 75, 100)
        attacker:PrintMessage(HUD_PRINTCENTER, "Du fühlst dich plötzlich... komisch.")
    end)

    self.HasUsed = true
    self:SetNextPrimaryFire(CurTime() + 1)
    owner:StripWeapon(self:GetClass())
end

function SWEP:SecondaryAttack() end
function SWEP:Reload() end

hook.Add("DoPlayerDeath", "Rebooter_MarkCorpse", function(victim, attacker)
    timer.Simple(0.1, function()
        local rag = victim:GetRagdollEntity()
        if IsValid(rag) then
            rag.time = CurTime()
        end
        if IsValid(attacker) and attacker:IsPlayer() then
            victim:SetNWEntity("killer_ent", attacker)
        end
    end)
end)
