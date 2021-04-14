local Cells = require('src/cells')
local Set = require("pl.Set")
local tablex = require("pl.tablex")

describe("cells", function()
    it("should create cells", function()
        assert.are.same({
            max_x = 20,
            max_y = 30,
            values = {}
        }, Cells:new(20, 30))
    end)

    it("should toggle cell at", function()
        local cells = Cells:new(20, 30)
        cells:toggle_cell_at(1, 1)
        assert.are.same({ ["1:1"] = { x = 1, y = 1 } }, cells.values)
        cells:toggle_cell_at(1, 1)
        assert.are.same(cells.values, {})
        cells:toggle_cell_at(1, 1)
        cells:toggle_cell_at(1, 2)
        cells:toggle_cell_at(1, 3)
        assert.are.same({
            ["1:1"] = { x = 1, y = 1 },
            ["1:2"] = { x = 1, y = 2 },
            ["1:3"] = { x = 1, y = 3 }
        }, cells.values)
    end)

    it("should get next cell value", function()
        local cells = Cells:new(100, 100)
        cells:toggle_cell_at(10, 9)
        cells:toggle_cell_at(10, 10)
        cells:toggle_cell_at(10, 11)
        assert.are.same(Set({"10:10", "10:11", "10:9"}), Set(tablex.keys(cells.values)))
        assert.is.falsy(cells:get_next_cell_value(10, 9))
        assert.is.falsy(cells:get_next_cell_value(10, 11))
        assert.is.truthy(cells:get_next_cell_value(10, 10))
    end)
end)
