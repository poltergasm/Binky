local EntityGoal = px.Entity:extends()

local atlas = love.graphics.newImage("assets/gfx/binky.png")

function EntityGoal:init(x, y, last)
  EntityGoal.super:init()

  atlas:setFilter("nearest", "nearest")
  self.sprite = px.Sprite(atlas, 16, 16, x, y, 3, 3)
  self.sprite:add_animations({
    idle = px.Anim(128, 112, 16, 16, {1, 2, 3, 4}, 4, 6, true)
  })
  self.sprite:animate("idle")
end

return EntityGoal