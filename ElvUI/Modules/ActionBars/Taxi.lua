local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local AB = E:GetModule('ActionBars')
local LAB = E.Libs.LAB

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local CreateFrame = CreateFrame
local Masque = E.Masque
local MasqueGroup = Masque and Masque:Group("ElvUI", "ActionBars")

--[[
AB.customTaxiButton = {
	func = TaxiRequestEarlyLanding,
	texture = "Interface\\Icons\\Spell_Shadow_SacrificialShield",
	tooltip = _G.LEAVE_VEHICLE,
}
]]

function AB:MoveTaxiButton()
	CreateFrame('Frame', 'TaxiButtonHolder', E.UIParent)
	TaxiButtonHolder:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 150)
	TaxiButtonHolder:Size(_G.MainMenuBarVehicleLeaveButton:GetSize())

	local Button = _G.MainMenuBarVehicleLeaveButton

	if (MasqueGroup and E.private.actionbar.masque.actionbars and true) then
		Button:StyleButton(true, true, true)
	else
		Button:CreateBackdrop(nil, true)
		Button.backdrop:SetAllPoints()
		Button:StyleButton(nil, true, true)
	end

	E:CreateMover(TaxiButtonHolder, 'TaxiButtonMover', L["Taxi Button"], nil, nil, nil, nil, nil, 'all,general')

	hooksecurefunc(Button, 'SetPoint', function(_, _, parent)
		if parent ~= TaxiButtonHolder then
			Button:ClearAllPoints()
			Button:SetParent(UIParent)
			Button:SetPoint('CENTER', TaxiButtonHolder, 'CENTER')
		end
	end)

	hooksecurefunc(Button, 'SetHighlightTexture', function(_, tex)
		if tex ~= self.hover then
			Button:SetHighlightTexture(self.hover)
		end
	end)
end
