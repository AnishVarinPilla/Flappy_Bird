PlayState=Class{__includes=BaseState}

Pipe_Speed=60
Pipe_Height=288
Pipe_Width= 70

Bird_Width=38
Bird_Height=24

function PlayState:init()
    self.bird=Bird()
    self.pipePairs={}
    self.timer=0
    self.score=0

    self.lastY= -Pipe_Height+math.random(80)+20
end

function PlayState:update(dt)
    sounds['intro']:play()
    if self.timer > 2 then
        -- modify the last Y coordinate we placed so pipe gaps aren't too far apart
        local y = math.max(-Pipe_Height + 10, math.min(self.lastY + math.random(-20, 20), Pipe_Height / 3))

        table.insert(self.pipePairs, {
            -- flag to store whether we've scored the point for this pair of pipes
            scored = false,
            pipes = {
                Pipe('top', y),
                Pipe('bottom', y + Pipe_Height + 90)
            }
        })

        -- reset timer
        self.timer = 0
    end

    for k, pair in pairs(self.pipePairs) do
        local doRemove = false

        for l, pipe in pairs(pair.pipes) do
            -- score a point if the pipe has gone past the bird to the left all the way
            if not pair.scored then
                if pipe.x + Pipe_Width < self.bird.x then
                    self.score = self.score + 1
                    pair.scored = true
                    sounds['score']:play()
                end
            end

            -- remove the pipe from the scene if it's beyond the left edge of the screen,
            -- else move it from right to left
            if pipe.x > -72 then
                pipe.x = pipe.x - Pipe_Speed * dt
            else
                doRemove = true
            end
        end

        if doRemove then
            table.remove(self.pipePairs, k)
        end
    end

    self.timer = self.timer + dt

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('title')
    end

    -- simple collision between bird and all pipes
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            if (self.bird.x + 2) + (Bird_Width - 4) >= pipe.x and self.bird.x + 2 <= pipe.x + Pipe_Width then
                if (self.bird.y + 2) + (Bird_Height - 4) >= pipe.y and self.bird.y + 2 <= pipe.y + Pipe_Height then
                    sounds['explosion']:play()
                    sounds['hurt']:play()

                    gStateMachine:change('score', {
                        score = self.score
                    })
                end
            end
        end
    end

    -- reset if we get to the ground
    if self.bird.y > Virtual_Height - 15 then
        gStateMachine:change('score', {
            score = self.score
        })
    end

    -- reset if we get above the screen
    if self.bird.y <0 then
        gStateMachine:change('score', {
            score = self.score
        })
    end

    self.bird:update(dt)
end

function PlayState:render()
    for k, pair in pairs(self.pipePairs) do
        for l, pipe in pairs(pair.pipes) do
            pipe:render()
        end
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end

--[[
    Called when this state is transitioned to from another state.
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end

--[[
    Called when this state changes to another state.
]]
function PlayState:exit()
    -- stop scrolling for the death/score screen
    scrolling = false
end

