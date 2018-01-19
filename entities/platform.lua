local EntityPlatform = px.Entity:extends()

local atlas = love.graphics.newImage("assets/gfx/binky.png")

function EntityPlatform:init(x, y, last)
  EntityPlatform.super:init()

  local xoff = 32
  local yoff = 96

  if last then
  	xoff = 144
  	yoff = 144
  end
  atlas:setFilter("nearest", "nearest")
  self.sprite = px.Sprite(atlas, 16, 16, x, y, 3, 3)
  self.sprite:add_animations({
    --top = px.Anim(224, 48, 16, 16, {1}, 1, 10, false),
    top = px.Anim(xoff, yoff, 16, 16, {1}, 1, 10, false),
    bottom = px.Anim(224, 64, 16, 16, {1}, 1, 10, false)
  })
  self.sprite:animate("top")
end

return EntityPlatform