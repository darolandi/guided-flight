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
local id_counter = 0

local function printLoading()
	print("Loading entities...")
end

local function loadEntities()
	local files = love.filesystem.enumerate(PATH)
	for _, file in ipairs(files) do
		local name = file:gsub(".lua", "")
		types[name] = 1
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

local function createTypeXY(type, x, y)
	local newEntity = types[type]()
	newEntity.x = x
	newEntity.y = y
	newEntity.id = id_counter
	return newEntity
end

function EntityManager.create(type, x, y, table)
	if not table then
		table = {}
	end

	if not types[type] then
		print("EntityManager: type not found! " .. type)
		return nil
	end

	newEntity = createTypeXY(type, x, y)
	entities[id_counter] = newEntity
	id_counter = id_counter + 1

end