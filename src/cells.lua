local Cell = require("src/cell")
local log = require("src/logger")

local Cells = {
}

function Cells:new(max_x, max_y)
    local o = {
        values = {},
        y_to_xs = {},
        top_x = 0,
        top_y = 0,
        max_x = max_x,
        max_y = max_y
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

local function get_column_values_or_init(column, index)
    local values = column[index]
    if values == nil then
        values = {}
        column[index] = values
    end
    return values
end

function Cells.toggle_cell_at(self, cell_x, cell_y)
    local cell_key = cell_x .. ":" .. cell_y
    log.trace("toggle_cell_at(" .. cell_x .. ", " .. cell_y .. ")")
    local xs = get_column_values_or_init(self.y_to_xs, cell_y)
    if self.values[cell_key] == nil then
        local new_value = Cell:new({
            x = cell_x,
            y = cell_y
        })
        self.values[cell_key] = new_value
        xs[cell_x] = new_value
    else
        self.values[cell_key] = nil
        xs[cell_x] = nil
        if next(xs) == nil then
            self.y_to_xs[cell_y] = nil
        end
    end
    self.top_x = 0
    self.top_y = 0
    for _, v in pairs(self.values) do
        self.top_x = math.max(v.x, self.top_x)
        self.top_y = math.max(v.y, self.top_y)
    end
    log.trace("self.top_x = " .. self.top_x .. "; self.top_y = " .. self.top_y .. ".")
end

function Cells.get_next_cell_value(self, cell_x, cell_y)
    local xs_top = get_column_values_or_init(self.y_to_xs, cell_y - 1)
    local xs_middle = get_column_values_or_init(self.y_to_xs, cell_y)
    local xs_bottom = get_column_values_or_init(self.y_to_xs, cell_y + 1)
    local cell_key = cell_x .. ":" .. cell_y
    local cell = self.values[cell_key]
    local grid = {
        xs_top[cell_x - 1], xs_top[cell_x], xs_top[cell_x + 1],
        xs_middle[cell_x - 1], xs_middle[cell_x + 1],
        xs_bottom[cell_x - 1], xs_bottom[cell_x], xs_bottom[cell_x + 1]
    }
    local neighbors = table.getn(grid)
    if cell == nil then
        if neighbors == 3 then
            return Cell:new({
                x = cell_x,
                y = cell_y
            })
        else
            return nil
        end
    else
        if neighbors == 3 or neighbors == 2 then
            return cell
        else
            return nil
        end
    end
end

function Cells.update(self)
    local new_values = {}
    for i_x = 1, self.max_x do
        for i_y = 1, self.max_y do
            local new_key = i_x .. ":" .. i_y
            new_values[new_key] = self:get_next_cell_value(i_x, i_y)
        end
    end
    self.values = new_values
end

function Cells.reset(self)
    self.values = {}
    self.x_to_ys = {}
    self.top_x = 0
    self.top_y = 0
end

return Cells
