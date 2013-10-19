--[[
    global.lua
    Constants and global values

    Authors:
        Daniel Rolandi
--]]

DEBUG = true

SCREEN_WIDTH = 800
SCREEN_HEIGHT = 600
HUD_X = 40
HUD_Y = 40
LINE_SIZE = 18

BOUNDARY_UP = 0
BOUNDARY_DOWN = SCREEN_HEIGHT
BOUNDARY_LEFT = 0
BOUNDARY_RIGHT = SCREEN_WIDTH
BLOCK_SIZE = 20
HITBOX = 18

INIT_GAMESPEED = 170
MAX_GAMESPEED = 260
SPEEDUP_FACTOR = 0.1
DYNAMIC_GAMESPEED_FACTOR = 1

GRAVITY = 200
THRUST = GRAVITY * 3
DROP = THRUST
MOVESPEED = 200

INIT_HEALTH = 100
HEALTH_PICKUP = 30
DAMAGE_PER_BLOCK = 3
EASY_COLLISION = false -- only 1 collision counts if the player hits overlapping blocks

SCORE_FACTOR = 1500
BONUS_FACTOR = 3
HEALTH_FACTOR_TO_BONUS = 0.5
HEALTHBAR_LENGTH = 20
HEALTHBAR_INCREMENT = INIT_HEALTH / HEALTHBAR_LENGTH

DIRECTION_CHANGE_DISTANCE = 150
DIRECTION_CHANGE_VARIANCE = 100

DIRECTION = {
	["RIGHT"] = 0,
	["LEFT"] = 1,
	["DOWN"] = 2,
	["UP"] = 3
}

SPAWNDATA = {
	["HORIZONTAL_BUFFER"] = 700,
	["VERTICAL_BUFFER"] = 500,
	["HORIZONTAL_VARIANCE"] = 500,
	["VERTICAL_VARIANCE"] = 200,
	["FREQUENCY_TICKS"] = 2,

	["SPAWN_CHANCE"] = {
		["BIGWALL"] = 0.15,
		["WALL"] = 0.3,
		["HUGE"] = 0.10,
		["BIG"] = 0.3,
		["SMALL"] = 0.7,
		["HEALTH"] = 0.4,
	}
}

UNITDATA = {
	["BIGWALL"] = {
		["WIDTH"] = 12,
		["HEIGHT"] = 2
	},
	["WALL"] = {
		["WIDTH"] = 4,
		["HEIGHT"] = 1
	},
	["HUGE"] = {
		["WIDTH"] = 3,
		["HEIGHT"] = 6
	},
	["BIG"] = {
		["WIDTH"] = 2,
		["HEIGHT"] = 3
	},
	["SMALL"] = {
		["WIDTH"] = 1,
		["HEIGHT"] = 1
	},

	["ARROW"] = {
		["WIDTH"] = 3,
		["HEIGHT"] = 3
	},
	["ARROWALL"] = {
		["WIDTH"] = 2,
		["HEIGHT"] = 30
	}

}

DUMMYDATA = {
	["HEALTH"] = "dummy",
	["rightarrow"] = "dummy",
	["leftarrow"] = "dummy",
	["uparrow"] = "dummy",
	["downarrow"] = "dummy"
}

ARROWS = {}
ARROWS[DIRECTION.RIGHT] = "rightarrow"
ARROWS[DIRECTION.LEFT] = "leftarrow"
ARROWS[DIRECTION.UP] = "uparrow"
ARROWS[DIRECTION.DOWN] = "downarrow"