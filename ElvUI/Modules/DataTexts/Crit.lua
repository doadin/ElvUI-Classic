local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

--Lua functions
local strjoin = strjoin
--WoW API / Variables
local GetCritChance = GetCritChance
local GetRangedCritChance = GetRangedCritChance
local GetSpellCritChance = GetSpellCritChance
local CRIT_ABBR = CRIT_ABBR
local RANGED_CRIT_CHANCE = RANGED_CRIT_CHANCE
local SPELL_CRIT_CHANCE = SPELL_CRIT_CHANCE
local STAT_CATEGORY_ENHANCEMENTS = STAT_CATEGORY_ENHANCEMENTS

local displayString, lastPanel = ''

local function OnEvent(self)
	local critRating

	if E.myclass == "HUNTER" then
		critRating = GetRangedCritChance()
	else
		critRating = GetCritChance()
	end

	self.text:SetFormattedText(displayString, CRIT_ABBR, critRating)

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s: ", hex, "%.2f%%|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Crit Chance', STAT_CATEGORY_ENHANCEMENTS, {"UNIT_STATS", "UNIT_AURA", "PLAYER_DAMAGE_DONE_MODS"}, OnEvent, nil, nil, OnEnter, nil, STAT_CRITICAL_STRIKE)
