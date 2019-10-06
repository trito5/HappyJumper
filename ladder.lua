Ladder = Entity:extend()

function Ladder:new(x, y)
    Ladder.super.new(self, x, y, "img/ladder_big.png")
    self.isVisible = false            
end

function Ladder:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Ladder:changePos(x, y)
    self.x = x
    self.y = y
end