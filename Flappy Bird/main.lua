push =require 'push'

Class = require 'class'

require 'Bird' --calling the Bird Class to the main 

require 'Pipe' --calling the  Pipe class to the main but it is mainly used by its parent class PipePair

require 'PipePair' --calling the PipePair class to the main 

--Below is the class/library along with the states present and needed in the game 

require 'StateMachine'
require 'states/BaseState'
require 'states/PlayState'
require 'states/TitleScreenState'
require 'states/CountdownState'
require 'states/ScoreState'

--Creating a graphic window with those dimensions

Window_Width=1280
Window_Height=720

--Creating a virtual window where all of our assets(objects) will be displayed on and keeping the resolution independent to have a clear sharp objects

Virtual_Width=512
Virtual_Height=288

local background = love.graphics.newImage('background.png') --loading an image 
local backgroundScroll = 0     --initializing the scrolling of the image to 0
local backgroundScroll_Speed=30 --initializing the speed of the scrolling of the image
local background_Loop_Point=413 --initializing a value in horizontal axis to push back the image to the original position
--when it passes the 413th co-ordinate

--same thing as before but for the ground image and did not initialize a looping point for the ground
local ground = love.graphics.newImage('ground.png')
local groundScroll=0
local groundScroll_Speed=90

 

local pipePairs = {} --creating a empty table to take in a pair of pipes (the upper and lower pipes) as one and keep track of it using a key

local spawnTimer=0 --initializing a variable to check take in time so that we can spawn pipes at periodic intervals

local scrolling=true --this is done to make the scrolling turn off or on depending on the state or collisions

local lastY= -Pipe_Height + math.random(80)+20 --taking in the Y value of the previous pipe to create the next set of pipes with respect to it


function love.load()

    love.graphics.setDefaultFilter('nearest','nearest') --setting a filter so that when the window is resized or rendered it will not blue the image
    love.window.setTitle('Flappy Bird') --setting a name for the Graphic Window 

    smallFont =love.graphics.newFont('font_1.ttf',8)
    mediumFont=love.graphics.newFont('flappy.ttf',14)
    flappyFont=love.graphics.newFont('flappy.ttf',28)
    hugeFont=love.graphics.newFont('flappy.ttf',56)
    love.graphics.setFont(flappyFont)

    --Setting up the Graphic Window with all the parameters and vitual screen parameters

    push:setupScreen(Virtual_Width,Virtual_Height,Window_Width,Window_Height,
    {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['intro'] = love.audio.newSource('intro.wav','stream'),
        ['home']= love.audio.newSource('home.wav','stream')
    }

    love.keyboard.keysPressed={} --creating a table to take in keyboard inputs

    gStateMachine=StateMachine{
        ['title']=function() return TitleScreenState() end,
        ['play']=function() return PlayState() end,
        ['score']=function() return ScoreState() end,
        ['countdown']=function() return CountdownState()end,
    }

    gStateMachine:change('title')
    

    math.randomseed(os.time()) --to give a timer to the game so that all the objects will follow one set of time.

end

function love.resize(w,h)

    push:resize(w,h) --to resize the window however we want 

end

function love.keypressed(key)

    love.keyboard.keysPressed[key] = true --it takes the keyboard input and declares it true everytime 

    if key=='escape' then 
        love.event.quit() --to close the graphic window 
    end

end

function love.update(dt)
    
    if scrolling then
        backgroundScroll = (backgroundScroll + backgroundScroll_Speed * dt) % background_Loop_Point
        groundScroll = (groundScroll + groundScroll_Speed * dt) % Virtual_Width
    end

    gStateMachine:update(dt)
    
    love.keyboard.keysPressed={}
end


function love.draw()

   push:start()

     love.graphics.draw(background,-backgroundScroll,0)

     gStateMachine:render()

     love.graphics.draw(ground,-groundScroll,Virtual_Height-16)

     

   push:finish()
end

function love.keyboard.wasPressed(key)

     if love.keyboard.keysPressed[key] then 
        return true
     else
        return false
    
     end

end

