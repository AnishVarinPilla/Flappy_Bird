TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:init()
    -- nothing
    
end

function TitleScreenState:update(dt)
    sounds['home']:play()
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Flappy Bird', 0, 64, Virtual_Width, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, Virtual_Width, 'center')
end