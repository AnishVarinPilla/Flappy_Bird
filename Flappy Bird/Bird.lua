Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.x = Virtual_Width / 2 - 8
    self.y = Virtual_Height / 2 - 8

    self.dy = 0
end

function Bird:update(dt)
    self.dy = self.dy + GRAVITY * dt

    if love.keyboard.wasPressed('space') then
        self.dy = -5
        sounds['jump']:play()
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end