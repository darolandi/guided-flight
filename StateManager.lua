--[[
	ImageManager.lua
	Loads images file and allow other files to use them

	Authors:
		Daniel Rolandi
--]]

StateManager = {}

local PATH = "states/"

local states = {}
local currentState = nil
local defeat = false

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

--[[
	Authors:
		Dan Wager
]]
local function clearLove()
    -- Not sure if we should nil this one out... lol
    --love.load = nil
    love.draw = nil
    love.update = nil
    love.focus = nil
    love.run = nil
    love.quit = nil
    love.mousepressed = nil
    love.mousereleased = nil
    love.joystickpressed = nil
    love.joystickreleased = nil
    love.keypressed = nil
    love.keyreleased = nil
    defeat = false
end

function StateManager.load(state, args)
	if not args then
		args = {}
	end

	if not states[state] then
		print("StateManager: state not found! " .. state)
		return nil
	end

	clearLove()
	print("Loading state: " .. state)
	currentState = state

	states[state]()
	load(args)
end

function StateManager.defeatNow()
	defeat = true
end

function StateManager.getDefeatState()
	return defeat
end