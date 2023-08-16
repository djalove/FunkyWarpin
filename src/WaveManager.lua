--[[
    WaveManager.lua
]]

WaveManager = Class{}

function WaveManager:init()
    self.waves = {}
    self:newWave(-1)
end

function WaveManager:newWave(direction)
    local waveTypeIndex = math.random(#WAVE_TYPES)
    table.insert(self.waves, Wave(WAVETYPE_DEF[WAVE_TYPES[waveTypeIndex] ], WAVE_TYPES[waveTypeIndex], direction))
end

function WaveManager:warp()
    for k, wave in pairs(self.waves) do
        wave:warp()
    end
end

function WaveManager:update(dt)
    for k, wave in pairs(self.waves) do
        wave:update(dt)
    end
end

function WaveManager:render()
    for k, wave in pairs(self.waves) do
        wave:render()
    end
end

    
function WaveManager:clearBullets()
    for k, wave in pairs(self.waves) do
        wave:clearBullets()
    end
end