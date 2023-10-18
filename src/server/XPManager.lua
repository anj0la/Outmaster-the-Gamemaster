--[[

	Script: XPManager
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This module handles the experience points that a player receives by playing a round, 
    and the experience points that a player has earned throughout their time spent playing the game.

    TODO - Add saving method so that a player's experience points persist throughout multiple servers.
    That is, their data is saved periodically (and when they leave the game), and loaded when they join the game.
]]

local XPManager = {}

-- Game Services
local Configurations = require(game.ServerStorage.Configurations)
local EventCreator = require(script.Parent.EventCreator)

-- Event Variables (to be created during the initialization process)
local IncreaseLevel
local ResetXP
local UpdateXP
local UpdateTotalXP

-- Local Functions
local function OnUpdateXP(player)
	player.RoundXP.Value += Configurations.XP_INCREMENT
end

local function OnResetXP(player)
	player.XP.Value += player.RoundXP.Value
	player.RoundXP.Value = 0
end

local function OnIncreaseLevel(player)
	local currentLevel = player.leaderstats.Level.Value
	local currentXP = player.XP.Value
	local requiredXP = math.floor(((currentLevel * (currentLevel - 1)) / Configurations.LEVEL_DIVIDER) * Configurations.LEVEL_MULTIPLER) + Configurations.BASE_XP
	
	if currentXP >= requiredXP then
		player.leaderstats.Level.Value += 1
		player.XP.Value = currentXP - requiredXP
	end
end

-- Public Functions
function XPManager:Initialize()
    IncreaseLevel = EventCreator:CreateEvent('IncreaseLevel')
    ResetXP = EventCreator:CreateEvent('ResetXP')
    UpdateXP = EventCreator:CreateEvent('UpdateXP')
    UpdateTotalXP = EventCreator:CreateEvent('UpdateTotalXP')
    
    -- Event Bindings
    UpdateXP.OnServerEvent:Connect(OnUpdateXP)
    ResetXP.OnServerEvent:Connect(OnResetXP)
    IncreaseLevel.OnServerEvent:Connect(OnIncreaseLevel)  
end

function XPManager:UpdateTotalXP(isRoundActive)
	UpdateTotalXP:FireAllClients(isRoundActive)
end

return XPManager
