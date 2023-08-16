--[[
    StartState.lua
]]

StartState = Class{__includes = BaseState}

function StartState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('play')
        gSounds['title']:stop()
    end
end

function StartState:render()
    love.graphics.setFont(gFonts['title'])
    love.graphics.setColor(0, 0, 1, 1)
    love.graphics.printf('FUNKY WARPIN\'', 0, 16, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(1, 0, 0, 1)
    love.graphics.printf('Press Enter to START', 0, 180, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.printf('Programming/Music/Graphics: DJ Aloe (C) 2020.', 0, VIRTUAL_HEIGHT - 12, VIRTUAL_WIDTH, 'center')
end