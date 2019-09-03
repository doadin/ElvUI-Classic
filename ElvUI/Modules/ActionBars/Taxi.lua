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
local TaxiButtonHolder

--[[
AB.customTaxiButton = {
	func = TaxiRequestEarlyLanding,
	texture = "Interface\\Icons\\Spell_Shadow_SacrificialShield",
	tooltip = _G.LEAVE_VEHICLE,
}
]]

function AB:MoveTaxiButton()
	TaxiButtonHolder = CreateFrame('Frame', nil, E.UIParent)
	TaxiButtonHolder:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 150)
	TaxiButtonHolder:Size(_G.MainMenuBarVehicleLeaveButton:GetSize())

	local Button = _G.MainMenuBarVehicleLeaveButton

	if (MasqueGroup and E.private.actionbar.masque.actionbars and true) then
		Button:StyleButton(true, true, true)
	else
		Button:CreateBackdrop(nil, true)
		Button.backdrop:SetAllPoints()
		Button:StyleButton()
	end

	E:CreateMover(TaxiButtonHolder, 'TaxiButtonMover', L["Taxi Button"], nil, nil, nil, nil, nil, 'all,general')

	hooksecurefunc(Button, 'SetPoint', function(_, parent)
		if parent ~= TaxiButtonHolder then
			_G.MainMenuBarVehicleLeaveButton:SetPoint('CENTER', TaxiButtonHolder, 'CENTER')
		end
	end)

	hooksecurefunc(Button, 'SetHighlightTexture', function(self, tex)
		if tex ~= self.hover then
			self:SetHighlightTexture(self.hover)
		end
	end)
end
