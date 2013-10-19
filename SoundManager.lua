--[[
	SoundManager.lua
	Loads sounds file and allow other files to use them

	Authors:
		Daniel Rolandi
--]]

SoundManager = {}

local PATH = "sounds/"

local sounds = {}

local function printLoading()
	print("Loading sounds...")
end

local function loadSounds()
	local files = love.filesystem.enumerate(PATH)

	for _, file in ipairs(files) do
		if string.endsWith(file, ".ogg") then
			local name = file:gsub(".ogg", "")

			print(PATH .. file)
			sounds[name] = love.audio.newSource( PATH .. file)
			print("   " .. name)
		end
	end
end

function SoundManager.init()
	if not love.filesystem.exists(PATH) then
		print("SoundManager: directory not found! " .. PATH )
		return nil
	end

	printLoading()
	loadSounds()
end

function SoundManager.playSound(name)
	if not sounds[name] then
		print("SoundManager: sound not found!" .. name)
		return nil
	end

	-- love.audio.rewind( sounds[name] )
	-- love.audio.play(sounds[name])
end