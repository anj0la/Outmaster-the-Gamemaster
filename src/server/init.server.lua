local GameManager = require(script.GameManager)

GameManager:Initialize()

while true do
	repeat
		GameManager:RunIntermission()
	until GameManager:GameReady()

	GameManager:StopIntermission()
	--[[ GameManager:StartRound()

	repeat
		GameManager:Update()
		task.wait()
	until GameManager:RoundOver()

	GameManager:RoundCleanup() ]]
end 
