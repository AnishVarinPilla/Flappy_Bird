Pipe = Class{}

-- since we only want the image loaded once, not per instantation, define it externally
local PIPE_IMAGE = love.graphics.newImage('pipe.png')

function Pipe:init(orientation, y)
    self.x = Virtual_Width + 64
    self.y = y
    self.orientation = orientation
    self.scored = false
end

function Pipe:update(dt)
    
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor((self.orientation == 'top' and self.y + Pipe_Height or self.y) + 0.5), 
        0, --Rotation
        1, --from where you wanna start the read of image along x axis
        self.orientation == 'top' and -1 or 1) -- from where you wanna start the read of image along y axis
end