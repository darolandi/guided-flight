--- Override me!

--- Main love.load
function love.load()
    require("util")

    require("ImageManager")
    require("EntityManager")
    require("StateManager")
    require("SoundManager")

    ImageManager.init()
    EntityManager.init()
    StateManager.init()
    SoundManager.init()

    StateManager.load("game")
end
