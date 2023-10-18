local StarterGui = game:GetService("StarterGui")
--[[

	Script: DisplayRoundInformationScript
    Username: anj0Ia
    Last Modified: Monday, October 9th, 2023
    
    Description: This local script displays all timer-related information for the round,
    including the intermission, time until the round starts, and the round duration.
    
    
]]

-- Local Variables
local TimeObject = game.Workspace:WaitForChild('MapCache'):WaitForChild('Time')
local Events = game.ReplicatedStorage.Shared.Events
local DisplayIntermission = Events.DisplayIntermission
local DisplayTimerInfo = Events.DisplayTimerInfo
local Player = game.Players.LocalPlayer
local ScreenGui = game.ReplicatedStorage.Shared.ScreenGui
local Timer = ScreenGui.TimerFrame.Timer
local InIntermission = false

-- Initialization
game.StarterGui.ResetPlayerGuiOnSpawn = false
ScreenGui.Parent = Player:WaitForChild('PlayerGui')

-- Local Functions
local function OnDisplayIntermission(shouldDisplayIntermission)
	if shouldDisplayIntermission and not InIntermission then
		print("OnDisplayIntermission is showing")
		ScreenGui.TimerFrame.Visible = true
		InIntermission = true
	end
	if not shouldDisplayIntermission and InIntermission then
		print("OnDisplayIntermission is NOT showing")
		InIntermission = false
		Timer.TimeLeft.Visible = true
	end
end

local function OnTimeChanged(newValue)
	local currentTime = math.max(0, newValue)
	local minutes = math.floor(currentTime / 60)-- % 60
	local seconds = math.floor(currentTime) % 60
	Timer.Text = string.format("%02d:%02d", minutes, seconds)
end

local function OnDisplayTimerInfo(intermission, waitingForPlayers, timeLeft)
	Timer.Intermission.Visible = intermission
	Timer.WaitingForPlayers.Visible = waitingForPlayers
	Timer.TimeLeft.Visible = timeLeft
	Timer.RoundStart.Visible = not intermission and not waitingForPlayers and not timeLeft
end

-- Event Bindings
DisplayIntermission.OnClientEvent:connect(OnDisplayIntermission)
TimeObject.Changed:Connect(OnTimeChanged)
DisplayTimerInfo.OnClientEvent:connect(OnDisplayTimerInfo)