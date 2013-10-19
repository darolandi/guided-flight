--[[
	downarrow.lua
	Downarrow changes game direction to down

	Authors:
		Daniel Rolandi
--]]

local downarrow = EntityManager.deriveBase()

-- pixels
downarrow.width = BLOCK_SIZE
downarrow.height = BLOCK_SIZE

downarrow.pathing = true
downarrow.alive = true
downarrow.imageNameAlive = "downarrow"
downarrow.imageNameDead = "downarrow_dead"

--[[
	args:
		x
		y
		id
		type
		special
]]
function downarrow:load(args)
	downarrow.x = args.x
	downarrow.y = args.y
	downarrow.id = args.id
	downarrow.type = args.type
	downarrow.special = args.special or nil

	downarrow.image = ImageManager.getImage(self.imageNameAlive)
end

function downarrow:onCollide(triggering)
	if self.alive then
		self:kill()
		return DIRECTION.DOWN
	end
end

function downarrow:kill()
	downarrow.image = ImageManager.getImage(self.imageNameDead)
	self.alive = false
end

return downarrow