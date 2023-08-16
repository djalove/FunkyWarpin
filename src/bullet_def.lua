--[[
    bullet_def.lua
]]

BULLET_DEF = {
    ['pBasic'] = {
        type = 'player',
        texture = 'pBasic',
        width = 11,
        height = 11,
        bulletMoveSpeed = 125        
    },
    ['pPower'] = {
        type = 'player',
        texture = 'pPower',
        width = 20,
        height = 10,
        bulletMoveSpeed = 145
    },
    ['flare'] = {
        type = 'enemy',
        texture = 'flare',
        width = 11,
        height = 11,
        bulletMoveSpeed = 100
    },
    ['spinner'] = {
        type = 'enemy',
        texture = 'spinner',
        width = 11,
        height = 11,
        bulletMoveSpeed = 110
    },
    ['bubble'] = {
        type = 'enemy',
        texture = 'bubble',
        width = 13,
        height = 12,
        bulletMoveSpeed = 65
    },
    ['fireball'] = {
        type = 'enemy',
        texture = 'fireball',
        width = 27,
        height = 11,
        bulletMoveSpeed = 120
    },
    ['horiz'] = {
        type = 'enemy',
        texture = 'horiz',
        width = 11,
        height = 7,
        bulletMoveSpeed = 115
    },
    ['upright'] = {
        type = 'enemy',
        texture = 'horiz',
        width = 10,
        height = 10,
        bulletMoveSpeed = 100
    },
    ['downright'] = {
        type = 'enemy',
        texture = 'downright',
        width = 10,
        height = 10,
        bulletMoveSpeed = 100
    },
    ['vertdown'] = {
        type = 'enemy',
        texture = 'vertdown',
        width = 7,
        height = 11,
        bulletMoveSpeed = 100
    },
    ['vertup'] = {
        type = 'enemy',
        texture = 'vertup',
        width = 7,
        height = 11,
        bulletMoveSpeed = 100
    }
}