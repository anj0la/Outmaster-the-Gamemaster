--[[

	Script: MapManager
    Username: anj0Ia
    Last Modified: Monday, October 9th, 2023
    
    Description: This module handles the map voting, loading the chosen map into the game, and removing the
    map after the game has ended.
    
]]
local MapManager = {}

-- ROBLOX Services
local ServerStorage = game:GetService('ServerStorage')

-- Game Services
local Configurations = require(ServerStorage.Configurations)
local EventCreator = require(script.Parent.EventCreator)

-- Event Variables (to be created during the initialization process)
local GetChosenMap
local UpdateMapVoting
local UpdateNumLabel

-- Constants
local MAP_OFFSET = 200

-- Local Variables
local Maps = ServerStorage.Maps
local PlayerVotes = {
	MapFrame1 = {},
	MapFrame2 = {},
	MapFrame3 = {},
}

-- Initialization
local MapCache = game.Workspace:FindFirstChild('MapCache')
if not MapCache then
	MapCache = Instance.new('Folder', game.Workspace)
	MapCache.Name = 'MapCache'
end

-- Local Functions
local function _LoadModelsIntoMap(model)
	for _, child in ipairs(model:GetChildren()) do
		local copy = child:Clone()
		if copy then
			local oldPosition = copy.Position
			copy.Parent = game.Workspace
			copy.Position = Vector3.new(oldPosition.X + MAP_OFFSET, oldPosition.Y, oldPosition.Z + MAP_OFFSET)
		end
	end
end

local function _CanPlayerVote(player)
	for mapName, voters in pairs(PlayerVotes) do
		for _, votedPlayer in ipairs(voters) do
			if votedPlayer == player then
				return false -- the player has already voted for a map
			end
		end
	end
	return true -- the player has not voted for any map
end


local function OnUpdateMapVoting(player, mapFrame, MapFramesFolder, selectedMap)
	
	-- TODO - Add toggling effect so that if a player wants to revoke their vote, they can
	if not _CanPlayerVote(player) then
		return -- Player has already voted for a map, so don't allow them to vote again
	end
	
	local mapName = mapFrame.Name

	-- Check if the player has already voted for this map frame
	if not PlayerVotes[mapName] then
		PlayerVotes[mapName] = {}
	end

	-- Check if the player has already voted
	local hasVoted = false
	local playerIndex = nil

	for i, votedPlayer in ipairs(PlayerVotes[mapName]) do
		if votedPlayer == player then
			hasVoted = true
			playerIndex = i
			break
		end
	end

	if hasVoted then
		table.remove(PlayerVotes[mapName], playerIndex) -- remove the player from the list of voters for this map frame
	else
		table.insert(PlayerVotes[mapName], player) -- add the player to the list of voters for this map frame
	end
	
	-- Broadcast the updated votes to all clients
	local votes = {}
	for frameName, voters in pairs(PlayerVotes) do
		votes[frameName] = #voters
	end

	UpdateNumLabel:FireAllClients(votes)
end

local function OnGetChosenMap(player, mapName)
    Configurations:SetChosenMapName(mapName)
	MapManager:LoadMap()
end

-- Public Functions
function MapManager:Initalize()
	GetChosenMap = EventCreator:CreateEvent('GetChosenMap')
    UpdateMapVoting = EventCreator:CreateEvent('UpdateMapVoting')
    UpdateNumLabel = EventCreator:CreateEvent('UpdateNumLabel')

    -- Event Bindings
    UpdateMapVoting.OnServerEvent:Connect(OnUpdateMapVoting)
    GetChosenMap.OnServerEvent:Connect(OnGetChosenMap)
end

function MapManager:LoadMap()
	local ChosenMap = Configurations:GetChosenMapName()
	for _, child in ipairs(ChosenMap:GetChildren()) do
		local copy = child:Clone()
		if copy then
			if copy:IsA('Model') then
				_LoadModelsIntoMap(copy)
			else
				local oldPosition = copy.Position
				copy.Parent = game.Workspace
				copy.Position = Vector3.new(oldPosition.X + MAP_OFFSET, oldPosition.Y, oldPosition.Z + MAP_OFFSET)
			end
		end	
	end
end


function MapManager:RemoveMap()
	for _, child in ipairs(game.Workspace:GetChildren()) do
		if not child:IsA('Camera') and not child:IsA('Terrain') and not child:IsA('Folder') and not child:IsA('Model') then
			child:Destroy()
		end	
	end
end


function MapManager:ClearPlayerVotes()
	for frameName, _ in pairs(PlayerVotes) do
		PlayerVotes[frameName] = {} -- clears the list of voters for each map frame
	end
end


return MapManager
