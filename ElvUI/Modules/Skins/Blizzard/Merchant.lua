local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local S = E:GetModule('Skins')

--Lua functions
local _G = _G
local unpack = unpack
--WoW API / Variables
local GetItemInfo = GetItemInfo
local GetItemQualityColor = GetItemQualityColor
local hooksecurefunc = hooksecurefunc

local function LoadSkin()
	if E.private.skins.blizzard.enable ~= true or E.private.skins.blizzard.merchant ~= true then return end

	local MerchantFrame = _G.MerchantFrame
	S:HandlePortraitFrame(MerchantFrame, true)
	MerchantFrame.backdrop:Point('TOPLEFT', -5, 0)
	MerchantFrame.backdrop:Point('BOTTOMRIGHT', 1, -1)
	MerchantFrame:Height(423)

	_G.MerchantFrameCloseButton:Point('TOPRIGHT', 4, 3)

	-- skin icons / merchant slots
	for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
		local item = _G['MerchantItem'..i]
		local button = _G['MerchantItem'..i..'ItemButton']
		local icon = _G['MerchantItem'..i..'ItemButtonIconTexture']
		local money = _G['MerchantItem'..i..'MoneyFrame']
		local nameFrame = _G['MerchantItem'..i..'NameFrame']
		local name = _G['MerchantItem'..i..'Name']
		local slot = _G['MerchantItem'..i..'SlotTexture']

		item:StripTextures(true)
		item:CreateBackdrop('Default')
		item.backdrop:Point('BOTTOMRIGHT', 0, -4)

		button:StripTextures()
		button:StyleButton()
		button:SetTemplate('Default', true)
		button:Size(40)
		button:Point('TOPLEFT', item, 'TOPLEFT', 4, -4)

		icon:SetTexCoord(unpack(E.TexCoords))
		icon:SetInside()

		nameFrame:Point('LEFT', slot, 'RIGHT', -6, -17)

		name:Point('LEFT', slot, 'RIGHT', -4, 5)

		money:ClearAllPoints()
		money:Point('BOTTOMLEFT', button, 'BOTTOMRIGHT', 3, 0)

		for j = 1, 2 do
			local currencyItem = _G['MerchantItem'..i..'AltCurrencyFrameItem'..j]
			local currencyIcon = _G['MerchantItem'..i..'AltCurrencyFrameItem'..j..'Texture']

			currencyIcon.backdrop = CreateFrame('Frame', nil, currencyItem)
			currencyIcon.backdrop:SetTemplate('Default')
			currencyIcon.backdrop:SetFrameLevel(currencyItem:GetFrameLevel())
			currencyIcon.backdrop:SetOutside(currencyIcon)

			currencyIcon:SetTexCoord(unpack(E.TexCoords))
			currencyIcon:SetParent(currencyIcon.backdrop)
		end
	end

	S:HandleNextPrevButton(_G.MerchantNextPageButton, nil, nil, true)
	S:HandleNextPrevButton(_G.MerchantPrevPageButton, nil, nil, true)

	S:HandleButton(_G.MerchantRepairItemButton)
	_G.MerchantRepairItemButton:StyleButton(false)
	_G.MerchantRepairItemButton:GetRegions():SetTexCoord(0.04, 0.24, 0.07, 0.5)
	_G.MerchantRepairItemButton:GetRegions():SetInside()

	S:HandleButton(_G.MerchantGuildBankRepairButton)
	_G.MerchantGuildBankRepairButton:StyleButton()
	_G.MerchantGuildBankRepairButtonIcon:SetTexCoord(0.61, 0.82, 0.1, 0.52)
	_G.MerchantGuildBankRepairButtonIcon:SetInside()

	S:HandleButton(_G.MerchantRepairAllButton)
	_G.MerchantRepairAllIcon:StyleButton(false)
	_G.MerchantRepairAllIcon:SetTexCoord(0.34, 0.1, 0.34, 0.535, 0.535, 0.1, 0.535, 0.535)
	_G.MerchantRepairAllIcon:SetInside()

	_G.MerchantItem1:Point('TOPLEFT', 7, -47)

	_G.MerchantMoneyBg:StripTextures()
	_G.MerchantMoneyInset:StripTextures()

	_G.MerchantBuyBackItem:StripTextures(true)
	_G.MerchantBuyBackItem:CreateBackdrop('Transparent')
	_G.MerchantBuyBackItem.backdrop:Point('TOPLEFT', -3, 3)
	_G.MerchantBuyBackItem.backdrop:Point('BOTTOMRIGHT', 0, -7)
	_G.MerchantBuyBackItem:Point('TOPLEFT', _G.MerchantItem10, 'BOTTOMLEFT', 0, -48)

	_G.MerchantBuyBackItemItemButton:StripTextures()
	_G.MerchantBuyBackItemItemButton:SetTemplate('Default', true)
	_G.MerchantBuyBackItemItemButton:StyleButton()
	_G.MerchantBuyBackItemItemButton:Size(40)

	_G.MerchantBuyBackItemItemButtonIconTexture:SetTexCoord(unpack(E.TexCoords))
	_G.MerchantBuyBackItemItemButtonIconTexture:SetInside()

	-- skin tabs
	for i = 1, 2 do
		S:HandleTab(_G['MerchantFrameTab'..i])
	end

	hooksecurefunc('MerchantFrame_UpdateMerchantInfo', function()
		local numMerchantItems = GetMerchantNumItems()
		local index, button, name
		for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
			index = (((MerchantFrame.page - 1) * _G.MERCHANT_ITEMS_PER_PAGE) + i)
			button = _G['MerchantItem'..i..'ItemButton']
			name = _G['MerchantItem'..i..'Name']

			if index <= numMerchantItems then
				if button.link then
					local _, _, quality = GetItemInfo(button.link)

					if quality and quality > 1 then
						button:SetBackdropBorderColor(GetItemQualityColor(quality))
						name:SetTextColor(GetItemQualityColor(quality))
					else
						button:SetBackdropBorderColor(unpack(E.media.bordercolor))
						name:SetTextColor(1, 1, 1)
					end
				else
					button:SetBackdropBorderColor(unpack(E.media.bordercolor))
					name:SetTextColor(1, 1, 1)
				end
			end

			local buybackName = GetBuybackItemInfo(GetNumBuybackItems())
			if buybackName then
				local _, _, quality = GetItemInfo(buybackName)
				local r, g, b = GetItemQualityColor(quality)

				if quality and quality > 1 then
					MerchantBuyBackItemItemButton:SetBackdropBorderColor(r, g, b)
					MerchantBuyBackItemName:SetTextColor(r, g, b)
				else
					MerchantBuyBackItemItemButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
					MerchantBuyBackItemName:SetTextColor(1, 1, 1)
				end
			else
				MerchantBuyBackItemItemButton:SetBackdropBorderColor(unpack(E.media.bordercolor))
			end
		end
	end)

	hooksecurefunc('MerchantFrame_UpdateBuybackInfo', function()
		local numBuybackItems = GetNumBuybackItems()
		local button, name
		for i = 1, _G.BUYBACK_ITEMS_PER_PAGE do
			button = _G['MerchantItem'..i..'ItemButton']
			name = _G['MerchantItem'..i..'Name']

			if i <= numBuybackItems then
				local buybackName = GetBuybackItemInfo(i)
				if buybackName then
					local _, _, quality = GetItemInfo(buybackName)

					if quality and quality > 1 then
						button:SetBackdropBorderColor(GetItemQualityColor(quality))
						name:SetTextColor(GetItemQualityColor(quality))
					else
						button:SetBackdropBorderColor(unpack(E.media.bordercolor))
						name:SetTextColor(1, 1, 1)
					end
				end
			end
		end
	end)
end

S:AddCallback('Merchant', LoadSkin)
