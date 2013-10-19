--[[
	rightarrow.lua
	Rightarrow changes game direction to right

	Authors:
		Daniel Rolandi
--]]

local rightarrow = EntityManager.deriveBase()

-- pixels
rightarrow.width = BLOCK_SIZE
rightarrow.height = BLOCK_SIZE

rightarrow.pathing = true
rightarrow.alive = true
rightarrow.imageNameAlive = "rightarrow"
rightarrow.imageNameDead = "rightarrow_dead"

--[[
	args:
		x
		y
		id
		type
		special
]]
function rightarrow:load(args)
	rightarrow.x = args.x
	rightarrow.y = args.y
	rightarrow.id = args.id
	rightarrow.type = args.type
	rightarrow.special = args.special or nil

	rightarrow.image = ImageManager.getImage(self.imageNameAlive)
end

function rightarrow:onCollide(triggering)
	if self.alive then
		self:kill()
		return DIRECTION.RIGHT
	end
end

function rightarrow:kill()
	rightarrow.image = ImageManager.getImage(self.imageNameDead)
	self.alive = false
end

return rightarrow