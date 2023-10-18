--[[

	Script: SpectateScript
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This local script contains the following local functions that handling the 
    spectating process in the game. Players can spectate each other by toggling the spectate button, and
    can get out of the spectating players by clicking on the spectate button again. 
]]

-- ROBLOX Services
local Players = game:GetService('Players')

-- Local Variables
local Camera = game.Workspace.CurrentCamera
local ScreenGui = game.Players.LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('ScreenGui')
local SpectateButton = ScreenGui.NavFrame.SpectateButton
local NextButton = ScreenGui.SpectateFrame.NextButton
local PrevButton = ScreenGui.SpectateFrame.PrevButton
local PlayerLabel = ScreenGui.SpectateFrame.SpectatedPlayerLabel
local PlayerIndex = 1

-- Local Functions
local function ToggleSpectate()
	local toggled = SpectateButton.Toggled.Value
	if not toggled then
		SpectateButton.Toggled.Value = true
		ScreenGui.SpectateFrame.Visible = false
		PlayerIndex = 1
		Camera.CameraSubject = Players.LocalPlayer.Character.Humanoid
		PlayerLabel.Text = Players.LocalPlayer.Name
	else
		SpectateButton.Toggled.Value = false
		ScreenGui.SpectateFrame.Visible = true
		PlayerIndex = 1
		Camera.CameraSubject = Players.LocalPlayer.Character.Humanoid
		PlayerLabel.Text = Players.LocalPlayer.Name
	end
end

-- Local Functions
local function SpectateNextPlayer()
	local numPlayers = #Players:GetPlayers()
	PlayerIndex = PlayerIndex % numPlayers + 1
	
	local currPlayer = Players:GetPlayers()[PlayerIndex]
	Camera.CameraSubject = currPlayer.Character.Humanoid
	PlayerLabel.Text = currPlayer.Name
end

local function SpectatePrevPlayer()
	local numPlayers = #Players:GetPlayers()
	PlayerIndex = (PlayerIndex - 2) % numPlayers + 1

	local currPlayer = Players:GetPlayers()[PlayerIndex]
	Camera.CameraSubject = currPlayer.Character.Humanoid
	PlayerLabel.Text = currPlayer.Name
end

-- Event Bindings
SpectateButton.Activated:Connect(ToggleSpectate)
NextButton.Activated:Connect(SpectateNextPlayer)
PrevButton.Activated:Connect(SpectatePrevPlayer)