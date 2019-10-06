Ladderitem = Entity:extend()

function Ladderitem:new(x, y)
    Ladderitem.super.new(self, x, y, "img/ladder_small.png")
end

function Ladderitem:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Ladderitem:changePos()
    self.x = 50
    self.y = 100
end