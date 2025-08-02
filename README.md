# TTT Fun Mods Collection by Bene

Ein Bündel von drei unterhaltsamen Trouble-in-Terrorist-Town Mods für Garry’s Mod.

## 1. One-Hit Crowbar

### Typ: Traitor-Equipment
### Effekt: Tötet Spieler/NPCs mit einem Schlag, spielt einen zufälligen Sound und zeigt Blutspritzer + Mini-Explosion.
### Features:
- 5 % Explosions-Risiko in der Hand
- Sekundärangriff: starker Rückstoß („Fart Dash“)
- 20 % Chance beim Dash: Opfer fliegt hoch und stirbt mit Sound
- Drop-Effekt: Mini-Explosion beim Fallenlassen
- 5 s Cooldown

## 2. DNA Rebooter

### Typ: Detective-Equipment (Einweg)
### Effekt: Scannt frische Spieler-Leichen (< 10 s), liest DNA aus und fügt dem Täter 30 Schaden zu.
### Features:
- Nur einmal verwendbar, entfernt sich nach Einsatz
- Feedback via Sound & Chat-Nachrichten

## 3. Meme-Blaster

### Typ: Traitor/Detective-Equipment
### Effekt: Schießt auf Ziel und löst einen von acht zufälligen Meme-Effekten aus.
### Features:
- Sonnenbrille („Deal With It“) Overlay
- Rickroll-Chat-Message
- NPC-Horde (5x Bürger)
- Speed-Debuff („Teletubby“)
- Pixelate-Screen-Overlay
- Nyan Cat Partikel-Trail
- Instant-Kill („Fatality“)
- Bruh-Sound („Nothing happens“)

### Installation

Lege dieses Repo in garrysmod/addons/ ab.

### Achte auf die jeweilige Ordnerstruktur:
onehit_crowbar/
dna_rebooter/
meme_blaster/

### Inhalte:
```
/lua/weapons/*.lua
/sound/weapons/...
/materials/vgui/ttt/... (Icons)
```

### Starte Garry’s Mod und lade eine TTT-Runde im Einzelspieler.

### Setze die nötigen ConVars:
```
sv_cheats 1
ttt_minimum_players 1
ttt_force_traitor 1  (oder ttt_force_detective 1)
ttt_startforce 1
```

### Gib dir die Waffe per Konsole:
```
give weapon_ttt_onehitcrowbar
give weapon_ttt_dna_rebooter
give weapon_ttt_memeblaster
```

## Nutzung
- One-Hit Crowbar: Linksklick = Tötung; Rechtsklick = Dash | Fart.
- DNA Rebooter: Linksklick auf frische Leiche (< 10 s).
- Meme-Blaster: Linksklick = zufälliger Meme-Effekt.

## Viel Spaß beim Testen und Chaos-Schüren in TTT! 🎉
