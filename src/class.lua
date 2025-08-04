local M = {}

---@class (exact) MetaClass : Class
local Class = {}
Class.name = "Class"

---Class of every other class.
---
---As a type it is a type of every class object.
---Every class object is created as an instance of the `Class` type (except for the `Class` class object itself).
---
---As an object contains operations of the `Class` type.
---
---@class (exact) Class
---@field public name string
---@field public prototype table
---@field public mt Metatable
Class.prototype = {}

---Metatable for every class.
---
---@class Metatable : metatable
---@field public __class Class
Class.mt = {
    __class = Class,
    __index = Class.prototype,
}

setmetatable(Class, Class.mt)

---A class instance constructor.
---
---By default is `private`, so it should be specified on the class object type as a field
---That way it gets its correct type signature and visibility.
---
---Creates an instance of the class by creating an empty table,
---setting the class `mt` as a metatable of the instance
---and calling `__init` instance method to initialize table with arguments passed to the constructor.
---
---If the `__init` is not defined, then initialization will be empty.
---
---The access modifier of the `__init` prototype method should be `private`.
---
---When the class is created,
---the exact type signature of the constructor can be specified
---as a `new` field type.
---```lua
------@class (exact) PointClass : Class
------@field public new fun(class: self, x: number, y: number): Point
---local Point = Class:new("Point")
---
------@class (exact) Point
------@field public x string
------@field public y integer
---Point.prototype = Point.prototype
---
------@private
------@param x number
------@param y number
------@return void
---function Point.prototype:__init(x, y)
---    self.x = x
---    self.y = y
---end
---
----- Creates a Point class instance.
---local point = Point:new(1, 2)
---```
---
---@private (protected)
---@return table
function Class.prototype:new(...)
    ---@type table
    local instance = setmetatable({}, self.mt)
    instance:__init(...)

    return instance
end

---A function that does nothing.
---
---"By doing nothing, everything is done." - Lao Tzu
---
---@return void
local function noop(...) end

---Creates a new class.
---
---```lua
------Class as object has its separate type.
------It contains meta fields: `name`, `prototype` and `mt` --
------and also class methods -- operations for the class, such as constructors.
---
------Every class already has a constructor (`new` class method), but it's private and untyped.
------The constructor should be specified on the class object type as a field.
------That way it gets its correct type signature and visibility.
---
------@class (exact) PointClass : Class
------@field public new fun(self: self, x: number, y: number): Point
---local Point = Class:new("Point")
---
------Class as type is defined on the `prototype`.
------Fields should be defined here.
---
------If the class is generic, the methods also should be defined here as functional fields.
---
------@class (exact) Point
------@field public x number
------@field public y number
---Point.prototype = Point.prototype
---
------Initializer.
------Takes arguments from the constructor and initializes fields.
---
------@private
------@param x number
------@param y number
------@return void
---function Point.prototype:__init(x, y)
---    self.x = x
---    self.y = y
---end
---
------Instance methods should be defined on the `prototype`.
---
------@public
------@param other Point
------@return number
---function Point.prototype:distance_to(other)
---    local dx = self.x - other.x
---    local dy = self.y - other.y
---    return math.sqrt(dx * dx + dy * dy)
---end
---
------Meta-methods should be defined on the `mt`.
---
------@public
------@param left Point
------@param right Point
------@return boolean
---function Point.mt.__eq(left, right)
---    if left.x ~= right.x then return false end
---    if left.y ~= right.y then return false end
---
---    return true
---end
---
------Class methods should be defined on the class object.
---
------@public
------@return Point
---function Point:origin()
---    return Point:new(0, 0)
---end
---
-----Point instance created with constructor.
---local point = Point:new(10, 20)
---
-----Point instance created with `origin` class method.
---local origin = Point:origin()
---```
---
---@public
---@param name string
---@return Class
function Class:new(name)
    local class = setmetatable({}, self.mt)
    class.name = name
    class.prototype = {
        __init = noop,
    }
    class.mt = {
        __class = class,
        __index = class.prototype,
    }

    return class
end

---Gets a class of the table.
---
---Returns a class if the table is a class instance,
---otherwise -- `nil`.
---
---@public
---@param instance unknown
---@return Class?
function Class:of(instance)
    local mt = getmetatable(instance)
    if mt == nil then return nil end

    return mt.__class
end

M.Class = Class

return M
