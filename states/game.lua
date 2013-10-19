--[[
	game.lua
	Game runs in this state

	Authors:
		Daniel Rolandi
--]]

local PLAYER_STARTX = 100
local PLAYER_STARTY = 200
local BG_COLOR = {66, 255, 255}

local player = nil
local score = 0

local blockTicker = 0 -- ticks up every new block generated
local clock = 0
local gameSpeed = INIT_GAMESPEED
local gameDirection = DIRECTION.RIGHT

local leftPressed = false
local rightPressed = false
local upPressed = false
local downPressed = false


local function initUpBoundary()
	local args = {}
	args.y = BOUNDARY_UP
	args.special = "boundary"

	for x = 0, SCREEN_WIDTH, BLOCK_SIZE do
		args.x = x
		EntityManager.create("block", args)
	end
end

local function initDownBoundary()
	local args = {}
	args.y = BOUNDARY_DOWN - BLOCK_SIZE
	args.special = "boundary"

	for x = 0, SCREEN_WIDTH, BLOCK_SIZE do
		args.x = x
		EntityManager.create("block", args)
	end
end

local function initBoundaries()
	if (gameDirection == DIRECTION.RIGHT) or (gameDirection == DIRECTION.LEFT) then
		initUpBoundary()
		initDownBoundary()
	end
end

function load(args)
	-- TODO
	-- load parameters and stuff
	love.graphics.setBackgroundColor(BG_COLOR)

	local args = {
		["x"] = PLAYER_STARTX,
		["y"] = PLAYER_STARTY
	}
	EntityManager.create("player", args)
	player = EntityManager.getPlayer()

	initBoundaries()
end


local function updateDynamicSpeedFactor(dt)
	-- magic formula
	gameSpeed = MAX_GAMESPEED + (INIT_GAMESPEED - MAX_GAMESPEED) * math.exp(-1 * SPEEDUP_FACTOR * dt * blockTicker)

	DYNAMIC_SPEED_FACTOR = gameSpeed / INIT_GAMESPEED
end

local function dynamic(dt)
	return DYNAMIC_SPEED_FACTOR * dt
end

local function addScore(dt)
	score = score + SCORE_FACTOR * dt
end

local function addUpBoundary()
	if gameDirection == DIRECTION.RIGHT then
		local args = {}
		args.x = BOUNDARY_RIGHT
		args.y = BOUNDARY_UP
		args.special = "boundary"
		EntityManager.create("block", args)

	elseif gameDirection == DIRECTION.LEFT then
		local args = {}
		args.x = BOUNDARY_LEFT - BLOCK_SIZE
		args.y = BOUNDARY_UP
		args.special = "boundary"
		EntityManager.create("block", args)
	end
end

local function addDownBoundary()
	if gameDirection == DIRECTION.RIGHT then
		local args = {}
		args.x = BOUNDARY_RIGHT
		args.y = BOUNDARY_DOWN - BLOCK_SIZE
		args.special = "boundary"
		EntityManager.create("block", args)

	elseif gameDirection == DIRECTION.LEFT then
		local args = {}
		args.x = BOUNDARY_LEFT - BLOCK_SIZE
		args.y = BOUNDARY_UP - BLOCK_SIZE
		args.special = "boundary"
		EntityManager.create("block", args)
	end
end

local function createNewBoundaries()
	if (gameDirection == DIRECTION.RIGHT) or (gameDirection == DIRECTION.LEFT) then
		addUpBoundary()
		addDownBoundary()
	end
end

local function spawnLogic()
	-- add direction factor here
	local horizontalBuffer = SPAWNDATA.HORIZONTAL_BUFFER + math.random() * SPAWNDATA.HORIZONTAL_VARIANCE
	local verticalBuffer = (math.random() - 0.5) * SPAWNDATA.VERTICAL_VARIANCE

	-- ORDER/PRIORITY MATTERS
	if math.random() <= SPAWNDATA.SPAWN_CHANCE.BIGWALL then
		EntityManager.createUnit("BIGWALL", player.x + horizontalBuffer, player.y + verticalBuffer)

	elseif math.random() <= SPAWNDATA.SPAWN_CHANCE.WALL then
		EntityManager.createUnit("WALL", player.x + horizontalBuffer, player.y + verticalBuffer)

	elseif math.random() <= SPAWNDATA.SPAWN_CHANCE.HUGE then
		EntityManager.createUnit("HUGE", player.x + horizontalBuffer, player.y + verticalBuffer)

	elseif math.random() <= SPAWNDATA.SPAWN_CHANCE.BIG then
		EntityManager.createUnit("BIG", player.x + horizontalBuffer, player.y + verticalBuffer)

	elseif math.random() <= SPAWNDATA.SPAWN_CHANCE.SMALL then
		EntityManager.createUnit("SMALL", player.x + horizontalBuffer, player.y + verticalBuffer)

	elseif math.random() <= SPAWNDATA.SPAWN_CHANCE.HEALTH then
		EntityManager.createUnit("HEALTH", player.x + horizontalBuffer, player.y + verticalBuffer)
	end
end

local function updateClock(dt)
	clock = clock + gameSpeed * dt

	if clock >= BLOCK_SIZE then
		createNewBoundaries()
		clock = 0

		blockTicker = blockTicker + 1
		if blockTicker % SPAWNDATA.FREQUENCY_TICKS == 0 then
			spawnLogic()
		end
	end
end

local function updatePlayerPos(dt)
	player:move(dt)
	player:gravity(dt)
	if upPressed then
		player:thrust(dt)
	end
	if downPressed then
		player:drop(dt)
	end
end

local function moveBlocks(dt)
	if gameDirection == DIRECTION.RIGHT then
		EntityManager.moveBlocksLeft(gameSpeed, dt)

	elseif gameDirection == DIRECTION.LEFT then
		EntityManager.moveBlocksRight(gameSpeed, dt)

	elseif gameDirection == DIRECTION.UP then
		EntityManager.moveBlocksDown(gameSpeed, dt)

	elseif gameDirection == DIRECTION.DOWN then
		EntityManager.moveBlocksUp(gameSpeed, dt)
	end
end


local function boundaryFilter()
	if gameDirection == DIRECTION.RIGHT then
		return ( function(entity) return entity:getRight() < BOUNDARY_LEFT end )

	elseif gameDirection == DIRECTION.LEFT then
		return ( function(entity) return entity:getLeft() > BOUNDARY_RIGHT end )

	elseif gameDirection == DIRECTION.UP then
		return ( function(entity) return entity:getUp() > BOUNDARY_DOWN end )

	elseif gameDirection == DIRECTION.DOWN then
		return ( function(entity) return entity:getDown() < BOUNDARY_UP end )
	end
end

-- CORE
function love.update(dt)
	updateDynamicSpeedFactor(dt)
	dt = dynamic(dt)

	addScore(dt)
	updateClock(dt)
	updatePlayerPos(dt)
	moveBlocks(dt)

	EntityManager.killPlayerIfOut()
	EntityManager.checkPlayerCollision()
	EntityManager.outOfBoundsCleanUp( boundaryFilter() )
end

local function healthBar()
	local health = ""

	for i = HEALTHBAR_INCREMENT, INIT_HEALTH, HEALTHBAR_INCREMENT do
		if i <= player.health then
			health = health .. "|"
		else
			health = health .. " "
		end
	end

	return health
end

local function updateHUD()
	love.graphics.setColor(255, 255, 255)
	love.graphics.print("SCORE: " .. round(score, 0), HUD_X, HUD_Y)
	love.graphics.print("GAMESPEED: " .. round(DYNAMIC_SPEED_FACTOR, 2) .. "x", HUD_X, HUD_Y + LINE_SIZE)
	love.graphics.print("HEALTH: " .. "[" .. healthBar() .. "]", HUD_X, HUD_Y + LINE_SIZE * 2)
end

function love.draw()
	EntityManager.drawAll()
	updateHUD()

	-- temporary
	if StateManager.defeatState() then
		love.graphics.setColor(0, 0, 0)
		love.graphics.print("DEFEAT!", HUD_X, HUD_Y + LINE_SIZE * 3)
	end
end

local function updatePlayerSpeed()
	player.vx = 0

	if leftPressed then
		player.vx = player.vx - MOVESPEED
	end

	if rightPressed then
		player.vx = player.vx + MOVESPEED
	end
end

function love.keypressed(key, unicode)
	if key == "up" then
		upPressed = true
	elseif key == "down" then
		downPressed = true
	elseif key == "left" then
		leftPressed = true
	elseif key == "right" then
		rightPressed = true
	elseif key == "d" then
		DEBUG = not DEBUG
	end
	updatePlayerSpeed()
end

function love.keyreleased(key, unicode)
	if key == "up" then
		upPressed = false
	elseif key == "down" then
		downPressed = false
	elseif key == "left" then
		leftPressed = false
	elseif key == "right" then
		rightPressed = false
	end
	updatePlayerSpeed()
end