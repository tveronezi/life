local Cell = require("src/cell")
local log = require("src/logger")
local tablex = require("pl.tablex")

local Cells = {
}

function Cells:new(max_x, max_y)
    local o = {
        values = {},
        max_x = max_x,
        max_y = max_y
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Cells.activate_cell_at(self, cell_x, cell_y)
    local cell_key = cell_x .. ":" .. cell_y
    local new_value = Cell:new({
        x = cell_x,
        y = cell_y
    })
    self.values[cell_key] = new_value
    log.trace("[activate] x=" .. cell_x .. ", y=" .. cell_y .. ";")
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
    log.trace("[toggle] x=" .. cell_x .. ", y=" .. cell_y .. ";")
end

function Cells.get_neighbors(self, cell_x, cell_y)
    local get_cell = function(x, y)
        local result = self.values[x .. ":" .. y]
        if result == nil then
            return {
                x = x,
                y = y,
                living = false
            }
        else
            return {
                x = x,
                y = y,
                living = true
            }
        end
    end
    local top_left = get_cell(cell_x - 1, cell_y - 1)
    local top = get_cell(cell_x, cell_y - 1)
    local top_right = get_cell(cell_x + 1, cell_y - 1)
    local left = get_cell(cell_x - 1, cell_y)
    local right = get_cell(cell_x + 1, cell_y)
    local bottom_left = get_cell(cell_x - 1, cell_y + 1)
    local bottom = get_cell(cell_x, cell_y + 1)
    local bottom_right = get_cell(cell_x + 1, cell_y + 1)
    log.trace(tostring(top_left.living) .. " | " .. tostring(top.living) .. " | " .. tostring(top_right.living))
    log.trace(tostring(left.living) .. " | X | " .. tostring(right.living))
    log.trace(tostring(bottom_left.living) .. " | " .. tostring(bottom.living) .. " | " .. tostring(bottom_right.living))
    return {top_left, top, top_right, left, right, bottom_left, bottom, bottom_right}
end

function Cells.get_next_cell_value(self, cell_x, cell_y)
    local cell = self.values[cell_x .. ":" .. cell_y]
    local grid = self:get_neighbors(cell_x, cell_y)
    local neighbors = tablex.size(tablex.filter(grid, function(el)
        return el.living
    end))
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

function Cells.get_target_cells(self)
    local update_table = function(the_table, neighbor)
        local neighbor_neighbors = self:get_neighbors(neighbor.x, neighbor.y)
        for _, n in pairs(neighbor_neighbors) do
            the_table[n.x .. ":" .. n.y] = n
        end
        return the_table
    end
    local all_neighbors = {}
    for _, v in pairs(self.values) do
        all_neighbors = update_table(all_neighbors, v)
    end
    local all_neighbors_neighbors = {}
    for _, v in pairs(all_neighbors) do
        all_neighbors_neighbors = update_table(all_neighbors_neighbors, v)
    end
    local all_living = {}
    for _, v in pairs(self.values) do
        all_living[v.x .. ":" .. v.y] = {
            x = v.x,
            y = v.y,
            living = true
        }
    end
    return tablex.merge(all_neighbors, all_neighbors_neighbors, all_living)
end

function Cells.update(self)
    local new_values = {}
    for _, v in pairs(self:get_target_cells()) do
        local new_key = v.x .. ":" .. v.y
        new_values[new_key] = self:get_next_cell_value(v.x, v.y)
    end
    self.values = new_values
end

function Cells.reset(self)
    self.values = {}
    self.x_to_ys = {}
end

return Cells
