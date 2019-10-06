Door = Entity:extend()

function Door:new(x, y)
    Door.super.new(self, x, y, "img/door.png")
end

function Door:draw()
    love.graphics.draw(self.image, self.x, self.y)
end