local Cells = require("src/cells")
local log = require("src/logger")
local tablex = require("pl.tablex")
local stringx = require("pl.stringx")

local World = {
    run_simulation = false,
    simulation_step = false,
    cell_size = 30,
    mouse_cell = {
        x = 0,
        y = 0
    },
    cells = nil
}

function World:new(window_width, window_height, cell_size)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.cell_size = cell_size
    local max_x = math.floor(window_width / cell_size)
    local max_y = math.floor(window_height / cell_size)
    log.trace("max_x = " .. max_x .. "; window_width = " .. window_width .. "; ")
    log.trace("max_y = " .. max_y .. "; window_height = " .. window_height .. "; ")
    log.trace("cell_size = " .. cell_size .. ";")
    o.cells = Cells:new(max_x, max_y)
    return o
end

function World.get_cell_coords_at(self, window_x, window_y)
    local cell_x = math.floor(window_x / self.cell_size);
    local cell_y = math.floor(window_y / self.cell_size);
    return cell_x, cell_y
end

function World.load(self, file_name)
    local get_content = function()
        local f = assert(io.open("worlds/" .. file_name, "rb"))
        local content = f:read("*all")
        f:close()
        return content
    end
    local lines = stringx.lines(get_content())
    for line in lines do
        local columns
    end

end

function World.update_mouse_cell(self, window_x, window_y)
    local cell_x, cell_y = self:get_cell_coords_at(window_x, window_y)
    self.mouse_cell = {
        x = cell_x,
        y = cell_y
    }
end

function World.activate_cell_at(self, window_x, window_y)
    local cell_x, cell_y = self:get_cell_coords_at(window_x, window_y)
    self.cells:activate_cell_at(cell_x, cell_y)
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
end

function World.reset(self)
    self.run_simulation = false
    self.simulation_step = false
    self.cells:reset()

end

function World.run_simulation_step(self)
    self.simulation_step = true
end

function World.toggle_simulation(self)
    self.run_simulation = not self.run_simulation
end

function World.update_simulation(self)
    if self.simulation_step or self.run_simulation then
        self.cells:update()
    end
    self.simulation_step = false
    if tablex.size(self.cells.values) == 0 then
        self:reset()
    end
end

return World