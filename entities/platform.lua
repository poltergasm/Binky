local EntityPlatform = px.Entity:extends()

local atlas = love.graphics.newImage("assets/gfx/binky.png")

function EntityPlatform:init(x, y)
  EntityPlatform.super:init()

  atlas:setFilter("nearest", "nearest")
  self.sprite = px.Sprite(atlas, 16, 16, x, y, 2, 2)
  self.sprite:add_animations({
    idle = px.Anim(224, 48, 16, 16, {1}, 1, 10)
  })
  self.sprite:animate("idle")
end

return EntityPlatform