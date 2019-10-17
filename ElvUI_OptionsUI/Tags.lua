local E, _, V, P, G = unpack(ElvUI); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local C, L = unpack(select(2, ...))

E.Options.args.tagGroup = {
	order = 925,
	type = "group",
	name = L["Available Tags"],
	args = {
		header = {
			order = 1,
			type = "header",
			name = L["Available Tags"],
		},
		general = {
			order = 2,
			type = "group",
			name = "General",
			guiInline = true,
			childGroups = 'tab',
			args = {},
		},
	}
}

E.TagInfo = {
	--Colors
	['namecolor'] = { category = 'Colors', description = "Colors Names by Player Class / NPC Reaction" },
	['reactioncolor'] = { category = 'Colors', description = "Colors Names NPC Reaction (Bad/Neutral/Good)" },
	['powercolor'] = { category = 'Colors', description = "Colors Unit Power based upon its type" },
	['happiness:color'] = { category = 'Colors', description = "Colors the following tags based upon pet happiness (e.g. 'Happy = green')" },
	['difficultycolor'] = { category = 'Colors', description = "Colors the difficulty, red for impossible, orange for hard, green for easy" },
	--Classification
	['classification'] = { category = 'Classification', description = "Show the Unit Classification (e.g. 'ELITE' and 'RARE')" },
	['shortclassification'] = { category = 'Classification', description = "Show the Unit Classification in short form (e.g. '+' for ELITE and 'R' for RARE)" },
	['classification:icon'] = { category = 'Classification', description = "Show the Unit Classification in icon form (Gold for 'ELITE' Silver for 'RARE')" },
	--Health
	['curhp'] = { category = 'Health', description = "Display current HP without decimals" },
	--Hunter
	['happiness:icon'] = { category = 'Hunter', description = "Displays the Pet Happiness like the default Blizzard icon" },
	['happiness:discord'] = { category = 'Hunter', description = "Displays the Pet Happiness like a Discord Emoji" },
	['happiness:full'] = { category = 'Hunter', description = "Displays the Pet Happiness as a word (e.g. 'Happy')" },
	['loyalty'] = { category = 'Hunter', description = "Display the Pet Loyalty Level" },
	--Level
	['smartlevel'] = { category = 'Level', description = "Displays the level and adds a '+' for ELITE / a 'BOSS' for Worldboss" },
	['level'] = { category = 'Level', description = "Display the level" },
	--Mana
	['mana:current'] = { category = 'Mana', description = "Shows the current amount of Mana a unit has" },
	['mana:current:shortvalue'] = { category = 'Mana', description = "Shortvalue of the current amount of Mana a unit has (e.g. 4k instead of 4000)" },
	['mana:current-percent'] = { category = 'Mana', description = "Shows the current Mana and power as a percent, separated by a dash" },
	['mana:current-percent:shortvalue'] = { category = 'Mana', description = "Shortvalue of the current Mana and Mana as a percent, separated by a dash" },
	['mana:current-max'] = { category = 'Mana', description = "Shows the current Mana and max Mana, separated by a dash" },
	['mana:current-max:shortvalue'] = { category = 'Mana', description = "Shortvalue of the current Mana and max Mana, separated by a dash" },
	['mana:current-max-percent'] = { category = 'Mana', description = "Shows the current Mana and max Mana, separated by a dash (% when not full power)" },
	['mana:current-max-percent:shortvalue'] = { category = 'Mana', description = "Shortvalue of the current Mana and max Mana, separated by a dash (% when not full power)" },
	['mana:percent'] = { category = 'Mana', description = "Displays the Unit Mana as a percentage value" },
	['mana:max'] = { category = 'Mana', description = "Shows the unit's maximum Mana" },
	['mana:max:shortvalue'] = { category = 'Mana', description = "Shortvalue of the unit's maximum Mana" },
	['mana:deficit'] = { category = 'Mana', description = "Shows the power as a deficit (Total Mana - Current Mana = -Deficit)" },
	['mana:deficit:shortvalue'] = { category = 'Mana', description = "Shortvalue of the mana as a deficit (Total Mana - Current Mana = -Deficit)" },
	['curmana'] = { category = 'Mana', description = "Display current Mana without decimals" },
	--Names
	['name'] = { category = 'Names', description = "Shows the full Unit Name without any letter limitation" },
	['name:veryshort'] = { category = 'Names', description = "Shows the Unit Name (limited to 5 letters)" },
	['name:short'] = { category = 'Names', description = "Shows the Unit Name (limited to 10 letters)" },
	['name:medium'] = { category = 'Names', description = "Shows the Unit Name (limited to 15 letters)" },
	['name:long'] = { category = 'Names', description = "Shows the Unit Name (limited to 20 letters)" },
	['name:veryshort:translit'] = { category = 'Names', description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 5 letters)" },
	['name:short:translit'] = { category = 'Names', description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 10 letters)" },
	['name:medium:translit'] = { category = 'Names', description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 15 letters)" },
	['name:long:translit'] = { category = 'Names', description = "Shows the Unit Name with transliteration for cyrillic letters (limited to 20 letters)" },
	['name:abbrev'] = { category = 'Names', description = "Shows the Unit Name with Abbreviation (e.g. 'Shadowfury Witch Doctor' becomes 'S. W. Doctor')" },
	['name:abbrev:veryshort'] = { category = 'Names', description = "Shows the Unit Name with Abbreviation (limited to 5 letters)" },
	['name:abbrev:short'] = { category = 'Names', description = "Shows the Unit Name with Abbreviation (limited to 10 letters)" },
	['name:abbrev:medium'] = { category = 'Names', description = "Shows the Unit Name with Abbreviation (limited to 15 letters)" },
	['name:abbrev:long'] = { category = 'Names', description = "Shows the Unit Name with Abbreviation (limited to 20 letters)" },
	['name:veryshort:status'] = { category = 'Names', description = "Replaces the Unit Name 'DEAD' or 'OFFLINE' (limited to 5 letters)" },
	['name:short:status'] = { category = 'Names', description = "Replaces the Unit Name 'DEAD' or 'OFFLINE' (limited to 10 letters)" },
	['name:medium:status'] = { category = 'Names', description = "Replaces the Unit Name 'DEAD' or 'OFFLINE' (limited to 15 letters)" },
	['name:long:status'] = { category = 'Names', description = "Replaces the Unit Name with 'DEAD' or 'OFFLINE' (limited to 20 letters)" },
	--Power
	['power:current'] = { category = 'Power', description = "Shows the current amount of power a unit has" },
	['power:current:shortvalue'] = { category = 'Power', description = "Shortvalue of the current amount of power a unit has (e.g. 4k instead of 4000)" },
	['power:current-percent'] = { category = 'Power', description = "Shows the current power and power as a percent, separated by a dash" },
	['power:current-percent:shortvalue'] = { category = 'Power', description = "Shortvalue of the current power and power as a percent, separated by a dash" },
	['power:current-max'] = { category = 'Power', description = "Shows the current power and max power, separated by a dash" },
	['power:current-max:shortvalue'] = { category = 'Power', description = "Shortvalue of the current power and max power, separated by a dash" },
	['power:current-max-percent'] = { category = 'Power', description = "Shows the current power and max power, separated by a dash (% when not full power)" },
	['power:current-max-percent:shortvalue'] = { category = 'Power', description = "Shortvalue of the current power and max power, separated by a dash (% when not full power)" },
	['power:percent'] = { category = 'Power', description = "Displays the Unit Power as a percentage value" },
	['power:max'] = { category = 'Power', description = "Shows the unit's maximum power" },
	['power:max:shortvalue'] = { category = 'Power', description = "Shortvalue of the unit's maximum power" },
	['power:deficit'] = { category = 'Power', description = "Shows the power as a deficit (Total Power - Current Power = -Deficit)" },
	['power:deficit:shortvalue'] = { category = 'Power', description = "Shortvalue of the power as a deficit (Total Power - Current Power = -Deficit)" },
	['curpp'] = { category = 'Power', description = "Display current Power without decimals" },
	--Realm
	['realm'] = { category = 'Realm', description = "Shows the Server Name" },
	['realm:translit'] = { category = 'Realm', description = "Shows the Server Name with transliteration for cyrillic letters" },
	['realm:dash'] = { category = 'Realm', description = "Shows the Server Name with a dash in front (e.g. -Realm)" },
	['realm:dash:translit'] = { category = 'Realm', description = "Shows the Server with transliteration for cyrillic letters and a dash in front" },
	--Status
	['status'] = { category = 'Status', description = 'Show Zzz(inactive), dead, ghost, offline' },
	['status:icon'] = { category = 'Status', description = "Show AFK/DND as an orange(afk) / red(dnd) icon" },
	['status:text'] = { category = 'Status', description = "Show <AFK> and <DND>" },
	['statustimer'] = { category = 'Status', description = "Show a timer for how long a unit has had that status (e.g 'DEAD - 0:34')" },
	['dead'] = { category = 'Status', description = "Show <DEAD> if the Unit is dead" },
	--Target
	['target'] = { category = 'Target', description = "Displays the current target of the Unit" },
	['target:veryshort'] = { category = 'Target', description = "Displays the current target of the Unit (limited to 5 letters)" },
	['target:short'] = { category = 'Target', description = "Displays the current target of the Unit (limited to 10 letters)" },
	['target:medium'] = { category = 'Target', description = "Displays the current target of the Unit (limited to 15 letters)" },
	['target:long'] = { category = 'Target', description = "Displays the current target of the Unit (limited to 20 letters)" },
	['target:translit'] = { category = 'Target', description = "Displays the current target of the Unit with transliteration for cyrillic letters" },
	['target:veryshort:translit'] = { category = 'Target', description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 5 letters)" },
	['target:short:translit'] = { category = 'Target', description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 10 letters)" },
	['target:medium:translit'] = { category = 'Target', description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 15 letters)" },
	['target:long:translit'] = { category = 'Target', description = "Displays the current target of the Unit with transliteration for cyrillic letters (limited to 20 letters)" },
	--Work in Progress from here
	['affix'] = { category = 'Miscellanous', description = '' },
	['class'] = { category = 'Miscellanous', description = '' } ,
	['classificationcolor'] = { category = 'Miscellanous', description = '' },
	['cpoints'] = { category = 'Miscellanous', description = '' },
	['deficit:name'] = { category = 'Miscellanous', description = '' },
	['diet'] = { category = 'Miscellanous', description = '' },
	['difficulty'] = { category = 'Miscellanous', description = '' },
	['faction'] = { category = 'Miscellanous', description = '' },
	['group'] = { category = 'Miscellanous', description = '' },
	['guild'] = { category = 'Miscellanous', description = '' },
	['guild:brackets'] = { category = 'Miscellanous', description = '' },
	['guild:brackets:translit'] = { category = 'Miscellanous', description = '' },
	['guild:rank'] = { category = 'Miscellanous', description = '' },
	['guild:translit'] = { category = 'Miscellanous', description = '' },
	['health:current'] = { category = 'Miscellanous', description = '' },
	['health:current-max'] = { category = 'Miscellanous', description = '' },
	['health:current-max-nostatus'] = { category = 'Miscellanous', description = '' },
	['health:current-max-nostatus:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:current-max-percent'] = { category = 'Miscellanous', description = '' },
	['health:current-max-percent-nostatus'] = { category = 'Miscellanous', description = '' },
	['health:current-max-percent-nostatus:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:current-max-percent:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:current-max:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:current-nostatus'] = { category = 'Miscellanous', description = '' },
	['health:current-nostatus:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:current-percent'] = { category = 'Miscellanous', description = '' },
	['health:current-percent-nostatus'] = { category = 'Miscellanous', description = '' },
	['health:current-percent-nostatus:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:current-percent:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:current:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:deficit'] = { category = 'Miscellanous', description = '' },
	['health:deficit-nostatus'] = { category = 'Miscellanous', description = '' },
	['health:deficit-nostatus:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:deficit-percent:name'] = { category = 'Miscellanous', description = '' },
	['health:deficit-percent:name-long'] = { category = 'Miscellanous', description = '' },
	['health:deficit-percent:name-medium'] = { category = 'Miscellanous', description = '' },
	['health:deficit-percent:name-short'] = { category = 'Miscellanous', description = '' },
	['health:deficit-percent:name-veryshort'] = { category = 'Miscellanous', description = '' },
	['health:deficit:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:max'] = { category = 'Miscellanous', description = '' },
	['health:max:shortvalue'] = { category = 'Miscellanous', description = '' },
	['health:percent'] = { category = 'Miscellanous', description = '' },
	['health:percent-nostatus'] = { category = 'Miscellanous', description = '' },
	['healthcolor'] = { category = 'Miscellanous', description = '' },
	['leader'] = { category = 'Miscellanous', description = '' },
	['leaderlong'] = { category = 'Miscellanous', description = '' },
	['maxhp'] = { category = 'Miscellanous', description = '' },
	['maxmana'] = { category = 'Miscellanous', description = '' },
	['maxpp'] = { category = 'Miscellanous', description = '' },
	['missinghp'] = { category = 'Miscellanous', description = '' },
	['missingpp'] = { category = 'Miscellanous', description = '' },
	['name:title'] = { category = 'Miscellanous', description = '' },
	['npctitle'] = { category = 'Miscellanous', description = '' },
	['offline'] = { category = 'Miscellanous', description = '' },
	['perhp'] = { category = 'Miscellanous', description = '' },
	['perpp'] = { category = 'Miscellanous', description = '' },
	['plus'] = { category = 'Miscellanous', description = '' },
	['pvp'] = { category = 'Miscellanous', description = '' },
	['quest:info'] = { category = 'Miscellanous', description = '' },
	['quest:title'] = { category = 'Miscellanous', description = '' },
	['rare'] = { category = 'Miscellanous', description = '' },
	['resting'] = { category = 'Miscellanous', description = '' },
}

-- We need to implement this
-- |cffXXXXXX [tags] or text here |r
-- description = "Custom color your Text: replace the XXXXXX with a Hex color code"

for Tag in next, E.oUF.Tags.Events do
	if not E.TagInfo[Tag] then
		E.TagInfo[Tag] = { category = 'Miscellanous', description = "" }
		E:Print("['"..Tag.."'] = { category = 'Miscellanous', description = '' }")
	end

	if not E.Options.args.tagGroup.args.general.args[E.TagInfo[Tag].category] then
		E.Options.args.tagGroup.args.general.args[E.TagInfo[Tag].category] = {
			order = 925,
			type = "group",
			name = E.TagInfo[Tag].category,
			args = {}
		}
	end

	E.Options.args.tagGroup.args.general.args[E.TagInfo[Tag].category].args[Tag] = {
		type = "description",
		fontSize = "medium",
		name = format('[%s] - %s', Tag, E.TagInfo[Tag].description),
	}
end
