PipePair = Class{}

local Gap_Height = 90

function PipePair:init(y)
    self.x=Virtual_Width+32
    self.y= y 
    self.pipes ={
        ['upper']=Pipe('top',self.y),
        ['lower'] = Pipe('bottom', self.y+Pipe_Height+Gap_Height)
    }
    self.remove = false --wether the pipe pair is ready to be removed or not
end

function PipePair:update(dt)

    if self.x> -Pipe_Width then 
        self.x = self.x - Pipe_Speed * dt
        self.pipes['lower'].x=self.x
        self.pipes['upper'].x=self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for k , pipe in pairs (self.pipes) do 
        pipe:render()   
    end
end
