local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local UF = E:GetModule('UnitFrames');
local _, ns = ...
local ElvUF = ns.oUF
assert(ElvUF, "ElvUI was unable to locate oUF.")

--Lua functions
local _G = _G
local tinsert = tinsert
--WoW API / Variables
local IsAddOnLoaded = IsAddOnLoaded

function UF:Construct_TargetFrame(frame)
	frame.Health = self:Construct_HealthBar(frame, true, true, 'RIGHT')
	frame.Health.frequentUpdates = true;
	frame.Power = self:Construct_PowerBar(frame, true, true, 'LEFT')
	frame.Power.frequentUpdates = true;
	frame.Name = self:Construct_NameText(frame)
	frame.Portrait3D = self:Construct_Portrait(frame, 'model')
	frame.Portrait2D = self:Construct_Portrait(frame, 'texture')
	frame.Buffs = self:Construct_Buffs(frame)
	frame.Debuffs = self:Construct_Debuffs(frame)
	frame.Castbar = self:Construct_Castbar(frame, L["Target Castbar"])
	frame.Castbar.SafeZone = nil
	frame.Castbar.LatencyTexture:Hide()
	frame.RaidTargetIndicator = self:Construct_RaidIcon(frame)
	frame.PowerPrediction = self:Construct_PowerPrediction(frame)
	frame.HealthPrediction = self:Construct_HealComm(frame)
	frame.DebuffHighlight = self:Construct_DebuffHighlight(frame)
	frame.InfoPanel = self:Construct_InfoPanel(frame)
	frame.MouseGlow = self:Construct_MouseGlow(frame)
	frame.TargetGlow = self:Construct_TargetGlow(frame)
	frame.AuraBars = self:Construct_AuraBarHeader(frame)
	frame.PvPIndicator = self:Construct_PvPIcon(frame)
	frame.Fader = self:Construct_Fader()
	frame.Cutaway = self:Construct_Cutaway(frame)
	frame.RaidRoleFramesAnchor = UF:Construct_RaidRoleFrames(frame)
	frame.ResurrectIndicator = UF:Construct_ResurrectionIcon(frame)

	frame.customTexts = {}
	frame:Point('BOTTOMRIGHT', E.UIParent, 'BOTTOM', 413, 68)
	E:CreateMover(frame, frame:GetName()..'Mover', L["Target Frame"], nil, nil, nil, 'ALL,SOLO', nil, 'unitframe,target,generalGroup')

	frame.Power.Holder = CreateFrame("Frame", nil, frame.Power)
	frame.Power.Holder:Point("BOTTOM", frame, "BOTTOM", 0, -20)
	E:CreateMover(frame.Power.Holder, 'TargetPowerBarMover', L["Target Powerbar"], nil, nil, nil, 'ALL,SOLO', nil, 'unitframe,target,power')

	frame.unitframeType = "target"
end

function UF:Update_TargetFrame(frame, db)
	frame.db = db

	do
		frame.ORIENTATION = db.orientation --allow this value to change when unitframes position changes on screen?
		frame.UNIT_WIDTH = db.width
		frame.UNIT_HEIGHT = db.infoPanel.enable and (db.height + db.infoPanel.height) or db.height

		frame.USE_POWERBAR = db.power.enable
		frame.POWERBAR_DETACHED = db.power.detachFromFrame
		frame.USE_INSET_POWERBAR = not frame.POWERBAR_DETACHED and db.power.width == 'inset' and frame.USE_POWERBAR
		frame.USE_MINI_POWERBAR = (not frame.POWERBAR_DETACHED and db.power.width == 'spaced' and frame.USE_POWERBAR)
		frame.USE_POWERBAR_OFFSET = db.power.offset ~= 0 and frame.USE_POWERBAR and not frame.POWERBAR_DETACHED
		frame.POWERBAR_OFFSET = frame.USE_POWERBAR_OFFSET and db.power.offset or 0

		frame.POWERBAR_HEIGHT = not frame.USE_POWERBAR and 0 or db.power.height
		frame.POWERBAR_WIDTH = frame.USE_MINI_POWERBAR and (frame.UNIT_WIDTH - (frame.BORDER*2))/2 or (frame.POWERBAR_DETACHED and db.power.detachedWidth or (frame.UNIT_WIDTH - ((frame.BORDER+frame.SPACING)*2)))

		frame.USE_PORTRAIT = db.portrait and db.portrait.enable
		frame.USE_PORTRAIT_OVERLAY = frame.USE_PORTRAIT and (db.portrait.overlay or frame.ORIENTATION == "MIDDLE")
		frame.PORTRAIT_WIDTH = (frame.USE_PORTRAIT_OVERLAY or not frame.USE_PORTRAIT) and 0 or db.portrait.width

		frame.USE_INFO_PANEL = not frame.USE_MINI_POWERBAR and not frame.USE_POWERBAR_OFFSET and db.infoPanel.enable
		frame.INFO_PANEL_HEIGHT = frame.USE_INFO_PANEL and db.infoPanel.height or 0

		frame.BOTTOM_OFFSET = UF:GetHealthBottomOffset(frame)

		frame.VARIABLES_SET = true
	end

	frame.colors = ElvUF.colors
	frame.Portrait = frame.Portrait or (db.portrait.style == '2D' and frame.Portrait2D or frame.Portrait3D)
	frame:RegisterForClicks(self.db.targetOnMouseDown and 'AnyDown' or 'AnyUp')
	frame:Size(frame.UNIT_WIDTH, frame.UNIT_HEIGHT)
	_G[frame:GetName()..'Mover']:Size(frame:GetSize())

	if not IsAddOnLoaded("Clique") then
		if db.middleClickFocus then
			frame:SetAttribute("type3", "focus")
		elseif frame:GetAttribute("type3") == "focus" then
			frame:SetAttribute("type3", nil)
		end
	end

	UF:Configure_InfoPanel(frame)

	--Health
	UF:Configure_HealthBar(frame)

	--Name
	UF:UpdateNameSettings(frame)

	--Power
	UF:Configure_Power(frame)

	UF:Configure_PowerPrediction(frame)

	--Portrait
	UF:Configure_Portrait(frame)

	--Auras
	UF:EnableDisable_Auras(frame)
	UF:Configure_Auras(frame, 'Buffs')
	UF:Configure_Auras(frame, 'Debuffs')

	-- Resurrect
	UF:Configure_ResurrectionIcon(frame)

	--Castbar
	UF:Configure_Castbar(frame)

	--Fader
	UF:Configure_Fader(frame)

	--Debuff Highlight
	UF:Configure_DebuffHighlight(frame)

	--OverHealing
	UF:Configure_HealComm(frame)

	--Raid Icon
	UF:Configure_RaidIcon(frame)

	UF:Configure_RaidRoleIcons(frame)

	--AuraBars
	UF:Configure_AuraBars(frame)

	--PvP & Prestige Icon
	UF:Configure_PVPIcon(frame)

	--Cutaway
	UF:Configure_Cutaway(frame)

	--CustomTexts
	UF:Configure_CustomTexts(frame)

	E:SetMoverSnapOffset(frame:GetName()..'Mover', -(12 + db.castbar.height))
	frame:UpdateAllElements("ElvUI_UpdateAllElements")
end

tinsert(UF.unitstoload, 'target')
