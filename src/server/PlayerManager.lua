--[[

	Script: PlayerManager
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This module handles the player, including setting its leaderstats, spawning the player,
    and destroying players after a round is over.
]]

local PlayerManager = {}

-- ROBLOX Services
local Players = game.Players

-- Game Services
local DisplayManager = require(script.Parent.DisplayManager)
local GameState = require(script.Parent.GameState)
local TeamManager = require(script.Parent.TeamManager)
local XPManager = require(script.Parent.XPManager)

-- Local Variables
local InGame = false

-- Local Functions
local function LoadLeaderstats(player)
	-- Setup leaderboard stats
	local leaderstats = Instance.new('Model', player)
	leaderstats.Name = 'leaderstats'

	local Level = Instance.new('IntValue', leaderstats)
	Level.Name = 'Level'
	Level.Value = 0 -- this would be a saved value

	local XP = Instance.new('IntValue', player)
	XP.Name = 'XP'
	XP.Value = 0 -- this would be a saved value
	
	local RoundXP = Instance.new('IntValue', player)
	RoundXP.Name = 'RoundXP'
	RoundXP.Value = 0
end

local function SpawnPlayer(character)
	if not GameState:IsIntermissionRunning() and GameState:IsRoundActive() then
		if not InGame then -- a game has started and the player is not in it currently, so spawn the player into the chosen map
			InGame = true -- if the player is caught by the Gamemaster, they will not spawn in the map again 
			local mapSpawn = game.Workspace.SpawnLocation
			task.wait()
			character.HumanoidRootPart.CFrame = mapSpawn.CFrame
			print(Players:GetPlayerFromCharacter(character))
		else
			local player = Players:GetPlayerFromCharacter(character) -- a game is in progress and the player was caught, so send them back to the lobby
			local lobbySpawn = game.Workspace.Lobby.SpawnLocation
			task.wait()
			TeamManager:ChangePlayerToSpectatorTeam(player)
			character.HumanoidRootPart.CFrame = lobbySpawn.CFrame
			DisplayManager:DisplayTotalXP(false)
			XPManager:UpdateTotalXP(false)
		end		
	else
		local lobbySpawn = game.Workspace.Lobby.SpawnLocation
		task.wait()
		character.HumanoidRootPart.CFrame = lobbySpawn.CFrame
		DisplayManager:DisplayTotalXP(false)
		XPManager:UpdateTotalXP(false)
	end
end

local function OnPlayerAdded(player)
	-- Load leaderstats
	LoadLeaderstats(player)
	-- Add listener to correctly spawn the player into the current round or lobby
	player.CharacterAdded:Connect(SpawnPlayer)
end

-- Public Functions
function PlayerManager:LoadPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		player:LoadCharacter()
	end
end

function PlayerManager:DestroyPlayers()
	for _, player in ipairs(Players:GetPlayers()) do
		player.Character:Destroy()
		for _, item in ipairs(player.Backpack:GetChildren()) do
			item:Destroy()
		end
	end
end

function PlayerManager:ResetInGame()
	InGame = false
end

-- Event Binding
Players.PlayerAdded:Connect(OnPlayerAdded)

return PlayerManager