Shoes = Entity:extend()

function Shoes:new(x, y)
    Shoes.super.new(self, x, y, "img/shoes.png")
end

function Shoes:draw()
    love.graphics.draw(self.image, self.x, self.y)
end
