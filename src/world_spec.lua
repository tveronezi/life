local World = require('src/world')

describe("world", function()
    it("should create a world", function()
        assert.are.same({
            cell_size = 10,
            max_x = 80,
            max_y = 60,
            cells = {
                values = {}
            }
        }, World:new(800, 600, 10))
        assert.are.same({
            cell_size = 12,
            max_x = 66,
            max_y = 50,
            cells = {
                values = {}
            }
        }, World:new(800, 600, 12))
        assert.are.same({
            cell_size = 20,
            max_x = 60,
            max_y = 40,
            cells = {
                values = {}
            }
        }, World:new(1200, 800, 20))
    end)
end)
