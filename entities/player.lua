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
player.health = INIT_HEALTH

player.pathing = false
player.imageNameAlive = "player_smiley"

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

	player.image = ImageManager.getImage(self.imageNameAlive)
end

function player:heal(amount)
	self.health = self.health + amount
	if self.health >= INIT_HEALTH then
		self.health = INIT_HEALTH
	end
end

function player:damage(amount)
	self.health = self.health - amount
	if self.health <= 0 then
		player:kill()
	end
end

function player:kill()
	-- DEFEAT!
	--StateManager.load("defeat")

	-- temporary defeat
	self.health = 0
	StateManager.defeatNow()
end

return player