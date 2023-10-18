--[[

	Script: XPScript
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This local script handles displaying the total XP earned during a round,
	as well as firing events to update and reset a player's round XP. The actual
	calculation is handled in the server to make the code more safe and reliable.
]]

-- Local Variables
local Events = game.ReplicatedStorage.Shared.Events
local DisplayTotalXP = Events.DisplayTotalXP
local IncreaseLevel = Events.IncreaseLevel
local ResetXP = Events.ResetXP
local UpdateXP = Events.UpdateXP
local UpdateTotalXP = Events.UpdateTotalXP
local Player = game.Players.LocalPlayer
local ScreenGui = game.Players.LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('ScreenGui')

--[[ -- Initialization
game.StarterGui.ResetPlayerGuiOnSpawn = false
ScreenGui.Parent = Player:WaitForChild('PlayerGui')
 ]]
-- Local Functions
local function OnRoundActive(isInRound)
	if isInRound then
		ScreenGui.TotalXPFrame.Visible = true
	end
	if not isInRound then
		ScreenGui.TotalXPFrame.Visible = false

	end
end

local function OnUpdateTotalXP(isInRound)
	if isInRound then
		UpdateXP:FireServer(Player)
	end
	if not isInRound then
		ResetXP:FireServer(Player)
		IncreaseLevel:FireServer(Player)
	end
end

local function OnTotalXPChanged(newXP)
	ScreenGui.TotalXPFrame.TotalXP.Text = tostring(newXP)
end

-- Event Bindings
DisplayTotalXP.OnClientEvent:Connect(OnRoundActive)
UpdateTotalXP.OnClientEvent:Connect(OnUpdateTotalXP)
Player.RoundXP.Changed:Connect(OnTotalXPChanged)