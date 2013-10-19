--[[
	health.lua
	Health restores health upon pickup

	Authors:
		Daniel Rolandi
--]]

local health = EntityManager.deriveBase()

-- pixels
health.width = BLOCK_SIZE
health.height = BLOCK_SIZE

health.pathing = true
health.alive = true
health.imageNameAlive = "health"
health.imageNameDead = "health_dead"

--[[
	args:
		x
		y
		id
		type
		special
]]
function health:load(args)
	health.x = args.x
	health.y = args.y
	health.id = args.id
	health.type = args.type
	health.special = args.special or nil

	health.image = ImageManager.getImage(self.imageNameAlive)
end

function health:onCollide(triggering)
	if self.alive then
		triggering:heal(HEALTH_PICKUP)
		self:kill()
	end
end

function health:kill()
	health.image = ImageManager.getImage(self.imageNameDead)
	self.alive = false
end

return health