--[[
    EntityIdleState.lua
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity
    self.firingTimer = self.entity.firingRate
end

function EntityIdleState:update(dt)    
    if self.entity.dx ~= 0 then    
        self.entity.x = self.entity.x + self.entity.dx * self.entity.direction * dt
    end
    if self.entity.dy ~= 0 then
        self.entity.y = self.entity.y + self.entity.dy * dt
    end
    if self.firingTimer > 0 and not self.entity.warping then
        self.firingTimer = self.firingTimer - dt
    else
        self:shootBullet()
    end
end

function EntityIdleState:shootBullet()
    if not self.entity.warping then
        gSounds[self.entity.bulletType]:stop()
        gSounds[self.entity.bulletType]:play()
        table.insert(self.entity.bullets, Bullet(BULLET_DEF[self.entity.bulletType], self.entity.x + self.entity.firingOffX--[[/ 2]] * self.entity.direction, self.entity.y + self.entity.firingOffY, self.entity.direction))
        if self.entity.bulletType == 'bubble' then
            table.insert(self.entity.bullets, Bullet(BULLET_DEF[self.entity.bulletType], self.entity.x + self.entity.firingOffX + (self.entity.direction > 0 and -self.entity.firingOffX or self.entity.width) --[[/ 2]] * self.entity.direction, self.entity.y + self.entity.firingOffY, -self.entity.direction))
        end    
        self.firingTimer = self.entity.firingRate
    end
end

function EntityIdleState:render()
    love.graphics.setColor(1, 1, 1, self.entity.opacity)
    love.graphics.setShader(self.entity.whiteShader)
    self.entity.whiteShader:send('WhiteFactor', self.entity.warping and 1 or 0)
    self.entity.xOffset = self.entity.direction > 0 and 0 or self.width 
    love.graphics.draw(gTextures[self.entity.texture], self.entity.x, self.entity.y, 0, self.entity.direction, 1)
    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
    --love.graphics.rectangle('line', self.entity.x - self.entity.hbOffX, self.entity.y, self.entity.width, self.entity.height)
end