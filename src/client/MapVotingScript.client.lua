--[[

	Script: MapVotingScript
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This local script displays all the information related to 
    map voting.
    
    
]]

-- Local Variables
local Events = game.ReplicatedStorage.Shared.Events
local DisplayMapVoting = Events.DisplayMapVoting
local GetChosenMap = Events.GetChosenMap
local UpdateMapVoting = Events.UpdateMapVoting
local UpdateNumLabel = Events.UpdateNumLabel
local Player = game.Players.LocalPlayer
local ScreenGui = game.Players.LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('ScreenGui')
local MapFramesFolder = ScreenGui.MapVotingFrame.MapFrames
local firstMapButton = MapFramesFolder:FindFirstChild('MapFrame1'):FindFirstChild('TextButton')
local secondMapButton = MapFramesFolder:FindFirstChild('MapFrame2'):FindFirstChild('TextButton')
local thirdMapButton = MapFramesFolder:FindFirstChild('MapFrame3'):FindFirstChild('TextButton')
local chosenMap = nil

--[[ -- Initialization
game.StarterGui.ResetPlayerGuiOnSpawn = false
ScreenGui.Parent = Player:WaitForChild('PlayerGui') ]]

-- Local Functions
local function OnFirstMapButtonSelected()
	firstMapButton.Selected = true
	UpdateMapVoting:FireServer(MapFramesFolder:FindFirstChild('MapFrame1'), MapFramesFolder, 1)
end

local function OnSecondMapButtonSelected()
	secondMapButton.Selected = true
	UpdateMapVoting:FireServer(MapFramesFolder:FindFirstChild('MapFrame2'), MapFramesFolder, 2)
end

local function OnThirdMapButtonSelected()
	thirdMapButton.Selected = true
	UpdateMapVoting:FireServer(MapFramesFolder:FindFirstChild('MapFrame3'), MapFramesFolder, 3)
end

local function _ResetNumVotes()
    for _, mapFrame in ipairs(MapFramesFolder:GetChildren()) do
        mapFrame:FindFirstChild('NumVotesLabel').Text = "0"  -- Reset the NumVotesLabel text to "0"
    end
    GetChosenMap:FireServer(chosenMap)
end

local function OnDisplayMapVoting(intermissionRunning)
	if intermissionRunning then
		print("OnDisplayMapVoting is showing")
		ScreenGui.MapVotingFrame.Visible = true
		-- Activate the buttons so players can vote
		firstMapButton.Active = true
		secondMapButton.Active = true
		thirdMapButton.Active = true
	else
		print("OnDisplayMapVoting is NOT showing")
		ScreenGui.MapVotingFrame.Visible = false
		-- The buttons are now not activated anymore (as voting has ended)
		firstMapButton.Active = false
		secondMapButton.Active = false
		thirdMapButton.Active = false
		
		_ResetNumVotes()
	end
end

local function OnUpdateNumLabel(votes)
	local mapVotes = 0
	for _, mapFrame in ipairs(MapFramesFolder:GetChildren()) do
		if votes[mapFrame.Name] > mapVotes then
			mapVotes = votes[mapFrame.Name]
			chosenMap = mapFrame:FindFirstChild('MapNameLabel').Text
		end
		mapFrame:FindFirstChild('NumVotesLabel').Text = votes[mapFrame.Name]
	end
end

-- Event Bindings
DisplayMapVoting.OnClientEvent:Connect(OnDisplayMapVoting)
UpdateNumLabel.OnClientEvent:Connect(OnUpdateNumLabel)
firstMapButton.Activated:Connect(OnFirstMapButtonSelected)
secondMapButton.Activated:Connect(OnSecondMapButtonSelected)
thirdMapButton.Activated:Connect(OnThirdMapButtonSelected)