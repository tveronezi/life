local Cells = require("cells")

local World = {
    run_simulation = false,
    cell_size = 30,
    mouse_cell = {
        x = 0,
        y = 0
    },
    cells = Cells:new()
}

function World:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function World.get_cell_coords_at(self, window_x, window_y)
    local cell_x = math.floor(window_x / self.cell_size);
    local cell_y = math.floor(window_y / self.cell_size);
    return cell_x, cell_y
end

function World.update_mouse_cell(self, window_x, window_y)
    local cell_x, cell_y = self:get_cell_coords_at(window_x, window_y)
    self.mouse_cell = {
        x = cell_x,
        y = cell_y
    }
end

function World.toggle_cell_at(self, window_x, window_y)
    local cell_x, cell_y = self:get_cell_coords_at(window_x, window_y)
    self.cells:toggle_cell_at(cell_x, cell_y)
end

function World.draw(self)
    for _, cell in pairs(self.cells.values) do
        love.graphics.rectangle("fill",
                cell.x * self.cell_size,
                cell.y * self.cell_size,
                self.cell_size,
                self.cell_size
        )
    end
    love.graphics.rectangle("fill",
            self.mouse_cell.x * self.cell_size,
            self.mouse_cell.y * self.cell_size,
            self.cell_size,
            self.cell_size
    )
end

function World.reset(self)
    self.cells:reset()
end

function World.toggle_simulation(self)
    self.run_simulation = not self.run_simulation
end

function World.update_simulation(self)

end

return World