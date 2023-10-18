--[[

	Script: DisplayManager
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This module handles all of the events related to the displaying
    of information for the game. This includes displaying the map voting GUI,
    the intermission information, the round duration, the timer info,
    the total experience points (collected in a round and the overall points).
    
]]

local DisplayManager = {}

-- Game Services
local EventCreator = require(script.Parent.EventCreator)

-- Local Variables
local StarterGui = game.StarterGui

-- Event Variables (to be created during the initialization process)
local DisplayIntermission
local DisplayInventory
local DisplayMapVoting
local DisplayTimerInfo
local DisplayTotalXP

-- Initialization
StarterGui.ResetPlayerGuiOnSpawn = false
local MapCache = game.Workspace:FindFirstChild('MapCache')
if not MapCache then
	MapCache = Instance.new('Folder', game.Workspace)
	MapCache.Name = 'MapCache'
end

function DisplayManager:Initialize()
    DisplayIntermission = EventCreator:CreateEvent('DisplayIntermission')
    DisplayInventory = EventCreator:CreateEvent('DisplayInventory')
    DisplayMapVoting = EventCreator:CreateEvent('DisplayMapVoting')
    DisplayTimerInfo = EventCreator:CreateEvent('DisplayTimerInfo')
    DisplayTotalXP = EventCreator:CreateEvent('DisplayTotalXP')
end

-- Public Functions
function DisplayManager:StartIntermission(player)
	if player then
		DisplayIntermission:FireClient(player, true)
	else
		DisplayIntermission:FireAllClients(true)
	end
end

function DisplayManager:StopIntermission(player)
	if player then
		DisplayIntermission:FireClient(player, false)
	else
		DisplayIntermission:FireAllClients(false)
	end
end

function DisplayManager:UpdateTimerInfo(isIntermission, waitingForPlayers, timeLeft)
	DisplayTimerInfo:FireAllClients(isIntermission, waitingForPlayers, timeLeft)
end

function DisplayManager:DisplayTotalXP(isRoundActive)
	DisplayTotalXP:FireAllClients(isRoundActive)
end

function DisplayManager:DisplayInventory(isInRound)
	DisplayInventory:FireAllClients(isInRound)
end

function DisplayManager:DisplayMapVoting(isIntermission)
	DisplayMapVoting:FireAllClients(isIntermission)
end

return DisplayManager
