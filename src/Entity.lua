--[[
    Entity.lua
]]

Entity = Class{}

function Entity:init(def)
    self.type = def.type or 'player'
    self.texture = def.texture
    self.HP = def.HP or 1
    self.bulletType = def.bulletType or 'pBasic'
    self.firingRate = def.firingRate or 0
    self.x = def.x or -100
    self.y = def.y or -100
    self.firingOffX = def.firingOffX or 0
    self.firingOffY = def.firingOffY or 0
    self.xOffset = 0    
    self.dx = 0
    self.dy = 0
    self.width = def.width
    self.height = def.height
    self.direction = self.type == 'player' and 1 or -1 -- RIGHT = 1; LEFT = -1; Used to flip x-scale when rendering entity
    self.hbOffX = self.direction > 0 and 0 or self.width
    self.opacity = 1
    self.level = 1
    self.bullets = {}
    self.invincible = false
    self.invincibleDuration = 0.4
    self.invincibleTimer = 0
    self.flashTimer = 0
    self.warping = false
    self.whiteShader = love.graphics.newShader[[
        extern float WhiteFactor;

        vec4 effect(vec4 vcolor, Image tex, vec2 texcoord, vec2 pixcoord)
        {
            vec4 outputcolor = Texel(tex, texcoord) * vcolor;
            outputcolor.rgb += vec3(WhiteFactor);
            return outputcolor;
        }
    ]]
    self.dead = false
end

function Entity:collides(target)
    return not (self.x + self.width - self.hbOffX < target.x - target.hbOffX or self.x - self.hbOffX > target.x + target.width - target.hbOffX or self.y + self.height < target.y or self.y > target.y + target.height) and not self.invincible and not self.dead
end

-- RETURNS true, if the hit is lethal.
function Entity:hit()
    --[[ if self.type == 'player' then
        return true
    else ]]
        -- Decrease HP by 1
        self.HP = self.HP - 1
        return self.HP <= 0
    --end
end

function Entity:changeState(name)
    self.stateMachine:change(name)
end

function Entity:update(dt)
    if not self.dead then
        self.stateMachine:update(dt)
    end
    for k, bullet in pairs(self.bullets) do
        bullet:update(dt)
        if bullet.x > VIRTUAL_WIDTH or bullet.x - bullet.hbOffX < 0 or bullet.destroyed then
            self.bullets[k] = nil --bullet = nil
        end 
    end
end

function Entity:warp(destX, destY)
    self.warping = true
    -- Entity flashes (HAPPENS PRE-WARP; PUT IT IN PLAYSTATE)
    Timer.every(0.125, function()
        self.opacity = self.opacity == 64/255 and 1 or 64/255 end)
    :limit(8)
    :finish(function()
        self.opacity = 0
        self.invincible = true
        Timer.after(0.4, function() 
            -- Set x coordinate to destination's x
            self.x = destX
            -- Set y coordinate to destination's y
            self.y = destY
            -- Direction is inverted (* -1)
            self.direction = self.direction * -1
            -- Reset the hitbox offset
            self.hbOffX = self.direction > 0 and 0 or self.width
            -- Level the enemy up
            if self.type == 'enemy' then
                self:levelUp()
            end
            -- Reset opacity
            self.opacity = 1
            -- Signal Warping has ended
            self.warping = false
            -- No longer invincible
            self.invincible = false
    end)
    -- Goes completely transparent
    -- Becomes invincible
    
    end)
end

function Entity:render()
    for k, bullet in pairs(self.bullets) do
        bullet:render()
    end
    if not self.dead then 
        self.stateMachine:render()
    end
end

function Entity:levelUp()
    if self.level < 3 then
        self.level = self.level + 1
        self.HP = self.HP + 2
        self.texture = self.texture .. tostring(self.level)
    end
end