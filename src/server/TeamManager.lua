--[[

	Script: TeamManager
    Username: anj0Ia
    Last Modified: Monday, October 9th, 2023
    
    Description: This module handles the management of the teams, such as 
    assigning a player to the Gamemaster team, and the others to the Challengers team
    (if starting a game).
    
]]
local TeamManager = {}

-- ROBLOX Services
local Teams = game.Teams
local Players = game.Players

-- Local Variables
local TeamPlayers = {}
local GamemasterAssigned = false

-- Initialization
for _, team in ipairs(Teams:GetTeams()) do
	TeamPlayers[team] = {}
end

-- Local Functions

-- Public Functions
function TeamManager:AssignPlayersToTeams()
	for _, player in ipairs(Players:GetPlayers()) do
		local randomTeamIndex = math.random(1, 2)
		if randomTeamIndex == 1 then
			if not GamemasterAssigned then
				player.Team = Teams:WaitForChild('Gamemaster')
				table.insert(TeamPlayers[player.Team], player)
			else
				player.Team = Teams:WaitForChild('Challengers')
				table.insert(TeamPlayers[player.Team], player)
			end
		else
			player.Team = Teams:WaitForChild('Challengers')
			table.insert(TeamPlayers[player.Team], player)
		end
	end
end

function TeamManager:ChangePlayerToSpectatorTeam(player)
	local currentTeam = player.Team
	if currentTeam.Name ~= 'Spectators' then
		for i, teamPlayer in ipairs(TeamPlayers[currentTeam]) do
			if teamPlayer == player then
				table.remove(TeamPlayers[currentTeam], i)
				break
			end
		end
		player.Team = Teams:WaitForChild('Spectators')
		table.insert(TeamPlayers[player.Team], player)
	end
end

function TeamManager:ChangePlayersToSpectatorTeam()
	for i, player in ipairs(Players:GetPlayers()) do
		local currentTeam = player.Team
		if currentTeam.Name ~= 'Spectators' then
			table.remove(TeamPlayers[currentTeam], i)
			player.Team = Teams:WaitForChild('Spectators')
			table.insert(TeamPlayers[player.Team], player)
			
		end
	end
end

return TeamManager
