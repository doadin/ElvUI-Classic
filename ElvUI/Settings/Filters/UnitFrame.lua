local E, L, V, P, G = unpack(select(2, ...)); --Engine

--Lua functions
local unpack = unpack
local strlower = string.lower
--WoW API / Variables
local IsPlayerSpell = IsPlayerSpell

local function Defaults(priorityOverride)
	return {
		enable = true,
		priority = priorityOverride or 0,
		stackThreshold = 0
	}
end

G.unitframe.aurafilters = {};

-- These are debuffs that are some form of CC
G.unitframe.aurafilters.CCDebuffs = {
	type = 'Whitelist',
	spells = {
	--Druid
	--Hunter
	--Mage
	--Paladin
	--Priest
	--Rogue
	--Shaman
	--Warlock
	--Warrior
	--Racial
	},
}

-- These are buffs that can be considered "protection" buffs
G.unitframe.aurafilters.TurtleBuffs = {
	type = 'Whitelist',
	spells = {
	-- Druid
	--Hunter
	--Mage
	--Paladin
	--Priest
	--Rogue
	--Shaman
	--Warlock
	--Warrior
	--Racial
	},
}

G.unitframe.aurafilters.PlayerBuffs = {
	type = 'Whitelist',
	spells = {
	-- Druid
	--Hunter
	--Mage
	--Paladin
	--Priest
	--Rogue
	--Shaman
	--Warlock
	--Warrior
	--Racial
	},
}

-- Buffs that really we dont need to see
G.unitframe.aurafilters.Blacklist = {
	type = 'Blacklist',
	spells = {
	},
}

--[[
	This should be a list of important buffs that we always want to see when they are active
	bloodlust, paladin hand spells, raid cooldowns, etc..
]]
G.unitframe.aurafilters.Whitelist = {
	type = 'Whitelist',
	spells = {
	},
}

-- RAID DEBUFFS: This should be pretty self explainitory
G.unitframe.aurafilters.RaidDebuffs = {
	type = 'Whitelist',
	spells = {
		-- Onyxia's Lair
		[18431] = Defaults(2), --Bellowing Roar
		-- Molten Core
		[19703] = Defaults(2), --Lucifron's Curse
		[19408] = Defaults(2), --Panic
		[19716] = Defaults(2), --Gehennas' Curse
		[20277] = Defaults(2), --Fist of Ragnaros
		[20475] = Defaults(6), --Living Bomb
		[19695] = Defaults(6), --Inferno
		[19659] = Defaults(2), --Ignite Mana
		[19714] = Defaults(2), --Deaden Magic
		[19713] = Defaults(2), --Shazzrah's Curse
		-- Blackwing's Lair
		[23023] = Defaults(2), --Conflagration
		[18173] = Defaults(2), --Burning Adrenaline
		[24573] = Defaults(2), --Mortal Strike
		[23340] = Defaults(2), --Shadow of Ebonroc
		[23170] = Defaults(2), --Brood Affliction: Bronze
		[22687] = Defaults(2), --Veil of Shadow
		-- Zul'Gurub
		[23860] = Defaults(2), --Holy Fire
		[22884] = Defaults(2), --Psychic Scream
		[23918] = Defaults(2), --Sonic Burst
		[24111] = Defaults(2), --Corrosive Poison
		[21060] = Defaults(2), --Blind
		[24328] = Defaults(2), --Corrupted Blood
		[16856] = Defaults(2), --Mortal Strike
		[24664] = Defaults(2), --Sleep
		[17172] = Defaults(2), --Hex
		[24306] = Defaults(2), --Delusions of Jin'do
		-- Ahn'Qiraj Ruins
		[25646] = Defaults(2), --Mortal Wound
		[25471] = Defaults(2), --Attack Order
		[96] = Defaults(2), --Dismember
		[25725] = Defaults(2), --Paralyze
		[25189] = Defaults(2), --Enveloping Winds
		-- Ahn'Qiraj Temple
		[785] = Defaults(2), --True Fulfillment
		[26580] = Defaults(2), --Fear
		[26050] = Defaults(2), --Acid Spit
		[26180] = Defaults(2), --Wyvern Sting
		[26053] = Defaults(2), --Noxious Poison
		[26613] = Defaults(2), --Unbalancing Strike
		[26029] = Defaults(2), --Dark Glare
		-- Naxxramas
		[28732] = Defaults(2), --Widow's Embrace
		[28622] = Defaults(2), --Web Wrap
		[28169] = Defaults(2), --Mutating Injection
		[29213] = Defaults(2), --Curse of the Plaguebringer
		[28835] = Defaults(2), --Mark of Zeliek
		[27808] = Defaults(2), --Frost Blast
		[28410] = Defaults(2), --Chains of Kel'Thuzad
		[27819] = Defaults(2), --Detonate Mana
	},
}

G.unitframe.aurafilters.DungeonDebuffs = {
	type = 'Whitelist',
	spells = {
		[246] = Defaults(2), --Slow
		[6533] = Defaults(2), --Net
		[8399] = Defaults(2), --Sleep
		-- Blackrock Depths
		[13704] = Defaults(2), --Psychic Scream
		-- Deadmines
		[6304] = Defaults(2), --Rhahk'Zor Slam
		[12097] = Defaults(2), --Pierce Armor
		[7399] = Defaults(2), --Terrify
		[6713] = Defaults(2), --Disarm
		[5213] = Defaults(2), --Molten Metal
		[5208] = Defaults(2), --Poisoned Harpoon
		-- Maraudon
		[7964] = Defaults(2), --Smoke Bomb
		[21869] = Defaults(2), --Repulsive Gaze
		--
		[744] = Defaults(2), --Poison
		[18267] = Defaults(2), --Curse of Weakness
		[20800] = Defaults(2), --Immolate
		--
		[12255] = Defaults(2), --Curse of Tuten'kash
		[12252] = Defaults(2), --Web Spray
		[7645] = Defaults(2), --Dominate Mind
		[12946] = Defaults(2), --Putrid Stench
		--
		[14515] = Defaults(2), --Dominate Mind
		-- Scarlet Monastry
		[9034] = Defaults(2), --Immolate
		[8814] = Defaults(2), --Flame Spike
		[8988] = Defaults(2), --Silence
		[9256] = Defaults(2), --Deep Sleep
		[8282] = Defaults(2), --Curse of Blood
		-- Shadowfang Keep
		[7068] = Defaults(2), --Veil of Shadow
		[7125] = Defaults(2), --Toxic Saliva
		[7621] = Defaults(2), --Arugal's Curse
		--
		[16798] = Defaults(2), --Enchanting Lullaby
		[12734] = Defaults(2), --Ground Smash
		[17293] = Defaults(2), --Burning Winds
		[17405] = Defaults(2), --Domination
		[16867] = Defaults(2), --Banshee Curse
		[6016] = Defaults(2), --Pierce Armor
		[16869] = Defaults(2), --Ice Tomb
		[17307] = Defaults(2), --Knockout
		--
		[12889] = Defaults(2), --Curse of Tongues
		[12888] = Defaults(2), --Cause Insanity
		[12479] = Defaults(2), --Hex of Jammal'an
		[12493] = Defaults(2), --Curse of Weakness
		[12890] = Defaults(2), --Deep Slumber
		[24375] = Defaults(2), --War Stomp
		--
		[3356] = Defaults(2), --Flame Lash
		[6524] = Defaults(2), --Ground Tremor
		--
		[8040] = Defaults(2), --Druid's Slumber
		[8142] = Defaults(2), --Grasping Vines
		[7967] = Defaults(2), --Naralex's Nightmare
		[8150] = Defaults(2), --Thundercrack
		-- Zul'Farrak
		[11836] = Defaults(2), --Freeze Solid
		--
		[21056] = Defaults(2), --Mark of Kazzak
		[24814] = Defaults(2), --Seeping Fog
	},
}

--[[
	RAID BUFFS:
	Buffs that are provided by NPCs in raid or other PvE content.
	This can be buffs put on other enemies or on players.
]]
G.unitframe.aurafilters.RaidBuffsElvUI = {
	type = 'Whitelist',
	spells = {
		--Mythic/Mythic+
		--Raids
	},
}

-- Spells that we want to show the duration backwards
E.ReverseTimer = {

}

-- BuffWatch: List of personal spells to show on unitframes as icon
local function ClassBuff(id, point, color, anyUnit, onlyShowMissing, style, displayText, decimalThreshold, textColor, textThreshold, xOffset, yOffset, sizeOverride)
	local r, g, b = unpack(color)

	local r2, g2, b2 = 1, 1, 1
	if textColor then
		r2, g2, b2 = unpack(textColor)
	end

	return {
		enabled = true,
		id = id,
		point = point,
		color = {r = r, g = g, b = b},
		anyUnit = anyUnit,
		onlyShowMissing = onlyShowMissing,
		style = style or 'coloredIcon',
		displayText = displayText or false,
		decimalThreshold = decimalThreshold or 5,
		textColor = {r = r2, g = g2, b = b2},
		textThreshold = textThreshold or -1,
		xOffset = xOffset or 0,
		yOffset = yOffset or 0,
		sizeOverride = sizeOverride or 0
	}
end

--[[
G.unitframe.buffwatch = {
	PRIEST = {
		[194384] = ClassBuff(194384, "TOPRIGHT", {1, 1, 0.66}),          -- Atonement
		[214206] = ClassBuff(214206, "TOPRIGHT", {1, 1, 0.66}),          -- Atonement (PvP)
		[41635]  = ClassBuff(41635, "BOTTOMRIGHT", {0.2, 0.7, 0.2}),     -- Prayer of Mending
		[193065] = ClassBuff(193065, "BOTTOMRIGHT", {0.54, 0.21, 0.78}), -- Masochism
		[139]    = ClassBuff(139, "BOTTOMLEFT", {0.4, 0.7, 0.2}),        -- Renew
		[6788]   = ClassBuff(6788, "BOTTOMLEFT", {0.89, 0.1, 0.1}),       -- Weakened Soul
		[17]     = ClassBuff(17, "TOPLEFT", {0.7, 0.7, 0.7}, true),      -- Power Word: Shield
		[47788]  = ClassBuff(47788, "LEFT", {0.86, 0.45, 0}, true),      -- Guardian Spirit
		[33206]  = ClassBuff(33206, "LEFT", {0.47, 0.35, 0.74}, true),   -- Pain Suppression
	},
	DRUID = {
		[774]    = ClassBuff(774, "TOPRIGHT", {0.8, 0.4, 0.8}),   		-- Rejuvenation
		[155777] = ClassBuff(155777, "RIGHT", {0.8, 0.4, 0.8}),   		-- Germination
		[8936]   = ClassBuff(8936, "BOTTOMLEFT", {0.2, 0.8, 0.2}),		-- Regrowth
		[33763]  = ClassBuff(33763, "TOPLEFT", {0.4, 0.8, 0.2}),  		-- Lifebloom
		[48438]  = ClassBuff(48438, "BOTTOMRIGHT", {0.8, 0.4, 0}),		-- Wild Growth
		[207386] = ClassBuff(207386, "TOP", {0.4, 0.2, 0.8}),     		-- Spring Blossoms
		[102351] = ClassBuff(102351, "LEFT", {0.2, 0.8, 0.8}),    		-- Cenarion Ward (Initial Buff)
		[102352] = ClassBuff(102352, "LEFT", {0.2, 0.8, 0.8}),    		-- Cenarion Ward (HoT)
		[200389] = ClassBuff(200389, "BOTTOM", {1, 1, 0.4}),      		-- Cultivation
	},
	PALADIN = {
		[53563]  = ClassBuff(53563, "TOPRIGHT", {0.7, 0.3, 0.7}),          -- Beacon of Light
		[156910] = ClassBuff(156910, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Faith
		[200025] = ClassBuff(200025, "TOPRIGHT", {0.7, 0.3, 0.7}),         -- Beacon of Virtue
		[1022]   = ClassBuff(1022, "BOTTOMRIGHT", {0.2, 0.2, 1}, true),    -- Hand of Protection
		[1044]   = ClassBuff(1044, "BOTTOMRIGHT", {0.89, 0.45, 0}, true),  -- Hand of Freedom
		[6940]   = ClassBuff(6940, "BOTTOMRIGHT", {0.89, 0.1, 0.1}, true), -- Hand of Sacrifice
		[223306] = ClassBuff(223306, 'BOTTOMLEFT', {0.7, 0.7, 0.3}),       -- Bestow Faith
		[287280] = ClassBuff(287280, 'TOPLEFT', {0.2, 0.8, 0.2}),          -- Glimmer of Light (Artifact HoT)
	},
	SHAMAN = {
		[61295]  = ClassBuff(61295, "TOPRIGHT", {0.7, 0.3, 0.7}),   	 -- Riptide
		[974] = ClassBuff(974, "BOTTOMRIGHT", {0.2, 0.2, 1}), 	 -- Earth Shield
	},
	MONK = {
		[119611] = ClassBuff(119611, "TOPLEFT", {0.3, 0.8, 0.6}),        -- Renewing Mist
		[116849] = ClassBuff(116849, "TOPRIGHT", {0.2, 0.8, 0.2}, true), -- Life Cocoon
		[124682] = ClassBuff(124682, "BOTTOMLEFT", {0.8, 0.8, 0.25}),    -- Enveloping Mist
		[191840] = ClassBuff(191840, "BOTTOMRIGHT", {0.27, 0.62, 0.7}),  -- Essence Font
	},
	ROGUE = {
		[57934] = ClassBuff(57934, "TOPRIGHT", {0.89, 0.09, 0.05}),		 -- Tricks of the Trade
	},
	WARRIOR = {
		[114030] = ClassBuff(114030, "TOPLEFT", {0.2, 0.2, 1}),     	 -- Vigilance
		[3411]   = ClassBuff(3411, "TOPRIGHT", {0.89, 0.09, 0.05}), 	 -- Intervene
	},
	PET = {
		-- Warlock Pets
		[193396] = ClassBuff(193396, 'TOPRIGHT', {0.6, 0.2, 0.8}, true), -- Demonic Empowerment
		-- Hunter Pets
		[272790] = ClassBuff(272790, 'TOPLEFT', {0.89, 0.09, 0.05}, true), -- Frenzy
		[136]   = ClassBuff(136, 'TOPRIGHT', {0.2, 0.8, 0.2}, true)      -- Mend Pet
	},
	HUNTER = {}, --Keep even if it's an empty table, so a reference to G.unitframe.buffwatch[E.myclass][SomeValue] doesn't trigger error
	DEMONHUNTER = {},
	WARLOCK = {},
	MAGE = {},
	DEATHKNIGHT = {},
}
]]

G.unitframe.buffwatch = {
	PRIEST = {
		[1243] = ClassBuff(1243, "TOPLEFT"), --Power Word: Fortitude Rank 1
		[1244] = ClassBuff(1244, "TOPLEFT"), --Power Word: Fortitude Rank 2
		[1245] = ClassBuff(1245, "TOPLEFT"), --Power Word: Fortitude Rank 3
		[2791] = ClassBuff(2791, "TOPLEFT"), --Power Word: Fortitude Rank 4
		[10937] = ClassBuff(10937, "TOPLEFT"), --Power Word: Fortitude Rank 5
		[10938] = ClassBuff(10938, "TOPLEFT"), --Power Word: Fortitude Rank 6
		[21562] = ClassBuff(21562, "TOPLEFT"), --Prayer of Fortitude Rank 1
		[21564] = ClassBuff(21564, "TOPLEFT"), --Prayer of Fortitude Rank 2
		[14752] = ClassBuff(14752, "TOPRIGHT"), --Divine Spirit Rank 1
		[14818] = ClassBuff(14818, "TOPRIGHT"), --Divine Spirit Rank 2
		[14819] = ClassBuff(14819, "TOPRIGHT"), --Divine Spirit Rank 3
		[27841] = ClassBuff(27841, "TOPRIGHT"), --Divine Spirit Rank 4
		[27581] = ClassBuff(27581, "TOPRIGHT"), --Prayer of Spirit Rank 1
		[976] = ClassBuff(976, "BOTTOMLEFT"), --Shadow Protection Rank 1
		[10957] = ClassBuff(10957, "BOTTOMLEFT"), --Shadow Protection Rank 2
		[10958] = ClassBuff(10958, "BOTTOMLEFT"), --Shadow Protection Rank 3
		[27683] = ClassBuff(27683, "BOTTOMLEFT"), --Prayer of Shadow Protection Rank 1
	},
	DRUID = {
		[1126] = ClassBuff(1126, "TOPLEFT"), --Mark of the Wild Rank 1
		[5232] = ClassBuff(5232, "TOPLEFT"), --Mark of the Wild Rank 2
		[6756] = ClassBuff(6756, "TOPLEFT"), --Mark of the Wild Rank 3
		[5234] = ClassBuff(5234, "TOPLEFT"), --Mark of the Wild Rank 4
		[8907] = ClassBuff(8907, "TOPLEFT"), --Mark of the Wild Rank 5
		[9884] = ClassBuff(9884, "TOPLEFT"), --Mark of the Wild Rank 6
		[16878] = ClassBuff(16878, "TOPLEFT"), --Mark of the Wild Rank 7
		[21849] = ClassBuff(21849, "TOPLEFT"), --Gift of the Wild Rank 1
		[21850] = ClassBuff(21850, "TOPLEFT"), --Gift of the Wild Rank 2
		[467] = ClassBuff(467, "TOPRIGHT"), --Thorns Rank 1
		[782] = ClassBuff(782, "TOPRIGHT"), --Thorns Rank 2
		[1075] = ClassBuff(1075, "TOPRIGHT"), --Thorns Rank 3
		[8914] = ClassBuff(8914, "TOPRIGHT"), --Thorns Rank 4
		[9756] = ClassBuff(9756, "TOPRIGHT"), --Thorns Rank 5
		[9910] = ClassBuff(9910, "TOPRIGHT"), --Thorns Rank 6
	},
	PALADIN = {
		[1044] = ClassBuff(1044, "CENTER"), --Blessing of Freedom
		[6940] = ClassBuff(6940, "CENTER"), --Blessing Sacrifice Rank 1
		[20729] = ClassBuff(20729, "CENTER"), --Blessing Sacrifice Rank 2
		[19740] = ClassBuff(19740, "TOPLEFT"), --Blessing of Might Rank 1
		[19834] = ClassBuff(19834, "TOPLEFT"), --Blessing of Might Rank 2
		[19835] = ClassBuff(19835, "TOPLEFT"), --Blessing of Might Rank 3
		[19836] = ClassBuff(19836, "TOPLEFT"), --Blessing of Might Rank 4
		[19837] = ClassBuff(19837, "TOPLEFT"), --Blessing of Might Rank 5
		[19838] = ClassBuff(19838, "TOPLEFT"), --Blessing of Might Rank 6
		[25291] = ClassBuff(25291, "TOPLEFT"), --Blessing of Might Rank 7
		[19742] = ClassBuff(19742, "TOPLEFT"), --Blessing of Wisdom Rank 1
		[19850] = ClassBuff(19850, "TOPLEFT"), --Blessing of Wisdom Rank 2
		[19852] = ClassBuff(19852, "TOPLEFT"), --Blessing of Wisdom Rank 3
		[19853] = ClassBuff(19853, "TOPLEFT"), --Blessing of Wisdom Rank 4
		[19854] = ClassBuff(19854, "TOPLEFT"), --Blessing of Wisdom Rank 5
		[25290] = ClassBuff(25290, "TOPLEFT"), --Blessing of Wisdom Rank 6
		[25782] = ClassBuff(25782, "TOPLEFT"), --Greater Blessing of Might Rank 1
		[25916] = ClassBuff(25916, "TOPLEFT"), --Greater Blessing of Might Rank 2
		[25894] = ClassBuff(25894, "TOPLEFT"), --Greater Blessing of Wisdom Rank 1
		[25918] = ClassBuff(25918, "TOPLEFT"), --Greater Blessing of Wisdom Rank 2
	},
	SHAMAN = {
		[29203] = ClassBuff(29203, "TOPLEFT"), --Healing Way
		[16237] = ClassBuff(16237, "TOPRIGHT"), --Ancestral Fortitude
	},
	WARRIOR = {
		[6673] = ClassBuff(6673, "TOPLEFT"), --Battle Shout Rank 1
		[5242] = ClassBuff(5242, "TOPLEFT"), --Battle Shout Rank 2
		[6192] = ClassBuff(6192, "TOPLEFT"), --Battle Shout Rank 3
		[11549] = ClassBuff(11549, "TOPLEFT"), --Battle Shout Rank 4
		[11550] = ClassBuff(11550, "TOPLEFT"), --Battle Shout Rank 5
		[11551] = ClassBuff(11551, "TOPLEFT"), --Battle Shout Rank 6
		[25289] = ClassBuff(25289, "TOPLEFT"), --Battle Shout Rank 7
	},
	MAGE = {
		[1459] = ClassBuff(1459, "TOPLEFT"), --Arcane Intellect Rank 1
		[1460] = ClassBuff(1460, "TOPLEFT"), --Arcane Intellect Rank 2
		[1461] = ClassBuff(1461, "TOPLEFT"), --Arcane Intellect Rank 3
		[10156] = ClassBuff(10156, "TOPLEFT"), --Arcane Intellect Rank 4
		[10157] = ClassBuff(10157, "TOPLEFT"), --Arcane Intellect Rank 5
		[23028] = ClassBuff(23028, "TOPLEFT"), --Arcane Brilliance Rank 1
		[27127] = ClassBuff(27127, "TOPLEFT"), --Arcane Brilliance Rank 2
		[604] = ClassBuff(604, "TOPRIGHT"), --Dampen Magic Rank 1
		[8450] = ClassBuff(8450, "TOPRIGHT"), --Dampen Magic Rank 2
		[8451] = ClassBuff(8451, "TOPRIGHT"), --Dampen Magic Rank 3
		[10173] = ClassBuff(10173, "TOPRIGHT"), --Dampen Magic Rank 4
		[10174] = ClassBuff(10174, "TOPRIGHT"), --Dampen Magic Rank 5
		[1008] = ClassBuff(1008, "TOPRIGHT"), --Amplify Magic Rank 1
		[8455] = ClassBuff(8455, "TOPRIGHT"), --Amplify Magic Rank 2
		[10169] = ClassBuff(10169, "TOPRIGHT"), --Amplify Magic Rank 3
		[10170] = ClassBuff(10170, "TOPRIGHT"), --Amplify Magic Rank 4
	},
	HUNTER = {
		[19506] = ClassBuff(19506, "TOPLEFT"), --Trueshot Aura Rank 1
		[20905] = ClassBuff(20905, "TOPLEFT"), --Trueshot Aura Rank 2
		[20906] = ClassBuff(20906, "TOPLEFT"), --Trueshot Aura Rank 3
	},
	WARLOCK = {
		[5597] = ClassBuff(5597, "TOPLEFT"), --Unending Breath
		[6512] = ClassBuff(6512, "TOPRIGHT"), --Detect Lesser Invisibility
		[2970] = ClassBuff(2970, "TOPRIGHT"), --Detect Invisibility
		[11743] = ClassBuff(11743, "TOPRIGHT"), --Detect Greater Invisibility
	},
	PET = {
		--Warlock Imp
		[6307] = ClassBuff(6307, "BOTTOMLEFT"), --Blood Pact Rank 1
		[7804] = ClassBuff(7804, "BOTTOMLEFT"), --Blood Pact Rank 2
		[7805] = ClassBuff(7805, "BOTTOMLEFT"), --Blood Pact Rank 3
		[11766] = ClassBuff(11766, "BOTTOMLEFT"), --Blood Pact Rank 4
		[11767] = ClassBuff(11767, "BOTTOMLEFT"), --Blood Pact Rank 5
		--Warlock Felhunter
		[19480] = ClassBuff(19480, "BOTTOMLEFT"), --Paranoia
	},
	ROGUE = {}, --No buffs
}

-- Profile specific BuffIndicator
P.unitframe.filters = {
	buffwatch = {},
}

-- List of spells to display ticks
G.unitframe.ChannelTicks = {
	-- Warlock
	[198590] = 6, -- Drain Soul
	[755]    = 6, -- Health Funnel
	[234153] = 6, -- Drain Life
	-- Priest
	[64843]  = 4, -- Divine Hymn
	[15407]  = 4, -- Mind Flay
	[48045] = 5, -- Mind Sear
	-- Mage
	[5143]   = 5,  -- Arcane Missiles
	[12051]  = 3,  -- Evocation
	[205021] = 10, -- Ray of Frost
	--Druid
	[740]    = 4, -- Tranquility
}

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function()
	if strlower(E.myclass) ~= "priest" then return end

	local penanceTicks = IsPlayerSpell(193134) and 4 or 3
	E.global.unitframe.ChannelTicks[47540] = penanceTicks --Penance
end)

G.unitframe.ChannelTicksSize = {
	-- Warlock
	[198590] = 1, -- Drain Soul
}

-- Spells Effected By Haste
G.unitframe.HastedChannelTicks = {
	[205021] = true, -- Ray of Frost
}

-- This should probably be the same as the whitelist filter + any personal class ones that may be important to watch
G.unitframe.AuraBarColors = {
	[2825]  = {r = 0.98, g = 0.57, b = 0.10}, -- Bloodlust
	[32182] = {r = 0.98, g = 0.57, b = 0.10}, -- Heroism
	[80353] = {r = 0.98, g = 0.57, b = 0.10}, -- Time Warp
	[90355] = {r = 0.98, g = 0.57, b = 0.10}, -- Ancient Hysteria
}

G.unitframe.DebuffHighlightColors = {
	[25771] = {enable = false, style = "FILL", color = {r = 0.85, g = 0, b = 0, a = 0.85}},
}

G.unitframe.specialFilters = {
	-- Whitelists
	Boss = true,
	Personal = true,
	nonPersonal = true,
	CastByUnit = true,
	notCastByUnit = true,
	Dispellable = true,
	notDispellable = true,
	CastByNPC = true,
	CastByPlayers = true,

	-- Blacklists
	blockNonPersonal = true,
	blockCastByPlayers = true,
	blockNoDuration = true,
	blockDispellable = true,
	blockNotDispellable = true,
};
