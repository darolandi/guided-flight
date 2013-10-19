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
block.imageName = "block_purple"

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

	block.image = ImageManager.getImage(self.imageName)
end

function block:onCollide(triggering)
	triggering:kill()
end

return block