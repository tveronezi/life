local Cells = require('src/cells')

describe("cells", function()
    it("should create cells", function()
        assert.are.same({
            max_x = 20,
            max_y = 30,
            top_x = 0,
            top_y = 0,
            values = {},
            y_to_xs = {}
        }, Cells:new(20, 30))
    end)

    it("should toggle cell at", function()
        local cells = Cells:new(20, 30)
        cells:toggle_cell_at(1, 1)
        assert.are.same(cells.values, { ["1:1"] = { x = 1, y = 1 } })
        cells:toggle_cell_at(1, 1)
        assert.are.same(cells.values, {})
        cells:toggle_cell_at(1, 1)
        cells:toggle_cell_at(1, 2)
        cells:toggle_cell_at(1, 3)
        assert.are.same(cells.values, {
            ["1:1"] = { x = 1, y = 1 },
            ["1:2"] = { x = 1, y = 2 },
            ["1:3"] = { x = 1, y = 3 }
        })
    end)

    it("should get next cell value", function()
        local cells = Cells:new(100, 100)
        cells:toggle_cell_at(10, 10)
        cells:toggle_cell_at(10, 11)
        cells:toggle_cell_at(10, 12)
        assert.are.same(cells.values["10:11"], { x = 10, y = 11 })
        assert.are.same(cells.values["10:11"], { x = 10, y = 11 })
        assert.are.same(cells.values["10:11"], { x = 10, y = 11 })
    end)
end)
