--[[

	Script: EventCreator
    Username: anj0Ia
    Last Modified: Monday, October 9th, 2023
    
    Description: This module creates Events dynamically.
    
]]

local EventCreator = {}

function EventCreator:CreateEvent(eventName)
	local newEvent = Instance.new('RemoteEvent', game.ReplicatedStorage.Shared.Events)
	newEvent.Name = eventName
	return newEvent
end

return EventCreator