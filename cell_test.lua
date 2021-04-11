luaunit = require('luaunit')
Cell = require('cell')

function testCreateCell()
    local cell = Cell:new({x = 10, y = 11})
    luaunit.assertEquals(cell.x, 10)
    luaunit.assertEquals(cell.y, 11)
end

function testCreateEmptyCell()
    local cell = Cell:new()
    luaunit.assertEquals(cell.x, 0)
    luaunit.assertEquals(cell.y, 0)
end

os.exit(luaunit.LuaUnit.run())