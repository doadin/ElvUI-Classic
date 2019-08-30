local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
local select, unpack = select, unpack
local strfind = strfind
local match, split = string.match, string.split
--WoW API / Variables
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local GetTradeSkillItemLink = GetTradeSkillItemLink
local GetTradeSkillReagentInfo = GetTradeSkillReagentInfo
local GetTradeSkillReagentItemLink = GetTradeSkillReagentItemLink
local hooksecurefunc = hooksecurefunc
local CreateFrame = CreateFrame

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.tradeskill ~= true then return end

	local TradeSkillFrame = _G.TradeSkillFrame
	_G.TradeSkillFrame:StripTextures(true)
	_G.TradeSkillFrame:CreateBackdrop('Transparent')
	_G.TradeSkillFrame.backdrop:Point('TOPLEFT', 10, -11)
	_G.TradeSkillFrame.backdrop:Point('BOTTOMRIGHT', -32, 74)

	_G.TradeSkillRankFrameBorder:StripTextures()
	_G.TradeSkillRankFrame:Size(322, 16)
	_G.TradeSkillRankFrame:ClearAllPoints()
	_G.TradeSkillRankFrame:Point('TOP', -10, -45)
	_G.TradeSkillRankFrame:CreateBackdrop()
	_G.TradeSkillRankFrame:SetStatusBarTexture(E['media'].normTex)
	_G.TradeSkillRankFrame:SetStatusBarColor(0.13, 0.35, 0.80)
	E:RegisterStatusBar(_G.TradeSkillRankFrame)

	_G.TradeSkillExpandButtonFrame:StripTextures()

	_G.TradeSkillCollapseAllButton:SetNormalTexture(E.Media.Textures.PlusButton)
	_G.TradeSkillCollapseAllButton.SetNormalTexture = E.noop
	_G.TradeSkillCollapseAllButton:GetNormalTexture():SetPoint('LEFT', 3, 2)
	_G.TradeSkillCollapseAllButton:GetNormalTexture():Size(15)

	_G.TradeSkillCollapseAllButton:SetHighlightTexture('')
	_G.TradeSkillCollapseAllButton.SetHighlightTexture = E.noop

	_G.TradeSkillCollapseAllButton:SetDisabledTexture(E.Media.Textures.PlusButton)
	_G.TradeSkillCollapseAllButton.SetDisabledTexture = E.noop
	_G.TradeSkillCollapseAllButton:GetDisabledTexture():SetPoint('LEFT', 3, 2)
	_G.TradeSkillCollapseAllButton:GetDisabledTexture():Size(15)
	_G.TradeSkillCollapseAllButton:GetDisabledTexture():SetDesaturated(true)

	hooksecurefunc(_G.TradeSkillCollapseAllButton, 'SetNormalTexture', function(self, texture)
		local tex = self:GetNormalTexture()

		if strfind(texture, 'MinusButton') then
			tex:SetTexture(E.Media.Textures.MinusButton)
		else
			tex:SetTexture(E.Media.Textures.PlusButton)
		end
	end)

	S:HandleDropDownBox(_G.TradeSkillInvSlotDropDown, 140)
	_G.TradeSkillSubClassDropDown:ClearAllPoints()
	_G.TradeSkillInvSlotDropDown:Point('TOPRIGHT', TradeSkillFrame, 'TOPRIGHT', -32, -68)

	S:HandleDropDownBox(_G.TradeSkillSubClassDropDown, 140)
	_G.TradeSkillSubClassDropDown:ClearAllPoints()
	_G.TradeSkillSubClassDropDown:Point('RIGHT', _G.TradeSkillInvSlotDropDown, 'RIGHT', -120, 0)

	_G.TradeSkillFrameTitleText:ClearAllPoints()
	_G.TradeSkillFrameTitleText:Point('TOP', TradeSkillFrame, 'TOP', 0, -18)

	for i = 1, _G.TRADE_SKILLS_DISPLAYED do
		local button = _G['TradeSkillSkill'..i]
		local highlight = _G['TradeSkillSkill'..i..'Highlight']

		button:SetNormalTexture(E.media.normTex)
		button.SetNormalTexture = E.noop
		button:GetNormalTexture():Size(14)
		button:GetNormalTexture():SetPoint('LEFT', 2, 1)

		highlight:SetTexture('')
		highlight.SetTexture = E.noop

		hooksecurefunc(button, 'SetNormalTexture', function(self, texture)
			local tex = self:GetNormalTexture()

			if strfind(texture, 'MinusButton') then
				tex:SetTexture(E.Media.Textures.MinusButton)
			elseif strfind(texture, 'PlusButton') then
				tex:SetTexture(E.Media.Textures.PlusButton)
			else
				tex:SetTexture()
			end
		end)
	end

	_G.TradeSkillDetailScrollFrame:StripTextures()
	_G.TradeSkillListScrollFrame:StripTextures()
	_G.TradeSkillDetailScrollChildFrame:StripTextures()

	S:HandleScrollBar(_G.TradeSkillListScrollFrameScrollBar)
	S:HandleScrollBar(_G.TradeSkillDetailScrollFrameScrollBar)

	_G.TradeSkillSkillIcon:StyleButton(nil, true)
	_G.TradeSkillSkillIcon:SetTemplate('Default')

	for i = 1, _G.MAX_TRADE_SKILL_REAGENTS do
		local reagent = _G['TradeSkillReagent'..i]
		local icon = _G['TradeSkillReagent'..i..'IconTexture']
		local count = _G['TradeSkillReagent'..i..'Count']
		local nameFrame = _G['TradeSkillReagent'..i..'NameFrame']

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetDrawLayer('OVERLAY')

		icon.backdrop = CreateFrame('Frame', nil, reagent)
		icon.backdrop:SetFrameLevel(reagent:GetFrameLevel() - 1)
		icon.backdrop:SetTemplate('Default')
		icon.backdrop:SetOutside(icon)

		icon:SetParent(icon.backdrop)
		count:SetParent(icon.backdrop)
		count:SetDrawLayer('OVERLAY')

		nameFrame:Kill()
	end

	S:HandleButton(_G.TradeSkillCancelButton)
	S:HandleButton(_G.TradeSkillCreateButton)
	S:HandleButton(_G.TradeSkillCreateAllButton)

	S:HandleNextPrevButton(_G.TradeSkillDecrementButton)
	_G.TradeSkillInputBox:Height(16)
	S:HandleEditBox(_G.TradeSkillInputBox)
	S:HandleNextPrevButton(_G.TradeSkillIncrementButton)

	S:HandleCloseButton(_G.TradeSkillFrameCloseButton)

	hooksecurefunc('TradeSkillFrame_SetSelection', function(id)
		if _G.TradeSkillSkillIcon:GetNormalTexture() then
			_G.TradeSkillSkillIcon:SetAlpha(1)
			_G.TradeSkillSkillIcon:GetNormalTexture():SetTexCoord(unpack(E.TexCoords))
			_G.TradeSkillSkillIcon:GetNormalTexture():SetInside()
		else
			_G.TradeSkillSkillIcon:SetAlpha(0)
		end

		_G.TradeSkillSkillIcon:Size(40)
		_G.TradeSkillSkillIcon:Point('TOPLEFT', 2, -3)

		local skillLink = GetTradeSkillItemLink(id)
		if skillLink then
			local quality = select(3, GetItemInfo(skillLink))
			if quality then
				_G.TradeSkillSkillIcon:SetBackdropBorderColor(GetItemQualityColor(quality))
				_G.TradeSkillSkillName:SetTextColor(GetItemQualityColor(quality))
			else
				_G.TradeSkillSkillIcon:SetBackdropBorderColor(unpack(E.media.bordercolor))
				_G.TradeSkillSkillName:SetTextColor(1, 1, 1)
			end
		end

		local numReagents = GetTradeSkillNumReagents(id)
		for i = 1, numReagents, 1 do
			local _, _, reagentCount, playerReagentCount = GetTradeSkillReagentInfo(id, i)
			local reagentLink = GetTradeSkillReagentItemLink(id, i)
			local icon = _G['TradeSkillReagent'..i..'IconTexture']
			local name = _G['TradeSkillReagent'..i..'Name']

			if reagentLink then
				local quality = select(3, GetItemInfo(reagentLink))
				if quality then
					icon.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
					if playerReagentCount < reagentCount then
						name:SetTextColor(0.5, 0.5, 0.5)
					else
						name:SetTextColor(GetItemQualityColor(quality))
					end
				else
					icon.backdrop:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				end
			end
		end
	end)
end

S:AddCallbackForAddon('Blizzard_TradeSkillUI', 'TradeSkill', LoadSkin)
