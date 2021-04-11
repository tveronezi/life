local World = require("world")
local world = World:new()

function love.load()
    
end

function love.update(dt)

end

function love.draw()
    world:draw()
end

function love.mousepressed(x, y, button, istouch)
    world:toggle_cell_at(x, y)
 end
