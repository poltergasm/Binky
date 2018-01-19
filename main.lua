local px = require "px"

-- create entity player
EntityPlayer = require "entities.player"
EntityPlatform = require "entities.platform"
-- main game scene
Platforms = {}

MainGame = px.Module:extends()

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
  
  local yrow = 0
  for i,row in ipairs(self.map) do
    --print(row)
    if type(row) == "table" then
      yrow = yrow + 32
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
  self.speed = self.speed + dt * (10/self.speed);
  self.screen.y = self.screen.y + dt * self.speed;
end

function MainGame:draw()
  px.Print("Plixel Works!", 100, 100)

  local cx,cy = love.graphics.getWidth()/(2*zoom), love.graphics.getHeight()/(2*zoom)
  love.graphics.push()
  love.graphics.translate(cx, cy)
  love.graphics.translate(-love.graphics.getWidth() / 2, -self.screen.y)
  self.player:draw()
  for i = 1, #Platforms do
    Platforms[i].sprite:draw()
  end
  love.graphics.pop()
end

-- @args (title, module, width, height, loader)
px.Game("Binky", MainGame, 512, 768)