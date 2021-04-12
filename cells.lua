local Cell = require("cell")

local Cells = {
    values = {},
    xs_in_y = {},
    ys_in_x = {}
}

function Cells:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function get_column_values_or_init(column, index)
    local values = column[index]
    if values == nil then
        values = {}
        column[index] = values
    end
    return values
end

function Cells.toggle_cell_at(self, cell_x, cell_y)
    local cell_key = cell_x .. ":" ..cell_y
    local cell = self.values[cell_key]
    local ys_in_x = get_column_values_or_init(self.ys_in_x, cell_x)
    local xs_in_y = get_column_values_or_init(self.xs_in_y, cell_y)
    if cell == nil then
        local new_value = Cell.new({
            x = cell_x,
            y = cell_y
        })
        self.values[cell_key] = new_value
        ys_in_x[cell_y] = new_value
        xs_in_y[cell_x] = new_value
    else
        self.values[cell_key] = nil
        ys_in_x[cell_y] = nil
        xs_in_y[cell_x] = nil
    end
end

function Cells.get_next_cell_value(self, cell_x, cell_y)
    local ys_in_x = get_column_values_or_init(self.ys_in_x, cell_x)
    local xs_in_y = get_column_values_or_init(self.xs_in_y, cell_y)
    local tl = ys_in_x[cell_x - 1][cell_y - 1]
    
    
end

function Cells.update(self)
    local new_values = {}
    for _, cell in pairs(self.values) do

        
    end
end

function Cells.reset(self)
    self.values = {}
    self.xs_in_y = {}
    self.ys_in_x = {}
end



return Cells
