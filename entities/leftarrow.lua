--[[
	leftarrow.lua
	Leftarrow changes game direction to left

	Authors:
		Daniel Rolandi
--]]

local leftarrow = EntityManager.deriveBase()

-- pixels
leftarrow.width = BLOCK_SIZE
leftarrow.height = BLOCK_SIZE

leftarrow.pathing = true
leftarrow.alive = true
leftarrow.imageNameAlive = "leftarrow"
leftarrow.imageNameDead = "leftarrow_dead"

--[[
	args:
		x
		y
		id
		type
		special
]]
function leftarrow:load(args)
	leftarrow.x = args.x
	leftarrow.y = args.y
	leftarrow.id = args.id
	leftarrow.type = args.type
	leftarrow.special = args.special or nil

	leftarrow.image = ImageManager.getImage(self.imageNameAlive)
end

function leftarrow:onCollide(triggering)
	if self.alive then
		self:kill()
		return DIRECTION.LEFT
	end
end

function leftarrow:kill()
	leftarrow.image = ImageManager.getImage(self.imageNameDead)
	self.alive = false
end

return leftarrow