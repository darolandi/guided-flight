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
base.vx = 0
base.vy = 0
base.width = 0
base.height = 0

function base:setPos(x, y)
	self.x = x
	self.y = y
end

function base:getPos()
	return self.x, self.y
end

function base:setSize(width, height)
	self.width = width
	self.height = height
end

function base:getSize()
	return self.width, self.width
end

function base:getUp()
	return self.y
end

function base:getDown()
	return self.y + self.height
end

function base:getLeft()
	return self.x
end

function base:getRight()
	return self.x + self.width
end

function base:setID(id)
	self.id = id
end

function base:getID()
	return self.id
end

function base:draw()
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(self.image, self.x, self.y)

	if DEBUG then
		love.graphics.setColor(255, 0, 0)
		love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
	end
end

function base:move(dt)
	self.x = self.x + self.vx * dt
	self.y = self.y + self.vy * dt
end

function base:jump(power)
	self.vy = self.vy - power
end

function base:gravity(dt)
	self.vy = self.vy + GRAVITY * dt
end

function base:thrust(dt)
	self.vy = self.vy - THRUST * dt
end

function base:drop(dt)
	self.vy = self.vy + DROP * dt
end

function base:containsPoint(x, y)
	return (self.x <= x) and (x <= self:getRight() )
		and (self.y <= y) and (y <= self:getDown() )
end

function base:contains(entity)
	return self:containsPoint(entity:getLeft(), entity:getUp())
		or self:containsPoint(entity:getLeft(), entity:getDown())
		or self:containsPoint(entity:getRight(), entity:getUp())
		or self:containsPoint(entity:getRight(), entity:getDown())
end

return base