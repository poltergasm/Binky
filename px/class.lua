local Class = {}
Class.__index = Class

-- initializer
function Class:new() end

function Class:extends(ctype)
  --assert(ctype, "Namespace requires a type in the form of a string")
  local cls = {}
  cls["__call"] = Class.__call
  --cls.type = ctype
  cls.__index = cls
  cls.super = self
  setmetatable(cls, self)
  return cls
end

function Class:isa(cls)
  assert(cls, "Class:isa expects a class")
  assert(type(cls) == "table", "Parameter to Class:isa must be a table/class")
  local meta = getmetatable(self)
  while meta do
    if meta == cls then return true end
    meta = getmetatable(meta)
  end
  return false
end

function Class:is_type(cls_type)
  assert(cls_type, "Class:is_type expects a class type")
  assert(type(cls_type) == "string", "Parameter to Class:is_type must be a string")
  local base = self
  while base do
    if base.type == cls_type then return true end
    base = base.base
  end
  return false
end

-- create a new instance by calling Namespace()
function Class:__call(...)
  local inst = setmetatable({}, self)
  inst:init(...)
  return inst
end

function Class:get_type()
  return self.type
end

return Class