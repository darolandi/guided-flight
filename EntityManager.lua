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
	table.insert( entities, newEntity )
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

--[[
	The most hack-y method.
]]
function EntityManager.createUnit(unittype, x, y)
	if not UNITDATA[unittype] then
		if not DUMMYDATA[ unittype:gsub("_all", "") ] then
			print("EntityManager.createUnit: unittype not found! " .. unittype)
			return nil
		end
	end

	if DEBUG then
		-- print("Creating unit " .. unittype .. " at " .. x .. ", " .. y)
	end

	local args = {}
	args.y = y

	if unittype == "HEALTH" then
		args.x = x
		EntityManager.create("health", args)
		return nil
	end

	if string.endsWith(unittype, "arrow_all") then
		entity_type = unittype:gsub("_all", "")
		unittype = "ARROWALL"
	elseif string.endsWith(unittype, "arrow") then
		entity_type = unittype
		unittype = "ARROW"
	else
		entity_type = "block"
	end

	-- should only accept "block" or the 4 kinds of arrows
	for row = 1, UNITDATA[unittype].HEIGHT do
		args.x = x

		for col = 1, UNITDATA[unittype].WIDTH do
			EntityManager.create( string.lower(entity_type), args)

			args.x = args.x + BLOCK_SIZE
		end
		args.y = args.y + BLOCK_SIZE
	end
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

function EntityManager.killPlayerIfOut()
	if (player:getRight() < BOUNDARY_LEFT)
		or (player:getLeft() > BOUNDARY_RIGHT)
		or (player:getDown() < BOUNDARY_UP)
		or (player:getUp() > BOUNDARY_DOWN) then

		player:kill()
	end
end

function EntityManager.checkPlayerCollision( setDirection )
	local potentialDirectionChange = nil

	-- This is the only collision I care about
	for _, entity in ipairs(entities) do
		if entity.pathing and ( entity:contains(player) or player:contains(entity) ) then
			potentialDirectionChange = entity:onCollide(player)

			if potentialDirectionChange then
				setDirection( potentialDirectionChange )
			end

			if EASY_COLLISION then
				return nil
			end
		end
	end
end

function EntityManager.outOfBoundsCleanUp(filterBad)
	local newEntities = {}

	for _, entity in ipairs(entities) do
		if not filterBad(entity) then
			newEntities[#newEntities + 1] = entity
		end
	end

	entities = newEntities
end

function EntityManager.moveBlocksRight(gameSpeed, dt)
	for _, entity in ipairs(entities) do
		if entity.pathing then
			entity.vx = gameSpeed
			entity.vy = 0
			entity:move(dt)
		end
	end
end

function EntityManager.moveBlocksLeft(gameSpeed, dt)
	for _, entity in ipairs(entities) do
		if entity.pathing then
			entity.vx = -gameSpeed
			entity.vy = 0
			entity:move(dt)
		end
	end
end

function EntityManager.moveBlocksUp(gameSpeed, dt)
	for _, entity in ipairs(entities) do
		if entity.pathing then
			entity.vx = 0
			entity.vy = -gameSpeed
			entity:move(dt)
		end
	end
end

function EntityManager.moveBlocksDown(gameSpeed, dt)
	for _, entity in ipairs(entities) do
		if entity.pathing then
			entity.vx = 0
			entity.vy = gameSpeed
			entity:move(dt)
		end
	end
end

function EntityManager.clear()
	entities = {}
	idCounter = 1
end

function EntityManager.softClear()
	local newEntities = {}

	for _, entity in ipairs(entities) do
		if entity.type == "player" then
			newEntities[#newEntities + 1] = entity
		end
	end

	entities = newEntities
	idCounter = 2
end