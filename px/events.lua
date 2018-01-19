local Class = require("px.class")
local Events = Class:extends()

local function index_of(tbl, cb)
  if tbl == nil or cb == nil then return -1 end
  for i = 1, #tbl do
    if tbl[i] == cb then return i end
  end
  return -1
end

function Events:init()
  self.handlers = {}
end

function Events:add(evt_type)
  assert(self.handlers[evt_type] == nil, "Event " .. evt_type .. " already exists")
  self.handlers[evt_type] = {}
end

function Events:remove(type)
  self.handlers[type] = nil
end

function Events:exists(evt_type)
  return self.handlers[evt_type] ~= nil
end

function Events:hook(evt_type, callback)
  assert(type(callback) == "function", "Events:hook callback must be a function")
  if self.handlers[evt_type] == nil then self:add(evt_type) end
  local tbl = self.handlers[evt_type]
  tbl[#tbl + 1] = callback
end

function Events:unhook(evt_type, callback)
  assert(type(callback) == "function", "Events:unhook callback must be a function")
  if self.handlers[evt_type] == nil then return end
  local idx = index_of(self.handlers[evt_type], callback)
  if idx > -1 then
    table.remove(self.handlers[evt_type])
  end
end

function Events:clear(evt_type)
  if evt_type == nil then
    for k,v in pairs(self.handlers) do
      self.handlers[k] = {}
    end
  else
    self.handlers[evt_type] = {}
  end
end

function Events:invoke(evt_type, ...)
  --assert(self.handlers[evt_type] ~= nil, "Event '" .. evt_type .. "' does not exist")
  if self.handlers[evt_type] == nil then return end
  local tbl = self.handlers[evt_type]
  for i = 1, #tbl do
    tbl[i](...)
  end
end

return Events