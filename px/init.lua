px = {}
px.Class = require "px.class"
px.Events = require("px.events")()
px.Keyboard = require "px.keyboard"
px.Module = require "px.module"
px.Entity = require "px.entity"
px.Sprite = require "px.Sprite"
px.Anim   = require "px.animation"
px.Physics = require "px.physics"

px.modules = {}

local win = love.window
local gr  = love.graphics

function px.Game(title, mod, width, height, loader)
  px.title = title
  px.current_mod = mod
  px.width = width or 800
  px.height = height or 600
  px.loader = loader or {}
  
  function love.load()
    win.setTitle(px.title)
    gr.setDefaultFilter("nearest", "nearest")
    win.setMode(px.width, px.height)
    px.Keyboard:hook_events()
    if px.current_mod.init ~= nil and type(px.current_mod.init == "function") then
      px.current_mod:init()
    end
  end

  function love.draw()
    px.current_mod:draw()
  end
  
  if px.current_mod.init ~= nil and type(px.current_mod.update == "function") then
    function love.update(dt)
      if dt > 0.035 then return end
      px.current_mod:update(dt)
    end
  end
end

function px.Print(...) gr.print(...) end

return px