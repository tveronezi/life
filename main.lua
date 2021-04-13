local World = require("src/world")
local world = World:new()

function love.load()
    -- no-op
end

function love.update(dt)
    world:update_mouse_cell(
            love.mouse.getX(),
            love.mouse.getY()
    )
    world:update_simulation()
end

function love.draw()
    world:draw()
end

function love.mousepressed(x, y, button, istouch)
    world:toggle_cell_at(x, y)
end

function love.keypressed(key)
    if key == "escape" then
        world:reset()
        return
    end
    if key == "space" then
        world:toggle_simulation()
        return
    end
end
