require("collision")

function love.load()
    math.randomseed(os.time())

    player = {}
    player.x = 50
    player.y = 300
    player.w = 85
    player.h = 100
    player.direction = "down"

    coins = {}

    score = 0

    sounds = {}
    sounds.coin = love.audio.newSource("assets/sounds/coin.ogg", "static")

    fonts = {}
    fonts.large = love.graphics.newFont("assets/fonts/gamer.ttf", 36)

    images = {}
    images.background = love.graphics.newImage("assets/images/ground.png")
    images.coin = love.graphics.newImage("assets/images/coin.png")
    images.player_right = love.graphics.newImage("assets/images/player/player_right.png")
    images.player_left = love.graphics.newImage("assets/images/player/player_left.png")
    images.player_up = love.graphics.newImage("assets/images/player/player_up.png")
    images.player_down = love.graphics.newImage("assets/images/player/player_down.png")
end

function love.update(dt)
    if love.keyboard.isDown("d") then
        player.x = player.x + 4
        player.direction = "right"
    elseif love.keyboard.isDown("a") then
        player.x = player.x - 4
        player.direction = "left"
    elseif love.keyboard.isDown("w") then
        player.y = player.y - 4
        player.direction = "up"
    elseif love.keyboard.isDown("s") then
        player.y = player.y + 4
        player.direction = "down"
    end

    for i = #coins, 1, -1 do
        if AABB(player.x, player.y, player.w, player.h, coins[i].x, coins[i].y, coins[i].w, coins[i].h) then
            table.remove(coins, i)
            score = score + 1
            sounds.coin:play()
        end
    end

    if math.random() < 0.01 then
        local coin = {}
        coin.w = 55
        coin.h = 55
        coin.x = math.random(0, 800 - coin.w)
        coin.y = math.random(0, 600 - coin.h)

        table.insert(coins, coin)
    end
end

function love.draw()
    for x=0, love.graphics.getWidth(), images.background:getWidth() do
        for y=0, love.graphics.getHeight(), images.background:getHeight() do
            love.graphics.draw(images.background, x, y)
        end
    end

    if player.direction == "right" then
        love.graphics.draw(images.player_right, player.x, player.y)
    elseif player.direction == "left" then
        love.graphics.draw(images.player_left, player.x, player.y)
    elseif player.direction == "up" then
        love.graphics.draw(images.player_up, player.x, player.y)
    elseif player.direction == "down" then
        love.graphics.draw(images.player_down, player.x, player.y)
    end
    
    for i = #coins, 1, -1 do
        love.graphics.draw(images.coin, coins[i].x, coins[i].y)
    end
    
    love.graphics.setColor(0, 1, 1)
    love.graphics.setFont(fonts.large)
    love.graphics.print("Score: " .. score, 10, 10)

    love.graphics.setColor(1, 1, 1)
end