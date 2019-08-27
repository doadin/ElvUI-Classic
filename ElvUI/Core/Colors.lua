RAID_CLASS_COLORS = {
	["DRUID"] = CreateColor(1, .49, .03),
	["HUNTER"] = CreateColor(.67, .84, .45),
	["MAGE"] = CreateColor(.41, .8, 1),
	["PALADIN"] = CreateColor(.96, .55, .73),
	["PRIEST"] = CreateColor(.83, .83, .83),
	["ROGUE"] = CreateColor(1, .95, .32),
	["SHAMAN"] = CreateColor(0, .44, .86),
	["WARLOCK"] = CreateColor(.58, .51, .79),
	["WARRIOR"] = CreateColor(.78, .61, .43)
}

for _, v in pairs(RAID_CLASS_COLORS) do
	v.colorStr = v:GenerateHexColor()
end
