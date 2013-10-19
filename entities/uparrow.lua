--[[
	uparrow.lua
	Uparrow changes game direction to up

	Authors:
		Daniel Rolandi
--]]

local uparrow = EntityManager.deriveBase()

-- pixels
uparrow.width = BLOCK_SIZE
uparrow.height = BLOCK_SIZE

uparrow.pathing = true
uparrow.alive = true
uparrow.imageNameAlive = "uparrow"
uparrow.imageNameDead = "uparrow_dead"

--[[
	args:
		x
		y
		id
		type
		special
]]
function uparrow:load(args)
	uparrow.x = args.x
	uparrow.y = args.y
	uparrow.id = args.id
	uparrow.type = args.type
	uparrow.special = args.special or nil

	uparrow.image = ImageManager.getImage(self.imageNameAlive)
end

function uparrow:onCollide(triggering)
	if self.alive then
		self:kill()
		return DIRECTION.UP
	end
end

function uparrow:kill()
	uparrow.image = ImageManager.getImage(self.imageNameDead)
	self.alive = false
end

return uparrow