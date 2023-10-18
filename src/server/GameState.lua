--[[

	Script: GameState
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This module contains all the of code related to the two states of the game:
    when the game is in intermission and when the game round is active. 
]]

local GameState = {}

-- Local Variables
local IntermissionRunning = false 
local RoundActive = false

-- Public Functions
function GameState:IsIntermissionRunning()
	return IntermissionRunning
end

function GameState:SetIntermissionRunning(running)
	IntermissionRunning = running
end

function GameState:IsRoundActive()
	return RoundActive
end

function GameState:SetRoundActive(active)
	RoundActive = active
end

return GameState
