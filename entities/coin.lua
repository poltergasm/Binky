local EntityCoin = px.Entity:extends()

local atlas = love.graphics.newImage("assets/gfx/binky.png")

function EntityCoin:init(x, y, bottom)
  EntityCoin.super:init()

  atlas:setFilter("nearest", "nearest")
  self.sprite = px.Sprite(atlas, 16, 16, x, y, 2, 2)
  self.sprite:add_animations({
    idle = px.Anim(64, 112, 16, 16, {1, 2, 3, 4}, 4, 6, true)
  })
  self.sprite:animate("idle")
end

return EntityCoin