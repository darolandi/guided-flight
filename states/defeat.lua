--[[
	defeat.lua
	State of game defeat.

	Authors:
		Daniel Rolandi
--]]

local BG_COLOR = {0, 0, 0}
local RETRY_BUTTON = "r"
local SPLASH_IMAGE = ImageManager.getImage("splash_defeat")

local finalScore = 0

function load(args)
	finalScore = args.score
	love.graphics.setBackgroundColor(BG_COLOR)
end

function love.draw()
	love.graphics.setColor(255, 0, 0)
	love.graphics.setNewFont(40)
	love.graphics.print("Score: " .. round(finalScore, 0), 100, 150, 0, 1, 1)

	love.graphics.setColor(255, 255, 255)
	love.graphics.draw( SPLASH_IMAGE, 90, 200 )
end

function love.keypressed(key, unicode)
	if key == RETRY_BUTTON then
		StateManager.load("game", {})
	end
end