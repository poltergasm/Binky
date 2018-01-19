local Class = require("px.class")
local Vec2 = require("px.vector2")

local Rect = Class:extends()

local abs = math.abs

--where (x,y) indicate the upper left corner of the rect
function Rect:init(x, y, w, h)
    self.x = x or 0
    self.y = y or 0
    self.w = w or 0
    self.h = h or 0
end

--where (x,y) indicates the center of the rect
function Rect.create_centered(cx, cy, w, h)
    local r = Rect(0,0,w,h)
    r:set_center(cx,cy)
    return r
end

function Rect:center()
    return Vec2(self.x + self.w / 2, self.y + self.h / 2)
end

function Rect:set_center(x,y)
    self.x = x - self.w / 2
    self.y = y - self.h / 2
end

function Rect:min()
    return Vec2(self.x, self.y)
end

function Rect:max()
    return Vec2(self.x + self.w, self.y + self.h)
end

function Rect:size()
    return Vec2(self.w, self.h)
end

--other is also a Rect
function Rect:minowski_diff(other) 
    local top_left = Vec2.sub(self:min(), other:max())
    local newSize = Vec2.add(self:size(), other:size())
    local newLeft = Vec2.add(top_left, Vec2.static_div(newSize,2))
    return Rect.create_centered(newLeft.x, newLeft.y, newSize.x, newSize.y)
end

--Returns a Vec2 that indicates the point on the
--rectangle's boundary that is closest to the given point
--
function Rect:closest_point_on_bounds(point)
    local min_dist = abs(point.x - self.x)
    local max = self:max()
    local bounds_point = Vec2(self.x, point.y)

    --finish checking x axis
    if abs(max.x - point.x) < min_dist then
        min_dist = abs(max.x - point.x)
        bounds_point = Vec2(max.x, point.y)
    end

    --move to y axis
    if abs(max.y - point.y) < min_dist then
        min_dist = abs(max.y - point.y)
        bounds_point = Vec2(point.x, max.y)
    end

    if abs(self.y - point.y) < min_dist then
        min_dist = abs(self.y - point.y)
        bounds_point = Vec2(point.x, self.y)
    end

    return bounds_point
end

function Rect:collides_right(bounds_point)
  return bounds_point.x < 0
end

function Rect:collides_left(bounds_point)
  return bounds_point.x > 0
end

function Rect:collides_top(bounds_point)
  return bounds_point.y > 0
end

function Rect:collides_bottom(bounds_point)
  return bounds_point.y < 0
end

return Rect