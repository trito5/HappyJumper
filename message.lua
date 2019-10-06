Message = Entity:extend()

function Message:new(x, y)
    Message.super.new(self, x, y, "img/white_tile.png")
end

function Message:draw(keyword)
    love.graphics.draw(self.image, 300, 300)
end

function Message:retrieve(content)
    if content == "key" then
        self.image = love.graphics.newImage("img/message_key.png")
    else
        self.image = love.graphics.newImage("img/message_shoes.png")
    end
end