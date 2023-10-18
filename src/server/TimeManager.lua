--[[

	Script: TimeManager
    Username: anj0Ia
    Last Modified: Monday, October 9th, 2023
    
    Description: This module creates the Time value that is started with a given value
    via the StartTimer function. It is used to keep track of the time for the game,
    including the intermission and the round duration.
]]

local TimeManager = {}

-- Local Variables
local StartTime = 0
local Duration = 0

-- Initialization
local Time = Instance.new('IntValue', game.Workspace:WaitForChild('MapCache'))
Time.Name = 'Time'

-- Functions
function TimeManager:StartTimer(duration)
	StartTime = tick()
	Duration = duration
	task.spawn(function()
		repeat 
			Time.Value = Duration - (tick() - StartTime)
			task.wait()
		until Time.Value <= 0
		Time.Value = 0
	end)
end

function TimeManager:TimerDone()
	return tick() - StartTime >= Duration
end

return TimeManager
