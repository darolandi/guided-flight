--[[
	player.lua
	Player is the entity being controlled; our Hero

	Authors:
		Daniel Rolandi
--]]

local player = EntityManager.deriveBase()

-- pixels
player.width = 40
player.height = 40

player.pathing = false
player.imageName = "player_smiley"

--[[
	args:
		x
		y
		id
		type
		special
]]
function player:load(args)
	player.x = args.x
	player.y = args.y
	player.id = args.id
	player.type = args.type
	player.special = args.special or nil

	player.image = ImageManager.getImage(self.imageName)
end

function player:kill()
	-- DEFEAT!
	--StateManager.load("defeat")

	-- temporary defeat
	StateManager.defeatNow()
end

return player