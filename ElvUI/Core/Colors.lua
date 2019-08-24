
RAID_CLASS_COLORS["DRUID"] = CreateColor(1, .49, .03)
RAID_CLASS_COLORS["HUNTER"] = CreateColor(.67, .84, .45)
RAID_CLASS_COLORS["MAGE"] = CreateColor(.41, .8, 1)
RAID_CLASS_COLORS["PALADIN"] = CreateColor(.96, .55, .73)
RAID_CLASS_COLORS["PRIEST"] = CreateColor(.83, .83, .83)
RAID_CLASS_COLORS["ROGUE"] = CreateColor(1, .95, .32)
RAID_CLASS_COLORS["SHAMAN"] = CreateColor(.16, .31, .61)
RAID_CLASS_COLORS["WARLOCK"] = CreateColor(.58, .51, .79)
RAID_CLASS_COLORS["WARRIOR"] = CreateColor(.78, .61, .43)

for _, v in pairs(RAID_CLASS_COLORS) do
	if GenerateHexColor() then
		v.colorStr = v:GenerateHexColor();
	end
end
