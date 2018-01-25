local EntityPlatform = px.Entity:extends()

local atlas = love.graphics.newImage("assets/gfx/platform.png")

function EntityPlatform:init(x, y, last)
  EntityPlatform.super:init()

  local xoff = 0
  local yoff = 0

  if last then
  	xoff = 144
  	yoff = 144
  end
  atlas:setFilter("nearest", "nearest")
  self.sprite = px.Sprite(atlas, 32, 32, x, y)
  self.sprite:add_animations({
    --top = px.Anim(224, 48, 16, 16, {1}, 1, 10, false),
    top = px.Anim(xoff, yoff, 32, 32, {1}, 1, 10, false),
    bottom = px.Anim(224, 64, 32, 32, {1}, 1, 10, false)
  })
  self.sprite:animate("top")
end

return EntityPlatform