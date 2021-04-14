local Cell = require("src/cell")
local log = require("src/logger")
local tablex = require("pl.tablex")

local Cells = {
}

function Cells:new(max_x, max_y)
    local o = {
        values = {},
        top_x = 0,
        top_y = 0,
        max_x = max_x,
        max_y = max_y
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Cells.update_top(self)
    self.top_x = 0
    self.top_y = 0
    for _, v in pairs(self.values) do
        self.top_x = math.max(v.x, self.top_x)
        self.top_y = math.max(v.y, self.top_y)
    end
end

function Cells.activate_cell_at(self, cell_x, cell_y)
    local cell_key = cell_x .. ":" .. cell_y
    local new_value = Cell:new({
        x = cell_x,
        y = cell_y
    })
    self.values[cell_key] = new_value
    self:update_top()
    log.trace("[activate] x=" .. cell_x .. ", y=" .. cell_y .. ", top_x=" .. self.top_x .. "; top_y = " .. self.top_y)
end

function Cells.toggle_cell_at(self, cell_x, cell_y)
    local cell_key = cell_x .. ":" .. cell_y
    if self.values[cell_key] == nil then
        local new_value = Cell:new({
            x = cell_x,
            y = cell_y
        })
        self.values[cell_key] = new_value
    else
        self.values[cell_key] = nil
    end
    self:update_top()
    log.trace("[toggle] x=" .. cell_x .. ", y=" .. cell_y .. ", top_x=" .. self.top_x .. "; top_y = " .. self.top_y)
end

function Cells.get_next_cell_value(self, cell_x, cell_y)
    local cell = self.values[cell_x .. ":" .. cell_y]
    local get_cell = function(x, y)
        return self.values[x .. ":" .. y]
    end
    local top_left = get_cell(cell_x - 1, cell_y - 1)
    local top = get_cell(cell_x, cell_y - 1)
    local top_right = get_cell(cell_x + 1, cell_y - 1)
    local left = get_cell(cell_x - 1, cell_y)
    local right = get_cell(cell_x + 1, cell_y)
    local bottom_left = get_cell(cell_x - 1, cell_y + 1)
    local bottom = get_cell(cell_x, cell_y + 1)
    local bottom_right = get_cell(cell_x + 1, cell_y + 1)
    local grid = {
        top_left, top, top_right,
        left, right,
        bottom_left, bottom, bottom_right
    }
    log.trace(tostring(top_left ~= nil) .. " | " .. tostring(top ~= nil) .. " | " .. tostring(top_right ~= nil))
    log.trace(tostring(left ~= nil) .. " | X | " .. tostring(right ~= nil))
    log.trace(tostring(bottom_left ~= nil) .. " | " .. tostring(bottom ~= nil) .. " | " .. tostring(bottom_right ~= nil))
    local neighbors = tablex.size(grid)
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
    for i_y = 0, self.max_y - 1 do
        for i_x = 0, self.max_x - 1 do
            local new_key = i_x .. ":" .. i_y
            new_values[new_key] = self:get_next_cell_value(i_x, i_y)
        end
    end
    self.top_x = 0
    self.top_y = 0
    for _, v in pairs(new_values) do
        self.top_x = math.max(v.x, self.top_x)
        self.top_y = math.max(v.y, self.top_y)
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
