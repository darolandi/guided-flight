--[[
	ImageManager.lua
	Loads images file and allow other files to use them

	Authors:
		Daniel Rolandi
--]]

StateManager = {}

local PATH = "states/"

local states = {}

local function printLoading()
	print("Loading states...")
end

local function loadStates()
	local files = love.filesystem.enumerate(PATH)
	for _, file in ipairs(files) do
		local name = file:gsub(".lua", "")
		states[name] = love.filesystem.load(PATH .. file)
		print("   " .. name)
	end

end

function StateManager.init()
	if not love.filesystem.exists(PATH) then
		print("StateManager: directory not found! " .. PATH )
		return nil
	end

	printLoading()
	loadStates()
end

function StateManager.load(state, args)
	if not states[state] then
		print("StateManager: state not found! " .. state)
		return nil
	end

	print("Loading state: " .. state)
	states[state]()
	load(args)
end