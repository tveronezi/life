local Cell = require("cell")

local refreshing = false

local World = {
    run_simulation = false,
    cell_size = 30,
    mouse_cell = {
        x = 0,
        y = 0
    },
    cells = {},
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
    if refreshing then 
        return 
    end
    local cell_x, cell_y = self:get_cell_coords_at(window_x, window_y)
    print("toggle_cell_at -> x: ".. window_x .. "; y: " .. window_y)
    print("                  cell_x: ".. cell_x .. "; cell_y: " .. cell_y)
    local cell_key = cell_x .. ":" ..cell_y
    local cell = self.cells[cell_key]
    if cell == nil then
        self.cells[cell_key] = Cell.new({
            x = cell_x,
            y = cell_y
        }) 
    else
        self.cells[cell_key] = nil
    end
    numItems = 0
    for k,v in pairs(self.cells) do
        numItems = numItems + 1
    end
    print("total: ".. numItems)
    print("")
    refreshing = true
end

function World.draw(self)
    for _, cell in pairs(self.cells) do
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
    refreshing = false
end

function World.reset(self)
    self.cells = {}
end

function World.toggle_simulation(self) 
    self.run_simulation = not self.run_simulation
end

function World.update_simulation(self)

end

return World