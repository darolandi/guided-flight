--[[
    global.lua
    Constants and global values

    Authors:
        Daniel Rolandi
--]]

DEBUG = true

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600

BOUNDARY_UP = 0
BOUNDARY_DOWN = SCREEN_HEIGHT
BOUNDARY_LEFT = 0
BOUNDARY_RIGHT = SCREEN_WIDTH

BLOCK_SIZE = 20
GRAVITY = 170
THRUST = GRAVITY * 2
INIT_GAMESPEED = 60

DIRECTION = {
	["RIGHT"] = 0,
	["LEFT"] = 1,
	["DOWN"] = 2,
	["UP"] = 3
}