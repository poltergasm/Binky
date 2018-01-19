local Class  = require("px.class")
local Anim   = require("px.animation")
local Vec2   = require("px.vector2")
local Rect   = require("px.rect")

local Sprite = Class:extends()

function Sprite:init(atlas, w, h, x, y, sx, sy, angle, color)
  self.w            = w
  self.h            = h
  self.flip         = Vec2(1, 1)
  self.pos          = Vec2(x or 0, y or 0)
  self.atlas        = atlas
  self.animations   = {}
  self.current_anim = ""
  self.quad         = love.graphics.newQuad(0, 0, w, h, atlas:getDimensions())
  self.scale        = Vec2(sx or 1, sy or 1)
  self.angle        = angle or 0
  self.speed        = 1
  self.tint_color   = color or {255, 255, 255, 255}
end

function Sprite:animate(anim_name)
  if self.current_anim ~= anim_name and self.animations[anim_name] ~= nil then
    self.current_anim = anim_name
    self.animations[anim_name]:reset()
    self.animations[anim_name]:set(self.quad)
  elseif self.animations[anim_name] == nil then
    assert(false, "Sprite:animate animation name '" .. anim_name .. "' not found")
  end
end

function Sprite:animation_finished()
  if self.animations[self.current_anim] ~= nil then
    return self.animations[self.current_anim].done
  end
  return true
end

function Sprite:add_animations(anims)
  assert(type(anims) == "table", "Sprite:add_animations expects a table as a parameter")
  for k,v in pairs(anims) do
    self.animations[k] = v
  end
end

function Sprite:flip_h(flip)
  if flip then
    self.flip.x = -1
  else
    self.flip.x = 1
  end
end

function Sprite:flip_v(flip)
  if flip then
    self.flip.y = -1
  else
    self.flip.y = 1
  end
end

function Sprite:rect()
  return Rect.create_centered(self.pos.x, self.pos.y, self.w * self.scale.x, self.h * self.scale.y)
end

function Sprite:update(dt)
  if self.animations[self.current_anim] ~= nil then
    self.animations[self.current_anim]:update(dt, self.quad)
  end
end

function Sprite:draw()
  love.graphics.setColor(self.tint_color)
  love.graphics.draw(
    self.atlas, self.quad, self.pos.x, self.pos.y, self.angle,
      self.scale.x * self.flip.x, self.scale.y * self.flip.y,
        self.w / 2, self.h / 2)

  --local r = self:rect()
  --love.graphics.rectangle("line", r.x, r.y, r.w, r.h)
end

return Sprite