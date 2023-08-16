--[[
    Explosion.lua
]]

Explosion = Class{}

function Explosion:init(x, y)
    self.animationTimer = 0.25
    self.texture = 'explosion'
    self.x = x
    self.y = y
    self.opacity = 1
end

function Explosion:update(dt)
    if self.animationTimer > 0 then
        self.animationTimer = self.animationTimer - dt
    else
        self.texture = 'explosion2'
        Timer.tween(0.25, {[self] = {opacity = 0}})
    end
end

function Explosion:render()
    love.graphics.setColor(1, 1, 1, self.opacity)
    love.graphics.draw(gTextures[self.texture], self.x, self.y)
end