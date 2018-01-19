local Vector2 = require "px.vector2"
local Entity = px.Class:extends()

function Entity:init()
  self.pos = Vector2(0, 0)
  self.offset = Vector2(0, 0)
  self.max_vel = Vector2(100, 100)
  self.friction = 0.8
  self.group = nil
  self.check_against = nil
  self.anim_sheet = nil
  self.vel = Vector2(0, 0)
  self.jumping = false
  self.grounded = false
  self.gravity = 0.3
  self.speed   = 3
end

function Entity:draw()
  self.sprite:draw()
end

function Entity:update(dt)
  self.sprite:update(dt)
end

return Entity