--[[
    PlayerIdleState.lua
]]

PlayerIdleState = Class{__includes = BaseState}

function PlayerIdleState:init(player)
    self.player = player
end

function PlayerIdleState:update(dt)
    if love.keyboard.isDown('left') or love.keyboard.isDown('right') or love.keyboard.isDown('up') or love.keyboard.isDown('down') then
        self.entity:changeState('moving')
    end

    if love.keyboard.wasPressed('space') then
        -- Run a method that fires a bullet (needs a timer to check whether or not a bullet can be fired)
    end
end

function PlayerIdleState:render()
    if not self.player.dead then
        love.graphics.setColor(1, 1, 1, self.player.opacity)
        love.graphics.setShader(self.player.whiteShader)
        self.player.whiteShader:send('WhiteFactor', self.player.warping and 1 or 0)
        love.graphics.draw(gTextures[self.player.texture], self.player.x, self.player.y, 0, self.player.direction, 1)
        love.graphics.setColor(30/255, 30/255, 1, self.player.opacity)
        love.graphics.setLineWidth(2)
        love.graphics.arc('line', 'open', self.player.x - self.player.hbOffX + 13, self.player.y + self.player.height / 2, self.player.width - 13, -math.pi / 2, (-math.pi / 2) + (math.pi * 2) * (self.player.powerupTimer == 0 and 0 or self.player.powerupTimer / 16))
        love.graphics.setShader()
        love.graphics.setColor(1, 1, 1, 1)
    end
    --love.graphics.rectangle('line', self.player.x - self.player.hbOffX, self.player.y, self.player.width, self.player.height)
    --love.graphics.rectangle('line', self.player.direction == 1 and (self.player.x - self.player.hbOffX + self.player.hbOffset.x) or (self.player.x - self.player.hbOffX + (self.player.width - self.player.hbOffset.x)), self.player.y + self.player.hbOffset.y, self.player.hbOffset.width, self.player.hbOffset.height)

end