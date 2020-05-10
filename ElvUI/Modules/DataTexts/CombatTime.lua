local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

local floor, format, strjoin = floor, format, strjoin
--WoW API / Variables
local GetTime = GetTime

local displayString, lastPanel = ''
local timerText, timer, startTime = L["Combat"], 0, 0

local function UpdateText()
	return format("%02d:%02d:%02d", floor(timer/60), timer % 60, (timer - floor(timer)) * 100)
end

local function OnUpdate(self)
	timer = GetTime() - startTime
	self.text:SetFormattedText(displayString, timerText, UpdateText())
end

local function DelayOnUpdate(self, elapsed)
	startTime = startTime - elapsed
	if startTime <= 0 then
		timer, startTime = 0, GetTime()
		self:SetScript("OnUpdate", OnUpdate)
	end
end

local function OnEvent(self, event, _, timeSeconds)
	local _, instanceType = GetInstanceInfo()
	local isInArena = instanceType == "arena"
	if event == "PLAYER_REGEN_ENABLED" then
		self:SetScript("OnUpdate", nil)
	elseif event == "PLAYER_REGEN_DISABLED" then
		timerText, timer, startTime = L["Combat"], 0, GetTime()
		self:SetScript("OnUpdate", OnUpdate)
	elseif event == "PLAYER_ENTERING_WORLD" then
		self.text:SetFormattedText(displayString, timerText, UpdateText())
	end

	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayString = strjoin("", "%s: ", hex, "%s|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('Combat Time', nil, {"PLAYER_REGEN_DISABLED", "PLAYER_REGEN_ENABLED"}, OnEvent, nil, nil, nil, nil, L["Combat Time"])
