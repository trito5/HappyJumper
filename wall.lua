Wall = Entity:extend()

function Wall:new(x, y)
    Wall.super.new(self, x, y, "img/white_tile.png", 1)
    self.strength = 100
    self.weight = 0
end

function Wall:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Wall:changeImage()
    self.image = love.graphics.newImage("img/blue_tile.png")
end