local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Cache global variables
--Lua functions
local _G = _G

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.gossip ~= true then return end

	-- ItemTextFrame
	_G.ItemTextFrame:StripTextures(true)
	_G.ItemTextFrame:CreateBackdrop('Transparent')
	_G.ItemTextFrame.backdrop:Point('TOPLEFT', 13, -13)
	_G.ItemTextFrame.backdrop:Point('BOTTOMRIGHT', -32, 74)

	_G.ItemTextScrollFrame:StripTextures()

	S:HandleNextPrevButton(_G.ItemTextPrevPageButton)
	_G.ItemTextPrevPageButton:ClearAllPoints()
	_G.ItemTextPrevPageButton:Point('TOPLEFT', _G.ItemTextFrame, 'TOPLEFT', 30, -50)

	S:HandleNextPrevButton(_G.ItemTextNextPageButton)
	_G.ItemTextNextPageButton:ClearAllPoints()
	_G.ItemTextNextPageButton:Point('TOPRIGHT', _G.ItemTextFrame, 'TOPRIGHT', -48, -50)

	_G.ItemTextPageText:SetTextColor(1, 1, 1)
	hooksecurefunc(_G.ItemTextPageText, 'SetTextColor', function(pageText, headerType, r, g, b)
		if r ~= 1 or g ~= 1 or b ~= 1 then
			pageText:SetTextColor(headerType, 1, 1, 1)
		end
	end)

	local StripAllTextures = { 'GossipFrameGreetingPanel', 'GossipGreetingScrollFrame' }

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	S:HandleScrollBar(_G.ItemTextScrollFrameScrollBar)

	S:HandleCloseButton(_G.ItemTextCloseButton)

	-- GossipFrame
	local GossipFrame = _G.GossipFrame
	S:HandlePortraitFrame(GossipFrame, true)

	local GossipGreetingScrollFrame = _G.GossipGreetingScrollFrame
	GossipGreetingScrollFrame:SetTemplate()

	if E.private.skins.parchmentRemover.enable then
		for i = 1, _G.NUMGOSSIPBUTTONS do
			_G['GossipTitleButton'..i]:GetFontString():SetTextColor(1, 1, 1)
		end

		_G.GossipGreetingText:SetTextColor(1, 1, 1)

		hooksecurefunc('GossipFrameUpdate', function()
			for i = 1, _G.NUMGOSSIPBUTTONS do
				local button = _G['GossipTitleButton'..i]
				if button:GetFontString() then
					local Text = button:GetFontString():GetText()
					if Text and strfind(Text, '|cff000000') then
						button:GetFontString():SetText(gsub(Text, '|cff000000', '|cffffe519'))
					end
				end
			end
		end)
	else
		GossipGreetingScrollFrame.spellTex = GossipGreetingScrollFrame:CreateTexture(nil, 'ARTWORK')
		GossipGreetingScrollFrame.spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
		GossipGreetingScrollFrame.spellTex:Point('TOPLEFT', 2, -2)
		GossipGreetingScrollFrame.spellTex:Size(506, 615)
		GossipGreetingScrollFrame.spellTex:SetTexCoord(0, 1, 0.02, 1)
	end

	_G.GossipFrameGreetingGoodbyeButton:StripTextures()
	S:HandleButton(_G.GossipFrameGreetingGoodbyeButton)

	local NPCFriendshipStatusBar = _G.NPCFriendshipStatusBar
	NPCFriendshipStatusBar:StripTextures()
	NPCFriendshipStatusBar:SetStatusBarTexture(E.media.normTex)
	NPCFriendshipStatusBar:CreateBackdrop()

	E:RegisterStatusBar(NPCFriendshipStatusBar)
end

S:AddCallback('Gossip', LoadSkin)