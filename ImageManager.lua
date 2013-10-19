--[[
	ImageManager.lua
	Loads images file and allow other files to use them

	Authors:
		Daniel Rolandi
--]]

ImageManager = {}

local PATH = "images/"

local images = {}

local function printLoading()
	print("Loading images...")
end

local function loadImages()
	local files = love.filesystem.enumerate(PATH)

	for _, file in ipairs(files) do
		if string.endsWith(file, ".png") then
			local name = file:gsub(".png", "")

			images[name] = love.graphics.newImage( PATH .. file )
			print("   " .. name)
		end
	end
end

function ImageManager.init()
	if not love.filesystem.exists(PATH) then
		print("ImageManager: directory not found! " .. PATH )
		return nil
	end

	printLoading()
	loadImages()
end

function ImageManager.getImage(name)
	if not images[name] then
		print("ImageManager: image not found!" .. name)
		return nil
	end

	return images[name]
end