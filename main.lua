function love.load()
    Object = require "classic"
    require "entity"
    require "player"
    require "wall"
    require "box"
    require "colorSwitch"
    require "shoes"
    require "ladderitem"
    require "ladder"
    require "key"
    require "door"
    require "message"

    player = Player(150, 400)
    shoes = Shoes(500, 500)
    box = Box(100, -100)
    ladderitem = Ladderitem(100, -100)
    colorSwitch = ColorSwitch(350, 200)
    ladder1 = Ladder(100, -300)
    ladder2 = Ladder(100, -268)
    ladder3 = Ladder(100, -236)
    ladder4 = Ladder(100, -204)
    key = Key(50, 50)
    door = Door(750, 500)
    message = Message(100, 100)

    objects = {}
    table.insert(objects, door)
    table.insert(objects, player)
    table.insert(objects, shoes)
    
    table.insert(objects, box)
    table.insert(objects, ladderitem)
    table.insert(objects, colorSwitch)
    table.insert(objects, ladder1)
    table.insert(objects, ladder2)
    table.insert(objects, ladder3)
    table.insert(objects, ladder4)
    table.insert(objects, key)
    
    background = love.graphics.newImage("img/background.png")
    instructions = love.graphics.newImage("img/instructions.png")
    gameOverText = love.graphics.newImage("img/gameover.png")

    bgMusic = love.audio.newSource("audio/nothing.mp3", "stream")
    jump = love.audio.newSource("audio/jump.wav", "stream")
    take = love.audio.newSource("audio/take1.wav", "stream")
    takeShoes = love.audio.newSource("audio/take2.wav", "stream")
    takeLadder = love.audio.newSource("audio/take3.wav", "stream")
    takeKey = love.audio.newSource("audio/key2.wav", "stream")
    foot = love.audio.newSource("audio/foot.wav", "stream")
    takeDoor = love.audio.newSource("audio/game_cleared.wav", "stream")
    wrong = love.audio.newSource("audio/hit.wav", "stream")
    endMusic = love.audio.newSource("audio/nothingend.mp3", "stream")
    gameOver = love.audio.newSource("audio/gameover.wav", "stream")

    endText = love.graphics.newImage("img/levels_cleared.png")
    init()
end

function love.update(dt)

    countMessageTime = countMessageTime + 1 * dt
    countMessageShoesTime = countMessageShoesTime + 1 * dt
    if player.hasWon then
        updateEndBg = updateEndBg + 1 * dt
    end
    if player.hasGameOver then
        player.y = - 100
        countGameOver = countGameOver + 1 * dt
    end
    if countGameOver > 2 then
        init()   
        restartGame()
       
    end

    if player.hasColorSwitch and not box.isVisible then
        box:changePos()
        ladderitem:changePos()
        box.isVisible = true
    end

    if player.hasLadder and not ladder1.isVisible then
        ladder1:changePos(760, 112)
        ladder2:changePos(760, 144)
        ladder3:changePos(760, 176)
        ladder4:changePos(760, 208)
        ladder1.isVisible = true
    end

    for i,v in ipairs(objects) do
        v:update(dt)
    end

    for i,v in ipairs(walls) do
        v:update(dt)
    end

    local loop = true
    local limit = 0

    while loop do
        loop = false

        limit = limit + 1
        if limit > 100 then
            break
        end

        for i=1,#objects-1 do
            for j=i+1,#objects do
                local collision = objects[i]:resolveCollision(objects[j])
                if collision then
                    loop = true
                end
            end
        end

        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                local collision = object:resolveCollision(wall)
                if collision then
                    loop = true
                end
            end
        end
    end
end

function love.draw()
    if player.hasWon then
        if updateEndBg > 2 then
            love.graphics.setBackgroundColor(love.math.random( ), love.math.random( ),  love.math.random( ))
            updateEndBg = 0
        end
        love.graphics.draw(endText, 0, 0)
        player:draw()
        bgMusic:stop()
        endMusic:play()
        endMusic:setLooping(true)
        fixWalls()
    elseif player.hasGameOver then
        love.graphics.setBackgroundColor(0, 0, 0)
        love.graphics.draw(gameOverText, 0, 0)
        if player.y > 0 then
            gameOver:play()
        end
    else
        if player.hasColorSwitch then
            love.graphics.draw(background, 1, 1)
        end
     
        for i,v in ipairs(objects) do
            v:draw()
        end

        for i,v in ipairs(walls) do
            v:draw()
        end
        if showMessage then
            message:retrieve("key")
            message:draw()
            if countMessageTime > 6 then
                showMessage = false
            end
        end

        if showMessageShoes then
            message:retrieve("shoes")
            message:draw()
            if countMessageShoesTime > 2 then
                showMessageShoes = false
            end
        end
        love.graphics.draw(instructions, 0, 0)
    end
end

function love.keypressed(key)
    if key == "space" then
        if player.hasShoes then
            player:jump()
        else
            showMessageShoes = true
            countMessageShoesTime = 0
        end
    end

    if key == "up" then
        player:moveUp()
    end
end

function init()
    
    bgMusic:setLooping(true)
    bgMusic:play()

    countMessageTime = 0
    countMessageShoesTime = 0
    updateEndBg = 10
    countGameOver = 0

    walls = {}

    map = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,1,1,0,0,0,0,1,1,1,1}
    }

    for i,v in ipairs(map) do
        for j,w in ipairs(v) do
            if w == 1 then
                table.insert(walls, Wall((j-1)*32, (i-1)*32))
            end
        end
    end
end

function restartGame()
    player.x = 150
    player.y = 400
    player.canJump = false
    player.hasShoes = false
    player.hasColorSwitch = false
    player.hasLadder = false
    player.canMoveUp = false
    player.hasKey = false
    player.hasWon = false
    player.hasGameOver = false
    player:changePlayer("start")

    shoes.x = 500
    shoes.y = 500
    box.x = 100
    box.y = -100
    box.isVisible = false
    ladderitem.x = 100
    ladderitem.y = -100
    ladderitem.isVisible = false
    colorSwitch.x = 350
    colorSwitch.y = 200
    ladder1.x = 100
    ladder1.y = -300
    ladder2.x = 100
    ladder2.y = -268
    ladder3.x = 100
    ladder3.y = -236
    ladder4.x = 100
    ladder4.y = -204
    ladder1.isVisible = false
    key.x = 50
    key.y = 50
end

function fixWalls()
    walls = {}

    map = {
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,1,1},
        {1,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
        {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
    }

    for i,v in ipairs(map) do
        for j,w in ipairs(v) do
            if w == 1 then
                table.insert(walls, Wall((j-1)*32, (i-1)*32))
            end
        end
    end
end