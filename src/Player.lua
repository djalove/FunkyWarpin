--[[
    Player.lua
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.hbOffset = {x = 17, y = 4, width = 2, height = 2}
    self.dy = 0
    self.dx = 0
    self.bulletTimer = 0
    self.bullets = {}
    self.poweredUp = false
    self.powerupTimer = 0
end

function Player:collides(target)
    return not (self.x + self.hbOffset.x + self.hbOffset.width - self.hbOffX < target.x - target.hbOffX or self.x + (self.width - self.hbOffset.x) - self.hbOffX > target.x + target.width - target.hbOffX or self.y + self.hbOffset.y + self.hbOffset.height < target.y or self.y + self.hbOffset.y > target.y + target.height) and not self.invincible
end

function Player:update(dt)
    if love.keyboard.isDown('up') then
        self.texture = 'playerTurnUp'
        self.dy = -PLAYER_MOVE_SPEED
        self.y = math.max(8, self.y + self.dy * dt)
    elseif love.keyboard.isDown('down') then
        self.texture = 'playerTurnDown'
        self.dy = PLAYER_MOVE_SPEED
        self.y = math.min(VIRTUAL_HEIGHT - 8 - self.height, self.y + self.dy * dt)
    else
        self.texture = 'playerIdle'
        self.dy = 0
    end

    if love.keyboard.isDown('left') then
        self.dx = -PLAYER_MOVE_SPEED
        local leftMax = self.direction > 0 and 0 or self.width
        self.x = math.max(leftMax, self.x + self.dx * dt)
    elseif love.keyboard.isDown('right') then
        self.dx = PLAYER_MOVE_SPEED
        local rightMin = self.direction > 0 and VIRTUAL_WIDTH - self.width or VIRTUAL_WIDTH
        self.x = math.min(rightMin, self.x + self.dx * dt)
    else
        self.dx = 0
    end

    if self.dx ~= 0 and self.dy ~= 0 then
        self.dx = self.dx / PLAYER_MOVE_SPEED
        self.dy = self.dy / PLAYER_MOVE_SPEED
    end

    if love.keyboard.isDown('space') and self.bulletTimer <= 0 then
        self:shootBullet()
    end
    for k, bullet in pairs(self.bullets) do
        bullet:update(dt)
        if bullet.x > VIRTUAL_WIDTH or bullet.x - bullet.hbOffX < 0 or bullet.destroyed then
            self.bullets[k] = nil --bullet = nil
        end        
    end
    if self.bulletTimer > 0 then 
        self.bulletTimer = self.bulletTimer - dt
    end
    if self.powerupTimer > 0 then
        if not self.warping then self.powerupTimer = self.powerupTimer - dt end
    else
        self.poweredUp = false
    end
end

function Player:shootBullet()
        if self.poweredUp then
            gSounds['pPower']:stop()
            gSounds['pPower']:play()
            table.insert(self.bullets, Bullet(BULLET_DEF['pPower'], self.x + self.width * self.direction, self.y, self.direction))
            self.bulletTimer = POW_BULLET_WAIT_TIME
        else
            gSounds['pBasic']:stop()
            gSounds['pBasic']:play()
            table.insert(self.bullets, Bullet(BULLET_DEF['pBasic'], self.x + self.width * self.direction, self.y, self.direction))
            self.bulletTimer = BULLET_WAIT_TIME
        end
end

function Player:powerUp()
    self.poweredUp = true
    self.powerupTimer = math.min(16, self.powerupTimer + 4)
end

function Player:render()
    for k, bullet in pairs(self.bullets) do
        bullet:render()
    end
    if not self.dead then
        Entity.render(self)
    end
    
end