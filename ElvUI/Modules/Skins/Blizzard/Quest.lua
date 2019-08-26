local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G
local pairs = pairs
local unpack = unpack
local find, format, match,  split = string.find, string.format, string.match, string.split
--WoW API / Variables
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.quest ~= true then return end

	local QuestStrip = {
		'QuestFrame',
		'QuestLogFrame',
		'EmptyQuestLogFrame',
		'QuestFrameDetailPanel',
		'QuestDetailScrollFrame',
		'QuestDetailScrollChildFrame',
		'QuestRewardScrollFrame',
		'QuestRewardScrollChildFrame',
		'QuestFrameProgressPanel',
		'QuestFrameRewardPanel',
		'QuestFrameRewardPanel'
	}

	for _, object in pairs(QuestStrip) do
		_G[object]:StripTextures(true)
	end

	local QuestButtons = {
		'QuestLogFrameAbandonButton',
		'QuestFrameExitButton',
		'QuestFramePushQuestButton',
		'QuestFrameCompleteButton',
		'QuestFrameGoodbyeButton',
		'QuestFrameCompleteQuestButton',
		'QuestFrameCancelButton',
		'QuestFrameAcceptButton',
		'QuestFrameDeclineButton'
	}

	for _, button in pairs(QuestButtons) do
		_G[button]:StripTextures()
		S:HandleButton(_G[button])
	end

	for i = 1, MAX_NUM_ITEMS do
		local item = _G['QuestLogItem'..i]
		local icon = _G['QuestLogItem'..i..'IconTexture']
		local count = _G['QuestLogItem'..i..'Count']

		item:StripTextures()
		item:SetTemplate('Default')
		item:StyleButton(nil, true)
		item:Width(item:GetWidth() - 4)
		item:SetFrameLevel(item:GetFrameLevel() + 2)

		icon:SetDrawLayer('OVERLAY')
		icon:Size(icon:GetWidth() -(E.Spacing*2), icon:GetHeight() -(E.Spacing*2))
		icon:Point('TOPLEFT', E.Border, -E.Border)
		S:HandleIcon(icon)

		-- count:SetParent(item.backdrop)
		-- count:SetDrawLayer('OVERLAY')
	end

	for i = 1, 6 do
		local item = _G['QuestProgressItem'..i]
		local icon = _G['QuestProgressItem'..i..'IconTexture']
		local count = _G['QuestProgressItem'..i..'Count']

		item:StripTextures()
		item:SetTemplate('Default')
		item:StyleButton(nil, true)
		item:Width(item:GetWidth() - 4)
		item:SetFrameLevel(item:GetFrameLevel() + 2)

		icon:SetDrawLayer('OVERLAY')
		icon:Size(icon:GetWidth() -(E.Spacing*2), icon:GetHeight() -(E.Spacing*2))
		icon:Point('TOPLEFT', E.Border, -E.Border)
		S:HandleIcon(icon)

		-- count:SetParent(item.backdrop)
		-- count:SetDrawLayer('OVERLAY')
	end

--[[	for i = 1, 6 do
		local item = _G['QuestLogRewardItem'..i]
		local icon = _G['QuestLogRewardItem'..i..'IconTexture']
		local count = _G['QuestLogRewardItem'..i..'Count']

		item:StripTextures()
		item:SetTemplate('Default')
		item:StyleButton(nil, true)
		item:Width(item:GetWidth() - 4)
		item:SetFrameLevel(item:GetFrameLevel() + 2)

		icon:SetDrawLayer('OVERLAY')
		icon:Size(icon:GetWidth() -(E.Spacing*2), icon:GetHeight() -(E.Spacing*2))
		icon:Point('TOPLEFT', E.Border, -E.Border)
		S:HandleIcon(icon)

		count:SetParent(item.backdrop)
		count:SetDrawLayer('OVERLAY')
	end--]]

	local function QuestQualityColors(frame, text, quality, link)
		if link and not quality then
			quality = select(3, GetItemInfo(link))
		end

		if quality then
			if frame then
				frame:SetBackdropBorderColor(GetItemQualityColor(quality))
				frame.backdrop:SetBackdropBorderColor(GetItemQualityColor(quality))
			end
			text:SetTextColor(GetItemQualityColor(quality))
		else
			if frame then
				frame:SetBackdropBorderColor(unpack(E['media'].bordercolor))
				frame.backdrop:SetBackdropBorderColor(unpack(E['media'].bordercolor))
			end
			text:SetTextColor(1, 1, 1)
		end
	end

--[[	QuestRewardItemHighlight:StripTextures()
	QuestRewardItemHighlight:SetTemplate('Default', nil, true)
	QuestRewardItemHighlight:SetBackdropBorderColor(1, 1, 0)
	QuestRewardItemHighlight:SetBackdropColor(0, 0, 0, 0)
	QuestRewardItemHighlight:Size(142, 40)

	hooksecurefunc('QuestRewardItem_OnClick', function(self)
		QuestRewardItemHighlight:ClearAllPoints();
		QuestRewardItemHighlight:SetOutside(self:GetName()..'IconTexture')
		_G[self:GetName()..'Name']:SetTextColor(1, 1, 0)

		for i = 1, MAX_NUM_ITEMS do
			local questItem = _G['QuestRewardItem'..i]
			local questName = _G['QuestRewardItem'..i..'Name']
			local link = questItem.type and GetQuestItemLink(questItem.type, questItem:GetID())

			if questItem ~= self then
				QuestQualityColors(nil, questName, nil, link)
			end
		end
	end)--]]

	local function QuestObjectiveTextColor()
		local numObjectives = GetNumQuestLeaderBoards()
		local objective
		local _, type, finished
		local numVisibleObjectives = 0
		for i = 1, numObjectives do
			_, type, finished = GetQuestLogLeaderBoard(i)
			if type ~= 'spell' then
				numVisibleObjectives = numVisibleObjectives + 1
				objective = _G['QuestLogObjective'..numVisibleObjectives]
				if finished then
					objective:SetTextColor(1, 0.80, 0.10)
				else
					objective:SetTextColor(0.6, 0.6, 0.6)
				end
			end
		end
	end

	hooksecurefunc('QuestLog_UpdateQuestDetails', function()
		local requiredMoney = GetQuestLogRequiredMoney()
		if requiredMoney > 0 then
			if requiredMoney > GetMoney() then
				QuestLogRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestLogRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end
	end)

	hooksecurefunc('QuestFrameItems_Update', function(questState)
		local textColor = {1, 1, 1}
		local titleTextColor = {1, 0.80, 0.10}

		QuestFont:SetTextColor(unpack(textColor))
		QuestFontNormalSmall:SetTextColor(unpack(textColor))
		QuestDescription:SetTextColor(unpack(textColor))
		QuestObjectiveText:SetTextColor(unpack(textColor))

		QuestTitleText:SetTextColor(unpack(titleTextColor))
		QuestTitleFont:SetTextColor(unpack(titleTextColor))

		QuestDetailRewardTitleText:SetTextColor(unpack(titleTextColor))
		QuestDetailObjectiveTitleText:SetTextColor(unpack(titleTextColor))
		QuestDetailItemReceiveText:SetTextColor(unpack(textColor))
		QuestDetailSpellLearnText:SetTextColor(unpack(textColor))
		QuestDetailItemChooseText:SetTextColor(unpack(textColor))

		QuestLogRewardTitleText:SetTextColor(unpack(titleTextColor))
		QuestLogTitleText:SetTextColor(unpack(titleTextColor))
		QuestLogQuestTitle:SetTextColor(unpack(titleTextColor))
		QuestLogDescriptionTitle:SetTextColor(unpack(titleTextColor))
		QuestLogObjectivesText:SetTextColor(unpack(textColor))
		QuestLogQuestDescription:SetTextColor(unpack(textColor))
		QuestLogItemChooseText:SetTextColor(unpack(textColor))
		QuestLogItemReceiveText:SetTextColor(unpack(textColor))
		QuestLogSpellLearnText:SetTextColor(unpack(textColor))

		QuestRewardRewardTitleText:SetTextColor(unpack(titleTextColor))
		QuestRewardTitleText:SetTextColor(unpack(titleTextColor))
		QuestRewardItemChooseText:SetTextColor(unpack(textColor))
		QuestRewardItemReceiveText:SetTextColor(unpack(textColor))
		QuestRewardSpellLearnText:SetTextColor(unpack(textColor))
		QuestRewardText:SetTextColor(unpack(textColor))

		if GetQuestLogRequiredMoney() > 0 then
			if GetQuestLogRequiredMoney() > GetMoney() then
				QuestInfoRequiredMoneyText:SetTextColor(0.6, 0.6, 0.6)
			else
				QuestInfoRequiredMoneyText:SetTextColor(1, 0.80, 0.10)
			end
		end

		QuestObjectiveTextColor()

		local numQuestRewards, numQuestChoices
		if questState == 'QuestLog' then
			numQuestRewards, numQuestChoices = GetNumQuestLogRewards(), GetNumQuestLogChoices()
		else
			numQuestRewards, numQuestChoices = GetNumQuestRewards(), GetNumQuestChoices()
		end

		local rewardsCount = numQuestChoices + numQuestRewards
		if rewardsCount > 0 then
			local questItem, itemName, link
			local questItemName = questState..'Item'

			for i = 1, rewardsCount do
				questItem = _G[questItemName..i]
				itemName = _G[questItemName..i..'Name']
				link = questItem.type and (questState == 'QuestLog' and GetQuestLogItemLink or GetQuestItemLink)(questItem.type, questItem:GetID())

				QuestQualityColors(questItem, itemName, nil, link)
			end
		end
	end)

	QuestLogTimerText:SetTextColor(1, 1, 1)

	QuestFrame:CreateBackdrop('Transparent')
	QuestFrame.backdrop:Point('TOPLEFT', 15, -11)
	QuestFrame.backdrop:Point('BOTTOMRIGHT', -30, 67)

	QuestLogFrame:CreateBackdrop('Transparent')
	QuestLogFrame.backdrop:Point('TOPLEFT', 10, -12)
	QuestLogFrame.backdrop:Point('BOTTOMRIGHT', -1, 8)

	QuestLogListScrollFrame:StripTextures()
	QuestLogListScrollFrame:CreateBackdrop('Default', true)

	QuestLogDetailScrollFrame:StripTextures()
	QuestLogDetailScrollFrame:CreateBackdrop('Default', true)

	QuestLogDetailScrollFrame:ClearAllPoints()
	QuestLogDetailScrollFrame:Point('TOPLEFT', QuestLogListScrollFrame, 'TOPRIGHT', 25, 0)

	QuestLogNoQuestsText:ClearAllPoints()
	QuestLogNoQuestsText:Point('CENTER', EmptyQuestLogFrame, 'CENTER', -45, 65)

	QuestLogFrameAbandonButton:Point('BOTTOMLEFT', 18, 15)
	QuestLogFrameAbandonButton:Width(100)

	QuestFramePushQuestButton:ClearAllPoints()
	QuestFramePushQuestButton:Point('LEFT', QuestLogFrameAbandonButton, 'RIGHT', 2, 0)
	QuestFramePushQuestButton:Width(100)

	QuestFrameExitButton:Point('BOTTOMRIGHT', -8, 15)
	QuestFrameExitButton:Width(100)

	S:HandleScrollBar(QuestLogDetailScrollFrameScrollBar)
	S:HandleScrollBar(QuestDetailScrollFrameScrollBar)
	S:HandleScrollBar(QuestLogListScrollFrameScrollBar)
	QuestLogListScrollFrameScrollBar:Point('TOPLEFT', QuestLogListScrollFrame, 'TOPRIGHT', 5, -16)
	S:HandleScrollBar(QuestProgressScrollFrameScrollBar)
	S:HandleScrollBar(QuestRewardScrollFrameScrollBar)

	S:HandleCloseButton(QuestFrameCloseButton, QuestFrame.backdrop)

	S:HandleCloseButton(QuestLogFrameCloseButton)
	QuestLogFrameCloseButton:ClearAllPoints()
	QuestLogFrameCloseButton:Point('TOPRIGHT', 2, -9)

	for i = 1, 6 do
		local item = _G['QuestProgressItem'..i]
		local icon = _G['QuestProgressItem'..i..'IconTexture']
		local count = _G['QuestProgressItem'..i..'Count']

		item:StripTextures()
		item:SetTemplate('Default')
		item:StyleButton(nil, true)
		item:Width(item:GetWidth() - 4)
		item:SetFrameLevel(item:GetFrameLevel() + 2)

		icon:SetDrawLayer('OVERLAY')
		icon:Size(icon:GetWidth() -(E.Spacing*2), icon:GetHeight() -(E.Spacing*2))
		icon:Point('TOPLEFT', E.Border, -E.Border)
		S:HandleIcon(icon)

		-- count:SetParent(item.backdrop)
		-- count:SetDrawLayer('OVERLAY')
	end

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

			QuestQualityColors(item, name, nil, link)
		end
	end)

	for i = 1, QUESTS_DISPLAYED do
		local questLogTitle = _G['QuestLogTitle'..i]
		local highlight = _G['QuestLogTitle'..i..'Highlight']

		questLogTitle:SetNormalTexture('Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton')
		questLogTitle.SetNormalTexture = E.noop
		questLogTitle:GetNormalTexture():Size(14)
		questLogTitle:GetNormalTexture():Point('LEFT', 3, 0)

		highlight:SetTexture('')
		highlight.SetTexture = E.noop

		hooksecurefunc(questLogTitle, 'SetNormalTexture', function(self, texture)
			if find(texture, 'MinusButton') then
				self:GetNormalTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
			elseif find(texture, 'PlusButton') then
				self:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
			else
				self:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
 			end
		end)
	end

	QuestLogCollapseAllButton:StripTextures()
	QuestLogCollapseAllButton:Point('TOPLEFT', -45, 7)

	QuestLogCollapseAllButton:SetNormalTexture('Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton')
	QuestLogCollapseAllButton.SetNormalTexture = E.noop
	QuestLogCollapseAllButton:GetNormalTexture():Size(15)

	QuestLogCollapseAllButton:SetHighlightTexture('')
	QuestLogCollapseAllButton.SetHighlightTexture = E.noop

	QuestLogCollapseAllButton:SetDisabledTexture('Interface\\AddOns\\ElvUI\\media\\textures\\PlusMinusButton')
	QuestLogCollapseAllButton.SetDisabledTexture = E.noop
	QuestLogCollapseAllButton:GetDisabledTexture():Size(15)
	QuestLogCollapseAllButton:GetDisabledTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
	QuestLogCollapseAllButton:GetDisabledTexture():SetDesaturated(true)

	hooksecurefunc(QuestLogCollapseAllButton, 'SetNormalTexture', function(self, texture)
		if find(texture, 'MinusButton') then
			self:GetNormalTexture():SetTexCoord(0.540, 0.965, 0.085, 0.920)
		elseif find(texture, 'PlusButton') then
			self:GetNormalTexture():SetTexCoord(0.040, 0.465, 0.085, 0.920)
		else
			self:GetNormalTexture():SetTexCoord(0, 0, 0, 0)
 		end
	end)
end

S:AddCallback('Quest', LoadSkin)