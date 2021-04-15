local config = require("src/config")
local World = require("src/world")
local world

function love.load()
    love.window.setFullscreen(true)
    local width, height = love.graphics.getDimensions()
    world = World:new(width, height, config.cell_size)
    world:load(config.init_state)
end

function love.update(dt)
    world:update_mouse_cell(
            love.mouse.getX(),
            love.mouse.getY()
    )
    if love.mouse.isDown(1) then
        world:activate_cell_at(love.mouse.getX(), love.mouse.getY())
    else
        world:update_simulation()
    end
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
