local Cell = require("src/cell")

local Cells = {
    values = {},
    y_to_xs = {}
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
    local cell_key = cell_x .. ":" .. cell_y
    local cell = self.values[cell_key]
    local xs = get_column_values_or_init(self.y_to_xs, cell_y)
    if cell == nil then
        local new_value = Cell:new({
            x = cell_x,
            y = cell_y
        })
        self.values[cell_key] = new_value
        xs[cell_x] = new_value
    else
        self.values[cell_key] = nil
        xs[cell_x] = nill
        if next(xs) == nil then
            self.y_to_xs[cell_y] = nill
        end
    end
end

function Cells.get_next_cell_value(self, cell_x, cell_y)
    local neighbors = 0
    local xs_top = get_column_values_or_init(self.y_to_xs, cell_y - 1)
    local tl = xs_top[cell_x - 1]
    if tl ~= nil then
        neighbors = neighbors + 1
    end
    local t = xs_top[cell_x]
    if t ~= nil then
        neighbors = neighbors + 1
    end
    local tr = xs_top[cell_x + 1]
    if tr ~= nil then
        neighbors = neighbors + 1
    end
    local xs_middle = get_column_values_or_init(self.y_to_xs, cell_y)
    local l = xs_middle[cell_x - 1]
    if l ~= nil then
        neighbors = neighbors + 1
    end
    local r = xs_middle[cell_x + 1]
    if r ~= nil then
        neighbors = neighbors + 1
    end
    local xs_bottom = get_column_values_or_init(self.y_to_xs, cell_y + 1)
    local bl = xs_bottom[cell_x - 1]
    if bl ~= nil then
        neighbors = neighbors + 1
    end
    local b = xs_bottom[cell_x]
    if b ~= nil then
        neighbors = neighbors + 1
    end
    local br = xs_bottom[cell_x + 1]
    if br ~= nil then
        neighbors = neighbors + 1
    end
    local cell_key = cell_x .. ":" .. cell_y
    local cell = self.values[cell_key]
end

function Cells.update(self)
    local new_values = {}
    for _, cell in pairs(self.values) do


    end
end

function Cells.reset(self)
    self.values = {}
    self.x_to_ys = {}
end

return Cells
