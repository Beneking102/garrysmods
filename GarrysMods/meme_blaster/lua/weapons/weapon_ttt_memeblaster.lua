if SERVER then
    AddCSLuaFile()
    -- Distribute sound files
    resource.AddFile("sound/weapons/memeblaster/dealwithit.mp3")
    resource.AddFile("sound/weapons/memeblaster/rickroll.mp3")
    resource.AddFile("sound/weapons/memeblaster/meow.mp3")
    resource.AddFile("sound/weapons/memeblaster/teletubby.mp3")
    resource.AddFile("sound/weapons/memeblaster/8bit.wav")
    resource.AddFile("sound/weapons/memeblaster/nyan.mp3")
    resource.AddFile("sound/weapons/memeblaster/fatality.mp3")
    resource.AddFile("sound/weapons/memeblaster/bruh.mp3")
end

SWEP.Base = "weapon_zm_base"
SWEP.PrintName = "Meme-Blaster"
SWEP.Author = "Bene"
SWEP.Instructions = "Linksklick auf ein Ziel um einen zufälligen Meme-Effekt auszulösen."
SWEP.Category = WEAPON_EQUIP

SWEP.Spawnable = true
SWEP.AdminSpawnable = true
SWEP.AutoSpawnable = false

SWEP.Kind = WEAPON_EQUIP
SWEP.Slot = 6
SWEP.CanBuy = { ROLE_TRAITOR, ROLE_DETECTIVE }
SWEP.LimitedStock = false
SWEP.AllowDrop = true
SWEP.EquipMenuData = {
    type = "item_weapon",
    name = "Meme-Blaster",
    desc = "Eine Waffe, die bei jedem Schuss verrückte Meme-Effekte auslöst.",
}

SWEP.ViewModel = "models/weapons/c_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"
SWEP.UseHands = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

-- Primary attack: random meme effect
function SWEP:PrimaryAttack()
    if CLIENT then return end
    if self:GetNextPrimaryFire() > CurTime() then return end

    local owner = self.Owner
    owner:SetAnimation(PLAYER_ATTACK1)
    self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
    self:SetNextPrimaryFire(CurTime() + 1)

    -- Trace target
    local tr = util.TraceLine({
        start = owner:GetShootPos(),
        endpos = owner:GetShootPos() + owner:GetAimVector() * 500,
        filter = owner
    })
    if not tr.Hit or not IsValid(tr.Entity) then return end

    local ent = tr.Entity
    local effectID = math.random(1, 8)

    -- 1. Deal With It
    if effectID == 1 then
        sound.Play("weapons/memeblaster/dealwithit.mp3", ent:GetPos(), 100, 100)
        net.Start("Meme_DWIT") net.Send(ent)

    -- 2. Rickroll
    elseif effectID == 2 then
        sound.Play("weapons/memeblaster/rickroll.mp3", ent:GetPos(), 100, 100)
        net.Start("Meme_RickRoll") net.Send(ent)

    -- 3. Cat Overload
    elseif effectID == 3 then
        sound.Play("weapons/memeblaster/meow.mp3", ent:GetPos(), 100, 100)
        for i = 1, 5 do
            timer.Simple(i * 0.1, function()
                if not IsValid(ent) then return end
                local npc = ents.Create("npc_citizen")
                npc:SetPos(ent:GetPos() + Vector(math.random(-20,20), math.random(-20,20), 0))
                npc:Spawn()
            end)
        end

    -- 4. Teletubby-Lawnmower Debuff
    elseif effectID == 4 then
        sound.Play("weapons/memeblaster/teletubby.mp3", ent:GetPos(), 100, 100)
        if ent:IsPlayer() then
            local oldWalk = ent:GetWalkSpeed()
            local oldRun = ent:GetRunSpeed()
            ent:SetWalkSpeed(oldWalk * 0.5)
            ent:SetRunSpeed(oldRun * 0.5)
            timer.Simple(10, function()
                if IsValid(ent) then
                    ent:SetWalkSpeed(oldWalk)
                    ent:SetRunSpeed(oldRun)
                end
            end)
        end

    -- 5. Pixelate
    elseif effectID == 5 then
        sound.Play("weapons/memeblaster/8bit.mp3", ent:GetPos(), 100, 100)
        net.Start("Meme_Pixelate") net.Send(ent)

    -- 6. Nyan Cat Trail
    elseif effectID == 6 then
        sound.Play("weapons/memeblaster/nyan.mp3", ent:GetPos(), 100, 100)
        net.Start("Meme_Nyan") net.Send(ent)

    -- 7. Fatality
    elseif effectID == 7 then
        sound.Play("weapons/memeblaster/fatality.mp3", ent:GetPos(), 100, 100)
        ent:Kill()

    -- 8. Nothing Happens
    else
        sound.Play("weapons/memeblaster/bruh.mp3", ent:GetPos(), 100, 100)
    end
end

-- Client-side Net Effects
if CLIENT then
    local dwitMat = Material("vgui/ttt/icon_memeblaster.png")

    net.Receive("Meme_DWIT", function()
        hook.Add("HUDPaint", "MemeDWITPaint", function()
            surface.SetMaterial(dwitMat)
            surface.DrawTexturedRect(ScrW()/2 - 32, ScrH()/2 - 16, 64, 32)
        end)
        timer.Simple(5, function() hook.Remove("HUDPaint", "MemeDWITPaint") end)
    end)

    net.Receive("Meme_RickRoll", function()
        LocalPlayer():PrintMessage(HUD_PRINTCENTER, "Never gonna give you up! 🎵")
    end)

    net.Receive("Meme_Pixelate", function()
        hook.Add("RenderScreenspaceEffects", "MemePixelateFX", function()
            DrawMaterialOverlay("pp/heatwave", 0.2)
        end)
        timer.Simple(3, function() hook.Remove("RenderScreenspaceEffects", "MemePixelateFX") end)
    end)

    net.Receive("Meme_Nyan", function()
        ParticleEffectAttach("nyan_cat_trail", PATTACH_ABSORIGIN_FOLLOW, LocalPlayer(), 0)
        timer.Simple(5, function() ParticleEffectStop("nyan_cat_trail", LocalPlayer()) end)
    end)
end

-- Net message definitions
if SERVER then
    util.AddNetworkString("Meme_DWIT")
    util.AddNetworkString("Meme_RickRoll")
    util.AddNetworkString("Meme_Pixelate")
    util.AddNetworkString("Meme_Nyan")
end