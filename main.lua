local px = require "px"
local floor = math.floor
-- create entity player
EntityPlayer   = require "entities.player"
EntityPlatform = require "entities.platform"
EntityCoin     = require "entities.coin"
EntityGoal     = require "entities.goal"
-- main game scene
Platforms = {}
Coins = {}
Goal = nil

local music
local zoom = 1
local atlas = love.graphics.newImage("assets/gfx/binky.png")
atlas:setFilter("nearest", "nearest")
local backdrop = love.graphics.newQuad(0, 384, 320, 288, atlas:getDimensions())

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
  self.map = {{0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,1,1,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0},
              {0,0,0,0,0,0,0,0}}
    
  for i = 8, 70 do
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

  -- add goal
  local last_y = #self.map * 32
  local last_x = 4*32
  local platform = EntityPlatform(last_x, last_y+64)
  Platforms[#Platforms + 1] = platform

  platform = EntityPlatform(last_x+32, last_y+64)
  Platforms[#Platforms + 1] = platform

  Goal = EntityGoal(last_x, last_y+32)

  -- coins
  for i = 1, 50 do
    local trow  = math.ceil((math.random() * #self.map))
    local tile = math.ceil((math.random() * 8))
    --if type(self.map[trow]) == "table" then
      if self.map[trow][tile] == 1 and self.map[trow-2][tile] == 0 then
        local y = (trow-2)*32
        local x = (tile-1)*32
        local coin = EntityCoin(x, y)
        Coins[#Coins + 1] = coin
      --end
    end
  end
end

function MainGame:init()
  math.randomseed(os.time())
  self.font = love.graphics.newFont("assets/fonts/Gamer.ttf", 34)
  love.graphics.setFont(self.font)
  music = love.audio.newSource("assets/audio/bgm/happy.mp3", true)
  music:setVolume(0.3)
  music:play()
  love.graphics.setBackgroundColor(69, 186, 230)
  self.player = EntityPlayer(self)
  self.player.sprite.pos.x = 115
  self.player.sprite.pos.y = -50
  self.speed = 1
  self.screen = {}
  self.screen.y = 0
  self.screen.x = 0
  self.points = 0
  self:load_map()
end

function MainGame:update(dt)
  self.player:update(dt)
  for i = 1, #Coins do Coins[i]:update(dt) end
  Goal:update(dt)
  self.speed = self.speed + dt * (10/self.speed)
  self.screen.y = self.screen.y + dt * self.speed

  -- new row?
  --local need_row = self.screen.y % 400

  --[[if self.screen.y > 180 then
    --self.screen.y = self.screen.y - 8
    --self.player.sprite.pos.y = self.player.sprite.pos.y - 8
    
    table.remove(self.map, 1)
    local map_y = #self.map + 1
    self.map[map_y] = self:get_row()
    self:add_platform_row(map_y, self.map[map_y])

    -- place coin?
  end]]

  self.points = self.points + dt * self.speed
end

function MainGame:draw()

  local bdy = love.graphics.getHeight() - 220
  love.graphics.draw(atlas, backdrop, 0, bdy)
  love.graphics.draw(atlas, backdrop, 320, bdy)
  local pts = floor(self.points)
  love.graphics.setColor(220, 20, 60)
  local fontw = self.font:getWidth(pts)
  local fonth = self.font:getHeight(pts)
  px.Print(pts, love.graphics.getWidth() - (fontw + 30), fonth + 10)
  love.graphics.setColor(255, 255, 255, 255)

  local cx,cy = love.graphics.getWidth()/(2*zoom), love.graphics.getHeight()/(2*zoom)
  love.graphics.push()
  love.graphics.translate(cx, cy)
  love.graphics.translate(-love.graphics.getWidth() / 4, -self.screen.y * (self.speed / 4))
  self.player:draw()
  for i = 1, #Platforms do
    Platforms[i].sprite:draw()
  end

  for i = 1, #Coins do Coins[i].sprite:draw() end
  Goal.sprite:draw()
  love.graphics.pop()
end

LevelPassed = px.Module:extends()

function LevelPassed:init()
  Platforms = {}
  Coins = {}
  love.graphics.setBackgroundColor(69, 186, 230)
  self.font = love.graphics.newFont("assets/fonts/Gamer.ttf", 50)
  love.graphics.setFont(self.font)
end

function LevelPassed:draw()
  local bdy = love.graphics.getHeight() - 220
  love.graphics.draw(atlas, backdrop, 0, bdy)
  love.graphics.draw(atlas, backdrop, 320, bdy)
  love.graphics.setColor(220, 20, 60)
  local fonth = self.font:getHeight()
  love.graphics.print("Level passed!", love.graphics.getWidth() / 3, love.graphics.getHeight() / 3)
  love.graphics.print("Press R to play again", love.graphics.getWidth() / 5, love.graphics.getHeight() / 3 + fonth)
  love.graphics.setColor(255, 255, 255)
end

function LevelPassed:update(dt)
  if px.Keyboard:key_down("r") then
    music:stop()
    px.change_mod(MainGame)
  end
end

-- @args (title, module, width, height, loader)
px.Game("Binky", MainGame, 512, 768)