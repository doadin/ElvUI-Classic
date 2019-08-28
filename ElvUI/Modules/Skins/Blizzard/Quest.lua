local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Lua functions
local _G = _G
local unpack = unpack
local find = string.find
--WoW API / Variables
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then return end

	QuestLogFrame:StripTextures()
	QuestLogFrame:CreateBackdrop('Transparent')
	QuestLogFrame.backdrop:Point('TOPLEFT', 10, -12)
	QuestLogFrame.backdrop:Point('BOTTOMRIGHT', -1, 8)

	for frame, numItems in pairs({['QuestLogItem'] = MAX_NUM_ITEMS, ['QuestProgressItem'] = MAX_REQUIRED_ITEMS}) do
		for i = 1, numItems do
			local item = _G[frame..i]
			local icon = _G[frame..i..'IconTexture']

			item:StripTextures()
			item:SetTemplate('Default')
			item:StyleButton()
			item:Size(143, 40)
			item:SetFrameLevel(item:GetFrameLevel() + 2)

			icon:Size(E.PixelMode and 38 or 32)
			icon:SetDrawLayer('OVERLAY')
			icon:Point('TOPLEFT', E.PixelMode and 1 or 4, -(E.PixelMode and 1 or 4))
			S:HandleIcon(icon)
		end
	end

	local function QuestQualityColors(frame, text, link, quality)
		if link and not quality then
			quality = select(3, GetItemInfo(link))
		end

		if quality then
			frame:SetBackdropBorderColor(GetItemQualityColor(quality))
			--frame.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))

			text:SetTextColor(GetItemQualityColor(quality))
		else
			frame:SetBackdropBorderColor(unpack(E.media.bordercolor))
			--frame.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))

			text:SetTextColor(1, 1, 1)
		end
	end

	QuestInfoItemHighlight:StripTextures()

	hooksecurefunc('QuestInfoItem_OnClick', function(self)
		if self.type == 'choice' then
			_G[self:GetName()]:SetBackdropBorderColor(1, 0.80, 0.10)
			_G[self:GetName()].backdrop:SetBackdropBorderColor(1, 0.80, 0.10)
			_G[self:GetName()..'Name']:SetTextColor(1, 0.80, 0.10)

			for i = 1, MAX_NUM_ITEMS do
				local item = _G['QuestInfoItem'..i]
				local name = _G['QuestInfoItem'..i..'Name']
				local link = item.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(item.type, item:GetID())

				if item ~= self then
					QuestQualityColors(item, name, link)
				end
			end
		end
	end)

	S:HandleButton(QuestLogFrameAbandonButton)
	QuestLogFrameAbandonButton:Point('BOTTOMLEFT', 14, 14)

	S:HandleButton(QuestFramePushQuestButton)
	QuestFramePushQuestButton:Point('LEFT', QuestLogFrameAbandonButton, 'RIGHT', 2, 0)

	S:HandleButton(QuestFrameExitButton)
	QuestFrameExitButton:Point('BOTTOMRIGHT', -9, 14)

	local function QuestObjectiveText()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective
		local _, type, finished
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			_, type, finished = GetQuestLogLeaderBoard(i)
			if type ~= 'spell' then
				numVisibleObjectives = numVisibleObjectives + 1
				objective = _G['QuestInfoObjective'..numVisibleObjectives]
				if finished then
					objective:SetTextColor(1, 0.80, 0.10)
				else
					objective:SetTextColor(0.6, 0.6, 0.6)
				end
			end
		end
	end

	hooksecurefunc(_G, 'QuestLog_UpdateQuestDetails', function()
		_G.QuestLogQuestTitle:SetTextColor(1, .8, .1)
		_G.QuestLogObjectivesText:SetTextColor(1, 1, 1)

		_G.QuestLogDescriptionTitle:SetTextColor(1, .8, .1)
		_G.QuestLogQuestDescription:SetTextColor(1, 1, 1)

		_G.QuestLogRewardTitleText:SetTextColor(1, .8, .1)

		_G.QuestLogItemChooseText:SetTextColor(1, 1, 1)
		_G.QuestLogSpellLearnText:SetTextColor(1, 1, 1)

		local numObjectives = GetNumQuestLeaderBoards()
		local numVisibleObjectives = 0

		for i = 1, numObjectives do
			local _, _, finished = GetQuestLogLeaderBoard(i)
			if (type ~= 'spell' and type ~= 'log' and numVisibleObjectives < _G.MAX_OBJECTIVES) then
				numVisibleObjectives = numVisibleObjectives + 1
				local objective = _G['QuestLogObjective'..numVisibleObjectives]
				if objective then
					if finished then
						objective:SetTextColor(1, .8, .1)
					else
						objective:SetTextColor(.63, .09, .09)
					end
				end
			end
		end

		if QuestLogRequiredMoneyText:GetTextColor() == 0 then
			QuestLogRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
		else
			QuestLogRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
		end
	end)


	hooksecurefunc('QuestInfo_ShowRewards', function()
		for i = 1, MAX_NUM_ITEMS do
			local item = _G['QuestInfoItem'..i]
			local name = _G['QuestInfoItem'..i..'Name']
			local link = item.type and (QuestInfoFrame.questLog and GetQuestLogItemLink or GetQuestItemLink)(item.type, item:GetID())

			QuestQualityColors(item, name, link)
		end
	end)

	hooksecurefunc('QuestInfo_ShowRequiredMoney', function()
	end)

	hooksecurefunc('QuestInfo_Display', function()
		QuestInfoTitleHeader:SetTextColor(1, .8, .1)
		QuestInfoDescriptionHeader:SetTextColor(1, .8, .1)
		QuestInfoObjectivesHeader:SetTextColor(1, .8, .1)
		QuestInfoRewardsFrame.Header:SetTextColor(1, .8, .1)
		-- other text
		QuestInfoDescriptionText:SetTextColor(1, 1, 1)
		QuestInfoObjectivesText:SetTextColor(1, 1, 1)
		QuestInfoGroupSize:SetTextColor(1, 1, 1)
		QuestInfoRewardText:SetTextColor(1, 1, 1)
		-- reward frame text
		QuestInfoRewardsFrame.ItemChooseText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.ItemReceiveText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.PlayerTitleText:SetTextColor(1, 1, 1)
		QuestInfoRewardsFrame.XPFrame.ReceiveText:SetTextColor(1, 1, 1)

		QuestInfoRewardsFrame.spellHeaderPool.textR, QuestInfoRewardsFrame.spellHeaderPool.textG, QuestInfoRewardsFrame.spellHeaderPool.textB = 1, 1, 1
	end)

	QuestInfoTimerText:SetTextColor(1, 1, 1)
	QuestInfoAnchor:SetTextColor(1, 1, 1)

	QuestLogDetailScrollFrame:StripTextures()

	QuestLogFrame:HookScript('OnShow', function()
		if not QuestLogDetailScrollFrame.backdrop then
			QuestLogDetailScrollFrame:CreateBackdrop('Transparent')
		end

		QuestLogDetailScrollFrame.backdrop:Point('TOPLEFT', 0, 2)
		QuestLogDetailScrollFrame.backdrop:Point('BOTTOMRIGHT', 0, -2)
		QuestLogDetailScrollFrame:Point('TOPRIGHT', -32, -76)
		QuestLogDetailScrollFrame:Size(302, 300)

		if not QuestLogDetailScrollFrame.backdrop then
			QuestLogDetailScrollFrame:CreateBackdrop('Transparent')
		end

		QuestLogDetailScrollFrameScrollBar:Point('TOPLEFT', QuestLogDetailScrollFrame, 'TOPRIGHT', 5, -12)
	end)

	QuestLogDetailScrollFrame:HookScript('OnShow', function()
		if not QuestLogDetailScrollFrame.backdrop then
			QuestLogDetailScrollFrame:CreateBackdrop('Transparent')
		end
	end)

	QuestLogSkillHighlight:SetTexture(E.Media.Textures.Highlight)
	QuestLogSkillHighlight:SetAlpha(0.35)

	S:HandleCloseButton(QuestLogFrameCloseButton)

	EmptyQuestLogFrame:StripTextures()

	S:HandleScrollBar(QuestLogDetailScrollFrameScrollBar)
	S:HandleScrollBar(QuestDetailScrollFrameScrollBar)
	S:HandleScrollBar(QuestProgressScrollFrameScrollBar)
	S:HandleScrollBar(QuestRewardScrollFrameScrollBar)

	-- Quest Frame
	QuestFrame:StripTextures(true)
	QuestFrame:CreateBackdrop('Transparent')
	QuestFrame.backdrop:Point('TOPLEFT', 15, -11)
	QuestFrame.backdrop:Point('BOTTOMRIGHT', -20, 0)
	QuestFrame:Width(374)

	QuestFrameDetailPanel:StripTextures(true)
	QuestDetailScrollFrame:StripTextures(true)
	QuestDetailScrollFrame:Height(403)
	QuestDetailScrollChildFrame:StripTextures(true)
	QuestRewardScrollFrame:StripTextures(true)
	QuestRewardScrollFrame:Height(403)
	QuestRewardScrollChildFrame:StripTextures(true)
	QuestFrameProgressPanel:StripTextures(true)
	QuestProgressScrollFrame:Height(403)
	QuestProgressScrollFrame:StripTextures()
	QuestFrameRewardPanel:StripTextures(true)

	S:HandleButton(QuestFrameAcceptButton, true)
	QuestFrameAcceptButton:Point('BOTTOMLEFT', 20, 4)

	S:HandleButton(QuestFrameDeclineButton, true)
	QuestFrameDeclineButton:Point('BOTTOMRIGHT', -37, 4)

	S:HandleButton(QuestFrameCompleteButton, true)
	QuestFrameCompleteButton:Point('BOTTOMLEFT', 20, 4)

	S:HandleButton(QuestFrameGoodbyeButton, true)
	QuestFrameGoodbyeButton:Point('BOTTOMRIGHT', -37, 4)

	S:HandleButton(QuestFrameCompleteQuestButton, true)
	QuestFrameCompleteQuestButton:Point('BOTTOMLEFT', 20, 4)

	S:HandleButton(QuestFrameCancelButton)
	QuestFrameCancelButton:Point('BOTTOMRIGHT', -37, 4)

	S:HandleCloseButton(QuestFrameCloseButton)

	hooksecurefunc('QuestFrameProgressItems_Update', function()
		QuestProgressTitleText:SetTextColor(1, 0.80, 0.10)
		QuestProgressText:SetTextColor(1, 1, 1)
		QuestProgressRequiredItemsText:SetTextColor(1, 0.80, 0.10)

		if GetQuestMoneyToGet() > 0 then
			if GetQuestMoneyToGet() > GetMoney() then
				QuestProgressRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestProgressRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end

		for i = 1, MAX_REQUIRED_ITEMS do
			local item = _G['QuestProgressItem'..i]
			local name = _G['QuestProgressItem'..i..'Name']
			local link = item.type and GetQuestItemLink(item.type, item:GetID())

			QuestQualityColors(item, name, link)
		end
	end)

	for i = 1, QUESTS_DISPLAYED do
		local questLogTitle = _G['QuestLogTitle'..i]
		questLogTitle:SetNormalTexture(E.Media.Textures.Plus)
		questLogTitle.SetNormalTexture = E.noop
		questLogTitle:GetNormalTexture():Size(16)
		questLogTitle:GetNormalTexture():Point('LEFT', 5, 0)
		questLogTitle:SetHighlightTexture('')
		questLogTitle.SetHighlightTexture = E.noop

		hooksecurefunc(questLogTitle, 'SetNormalTexture', function(self, texture)
			local tex = self:GetNormalTexture()

			if find(texture, 'MinusButton') then
				tex:SetTexture(E.Media.Textures.Minus)
			elseif find(texture, 'PlusButton') then
				tex:SetTexture(E.Media.Textures.Plus)
			else
				tex:SetTexture()
			end
		end)
	end

	QuestLogCollapseAllButton:StripTextures()
	QuestLogCollapseAllButton:Point('TOPLEFT', -45, 7)

	QuestLogCollapseAllButton:SetNormalTexture(E.Media.Textures.Plus)
	QuestLogCollapseAllButton.SetNormalTexture = E.noop
	QuestLogCollapseAllButton:GetNormalTexture():Size(16)

	QuestLogCollapseAllButton:SetHighlightTexture('')
	QuestLogCollapseAllButton.SetHighlightTexture = E.noop

	QuestLogCollapseAllButton:SetDisabledTexture(E.Media.Textures.Plus)
	QuestLogCollapseAllButton.SetDisabledTexture = E.noop
	QuestLogCollapseAllButton:GetDisabledTexture():Size(16)
	QuestLogCollapseAllButton:GetDisabledTexture():SetTexture(E.Media.Textures.Plus)
	QuestLogCollapseAllButton:GetDisabledTexture():SetDesaturated(true)

	hooksecurefunc(QuestLogCollapseAllButton, 'SetNormalTexture', function(self, texture)
		local tex = self:GetNormalTexture()

		if find(texture, 'MinusButton') then
			tex:SetTexture(E.Media.Textures.Minus)
		else
			tex:SetTexture(E.Media.Textures.Plus)
		end
	end)
end

S:AddCallback('Quest', LoadSkin)
