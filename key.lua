Key = Entity:extend()

function Key:new(x, y)
    Key.super.new(self, x, y, "img/key.png")
    self.resetMe = false
end

function Key:draw()
    love.graphics.draw(self.image, self.x, self.y)
end