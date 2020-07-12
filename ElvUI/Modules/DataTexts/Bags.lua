local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

--Lua functions
local strjoin = strjoin
local format = format
--WoW API / Variables
local GetBagName = GetBagName
local GetContainerNumFreeSlots = GetContainerNumFreeSlots
local GetContainerNumSlots = GetContainerNumSlots
local ToggleAllBags = ToggleAllBags
local NUM_BAG_SLOTS = NUM_BAG_SLOTS
local GetInventoryItemQuality = GetInventoryItemQuality
local GetItemQualityColor = GetItemQualityColor
local GetInventoryItemTexture = GetInventoryItemTexture

local displayString, lastPanel = ''

local BAG_TYPES = {
	[0x0001]  = 'Quiver',
	[0x0002]  = 'Ammo Pouch',
	[0x0004]  = 'Soul Bag',
}

local function OnEvent(self)
	lastPanel = self
	local free, total = 0, 0
	for i = 0, NUM_BAG_SLOTS do
		local bagFreeSlots, bagType = GetContainerNumFreeSlots(i)
		if not bagType or bagType == 0 then
			free, total = free + bagFreeSlots, total + GetContainerNumSlots(i)
		end
	end
	self.text:SetFormattedText(displayString, L["Bags"]..': ', free, total)
end

local function OnClick()
	ToggleAllBags()
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	for i = 0, NUM_BAG_SLOTS do
		local bagName = GetBagName(i)
		if bagName then
			local bagFreeSlots, bagType = GetContainerNumFreeSlots(i)
			local bagSlots = GetContainerNumSlots(i)
			local r, g, b, icon = 1, 1, 1, 'Interface/Buttons/Button-Backpack-Up'
			local r2, g2, b2

			if BAG_TYPES[bagType] then
				r2, g2, b2 = E:ColorGradient(bagFreeSlots/bagSlots, 1, .1, .1, 1, 1, .1, .1, 1, .1) -- red, yellow, green
			else
				r2, g2, b2 = E:ColorGradient(bagFreeSlots/bagSlots, .1, 1, .1, 1, 1, .1, 1, .1, .1) -- green, yellow, red
			end

				if i > 0 then
					local quality = GetInventoryItemQuality("player", 19 + i)
					r, g, b = GetItemQualityColor(quality or 1)
					icon = GetInventoryItemTexture("player", 19 + i)
				end

			DT.tooltip:AddDoubleLine(format('|T%s:14:14:0:0:64:64:4:60:4:60|t  %s', icon, bagName), format('%d / %d', bagFreeSlots, bagSlots), r, g, b, r2, g2, b2)
		end
	end

	DT.tooltip:Show()
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s", hex, "%d/%d|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Bags', nil, {"BAG_UPDATE"}, OnEvent, nil, OnClick, OnEnter, nil, L["Bags"])
