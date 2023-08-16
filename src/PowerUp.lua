--[[
    PowerUp.lua
]]

PowerUp = Class{__includes = Entity}

function PowerUp:init(def)
    self.x = def.x
    self.y = def.y
    self.dx = def.dx
    --self.dy = def.dy
    self.direction = def.direction
    self.type = 'powerup'
    self.texture = 'powerup'
    self.hbOffX = 0
    self.width = 15
    self.height = 15
    self.obtained = false
    -- Needed to run entity's collide method.
    self.invincible = false
    self.dead = false
end

function PowerUp:update(dt)
    if not self.obtained then
        self.x = self.x + POWERUP_DRIFTING_SPEED * self.direction * dt
    end
end

function PowerUp:render()
    if not self.obtained then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gTextures['powerup'], self.x, self.y)
    end
end