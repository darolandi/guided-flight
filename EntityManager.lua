--[[
	EntityManager.lua
	Loads entity files and allows for their creation

	Authors:
		Daniel Rolandi
--]]

EntityManager = {}

local PATH = "entities/"

local types = {}
local entities = {}
local idCounter = 1
local player = nil

local function printLoading()
	print("Loading entities...")
end

local function loadEntities()
	local files = love.filesystem.enumerate(PATH)
	for _, file in ipairs(files) do
		local name = file:gsub(".lua", "")
		types[name] = love.filesystem.load(PATH .. file)
		print("   " .. name)
	end

end

function EntityManager.init()
	if not love.filesystem.exists(PATH) then
		print("EntityManager: directory not found! " .. PATH )
		return nil
	end

	printLoading()
	loadEntities()
end

local function saveToTable(newEntity)
	entities[idCounter] = newEntity
	idCounter = idCounter + 1
end

local function saveReferenceToPlayer(newEntity)
	if newEntity.type == "player" then
		player = newEntity
	end
end

local function createEntity(type, args)
	local newEntity = types[type]()
	args.type = type
	args.id = idCounter
	newEntity:load(args)

	saveToTable(newEntity)
	saveReferenceToPlayer(newEntity)
end

--[[
	args:
		x
		y
		id
		type
		special
]]
function EntityManager.create(type, args)
	if not args then
		args = {}
	end

	if not types[type] then
		print("EntityManager: type not found! " .. type)
		return nil
	end

	createEntity(type, args)
end

function EntityManager.deriveBase()
	return types["base"]()
end

function EntityManager.drawAll()
	for _, entity in ipairs(entities) do
		entity:draw()
	end
end

function EntityManager.getPlayer()
	-- This is possible because there is always only one player
	return player
end

function EntityManager.checkPlayerCollision()
	-- This is the only collision I care about
	for _, entity in ipairs(entities) do
		if entity.pathing and entity:contains(player) then
			entity:onCollide(player)

			-- for now, only want the first collision
			return nil
		end
	end
end

function EntityManager.outOfBoundsCleanUp(filterBad)
	for key, entity in ipairs(entities) do
		-- print(entity:getRight() )
		if filterBad(entity) then
			table.removeByKey(entities, key)
		end
	end
end

-- function EntityManager.moveCollidablesRight(gameSpeed, dt)
-- 	for _, entity in ipairs(collidables) do
-- 		entity.vx = gameSpeed
-- 		entity:move(dt)
-- 	end
-- end

function EntityManager.moveBoundaryLeft(gameSpeed, dt)
	print(#entities)
	for _, entity in ipairs(entities) do
		if entity.special == "boundary" then
			entity.vx = -1 * gameSpeed
			entity:move(dt)
		end
	end
end

-- function EntityManager.moveCollidablesUp(gameSpeed, dt)
-- 	for _, entity in ipairs(collidables) do
-- 		entity.vy = -gameSpeed
-- 		entity:move(dt)
-- 	end
-- end

-- function EntityManager.moveCollidablesDown(gameSpeed, dt)
-- 	for _, entity in ipairs(collidables) do
-- 		entity.vy = gameSpeed
-- 		entity:move(dt)
-- 	end
-- end