local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

--Lua functions
local format, strjoin = format, strjoin
--WoW API / Variables
local _G = _G
local GetHaste = GetHaste
local BreakUpLargeNumbers = BreakUpLargeNumbers
local GetPVPGearStatRules = GetPVPGearStatRules
local STAT_HASTE = STAT_HASTE
local CR_HASTE_MELEE = CR_HASTE_MELEE
local HIGHLIGHT_FONT_COLOR_CODE = HIGHLIGHT_FONT_COLOR_CODE
local FONT_COLOR_CODE_CLOSE = FONT_COLOR_CODE_CLOSE
local PAPERDOLLFRAME_TOOLTIP_FORMAT = PAPERDOLLFRAME_TOOLTIP_FORMAT
local STAT_HASTE_TOOLTIP = STAT_HASTE_TOOLTIP
local STAT_HASTE_BASE_TOOLTIP = STAT_HASTE_BASE_TOOLTIP
local RED_FONT_COLOR_CODE = RED_FONT_COLOR_CODE

local displayString, lastPanel = ''

local function OnEvent(self)
	local haste = GetHaste()
	self.text:SetFormattedText(displayString, STAT_HASTE, haste)

	lastPanel = self
end


local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s: ", hex, "%.2f%%|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Haste', {"UNIT_STATS", "UNIT_AURA", "UNIT_SPELL_HASTE"}, OnEvent, nil, nil, nil, nil, STAT_HASTE)
