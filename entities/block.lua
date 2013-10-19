--[[
	block.lua
	Block is the atomic pathblocker

	Authors:
		Daniel Rolandi
--]]

local block = EntityManager.deriveBase()

-- pixels
block.width = BLOCK_SIZE
block.height = BLOCK_SIZE

block.pathing = true
block.alive = true
block.imageNameAlive = "block_purple"
block.imageNameDead = "block_purple_dead"

--[[
	args:
		x
		y
		id
		type
		special
]]
function block:load(args)
	block.x = args.x
	block.y = args.y
	block.id = args.id
	block.type = args.type
	block.special = args.special or nil

	block.image = ImageManager.getImage(self.imageNameAlive)
end

function block:onCollide(triggering)
	if self.alive then
		triggering:damage(DAMAGE_PER_BLOCK)
		self:kill()
	end
end

function block:kill()
	block.image = ImageManager.getImage(self.imageNameDead)
	self.alive = false
end

return block