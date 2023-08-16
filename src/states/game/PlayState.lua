--[[
    PlayState
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.direction = -1
    self.waveManager = WaveManager()
    Timer.every(4, function()
        self.waveManager:newWave(self.direction)
    end)
    self.player = Player({
        x = 16,
        y = 16,
        width = 26,
        height = 12,
        texture = 'playerIdle'
    })
    self.player.stateMachine = StateMachine({
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['moving'] = function() return PlayerMovingState(self.player) end
    })
    self.player:changeState('idle')
    self.score = 0
    self.chain = 0
    self.chainX = 4
    self.chainAlign = "left"
    self.multiplierIndex = 0
    self.multiplierTable = {0.25, 0.5, 0.75, 1}
    self.powerups = {}
    self.explosions = {}
    self.warping = false
    self.gameover = false
end

function PlayState:enter()
    if love.filesystem.getInfo('hiscore') ~= nil then
        local t = TSerial.unpack(love.filesystem.read('hiscore'))
        self.hiScore = t[1]
    else
        self.hiScore = 50000
    end
    self.Timer = 16
    Timer.tween(0.4, {[gLine] = {y = VIRTUAL_HEIGHT}})
    self.onPlanetA = true
    -- Ensure music is looping
    gSounds['bgm']:setLooping(true)
    -- Play the music
    gSounds['bgm']:play()
end

function PlayState:update(dt)
    for k, explosion in pairs(self.explosions) do
        explosion:update(dt)
        if explosion.opacity == 0 then self.explosions[k] = nil end
    end
    if not self.gameover then
        self.Timer = self.Timer - dt
        if self.Timer <= 1 and not self.warping then
            if self.onPlanetA then
                tween = {[gLine] = {y = 0}}
                self.direction = 1
                self.onPlanetA = false
                self.player:warp(VIRTUAL_WIDTH - 26, self.player.y)
                self.waveManager:warp()
            else
                tween = {[gLine] = {y = VIRTUAL_HEIGHT}}
                self.direction = -1
                self.onPlanetA = true
                self.player:warp(16, self.player.y)
                self.waveManager:warp()
            end
            Timer.after(1, function()
                Timer.tween(0.4, tween)
                self.chainX = self.direction < 0 and 4 or VIRTUAL_WIDTH * 2 / 3 - 4
                if self.direction == 1 then self.chainAlign = 'right' else self.chainAlign = 'left' end
                self.warping = false
                self.Timer = 16
                self.player.bullets = {}
                self.player.bulletTimer = 0.5
                self.powerups = {}
                self.explosions = {}
                self.waveManager:clearBullets()
            end)
            self.warping = true        
        end

        self.player:update(dt)
        self.waveManager:update(dt)
        if not self.player.poweredUp and (self.chain ~= 0 or self.multiplierIndex ~= 0) then
            self.chain = 0
            self.multiplierIndex = 0
        end
        for k, powerup in pairs(self.powerups) do
            powerup:update(dt)
            if powerup:collides(self.player) and not powerup.obtained then
                gSounds['powerup']:stop()
                gSounds['powerup']:play()
                powerup.obtained = true
                self.player:powerUp()
            end
            if powerup.obtained then self.powerups[k] = nil end
        end
        for i, wave in pairs(self.waveManager.waves) do
            for j, enemy in pairs(wave.enemyGroup) do
                for z, bullet in pairs(enemy.bullets) do
                    if self.player:collides(bullet) and not bullet.destroyed then
                        bullet.destroyed = true
                        self:GameOver(self.player.x - self.player.hbOffX - 10, self.player.y - 5)
                    end
                end
                for k, bullet in pairs(self.player.bullets) do
                    if enemy:collides(bullet) and not bullet.destroyed then
                        if enemy:hit() then
                            gSounds['destroyed']:stop()
                            gSounds['destroyed']:play()
                            table.insert(self.explosions, Explosion(enemy.x - enemy.hbOffX - 10, enemy.y - 5)) 
                            if wave:oneDown(j) then 
                                table.insert(self.powerups, PowerUp({
                                    x = enemy.x,
                                    y = enemy.y,
                                    dx = enemy.dx,
                                    direction = enemy.direction
                                })) 
                            end
                            if self.player.poweredUp then
                                self.chain = self.chain + 1
                                self.multiplierIndex = math.min(4, math.floor(self.chain / 25))
                            end
                            if enemy.level > 1 then                            
                                self.score = self.score + 100 + (100 * (self.multiplierIndex * 0.25))
                            else
                                self.score = self.score + 50 + (100 * (self.multiplierIndex * 0.25))                           
                            end
                            self.hiScore = math.max(self.hiScore, self.score)
                        else
                            gSounds['hit']:stop()
                            gSounds['hit']:play()
                        end
                        bullet.destroyed = true
                    end
                end
                if not enemy.dead and self.player:collides(enemy) then
                    self:GameOver(self.player.x - self.player.hbOffX - 10, self.player.y - 5)
                end
            end
        end
    end
end

function PlayState:GameOver(x, y)
    self.gameover = true
    self.player.dead = true
    Timer.clear()
    gSounds['bgm']:stop()
    gSounds['pDestroyed']:play()
    table.insert(self.explosions, Explosion(x, y))
    if self.score > 50000 then love.filesystem.write('hiscore', TSerial.pack({self.score}, false, false)) end
    Timer.after(0.5, function() gStateMachine:change('game-over') end)
end

function PlayState:render()
    self.player:render()
    self.waveManager:render()
    love.graphics.setColor(1, 1, 1, 1)
    for k, explosion in pairs(self.explosions) do
        explosion:render()
    end
    for k, powerup in pairs(self.powerups) do
        powerup:render()
    end
    love.graphics.setColor(1, 1, 1, 200/255)
    love.graphics.printf("Hi-Score: " .. tostring(self.hiScore), 0, 4, VIRTUAL_WIDTH / 2, "left")
    love.graphics.printf("Score: " .. tostring(self.score), VIRTUAL_WIDTH / 2, 4, VIRTUAL_WIDTH / 2, "right")
    if self.chain > 0 then
        love.graphics.setColor(210/255, 210/255, 210/255, 200/255)
        if self.multiplierIndex > 0 then
            love.graphics.setShader(self.player.whiteShader)
            self.player.whiteShader:send('WhiteFactor', self.player.opacity == 1 and 0 or 1)
            love.graphics.setFont(gFonts['rankText'])
            love.graphics.printf(RANK_TEXT[self.multiplierIndex], self.chainX, VIRTUAL_HEIGHT / 3 - 32, VIRTUAL_WIDTH / 3, self.chainAlign)
        end
        love.graphics.setFont(gFonts['small'])
        love.graphics.printf("CHAIN: " .. tostring(self.chain), self.chainX, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH / 3, self.chainAlign)
    end
    love.graphics.setShader()
    love.graphics.setColor(1, 1, 1, 1)
end