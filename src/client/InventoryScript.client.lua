--[[

	Script: InvetoryScript
    Username: anj0Ia
    Last Modified: Tuesday, October 10th, 2023
    
    Description: This local script displays the inventory. More functionality will be added once the game 
    has been further developed.
]]

-- Game Services
local Events = game.ReplicatedStorage.Shared.Events
local DisplayInventory = Events.DisplayInventory

-- Local Variables
local ScreenGui = game.Players.LocalPlayer:WaitForChild('PlayerGui'):FindFirstChild('ScreenGui')
local InventoryButton = ScreenGui.NavFrame.InventoryButton
local InventoryFrame = ScreenGui.InventoryFrame
local CloseButton = InventoryFrame.CloseButton

-- Local Functions
local function OpenInventory()
	InventoryFrame.Visible = true
	print("Opened the inventory!")
end

local function CloseInventory()
	InventoryFrame.Visible = false
	print("Closed the inventory!")
end

local function OnDisplayInventory(isInRound)
	if not isInRound then
		InventoryButton.Active = true
		CloseButton.Active = true
		InventoryButton.Activated:Connect(OpenInventory)
		CloseButton.Activated:Connect(CloseInventory)
	else
		InventoryButton.Active = false
		CloseButton.Active = false
	end
end

-- Event Bindings
DisplayInventory.OnClientEvent:Connect(OnDisplayInventory)
