local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

--Lua functions
local _G = _G
local format, strjoin, pairs = format, strjoin, pairs
--WoW API / Variables
local GetInventoryItemDurability = GetInventoryItemDurability
local ToggleCharacter = ToggleCharacter
local DURABILITY = DURABILITY
local InCombatLockdown = InCombatLockdown

local displayString, lastPanel = ""
local tooltipString = "%d%%"
local totalDurability = 0
local invDurability = {}

local slots = {
	[1] = _G.INVTYPE_HEAD,
	[3] = _G.INVTYPE_SHOULDER,
	[5] = _G.INVTYPE_CHEST,
	[6] = _G.INVTYPE_WAIST,
	[7] = _G.INVTYPE_LEGS,
	[8] = _G.INVTYPE_FEET,
	[9] = _G.INVTYPE_WRIST,
	[10] = _G.INVTYPE_HAND,
	[16] = _G.INVTYPE_WEAPONMAINHAND,
	[17] = _G.INVTYPE_WEAPONOFFHAND,
}

local function OnEvent(self)
	lastPanel = self
	totalDurability = 100

	for index in pairs(slots) do
		local current, max = GetInventoryItemDurability(index)

		if current then
			invDurability[index] = (current/max)*100

			if ((current/max) * 100) < totalDurability then
				totalDurability = (current/max) * 100
			end
		end
	end

	self.text:SetFormattedText(displayString, totalDurability)
end

local function Click()
	if InCombatLockdown() then _G.UIErrorsFrame:AddMessage(E.InfoColor.._G.ERR_NOT_IN_COMBAT) return end
	ToggleCharacter("PaperDollFrame")
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for slot, durability in ipairs(invDurability) do
		DT.tooltip:AddDoubleLine(slot, format(tooltipString, durability), 1, 1, 1, E:ColorGradient(durability * 0.01, 1, 0, 0, 1, 1, 0, 0, 1, 0))
	end

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", DURABILITY, ": ", hex, "%d%%|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel, 'ELVUI_COLOR_UPDATE')
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Durability', nil, {"UPDATE_INVENTORY_DURABILITY", "MERCHANT_SHOW"}, OnEvent, nil, Click, OnEnter, nil, DURABILITY)
