--[[
    enemy_def.lua
]]

ENEMY_DEF = {
    ['square'] = {
        type = 'enemy',
        texture = 'square',
        width = 17,
        height = 17,
        hbOffsetX = 0,
        hbOffsetY = 0,
        hbWidth = 17,
        hbHeight = 17,
        firingOffX = 17/2,
        firingOffY = 17/2 - 4,
        bulletType = 'flare',
        firingRate = 1.5
        -- x and y are assigned in wave
        -- waves will put several groups of enemies beyond the border of the screen with a gap in between the first group and the rest. When the first group is defeated, the second group will be teleported up leaving the gap between that "2nd" group and the rest. When that group is defeated, the 3rd is teleported up to take its place and so on.
    },
    ['circle'] = {
        type = 'enemy',
        texture = 'circle',
        width = 17,
        height = 17,
        hbOffsetX = 1,
        hbOffsetY = 2,
        hbWidth = 15,
        hbHeight = 13,
        bulletType = 'spinner',
        firingOffX = 17/2,
        firingOffY = 17/2,
        firingRate = 2
    },
    ['tallrect'] = {
        type = 'enemy',
        texture = 'tallrect',
        width = 17,
        height = 27,
        hbOffsetX = 0,
        hbOffsetY = 0,
        hbWidth = 17,
        hbHeight = 27,
        bulletType = 'fireball',
        firingOffX = 17/2,
        firingOffY = 5,
        firingRate = 2.75
    },
    ['longrect'] = {
        type = 'enemy',
        texture = 'longrect',
        width = 25,
        height = 17,
        hbOffsetX = 0,
        hbOffsetY = 0,
        hbWidth = 25,
        hbHeight = 17,
        bulletType = 'bubble',
        firingOffX = 25,
        firingOffY = 0,
        firingRate = 2
    },
    ['tooth'] = {
        type = 'enemy',
        texture = 'tooth',
        width = 17,
        height = 17,
        hbOffsetX = 0,
        hbOffsetY = 0,
        hbWidth = 17,
        hbHeight = 17,
        bulletType = 'horiz',
        firingOffX = 17 / 2,
        firingOffY = 17 / 2 - 3,
        firingRate = 1
    },
    ['triangle'] = {
        type = 'enemy',
        texture = 'triangle',
        width = 17,
        height = 17,
        bulletType = 'vertdown',
        hbOffsetX = 3,
        hbOffsetY = 0,
        hbWidth = 11,
        hbHeight = 17,
        firingOffX = 22,
        firingOffY = 17,
        firingRate = 1.75
    },
    ['uptriangle'] = {
        type = 'enemy',
        texture = 'uptriangle',
        width = 17,
        height = 17,
        bulletType = 'vertup',
        hbOffsetX = 3,
        hbOffsetY = 0,
        hbWidth = 11,
        hbHeight = 17,
        firingOffX = 22,
        firingOffY = 0,
        firingRate = 1.75
    }
}

WAVETYPE_DEF = {
    --[[
        A, B, C, D, E, F, G
            A - Drifts in from the horizontal edge of the screen, stacked vertically (x = same; y = +height and padding (5px?))
            B - Comes in from the horizontal edge at quicker speed, stacked horizontally (y = same; x = +width and padding (5px?)
            C - Comes in at a diagonal from the horizontal edge of the screen (??)
            D - Drifts in from the upper edge of the screen stacked vertically (x = same; y = -height + padding (5px?)
            E - Drifts in from the lower edge of the screen
            stacked vertically (x = same; y = +height + padding (5px?))
            F - Drifts in from both vertical edges of the screen stacked horizontally (x = same; y = +/-height + padding (5px?))
            G - Drifts in from behind the player's ship stacked horizontally (y = same; x = -width + padding (5px))
    ]] 
    -- LEVEL 3 SHOOTS DIFFERENT BULLETS? (C = FIREBALL. Homing?)

    ['A'] = { -- SPINNER, TWO ON OPPOSING ENDS ARE LEVEL 2
        -- Diamond Shape
        ENEMY_DEF['square'], 
        ENEMY_DEF['square'],
        ENEMY_DEF['square'],
        ENEMY_DEF['square'],
        ENEMY_DEF['square'],
        ENEMY_DEF['square']
    },
    ['B'] = { -- UPRIGHT FOR TOP (trajectory = down left) DOWN RIGHT FOR BOTTOM (trajectory = up-left)
        -- Tall rectangles
        ENEMY_DEF['tallrect'],
        ENEMY_DEF['tallrect'],
        ENEMY_DEF['tallrect'],
        ENEMY_DEF['tallrect'],
        ENEMY_DEF['tallrect'],
        ENEMY_DEF['tallrect']
    },
    ['C'] = { -- FLARE (Two all the way at the back shoot horizontally; two front pairs should diagonally opposite their trajectory)
        -- Circles
        ENEMY_DEF['circle'],
        ENEMY_DEF['circle'],
        ENEMY_DEF['circle'],
        ENEMY_DEF['circle'],
        ENEMY_DEF['circle'],
        ENEMY_DEF['circle']
    },
    ['D'] = { -- BUBBLE (Slow movement speed) in both directions
        -- Long rectangles
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect']
    },
    ['E'] = { -- BUBBLE (Slow movement speed) in both directions
        -- Long rectangles
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect'],
        ENEMY_DEF['longrect']
    },
    ['F'] = { -- HORIZ
        -- Tooth shaped
        ENEMY_DEF['tooth'],
        ENEMY_DEF['tooth'],
        ENEMY_DEF['tooth'],
        ENEMY_DEF['tooth'],
        ENEMY_DEF['tooth'],
        ENEMY_DEF['tooth']
    },
    ['G'] = { -- VERT
        -- Tringle (Point down)
        ENEMY_DEF['triangle'],
        ENEMY_DEF['uptriangle'],
        ENEMY_DEF['triangle'],
        ENEMY_DEF['uptriangle'],
        ENEMY_DEF['triangle'],
        ENEMY_DEF['uptriangle']
    }

}