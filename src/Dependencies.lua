--[[
    DEPENDENCIES.LUA
]]

Class = require 'lib/class'
Event = require 'lib/knife.event'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
require 'lib/TSerial'

require 'src/StateMachine'
require 'src/constants'
require 'src/Entity'
require 'src/Player'
require 'src/bullet_def'
require 'src/Bullet'
require 'src/PowerUp'
require 'src/Explosion'
--require 'src/Enemy'
require 'src/enemy_def'
require 'src/Wave'
require 'src/WaveManager'

require 'src/states/BaseState'

require 'src/states/entity/EntityIdleState'

require 'src/states/player/PlayerIdleState'
--require 'src/states/player/PlayerMovingState'

require 'src/states/game/GameOverState'
require 'src/states/game/PlayState'
require 'src/states/game/StartState'

gTextures = {
    -- PLAYER --
    ['playerIdle'] = love.graphics.newImage('graphics/player/idleEDIT.png'),
    ['playerTurnUp'] = love.graphics.newImage('graphics/player/turnUpEDIT.png'),
    ['playerTurnDown'] = love.graphics.newImage('graphics/player/turnDownEDIT.png'),
    -- POWERUP --
    ['powerup'] = love.graphics.newImage('graphics/powerup.png'),
    --EXPLOSIONS --
    ['explosion'] = love.graphics.newImage('graphics/explosion.png'),
    ['explosion2'] = love.graphics.newImage('graphics/explosion2.png'),
    -- PLANET A BACKGROUND
    ['planetA-back60'] = love.graphics.newImage('graphics/planetA/back60.png'),
    ['planetA-back80'] = love.graphics.newImage('graphics/planetA/back80.png'),
    ['planetA-back100'] = love.graphics.newImage('graphics/planetA/back100.png'),
    -- PLANET B BACKGROUND --
    ['planetB-back0'] = love.graphics.newImage('graphics/planetB/back0.png'),
    ['planetB-back1'] = love.graphics.newImage('graphics/planetB/back1.png'),
    ['planetB-back2'] = love.graphics.newImage('graphics/planetB/back2.png'),
    ['planetB-back3'] = love.graphics.newImage('graphics/planetB/back3.png'),
    ['planetB-back4'] = love.graphics.newImage('graphics/planetB/back4.png'),
    ['planetB-back5'] = love.graphics.newImage('graphics/planetB/back5.png'),
    ['planetB-back6'] = love.graphics.newImage('graphics/planetB/back6.png'),
    ['planetB-back7'] = love.graphics.newImage('graphics/planetB/back7.png'),
    -- BULLETS --
    ['pBasic'] = love.graphics.newImage('graphics/bullet/pBasic.png'),
    ['pPower'] = love.graphics.newImage('graphics/bullet/pPower.png'),
    ['flare'] = love.graphics.newImage('graphics/bullet/flare.png'),
    ['spinner'] = love.graphics.newImage('graphics/bullet/spinner.png'),
    ['bubble'] = love.graphics.newImage('graphics/bullet/bubble.png'),
    ['fireball'] = love.graphics.newImage('graphics/bullet/fireball.png'),
    ['horiz'] = love.graphics.newImage('graphics/bullet/horiz.png'),
    ['upright'] = love.graphics.newImage('graphics/bullet/upright.png'),
    ['downright'] = love.graphics.newImage('graphics/bullet/downright.png'),
    ['vertdown'] = love.graphics.newImage('graphics/bullet/vert.png'),
    ['vertup'] = love.graphics.newImage('graphics/bullet/vert.png'),
    --ENEMIES --
    ['square'] = love.graphics.newImage('graphics/enemy/Square.png'),
    ['square2'] = love.graphics.newImage('graphics/enemy/Square2.png'),
    ['square3'] = love.graphics.newImage('graphics/enemy/Square3.png'),

    ['circle'] = love.graphics.newImage('graphics/enemy/Circle.png'),
    ['circle2'] = love.graphics.newImage('graphics/enemy/Circle2.png'),
    ['circle3'] = love.graphics.newImage('graphics/enemy/Circle3.png'),

    ['tallrect'] = love.graphics.newImage('graphics/enemy/TallRect.png'),
    ['tallrect2'] = love.graphics.newImage('graphics/enemy/TallRect2.png'),
    ['tallrect3'] = love.graphics.newImage('graphics/enemy/TallRect3.png'),

    ['longrect'] = love.graphics.newImage('graphics/enemy/LongRect.png'),
    ['longrect2'] = love.graphics.newImage('graphics/enemy/LongRect2.png'),
    ['longrect3'] = love.graphics.newImage('graphics/enemy/LongRect3.png'),

    ['tooth'] = love.graphics.newImage('graphics/enemy/Tooth.png'),
    ['tooth2'] = love.graphics.newImage('graphics/enemy/Tooth2.png'),
    ['tooth3'] = love.graphics.newImage('graphics/enemy/Tooth3.png'),

    ['triangle'] = love.graphics.newImage('graphics/enemy/Triangle.png'),
    ['triangle2'] = love.graphics.newImage('graphics/enemy/Triangle2.png'),
    ['triangle3'] = love.graphics.newImage('graphics/enemy/Triangle3.png'),

    ['uptriangle'] = love.graphics.newImage('graphics/enemy/UpTriangle.png'),
    ['uptriangle2'] = love.graphics.newImage('graphics/enemy/UpTriangle2.png'),
    ['uptriangle3'] = love.graphics.newImage('graphics/enemy/UpTriangle3.png')
}

gFonts = {
    ['small'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 12),
    ['medium'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 32),
    ['rankText'] = love.graphics.newFont('fonts/fipps.otf', 14),
    ['title'] = love.graphics.newFont('fonts/ArcadeAlternate.ttf', 48)
}

gSounds = {
    --MUSIC--
    ['title'] = love.audio.newSource('sounds/title.mp3', 'static'),
    ['bgm'] = love.audio.newSource('sounds/bgm.mp3', 'static'),
    -- SFX --
    ['destroyed'] = love.audio.newSource('sounds/destroyed.wav', 'static'),
    ['pDestroyed'] = love.audio.newSource('sounds/pDestroyed.wav', 'static'),
    ['powerup'] = love.audio.newSource('sounds/powerup.wav', 'static'),
    ['hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
    ['pBasic'] = love.audio.newSource('sounds/pBasic.wav', 'static'),
    ['pPower'] = love.audio.newSource('sounds/pPower.wav', 'static'),
    ['flare'] = love.audio.newSource('sounds/flare.wav', 'static'),
    ['spinner'] = love.audio.newSource('sounds/spinner.wav', 'static'),
    ['fireball'] = love.audio.newSource('sounds/fireball.wav', 'static'),
    ['bubble'] = love.audio.newSource('sounds/bubble.wav', 'static'),
    ['horiz'] = love.audio.newSource('sounds/horiz.wav', 'static'),
    ['vertdown'] = love.audio.newSource('sounds/pBasic.wav', 'static'),
    ['vertup'] = love.audio.newSource('sounds/pBasic.wav', 'static')
}
gSounds['pPower']:setVolume(0.6)
gSounds['spinner']:setVolume(0.7)
