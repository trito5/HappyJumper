Player = Entity:extend()

function Player:new(x, y)
    Player.super.new(self, x, y, "img/player_start.png", 5)
    self.strength = 10
    self.canJump = false
    self.hasShoes = false
    self.hasColorSwitch = false
    self.hasLadder = false
    self.canMoveUp = false
    self.hasKey = false
    self.hasWon = false
    self.hasGameOver = false
end

function Player:update(dt)
    if self.y > 600 then
        self.hasGameOver = true
    end
    Player.super.update(self, dt)
    self.canMoveUp = false
    if love.keyboard.isDown("left") then
        self.x = self.x - 200 * dt
    elseif love.keyboard.isDown("right") then
        self.x = self.x + 200 * dt
    end

    if self.last.y ~= self.y then
        self.canJump = false
    end
end

function Player:draw()
    love.graphics.draw(self.image, self.x, self.y)
end

function Player:jump()
    if self.canJump and self.hasShoes then
        self.gravity = -300
        self.canJump = false
        if self.hasColorSwitch then
            self:changePlayer("jumpglasses")
        else
            self:changePlayer("jump")
        end
        jump:play()
    end
end
function Player:moveUp()
    if self.canMoveUp then
        self.y = self.y - 10
        self.gravity = -50
        foot:play()
    end
end

function Player:collide(e, direction)
    Player.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canJump = true
        if self.hasColorSwitch then
            self:changePlayer("glasses")
        elseif self.hasShoes then
            self:changePlayer("shoes")
        end
    end
end

function Entity:resolveCollision(e)
    if self.tempStrength > e.tempStrength then
        return e:resolveCollision(self)
    end

    if self:checkCollision(e) then
        self.tempStrength = e.tempStrength
        if self:wasVerticallyAligned(e) then
            if self.x + self.width/2 < e.x + e.width/2 then
                local a = self:checkResolve(e, "right")
                local b = e:checkResolve(self, "left")
                if a and b then
                    self:collide(e, "right")
                end
            else
                local a = self:checkResolve(e, "left")
                local b = e:checkResolve(self, "right")
                if a and b then
                    self:collide(e, "left")
                end
            end
        elseif self:wasHorizontallyAligned(e) then
            if self.y + self.height/2 < e.y + e.height/2 then
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "bottom")
                end
            else
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "top")
                end
            end
        end
        return true
    end
    return false
end

function Entity:checkResolve(e, direction)
    return true
end

function Player:changePlayer(image)
    if image == "jump" then
        self.image = love.graphics.newImage("img/player_jump.png")
    elseif image == "glasses" then
        self.image = love.graphics.newImage("img/player_shoes_glasses.png")
    elseif image == "shoes" then
        self.image = love.graphics.newImage("img/player_shoes.png")
    elseif image == "start" then
        self.image = love.graphics.newImage("img/player_start.png")
    else
        self.image = love.graphics.newImage("img/player_jump_glasses.png")
    end
end

function Player:checkResolve(e, direction)
    if e:is(Ladder) then 
        self.canMoveUp = true
        self.canJump = false
        if direction == "bottom" then
            return true
        end       
        return false
    end
    if e:is(Box) then
        if direction == "bottom" then
            return true
        else
            return false
        end
    end
    if e:is(Shoes) then
        takeShoes:play()
        e.x = 100
        e.y = -100  
        self.hasShoes = true
        self:changePlayer("shoes")
        return false
    end
    if e:is(ColorSwitch) then
        take:play()
        e.x = 100
        e.y = -100
        for i,v in ipairs(walls) do
            v:changeImage()
        end
        self.hasColorSwitch = true
        self:changePlayer("glasses")
        return false
    end

    if e:is(Ladderitem) then
        takeLadder:play()
        e.x = 100
        e.y = -100
        self.hasLadder = true
        return false
    end

    if e:is(Key) then
        takeKey:play()
        e.x = 100
        e.y = -100
        self.hasKey = true
        return false
    end

    if e:is(Door) then
        if self.hasKey then
            takeDoor:play()
            e.x = 100
            e.y = -100
            self.hasWon = true 
        else
            wrong:play()
            showMessage = true
        end
        return false
        
    end
   
   
    return true
end