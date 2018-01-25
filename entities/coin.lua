local EntityCoin = px.Entity:extends()

local atlas = love.graphics.newImage("assets/gfx/binky.png")

function EntityCoin:init(x, y, bottom)
  EntityCoin.super:init()

  atlas:setFilter("nearest", "nearest")
  self.sprite = px.Sprite(atlas, 32, 32, x, y)
  self.sprite:add_animations({
    idle = px.Anim(128, 224, 32, 32, {1, 2, 3, 4}, 4, 6, true)
  })
  self.sprite:animate("idle")
end

return EntityCoin