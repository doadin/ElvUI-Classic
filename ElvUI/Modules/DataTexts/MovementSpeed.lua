local E, L, V, P, G = unpack(select(2, ...)); --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local DT = E:GetModule('DataTexts')

--Lua functions
local join = string.join
--WoW API / Variables
local BASE_MOVEMENT_SPEED = BASE_MOVEMENT_SPEED
local GetUnitSpeed = GetUnitSpeed
local IsFalling = IsFalling
local IsSwimming = IsSwimming

local displayNumberString = ''
local movementSpeedText = L["Mov. Speed:"]
local beforeFalling
local lastPanel

local function OnEvent(self)
	local _, runSpeed, flightSpeed, swimSpeed = GetUnitSpeed("player")

	local speed = runSpeed
	if (IsSwimming("player")) then
		speed = swimSpeed
	end

	if (IsFalling("player")) then
		speed = beforeFalling or speed
	else
		beforeFalling = speed
	end

	self.text:SetFormattedText(displayNumberString, movementSpeedText, speed/BASE_MOVEMENT_SPEED*100)
	lastPanel = self
end

local function ValueColorUpdate(hex)
	displayNumberString = join("", "%s ", hex, "%.0f%%|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end
E.valueColorUpdateFuncs[ValueColorUpdate] = true

DT:RegisterDatatext('MovementSpeed', {"UNIT_STATS", "UNIT_AURA"}, OnEvent, nil, nil, nil, nil, STAT_MOVEMENT_SPEED)
