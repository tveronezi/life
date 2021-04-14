local Cells = require("src/cells")
local log = require("src/logger")
local tablex = require("pl.tablex")
local stringx = require("pl.stringx")
local List = require("pl.List")

local World = {
    run_simulation = false,
    simulation_step = false,
    cell_size = 30,
    max_x = 0,
    max_y = 0,
    mouse_cell = {
        x = 0,
        y = 0
    },
    cells = nil,
    init_state = nil
}

function World:new(window_width, window_height, cell_size)
    local o = {
        max_x = math.floor(window_width / cell_size),
        max_y = math.floor(window_height / cell_size)
    }
    setmetatable(o, self)
    self.__index = self
    o.cell_size = cell_size
    log.trace("max_x = " .. o.max_x .. "; window_width = " .. window_width .. "; ")
    log.trace("max_y = " .. o.max_y .. "; window_height = " .. window_height .. "; ")
    log.trace("cell_size = " .. cell_size .. ";")
    o.cells = Cells:new()
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
    local get_cells = function(content)
        local cells = List.new()
        local lines = stringx.lines(content)
        log.trace("[load] lines = \n" .. content)
        local max_x = 0
        local y = 0
        for line in lines do
            local x = 0
            for column in line:gmatch(".") do
                if column ~= " " then
                    cells:append({ x = x, y = y })
                end
                x = x + 1
                max_x = math.max(max_x, x)
            end
            y = y + 1
        end
        return cells, max_x, y
    end
    local translate = function(cells, top_x, top_y)
        local translate_x = math.floor((self.max_x - top_x) / 2)
        local translate_y = math.floor((self.max_y - top_y) / 2)
        for cell in List.iterate(cells) do
            cell.x = cell.x + translate_x
            cell.y = cell.y + translate_y
        end
    end
    local cells, top_x, top_y = get_cells(get_content())
    translate(cells, top_x, top_y)
    for cell in List.iterate(cells) do
        self.cells:activate_cell_at(cell.x, cell.y)
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
    if self.init_state ~= nil then
        self:load(self.init_state)
    end
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