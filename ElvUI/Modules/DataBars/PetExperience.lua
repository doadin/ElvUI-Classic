local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local mod = E:GetModule('DataBars')
local LSM = E.Libs.LSM

--Lua functions
local _G = _G
local format = format
local min = min
--WoW API / Variables
local GetXPExhaustion = GetXPExhaustion
local GetExpansionLevel = GetExpansionLevel
local MAX_PLAYER_LEVEL_TABLE = MAX_PLAYER_LEVEL_TABLE
local InCombatLockdown = InCombatLockdown
local CreateFrame = CreateFrame

function mod:UpdatePetExperience(event)
	if not mod.db.petExperience.enable then return end

	local bar = self.petExpBar
	local hideXP = ((UnitLevel('pet') == MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] and self.db.petExperience.hideAtMaxLevel))

	if hideXP or (event == "PLAYER_REGEN_DISABLED" and self.db.petExperience.hideInCombat) then
		E:DisableMover(self.petExpBar.mover:GetName())
		bar:Hide()
	elseif not hideXP and (not self.db.petExperience.hideInCombat or not InCombatLockdown()) then
		E:EnableMover(self.petExpBar.mover:GetName())
		bar:Show()

		local cur, max = self:GetXP('pet')
		if max <= 0 then max = 1 end
		bar.statusBar:SetMinMaxValues(0, max)
		bar.statusBar:SetValue(cur - 1 >= 0 and cur - 1 or 0)
		bar.statusBar:SetValue(cur)

		local rested = GetXPExhaustion()
		local text = ''
		local textFormat = self.db.petExperience.textFormat

		if rested and rested > 0 then
			bar.rested:SetMinMaxValues(0, max)
			bar.rested:SetValue(min(cur + rested, max))

			if textFormat == 'PERCENT' then
				text = format('%d%% R:%d%%', cur / max * 100, rested / max * 100)
			elseif textFormat == 'CURMAX' then
				text = format('%s - %s R:%s', E:ShortValue(cur), E:ShortValue(max), E:ShortValue(rested))
			elseif textFormat == 'CURPERC' then
				text = format('%s - %d%% R:%s [%d%%]', E:ShortValue(cur), cur / max * 100, E:ShortValue(rested), rested / max * 100)
			elseif textFormat == 'CUR' then
				text = format('%s R:%s', E:ShortValue(cur), E:ShortValue(rested))
			elseif textFormat == 'REM' then
				text = format('%s R:%s', E:ShortValue(max - cur), E:ShortValue(rested))
			elseif textFormat == 'CURREM' then
				text = format('%s - %s R:%s', E:ShortValue(cur), E:ShortValue(max - cur), E:ShortValue(rested))
			elseif textFormat == 'CURPERCREM' then
				text = format('%s - %d%% (%s) R:%s', E:ShortValue(cur), cur / max * 100, E:ShortValue(max - cur), E:ShortValue(rested))
			end
		else
			bar.rested:SetMinMaxValues(0, 1)
			bar.rested:SetValue(0)

			if textFormat == 'PERCENT' then
				text = format('%d%%', cur / max * 100)
			elseif textFormat == 'CURMAX' then
				text = format('%s - %s', E:ShortValue(cur), E:ShortValue(max))
			elseif textFormat == 'CURPERC' then
				text = format('%s - %d%%', E:ShortValue(cur), cur / max * 100)
			elseif textFormat == 'CUR' then
				text = format('%s', E:ShortValue(cur))
			elseif textFormat == 'REM' then
				text = format('%s', E:ShortValue(max - cur))
			elseif textFormat == 'CURREM' then
				text = format('%s - %s', E:ShortValue(cur), E:ShortValue(max - cur))
			elseif textFormat == 'CURPERCREM' then
				text = format('%s - %d%% (%s)', E:ShortValue(cur), cur / max * 100, E:ShortValue(max - cur))
			end
		end

		bar.text:SetText(text)
	end
end

function mod:PetExperienceBar_OnEnter()
	local GameTooltip = _G.GameTooltip
	if mod.db.experience.mouseover then
		E:UIFrameFadeIn(self, 0.4, self:GetAlpha(), 1)
	end

	GameTooltip:ClearLines()
	GameTooltip:SetOwner(self, 'ANCHOR_CURSOR', 0, -4)

	local cur, max = mod:GetXP('pet')
	local rested = GetXPExhaustion()
	GameTooltip:AddLine(L["Experience"])
	GameTooltip:AddLine(' ')

	GameTooltip:AddDoubleLine(L["XP:"], format(' %d / %d (%d%%)', cur, max, cur/max * 100), 1, 1, 1)
	GameTooltip:AddDoubleLine(L["Remaining:"], format(' %d (%d%% - %d '..L["Bars"]..')', max - cur, (max - cur) / max * 100, 20 * (max - cur) / max), 1, 1, 1)

	if rested then
		GameTooltip:AddDoubleLine(L["Rested:"], format('+%d (%d%%)', rested, rested / max * 100), 1, 1, 1)
	end

	GameTooltip:Show()
end

function mod:PetExperienceBar_OnClick() end

function mod:UpdatePetExperienceDimensions()
	self.petExpBar:Width(self.db.petExperience.width)
	self.petExpBar:Height(self.db.petExperience.height)

	self.petExpBar.text:FontTemplate(LSM:Fetch("font", self.db.petExperience.font), self.db.petExperience.textSize, self.db.petExperience.fontOutline)
	self.petExpBar.rested:SetOrientation(self.db.petExperience.orientation)
	self.petExpBar.statusBar:SetReverseFill(self.db.petExperience.reverseFill)

	self.petExpBar.statusBar:SetOrientation(self.db.petExperience.orientation)
	self.petExpBar.rested:SetReverseFill(self.db.petExperience.reverseFill)

	if self.db.petExperience.orientation == "HORIZONTAL" then
		self.petExpBar.rested:SetRotatesTexture(false)
		self.petExpBar.statusBar:SetRotatesTexture(false)
	else
		self.petExpBar.rested:SetRotatesTexture(true)
		self.petExpBar.statusBar:SetRotatesTexture(true)
	end

	if self.db.petExperience.mouseover then
		self.petExpBar:SetAlpha(0)
	else
		self.petExpBar:SetAlpha(1)
	end
end

function mod:EnableDisable_PetExperienceBar()
	if (UnitLevel('pet') ~= MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()] or not self.db.petExperience.hideAtMaxLevel) and self.db.petExperience.enable then
		self:UpdateExperience()
		E:EnableMover(self.petExpBar.mover:GetName())
	else
		self.petExpBar:Hide()
		E:DisableMover(self.petExpBar.mover:GetName())
	end
end

function mod:LoadPetExperienceBar()
	self.petExpBar = self:CreateBar('ElvUI_PetExperienceBar', self.PetExperienceBar_OnEnter, self.PetExperienceBar_OnClick, 'LEFT', _G.LeftChatPanel, 'RIGHT', -E.Border + E.Spacing*3, 0)
	self.petExpBar.statusBar:SetStatusBarColor(0, 0.4, 1, .8)
	self.petExpBar.rested = CreateFrame('StatusBar', nil, self.petExpBar)
	self.petExpBar.rested:SetInside()
	self.petExpBar.rested:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(self.petExpBar.rested)
	self.petExpBar.rested:SetStatusBarColor(1, 0, 1, 0.2)

	self.petExpBar.eventFrame = CreateFrame("Frame")
	self.petExpBar.eventFrame:Hide()
	self.petExpBar.eventFrame:RegisterEvent("UNIT_PET", "EnableDisable_ExperienceBar")
	self.petExpBar.eventFrame:RegisterEvent("UNIT_PET_EXPERIENCE", 'UpdatePetExperience')
	self.petExpBar.eventFrame:RegisterEvent("PLAYER_REGEN_DISABLED", 'UpdatePetExperience')
	self.petExpBar.eventFrame:RegisterEvent("PLAYER_REGEN_ENABLED", 'UpdatePetExperience')

	self:UpdatePetExperienceDimensions()

	E:CreateMover(self.petExpBar, "PetExperienceBarMover", L["Pet Experience Bar"], nil, nil, nil, nil, nil, 'databars,experience')
	self:EnableDisable_PetExperienceBar()
end
