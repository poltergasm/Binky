local Class = require("px.class")
local Vec2  = require("px.vector2")

local Anim  = Class:extends()

function Anim:init(xoff, yoff, w, h, frames, col_size, fps, loop)
  self.fps          = fps
  if type(frames) == "table" then
    self.frames = frames
  else
    self.frames = {}
    for i = 1, frames do
      self.frames[i] = i
    end
  end
  self.col_size     = col_size
  self.offset       = Vec2()
  self.start_offset = Vec2(xoff, yoff)
  self.size         = Vec2(w, h)
  self.loop         = loop == nil or loop
  self.padding      = Vec2(xpad, ypad)
  self:reset()
end

function Anim:reset()
  self.timer = 1 / self.fps
  self.idx = 1
  self.done = false
  self.offset.x = self.start_offset.x + (self.size.x * ((self.frames[self.idx] - 1) % (self.col_size)))
  self.offset.y = self.start_offset.y + (self.size.y * math.floor((self.frames[self.idx] - 1) / self.col_size))
end

function Anim:set(quad)
  quad:setViewport(self.offset.x, self.offset.y, self.size.x, self.size.y)
end

function Anim:update(dt, quad)
  if #self.frames <= 1 then
    --self.offset.x = self.start_offset.x
    --self.offset.y = self.start_offset.y
    --self:set(quad)
    self.done = true
    return 
  elseif self.timer > 0 then
    self.timer = self.timer - dt
    if self.timer <= 0 then
      self.timer = 1 / self.fps
      self.idx = self.idx + 1
      if self.idx > #self.frames then
        if self.loop then
          self.idx = 1
        else
          self.idx = #self.frames
          self.timer = 0
          self.done  = true
        end
      end
      self.offset.x = self.start_offset.x + (self.size.x * ((self.frames[self.idx] - 1) % (self.col_size)))
      self.offset.y = self.start_offset.y + (self.size.y * math.floor((self.frames[self.idx] - 1) / self.col_size))
      self:set(quad)
    end
  end
end

return Anim