--[[
	base.lua
	Special kind of entity;
	All properties that an entity must have

	Authors:
		Daniel Rolandi
--]]

local base = {}

base.x = 0
base.y = 0
base.width = 0
base.height = 0

function base:setPos(x, y)
	self.x = x
	self.y = y
end

function base:getPos()
	return (self.x, self.y)
end

function base:setSize(width, height)
	self.width = width
	self.height = height
end

function base:getSize()
	return (self.width, self.width)
end

function base:setID(id)
	self.id = id
end

function base:getID()
	return self.id
end

function base:setType(type)
	self.type = type
end

function base:getType()
	return self.type
end

return base