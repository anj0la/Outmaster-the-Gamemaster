--[[

	Script: Configurations
    Username: anj0Ia
    Last Modified: Monday, October 9th, 2023
    
    Description: This module contains all of the constants to be used in the
    game. This includes constants such as the intermission and round duration,
    the miniumum amount of players, and the base XP that players receive.
    
    
]]

local Configurations = {}

-- Player Configurations
Configurations.MIN_PLAYERS = 1

-- Gameplay Configurations
Configurations.INTERMISSION_DURATION = 30 -- seconds
Configurations.START_GAME_WAIT = 5 -- seconds
Configurations.ROUND_DURATION = 5 * 60 -- seconds
Configurations.END_GAME_WAIT = 2 -- seconds
Configurations.RESPAWN_TIME = 5 -- seconds

-- XP Configurations
Configurations.BASE_XP = 100
Configurations.LEVEL_MULTIPLER = 100
Configurations.LEVEL_DIVIDER = 10
Configurations.XP_INCREMENT = 5

-- Map Configurations
Configurations.MAP_OFFSET = 200
local Maps = game.ServerStorage:FindFirstChild('Maps'):GetChildren()
local ChosenMapName = Maps[math.random(1, #Maps)].Name -- chooses a map initially (in the event players do not vote for a map, a random map from the list is chosen)

function Configurations:SetChosenMapName(mapName: string)
    ChosenMapName = mapName
end

function Configurations:GetChosenMapName()
    return ChosenMapName
end

return Configurations
