--[[

	Script: GameManager
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This module contains all the of code related to the running of the game.
    The public functions are called in the parent script to run the game.
]]

local GameManager = {}

-- ROBLOX Services
local Players = game.Players

-- Game Services
local Configurations = require(game.ServerStorage.Configurations)
local GameState = require(script.Parent.GameState)
local DisplayManager = require(script.Parent.DisplayManager)
local MapManager = require(script.Parent.MapManager)
local PlayerManager = require(script.Parent.PlayerManager)
local TeamManager = require(script.Parent.TeamManager)
local TimeManager = require(script.Parent.TimeManager)
local XPManager = require(script.Parent.XPManager)

-- Local Variables
local EnoughPlayers = false

-- Public Functions
function GameManager:Initialize()
	DisplayManager:Initialize()
    MapManager:Initalize()
    XPManager:Initialize()
end

function GameManager:RunIntermission()
	GameState:SetIntermissionRunning(true)
	DisplayManager:StartIntermission()
	DisplayManager:DisplayMapVoting(true)
	EnoughPlayers = Players.NumPlayers >= Configurations.MIN_PLAYERS	
	DisplayManager:UpdateTimerInfo(true, not EnoughPlayers, false)
	TimeManager:StartTimer(Configurations.INTERMISSION_DURATION)

	task.spawn(function()
		repeat
			if EnoughPlayers and Players.NumPlayers < Configurations.MIN_PLAYERS then
				EnoughPlayers = false
			elseif not EnoughPlayers and Players.NumPlayers >= Configurations.MIN_PLAYERS then
				EnoughPlayers = true
			end
			DisplayManager:UpdateTimerInfo(true, not EnoughPlayers, false)
			task.wait(.5)
		until GameState:IsIntermissionRunning() == false
	end)
	
	task.wait(Configurations.INTERMISSION_DURATION)
	GameState:SetIntermissionRunning(false)
end

function GameManager:GameReady()
	return #Players:GetPlayers() >= Configurations.MIN_PLAYERS
end

function GameManager:StopIntermission()
	DisplayManager:UpdateTimerInfo(false, false, false)
	DisplayManager:DisplayMapVoting(false)
	DisplayManager:StopIntermission()
end

function GameManager:StartRound()
	GameState:SetRoundActive(true)
	task.wait()
	TeamManager:AssignPlayersToTeams()
	PlayerManager:LoadPlayers()
	TimeManager:StartTimer(Configurations.START_GAME_WAIT)
	task.wait(Configurations.START_GAME_WAIT)
	DisplayManager:UpdateTimerInfo(false, false, true)
	TimeManager:StartTimer(Configurations.ROUND_DURATION)
end

function GameManager:UpdateSurvivalXP()
	local xpTimer = 0
	local xpInterval = 1 -- 3 seconds interval
	DisplayManager:DisplayTotalXP(true)
	
	repeat
		xpTimer += 1/60  -- assuming the game loop runs at 60 frames per second
		-- checking if the interval time has passed
		if xpTimer >= xpInterval then
			xpTimer = 0  -- R=reset the timer
			XPManager:UpdateTotalXP(true)
		end
		-- wait for the next frame
		task.wait()
	until GameManager:RoundOver()
end

function GameManager:Update()
	GameManager:UpdateSurvivalXP()
    -- TODO - add more game logic code
end

function GameManager:RoundOver()
	if TimeManager:TimerDone() then
		-- display who won
		return true
	end
	return false
end

function GameManager:RoundCleanup()
	PlayerManager:ResetInGame()
	GameState:SetRoundActive(false)
	task.wait(Configurations.END_GAME_WAIT)
	TeamManager:ChangePlayersToSpectatorTeam()
	PlayerManager:LoadPlayers()
	MapManager:RemoveMap()
	DisplayManager:DisplayTotalXP(false)
	XPManager:UpdateTotalXP(false)
	MapManager:ClearPlayerVotes()
end

return GameManager