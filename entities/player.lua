local EntityPlayer = px.Entity:extends()

local atlas = love.graphics.newImage("assets/gfx/player.png")
local snd = {
  shoot2 = love.audio.newSource("assets/audio/sfx/Shoot 2.wav"),
  jump3  = love.audio.newSource("assets/audio/sfx/Jump 3.wav"),
  hit2   = love.audio.newSource("assets/audio/sfx/Hit 2.wav"),
  hit5 = love.audio.newSource("assets/audio/sfx/Hit 5.wav"),
  wrong1 = love.audio.newSource("assets/audio/sfx/Wrong 1.wav"),
  powerup2 = love.audio.newSource("assets/audio/sfx/Powerup 2.wav")
}

function EntityPlayer:init()
  EntityPlayer.super:init()

  local idle = px.Anim(16, 16, 16, 16, {1, 2, 3, 4}, 4, 6)
  local walk = px.Anim(16, 32, 16, 16, {1, 2, 3, 4, 5, 6}, 6, 12)
  local swim = px.Anim(16, 64, 16, 16, {1, 2, 3, 4, 5, 6}, 6, 12)
  local punch = px.Anim(16, 80, 16, 16, {1, 2, 3}, 3, 10, false)
  local jump  = px.Anim(16, 48, 16, 16, {1, 2, 3}, 6, 6, false)

  atlas:setFilter("nearest", "nearest")
  self.sprite = px.Sprite(atlas, 16, 16, 200, 200, 2, 2)
  self.sprite:add_animations({
    idle = idle, walk = walk, swim = swim, punch = punch, jump = jump
  })
  self.sprite:animate("idle")
  self.speed = 1
  self.gravity = 0.2
end

function EntityPlayer:jump()
  if not self.jumping and self.grounded then
    snd.jump3:play()
    self.jumping = true
    self.grounded = false
    self.vel.y = -self.speed * 4
    self.sprite:animate("jump")
  end
end

function EntityPlayer:update(dt)
  EntityPlayer.super.update(self, dt)

  if px.Keyboard:key_down("x") then
    self:jump()
  elseif px.Keyboard:key_down("right") and not px.Keyboard:key_down("left") then
    self.sprite:flip_h(false)
    self.sprite:animate("walk")
    if self.vel.x < self.speed then self.vel.x = self.vel.x + 0.5 end
    self.vel.x = self.vel.x + 0.5
  elseif px.Keyboard:key_down("left") and not px.Keyboard:key_down("right") then
    self.sprite:flip_h(true)
    self.sprite:animate("walk")
    if self.vel.x < self.speed then self.vel.x = self.vel.x - 0.5 end
    self.vel.x = self.vel.x - 0.5
  elseif px.Keyboard:key_down("right") or px.Keyboard:key_down("left") and px.Keyboard:key_down("x") then
    self:jump()
  else
    self.sprite:animate("idle")
  end

  self.vel.x = self.vel.x * self.friction
  self.vel.y = self.vel.y + self.gravity

  self.grounded = false

  for i = 1, #Platforms do
    local dir = px.Physics.collides(self.sprite, Platforms[i].sprite)
    if dir == "bottom" then
      self.grounded = true
      self.jumping = false
    end
  end

  if self.grounded then self.vel.y = 0 end

  self.sprite.pos.x = self.sprite.pos.x + self.vel.x
  self.sprite.pos.y = self.sprite.pos.y + self.vel.y
end

return EntityPlayer