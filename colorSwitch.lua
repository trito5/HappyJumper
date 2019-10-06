ColorSwitch = Entity:extend()

function ColorSwitch:new(x, y)
    ColorSwitch.super.new(self, x, y, "img/glasses.png")
end

function ColorSwitch:draw()
    love.graphics.draw(self.image, self.x, self.y)
end