--[[
    Bullet.lua
]]

Bullet = Class{}

function Bullet:init(def, x, y, direction)
    self.type = def.type
    self.texture = def.texture    
    self.width = def.width
    self.height = def.height
    self.destroyed = false
    self.bulletMoveSpeed = def.bulletMoveSpeed
    self.direction = direction
    self.x = x
    self.y = y
    if self.texture == 'vertdown' or self.texture == 'vertup' then
        self.x = self.x - (17) * self.direction
    end
    self.dx = self:getDX()
    self.dy = self:getDY()
    self.rotation = 0
    

    self.hbOffX = self.direction > 0 and 0 or self.width
end

function Bullet:update(dt)
    if not self.destroyed then
        if self.dx ~= 0 and self.dy ~= 0 then
            self.dx = self.dx / self.bulletMoveSpeed
            self.dy = self.dy / self.bulletMoveSpeed
        end
        self.x = self.x + self.dx * dt
        self.y = self.y + self.dy * dt 
        if self.texture == 'spinner' then
            self.rotation = (self.rotation + (2 * math.pi / 16)) % (2 * math.pi)
        end
    end
end

function Bullet:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or self.y + self.height < target.y or self.y > target.y + target.height)
end

function Bullet:render()
    if not self.destroyed then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(gTextures[self.texture], self.x, self.y, self.rotation, self.direction, 1)
    end
end

function Bullet:getDX()
    if self.type == 'player' then return self.bulletMoveSpeed * self.direction end
    if self.texture == 'flare' then
        return self.bulletMoveSpeed * self.direction
    elseif self.texture == 'spinner' then
        return self.bulletMoveSpeed * self.direction
    elseif self.texture == 'bubble' then
        return self.bulletMoveSpeed * self.direction
    elseif self.texture == 'fireball' then
        return self.bulletMoveSpeed * self.direction
    elseif self.texture == 'horiz' then
        return self.bulletMoveSpeed * self.direction
    elseif self.texture == 'upright' then
        return self.bulletMoveSpeed * ((VIRTUAL_WIDTH - self.x) / (VIRTUAL_HEIGHT / self.y)) * self.direction
    elseif self.texture == 'downright' then
        return self.bulletMoveSpeed * ((VIRTUAL_WIDTH - self.x) / (VIRTUAL_HEIGHT / self.y)) * self.direction
    elseif self.texture == 'vertdown' then
        return 0
    elseif self.texture == 'vertup' then
        return 0
    end
end

function Bullet:getDY()
    if self.type == 'player' then return 0 end
    if self.texture == 'flare' then
        return 0
    elseif self.texture == 'spinner' then
        return 0
    elseif self.texture == 'bubble' then
        return 0
    elseif self.texture == 'fireball' then
        return 0
    elseif self.texture == 'horiz' then
        return 0
    elseif self.texture == 'upright' then
        return -self.bulletMoveSpeed
    elseif self.texture == 'downright' then
        return self.bulletMoveSpeed
    elseif self.texture == 'vertdown' then
        return self.bulletMoveSpeed
    elseif self.texture == 'vertup' then
        return -self.bulletMoveSpeed
    end
end