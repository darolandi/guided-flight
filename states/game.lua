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

local clock = 0
local blockTicker = 0 										-- ticks up every new block generated
local directionChangeCountdown = DIRECTION_CHANGE_DISTANCE 	-- ticks down every new block generated
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

local function initLeftBoundary()
	local args = {}
	args.x = BOUNDARY_LEFT
	args.special = "boundary"

	for y = 0, SCREEN_HEIGHT, BLOCK_SIZE do
		args.y = y
		EntityManager.create("block", args)
	end
end

local function initRightBoundary()
	local args = {}
	args.x = BOUNDARY_RIGHT - BLOCK_SIZE
	args.special = "boundary"

	for y = 0, SCREEN_HEIGHT, BLOCK_SIZE do
		args.y = y
		EntityManager.create("block", args)
	end
end

local function initBoundaries()
	if (gameDirection == DIRECTION.RIGHT) or (gameDirection == DIRECTION.LEFT) then
		initUpBoundary()
		initDownBoundary()
		return
	end
	initLeftBoundary()
	initRightBoundary()
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
		args.y = BOUNDARY_DOWN - BLOCK_SIZE
		args.special = "boundary"
		EntityManager.create("block", args)
	end
end

local function addLeftBoundary()
	if gameDirection == DIRECTION.UP then
		local args = {}
		args.x = BOUNDARY_LEFT
		args.y = BOUNDARY_UP - BLOCK_SIZE
		args.special = "boundary"
		EntityManager.create("block", args)

	elseif gameDirection == DIRECTION.DOWN then
		local args = {}
		args.x = BOUNDARY_LEFT
		args.y = BOUNDARY_DOWN
		args.special = "boundary"
		EntityManager.create("block", args)
	end
end

local function addRightBoundary()
	if gameDirection == DIRECTION.UP then
		local args = {}
		args.x = BOUNDARY_RIGHT - BLOCK_SIZE
		args.y = BOUNDARY_UP - BLOCK_SIZE
		args.special = "boundary"
		EntityManager.create("block", args)

	elseif gameDirection == DIRECTION.DOWN then
		local args = {}
		args.x = BOUNDARY_RIGHT - BLOCK_SIZE
		args.y = BOUNDARY_DOWN
		args.special = "boundary"
		EntityManager.create("block", args)
	end
end


local function createNewBoundaries()
	if (gameDirection == DIRECTION.RIGHT) or (gameDirection == DIRECTION.LEFT) then
		addUpBoundary()
		addDownBoundary()
		return
	end

	addLeftBoundary()
	addRightBoundary()
end

local function getBufferedDistanceXY()
	local horizontalBuffer = 0
	local verticalBuffer = 0

	-- add direction factor here
	if (gameDirection == DIRECTION.RIGHT) or (gameDirection == DIRECTION.LEFT) then
		horizontalBuffer = SPAWNDATA.HORIZONTAL_BUFFER + math.random() * SPAWNDATA.HORIZONTAL_VARIANCE
		verticalBuffer = (math.random() - 0.5) * SPAWNDATA.VERTICAL_VARIANCE

		if gameDirection == DIRECTION.LEFT then
			horizontalBuffer = -horizontalBuffer
		end

		return horizontalBuffer, verticalBuffer
	end

	-- DIRECTION.UP or DIRECTION.DOWN
	horizontalBuffer = (math.random() - 0.5) * SPAWNDATA.HORIZONTAL_VARIANCE
	verticalBuffer = SPAWNDATA.VERTICAL_BUFFER + math.random() * SPAWNDATA.VERTICAL_VARIANCE

	if gameDirection == DIRECTION.UP then
		verticalBuffer = -verticalBuffer
	end

	return horizontalBuffer, verticalBuffer
end

local function spawnLogic()
	-- add direction factor here
	local horizontalBuffer, verticalBuffer = getBufferedDistanceXY()

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

local function getRandomPossibleDirection()
	local possibleDirections = {}

	if gameDirection == DIRECTION.RIGHT then
		possibleDirections[0] = DIRECTION.LEFT
		possibleDirections[1] = DIRECTION.UP
		possibleDirections[2] = DIRECTION.DOWN

	elseif gameDirection == DIRECTION.LEFT then
		possibleDirections[0] = DIRECTION.RIGHT
		possibleDirections[1] = DIRECTION.UP
		possibleDirections[2] = DIRECTION.DOWN

	elseif gameDirection == DIRECTION.UP then
		possibleDirections[0] = DIRECTION.RIGHT
		possibleDirections[1] = DIRECTION.LEFT
		possibleDirections[2] = DIRECTION.DOWN

	elseif gameDirection == DIRECTION.DOWN then
		possibleDirections[0] = DIRECTION.RIGHT
		possibleDirections[1] = DIRECTION.UP
		possibleDirections[2] = DIRECTION.LEFT
	end

	local random_selector = math.random()

	if random_selector <= 0.33 then
		return possibleDirections[0]
	elseif random_selector <= 0.66 then
		return possibleDirections[1]
	else
		return possibleDirections[2]
	end
end

local function forceDirectionChange()
	local direction = getRandomPossibleDirection()
	local horizontalBuffer, verticalBuffer = getBufferedDistanceXY()

	EntityManager.createUnit( ARROWS[direction] .. "_all", player.x + horizontalBuffer, player.y + verticalBuffer)
end

local function updateBlockTicker()
	blockTicker = blockTicker + 1
	if blockTicker % SPAWNDATA.FREQUENCY_TICKS == 0 then
		spawnLogic()
	end
end

local function updateDirectionChangeCountdown()
	directionChangeCountdown = directionChangeCountdown - 1
	if directionChangeCountdown <= 0 then
		directionChangeCountdown = DIRECTION_CHANGE_DISTANCE + math.random() * DIRECTION_CHANGE_VARIANCE
		forceDirectionChange()
	end
end

local function updateClock(dt)
	clock = clock + gameSpeed * dt

	if clock >= BLOCK_SIZE then
		clock = 0
		createNewBoundaries()
		updateBlockTicker()
		updateDirectionChangeCountdown()
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

--[[
	The only place where those global values are altered.
]]
local function swapBlocksDimensions()
	-- ipairs didn't work, resort to manual work
	UNITDATA["BIGWALL"].WIDTH, UNITDATA.BIGWALL.HEIGHT = UNITDATA.BIGWALL.HEIGHT, UNITDATA.BIGWALL.WIDTH
	UNITDATA["WALL"].WIDTH, UNITDATA.WALL.HEIGHT = UNITDATA.WALL.HEIGHT, UNITDATA.WALL.WIDTH
	UNITDATA["HUGE"].WIDTH, UNITDATA.HUGE.HEIGHT = UNITDATA.HUGE.HEIGHT, UNITDATA.HUGE.WIDTH
	UNITDATA["BIG"].WIDTH, UNITDATA.BIG.HEIGHT = UNITDATA.BIG.HEIGHT, UNITDATA.BIG.WIDTH
	UNITDATA["SMALL"].WIDTH, UNITDATA.SMALL.HEIGHT = UNITDATA.SMALL.HEIGHT, UNITDATA.SMALL.WIDTH
	UNITDATA["ARROW"].WIDTH, UNITDATA.ARROW.HEIGHT = UNITDATA.ARROW.HEIGHT, UNITDATA.ARROW.WIDTH
	UNITDATA["ARROWALL"].WIDTH, UNITDATA.ARROWALL.HEIGHT = UNITDATA.ARROWALL.HEIGHT, UNITDATA.ARROWALL.WIDTH
end

local function setDirection(direction)
	local directionBefore = gameDirection
	local directionAfter = direction

	if directionBefore == directionAfter then
		return nil
	end

	gameDirection = directionAfter
	initBoundaries()

	if ((directionBefore == DIRECTION.LEFT) or (directionBefore == DIRECTION.RIGHT))
		and ((directionAfter == DIRECTION.UP) or (directionAfter == DIRECTION.DOWN)) then
		swapBlocksDimensions()
	elseif ((directionBefore == DIRECTION.UP) or (directionBefore == DIRECTION.DOWN))
		and ((directionAfter == DIRECTION.LEFT) or (directionAfter == DIRECTION.RIGHT)) then
		swapBlocksDimensions()
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
	EntityManager.checkPlayerCollision( setDirection )
	EntityManager.outOfBoundsCleanUp( boundaryFilter() )

	if StateManager.getDefeatState() then
		EntityManager.clear()
		StateManager.load("defeat", {["score"] = score})
	end
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