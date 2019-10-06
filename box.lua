Box = Entity:extend()

function Box:new(x, y)
    Box.super.new(self, x, y, "img/box.png")
    self.isVisible = false
end

function Box:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Box:changePos()
    self.x = 580
    self.y = 350
end