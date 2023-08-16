--[[
    GameOverState.lua
]]

GameOverState = Class{__includes = BaseState}

function GameOverState:init()
    
end

function GameOverState:enter()
    Timer.tween(0.4, {[gLine] = {y = VIRTUAL_HEIGHT / 2}})
    gSounds['bgm']:stop()
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
    end
end

function GameOverState:render()
    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.printf('GAME OVER', 0, 16, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.printf('Press Enter to try again', 0, 180, VIRTUAL_WIDTH, 'center')
end