local abs = math.abs

local Physics = {}

function Physics.collides(rect1, rect2)
  local r1w = (rect1.w * rect1.scale.x)
  local r1h = (rect1.h * rect1.scale.y)
  local r2w = (rect2.w * rect2.scale.x)
  local r2h = (rect2.h * rect2.scale.y) 
  local vx = (rect1.pos.x + (r1w / 2)) - (rect2.pos.x + (r2w / 2))
  local vy = (rect1.pos.y + (r1h / 2)) - (rect2.pos.y + (r2h / 2))

  local hW = (r1w / 2) + (r2w / 2)
  local hH = (r1h / 2) + (r2h / 2)
  local direction = nil

  if abs(vx) < hW and abs(vy) < hH then
    local oX = hW - abs(vx)
    local oY = hH - abs(vy)

    if oX > oY then
      if vy > 0 then
        direction = "top"
        rect1.pos.y = rect1.pos.y + oY
      else
        direction = "bottom"
        rect1.pos.y = rect1.pos.y - oY
      end
    else
      if vx > 0 then
        direction = "left"
        rect1.pos.x = rect1.pos.x + oX
      else
        direction = "right"
        rect1.pos.x = rect1.pos.x - oX
      end
    end
  end
  return direction
end

return Physics