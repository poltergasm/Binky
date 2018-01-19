local px = require "px"

-- create entity player
EntityPlayer = require "entities.player"
EntityPlatform = require "entities.platform"
-- main game scene
Platforms = {}

MainGame = px.Module:extends()

function MainGame:add_platform_row(y, row)
  for j,n in ipairs(row) do
    if n == 1 then
      local platform = EntityPlatform((j-1)*32, (y-1)*32)
      Platforms[#Platforms + 1] = platform
    end
  end
end

function MainGame:get_row()
  local row = {}
  for x = 1, 8 do
    row[x] = math.random() > 0.93 and 1 or 0
  end
  return row
end

function MainGame:load_map()
  self.map = {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,1,1,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0}
    
  for i = 8, 18 do
    self.map[i] = self:get_row()
  end
  
  for i,row in ipairs(self.map) do
    --print(row)
    if type(row) == "table" then
      for j,n in ipairs(row) do
        if n == 1 then
          local platform = EntityPlatform((j-1)*32, (i-1)*32)
          Platforms[#Platforms + 1] = platform
        end
      end
    else
      local platform = EntityPlatform((i-1)*32, (row-1)*32)
      Platforms[#Platforms + 1] = platform
    end
  end
end

function MainGame:init()
  math.randomseed(os.time())
  local music = love.audio.newSource("assets/audio/bgm/Happy.mp3", true)
  music:play()
  love.graphics.setBackgroundColor(69, 186, 230)
  self.player = EntityPlayer()
  self.player.sprite.pos.x = 150
  self.player.sprite.pos.y = -50
  self.speed = 1
  self.screen = {}
  self.screen.y = 0
  self.screen.x = 0
  self:load_map()
end

local zoom = 1
function MainGame:update(dt)
  self.player:update(dt)
  self.speed = self.speed + dt * (10/self.speed)
  self.screen.y = self.screen.y + dt * self.speed

  -- new row?
  --local need_row = self.screen.y % 400
  print(math.floor(self.screen.y) % 400)
  if false then
    --self.screen.y = self.screen.y - 8
    --for i = 1, #Platforms do
    --  Platforms[i].pos.y = Platforms[i].pos.y + 8
    --end

    for i = 1, 8 do
      table.remove(Platforms, i)
    end
    table.remove(self.map, 1)
    local map_y = #self.map + 1
    self.map[map_y] = self:get_row()
    self:add_platform_row(map_y, self.map[map_y])

    -- place coin?
  end
end

function MainGame:draw()
  px.Print("Plixel Works!", 100, 100)

  local cx,cy = love.graphics.getWidth()/(2*zoom), love.graphics.getHeight()/(2*zoom)
  love.graphics.push()
  love.graphics.translate(cx, cy)
  love.graphics.translate(-love.graphics.getWidth() / 4, -self.screen.y)
  self.player:draw()
  for i = 1, #Platforms do
    Platforms[i].sprite:draw()
  end
  love.graphics.pop()
end

-- @args (title, module, width, height, loader)
px.Game("Binky", MainGame, 512, 768)