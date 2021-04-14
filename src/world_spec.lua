local World = require('src/world')

describe("world", function()
    it("should create a world", function()
        assert.are.same({
            max_x = 80,
            max_y = 60,
            top_x = 0,
            top_y = 0,
            values = {}
        }, World:new(800, 600, 10).cells)
        assert.are.same({
            max_x = 66,
            max_y = 50,
            top_x = 0,
            top_y = 0,
            values = {}
        }, World:new(800, 600, 12).cells)
        assert.are.same({
            max_x = 60,
            max_y = 40,
            top_x = 0,
            top_y = 0,
            values = {}
        }, World:new(1200, 800, 20).cells)
    end)
end)
