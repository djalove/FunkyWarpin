--[[
    Wave.lua
]]

Wave = Class{}

function Wave:init(defs, waveType, direction)
    self.enemyGroup = {}
    for k, def in pairs(defs) do
        table.insert(self.enemyGroup, Entity(def))
    end
    self.waveType = waveType
    self.xOffset = self:getXOffset()
    self.yOffset = self:getYOffset()

    --mod = 0
    for k, enemy in pairs(self.enemyGroup) do
        -- Set each enemy's x,y using the offset obtained above
        enemy.direction = direction
        enemy.hbOffX = direction > 0 and 0 or enemy.width
        enemy.firingRate = enemy.firingRate + (0.5 * (k - 1))
        self:prepEnemy(k, direction)
        --[[ enemy.x = self:calculateX(enemy.direction, enemy.width, mod)
        enemy.y = self:calculateY(enemy.direction, enemy.height, mod)
        enemy.dx = self:calculateDX()
        enemy.dy = self:calculateDY(mod) ]]
        enemy.stateMachine = StateMachine({
            ['idle'] = function() return EntityIdleState(enemy) end
        })
        enemy:changeState('idle')
        --mod = mod + 1        
    end
    self.enemiesRemaining = #self.enemyGroup
    self.allDefeated = false
end

--[[
        A, B, C, D, E, F, G
            A - Drifts in from the horizontal edge of the screen, stacked vertically (x = same; y = +height and padding (5px?))
            B - Comes in from the horizontal edge at quicker speed, stacked horizontally (y = same; x = +width and padding (5px?)
            C - Comes in at a diagonal from the horizontal edge of the screen (??)
            D - Drifts in from the upper edge of the screen stackked vertically (x = same; y = -height + padding (5px?)
            E - Drifts in from the lower edge of the screen
            stacked vertically (x = same; y = +height + padding (5px?))
            F - Drifts in from both vertical edges of the screen stacked horizontally (x = same; y = +/-height + padding (5px?))
            G - Drifts in from behind the player's ship stacked horizontally (y = same; x = -width + padding (5px))
    ]] 

function Wave:getXOffset()
    if self.waveType == 'D' or self.waveType == 'E' then
        return VIRTUAL_WIDTH / 2
    else
        return 50
    end
end

function Wave:getYOffset()
    if self.waveType == 'B' or self.waveType == 'C' then
        return VIRTUAL_HEIGHT / 3
    else
        return 24
    end
end

function Wave:prepEnemy(index, dir)
    if self.waveType == 'A' then
        self.enemyGroup[index].x = dir < 0 and (self.xOffset + VIRTUAL_WIDTH + self.enemyGroup[index].width) or -self.xOffset - self.enemyGroup[index].width
        self.enemyGroup[index].y = self.yOffset + (self.enemyGroup[index].height + WAVE_PADDING) * (index - 1)
        self.enemyGroup[index].dx = ENTITY_DRIFTING_SPEED
        self.enemyGroup[index].dy = 0
    elseif self.waveType == 'B' then
        self.enemyGroup[index].x = dir < 0 and (self.xOffset + VIRTUAL_WIDTH + (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)) or -self.xOffset - (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)
        self.enemyGroup[index].y = (index - 1) % 2 == 0 and VIRTUAL_HEIGHT * 2 / 6 or VIRTUAL_HEIGHT * 4 / 6 
        self.enemyGroup[index].dx = ENTITY_DRIFTING_SPEED
        self.enemyGroup[index].dy = 0
    elseif self.waveType == 'C' then
        self.enemyGroup[index].x = dir < 0 and (self.xOffset + VIRTUAL_WIDTH + (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)) or -self.xOffset - (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)
        self.enemyGroup[index].y = (index - 1) % 2 == 0 and -self.yOffset or VIRTUAL_HEIGHT + self.yOffset
        self.enemyGroup[index].dx = ENTITY_DRIFTING_SPEED * VIRTUAL_WIDTH / VIRTUAL_HEIGHT
        self.enemyGroup[index].dy = (index - 1) % 2 == 0 and ENTITY_DRIFTING_SPEED or -ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'D' then
        self.enemyGroup[index].x = (index - 1) % 2 == 0 and VIRTUAL_WIDTH / 4 or VIRTUAL_WIDTH * 3 / 4
        self.enemyGroup[index].y = -self.yOffset - (self.enemyGroup[index].height + WAVE_PADDING) * (index - 1)
        self.enemyGroup[index].dx = 0 
        self.enemyGroup[index].dy = ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'E' then
        self.enemyGroup[index].x = (index - 1) % 2 == 0 and VIRTUAL_WIDTH / 4 or VIRTUAL_WIDTH * 3 / 4
        self.enemyGroup[index].y = VIRTUAL_HEIGHT + self.yOffset + (self.enemyGroup[index].height + WAVE_PADDING) * (index - 1)
        self.enemyGroup[index].dx = 0 
        self.enemyGroup[index].dy = -ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'F' then
        self.enemyGroup[index].x = dir < 0 and (VIRTUAL_WIDTH / 3 + (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)) or VIRTUAL_WIDTH * 2 / 3 - (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)
        self.enemyGroup[index].y = (index - 1) % 2 == 0 and -self.yOffset * 2 or VIRTUAL_HEIGHT + self.yOffset * 2
        self.enemyGroup[index].dx = 0 
        self.enemyGroup[index].dy = (index - 1) % 2 == 0 and ENTITY_DRIFTING_SPEED / 2 or -ENTITY_DRIFTING_SPEED / 2
    elseif self.waveType == 'G' then
        self.enemyGroup[index].x = dir > 0 and (self.xOffset + VIRTUAL_WIDTH + (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)) or -self.xOffset - (self.enemyGroup[index].width + WAVE_PADDING) * (index - 1)
        self.enemyGroup[index].y = (index - 1) % 2 == 0 and VIRTUAL_HEIGHT / 6 or VIRTUAL_HEIGHT * 5 / 6 
        self.enemyGroup[index].dx = -ENTITY_DRIFTING_SPEED 
        self.enemyGroup[index].dy = 0
    end
end

function Wave:calculateX(dir, width, mod)
    if self.waveType == 'A' then
        return dir < 0 and (self.xOffset + VIRTUAL_WIDTH + width) or -self.xOffset - width
    elseif self.waveType == 'B' then
        return dir < 0 and (self.xOffset + VIRTUAL_WIDTH + (width + WAVE_PADDING) * mod) or -self.xOffset - (width + WAVE_PADDING) * mod
    elseif self.waveType == 'C' then
        return dir < 0 and (self.xOffset + VIRTUAL_WIDTH + (width + WAVE_PADDING) * mod) or -self.xOffset - (width + WAVE_PADDING) * mod
    elseif self.waveType == 'D' then
        return mod % 2 == 0 and VIRTUAL_WIDTH / 4 or VIRTUAL_WIDTH * 3 / 4
    elseif self.waveType == 'E' then
        return mod % 2 == 0 and VIRTUAL_WIDTH / 4 or VIRTUAL_WIDTH * 3 / 4
    elseif self.waveType == 'F' then
        return dir < 0 and (VIRTUAL_WIDTH / 3 + (width + WAVE_PADDING) * mod) or VIRTUAL_WIDTH * 2 / 3 - (width + WAVE_PADDING) * mod
    elseif self.waveType == 'G' then
        return dir > 0 and (self.xOffset + VIRTUAL_WIDTH + (width + WAVE_PADDING) * mod) or -self.xOffset - (width + WAVE_PADDING) * mod
    end
end

function Wave:calculateY(dir, height, mod)
    if self.waveType == 'A' then
        return self.yOffset + (height + WAVE_PADDING) * mod
    elseif self.waveType == 'B' then
        return mod % 2 == 0 and VIRTUAL_HEIGHT * 2 / 6 or VIRTUAL_HEIGHT * 4 / 6 
    elseif self.waveType == 'C' then
        return mod % 2 == 0 and -self.yOffset or VIRTUAL_HEIGHT + self.yOffset
    elseif self.waveType == 'D' then
        return -self.yOffset - (height + WAVE_PADDING) * mod
    elseif self.waveType == 'E' then
        return VIRTUAL_HEIGHT + self.yOffset + (height + WAVE_PADDING) * mod
    elseif self.waveType == 'F' then
        return mod % 2 == 0 and -self.yOffset * 2 or VIRTUAL_HEIGHT + self.yOffset * 2
    elseif self.waveType == 'G' then
        return mod % 2 == 0 and VIRTUAL_HEIGHT / 6 or VIRTUAL_HEIGHT * 5 / 6 
    end
end

function Wave:calculateDX()
    if self.waveType == 'A' then
        return ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'B' then
        return ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'C' then
        return ENTITY_DRIFTING_SPEED * VIRTUAL_WIDTH / VIRTUAL_HEIGHT
    elseif self.waveType == 'D' then
        return 0
    elseif self.waveType == 'E' then
        return 0
    elseif self.waveType == 'F' then
        return 0
    elseif self.waveType == 'G' then
        return -ENTITY_DRIFTING_SPEED
    end
end

function Wave:calculateDY(mod)
    if self.waveType == 'A' then
        return 0
    elseif self.waveType == 'B' then
        return 0
    elseif self.waveType == 'C' then
        return mod % 2 == 0 and ENTITY_DRIFTING_SPEED or -ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'D' then
        return ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'E' then
        return -ENTITY_DRIFTING_SPEED
    elseif self.waveType == 'F' then
        return mod % 2 == 0 and ENTITY_DRIFTING_SPEED / 2 or -ENTITY_DRIFTING_SPEED / 2
    elseif self.waveType == 'G' then
        return 0
        
    end
end

function Wave:warp()
    for k, enemy in pairs(self.enemyGroup) do
        if enemy.x > 0 and enemy.x + enemy.width < VIRTUAL_WIDTH and enemy.y + enemy.height > 0 and enemy.y < VIRTUAL_HEIGHT then
            enemy:warp(VIRTUAL_WIDTH / 2 + (VIRTUAL_WIDTH / 2 - enemy.x - enemy.hbOffX), enemy.y)--(self:calculateX(-enemy.direction, enemy.width, k - 1), self:calculateY(-enemy.direction, enemy.height, k - 1))
        else
            enemy.dead = true
        end
    end
end

function Wave:clearBullets()
    for k, enemy in pairs(self.enemyGroup) do
        if enemy.dead then self.enemyGroup[k] = nil --enemy = nil 
        else
            enemy.bullets = {}
        end
    end
end

function Wave:oneDown(index)
    self.enemyGroup[index].dead = true
    self.enemiesRemaining = self.enemiesRemaining - 1
    return self.enemiesRemaining == 3 or self.enemiesRemaining == 0
end

function Wave:update(dt)
    for k, enemy in pairs(self.enemyGroup) do
        enemy:update(dt)
    end
end

function Wave:render()
    for k, enemy in pairs(self.enemyGroup) do
        enemy:render()
    end
end