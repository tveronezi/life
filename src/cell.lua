local Cell = {
    x = 0,
    y = 0
}

function Cell:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

return Cell
