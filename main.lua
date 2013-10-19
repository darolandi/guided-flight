--- Override me!

--- Main love.load
function love.load()
    require("util")

    require("ImageManager")
    require("EntityManager")
    require("StateManager")

    ImageManager.init()
    EntityManager.init()
    StateManager.init()

    StateManager.load("game", {})
end
