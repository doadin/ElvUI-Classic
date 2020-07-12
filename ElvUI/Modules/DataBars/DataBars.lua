local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DB = E:GetModule('DataBars')

--Lua functions
local _G = _G
--WoW API / Variables
local CreateFrame = CreateFrame
local GetExpansionLevel = GetExpansionLevel
local MAX_PLAYER_LEVEL_TABLE = MAX_PLAYER_LEVEL_TABLE
-- GLOBALS: ElvUI_ExperienceBar, ElvUI_ReputationBar, ElvUI_HonorBar

function DB:OnLeave()
	if (self == ElvUI_ExperienceBar and DB.db.experience.mouseover) or (self == ElvUI_ReputationBar and DB.db.reputation.mouseover) or (self == ElvUI_PetExperienceBar and DB.db.petExperience.mouseover) then
		E:UIFrameFadeOut(self, 1, self:GetAlpha(), 0)
	end

	_G.GameTooltip:Hide()
end

function DB:CreateBar(name, onEnter, onClick, ...)
	local bar = CreateFrame('Button', name, E.UIParent)
	bar:Point(...)
	bar:SetScript('OnEnter', onEnter)
	bar:SetScript('OnLeave', DB.OnLeave)
	bar:SetScript('OnMouseDown', onClick)
	bar:SetFrameStrata('LOW')
	bar:SetTemplate('Transparent')
	bar:Hide()

	bar.statusBar = CreateFrame('StatusBar', nil, bar)
	bar.statusBar:SetInside()
	bar.statusBar:SetStatusBarTexture(E.media.normTex)
	E:RegisterStatusBar(bar.statusBar)
	bar.text = bar.statusBar:CreateFontString(nil, 'OVERLAY')
	bar.text:FontTemplate()
	bar.text:Point('CENTER')

	E.FrameLocks[name] = true

	return bar
end

function DB:UpdateDataBarDimensions()
	DB:UpdateExperienceDimensions()
	DB:UpdateReputationDimensions()
	DB:UpdatePetExperienceDimensions()
end

function DB:PLAYER_LEVEL_UP(level)
	local maxLevel = MAX_PLAYER_LEVEL_TABLE[GetExpansionLevel()]
	if (level ~= maxLevel or not DB.db.experience.hideAtMaxLevel) and DB.db.experience.enable then
		DB:UpdateExperience("PLAYER_LEVEL_UP", level)
	else
		DB.expBar:Hide()
	end
end

function DB:Initialize()
	DB.Initialized = true
	DB.db = E.db.databars

	DB:LoadExperienceBar()
	DB:LoadReputationBar()
	DB:LoadPetExperienceBar()

	DB:RegisterEvent("PLAYER_LEVEL_UP")
end

E:RegisterModule(DB:GetName())
