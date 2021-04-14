local World = require("src/world")
local world = nil

function love.load()
    love.window.setFullscreen(true)
    local width, height = love.graphics.getDimensions()
    local cell_size = 10
    world = World:new(width, height, cell_size)
end

function love.update(dt)
    world:update_mouse_cell(
            love.mouse.getX(),
            love.mouse.getY()
    )
    if love.mouse.isDown(1) then
        world:activate_cell_at(love.mouse.getX(), love.mouse.getY())
    end
    world:update_simulation()
end

function love.draw()
    world:draw()
end

function love.mousepressed(x, y, button, istouch)
    if button == 1 then
        world:toggle_cell_at(x, y)
    end

end

function love.keypressed(key)
    if key == "escape" then
        world:reset()
        return
    end
    if key == "space" then
        world:run_simulation_step()
        return
    end
    if key == "return" then
        world:toggle_simulation()
        return
    end
end
