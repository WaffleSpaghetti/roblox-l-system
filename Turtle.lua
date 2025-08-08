local Turtle = {}

-- lua class setup
Turtle.proto = {}
Turtle.meta = {}

Turtle.meta.__index = Turtle.proto

local original = {}
function Turtle.new(obj)
	obj = obj or {}
	obj.stack = obj.stack or {}
	obj.color = Color3.new(1,0,0)
	obj.rules = obj.rules or {}
	local merged = {}
	merged = table.clone(Turtle.proto.rules)
	for rule, action in pairs(obj.rules) do
		merged[rule] = action
	end
	obj.rules = merged
	setmetatable(obj, Turtle.meta)

	original = {
		pos = obj.pos,
		dir = obj.dir,
		speed = obj.speed,
		transparency = obj.transparency,
		color = obj.color,
		pendown = obj.pendown,
		turnAngle = obj.turnAngle,
		lineWidth = obj.lineWidth,
		canCollide = obj.canCollide,
		castShadow = obj.castShadow,
	}
	return obj
end

setmetatable(Turtle, {
	__call = function(_, ...) return Turtle.new(...) end
})

-- main
Turtle.proto.container = workspace
Turtle.proto.canCollide = false
Turtle.proto.castShadow = false
Turtle.proto.pos = Vector3.zero
Turtle.proto.dir = Vector3.new(0,1,0)
Turtle.proto.speed = 1
Turtle.proto.turnAngle = math.rad(45)
Turtle.proto.lineWidth = 0.1
Turtle.proto.material = Enum.Material.SmoothPlastic
Turtle.proto.transparency = 0
Turtle.proto.pendown = false

function Turtle.proto:buildBranch(cframe, size, color)
	local part = Instance.new("Part")
	part.Size = size
	part.CanCollide=self.canCollide
	part.CastShadow=self.castShadow
	part.Material=self.material
	part.Transparency=self.transparency
	part.Anchored = true
	part.Color = color
	part.CFrame = cframe
	part.Parent = self.container
	return part
end
function Turtle.proto:move(length)
	self.pos = self.pos + self.dir.Unit * self.speed * length
end
function Turtle.proto:turn(axis, angle)
	self.dir = (CFrame.fromAxisAngle(axis.Unit, angle) * self.dir).Unit
end

Turtle.proto.rules = {
	["["] = function(self)
		table.insert(self.stack, {
			pos = self.pos,
			dir = self.dir,
			speed = self.speed,
			transparency = self.transparency,
			color = self.color,
			pendown = self.pendown,
			turnAngle = self.turnAngle,
			lineWidth = self.lineWidth,
			canCollide = self.canCollide,
			castShadow = self.castShadow,
		})
	end,
	["]"] = function(self)
		local pop = table.remove(self.stack)
		self.pos = pop.pos
		self.dir = pop.dir
		self.speed = pop.speed
		self.transparency = pop.transparency
		self.color = pop.color
		self.pendown = pop.pendown
		self.turnAngle = pop.turnAngle
		self.lineWidth = pop.lineWidth
		self.canCollide = pop.canCollide
		self.castShadow = pop.castShadow
	end,
	F = function(self)
		if self.pendown then
			self:move(0.5)
			self:buildBranch(
				CFrame.lookAt(self.pos, self.pos + self.dir),
				Vector3.new(self.lineWidth,self.lineWidth,self.speed),
				self.color
			)
			self:move(0.5)
		else
			self:move(1)
		end
	end,
	f = function(self)
		if self.pendown then
			self:move(-0.5)
			self:buildBranch(
				CFrame.lookAt(self.pos, self.pos - self.dir),
				Vector3.new(self.lineWidth,self.lineWidth,self.speed),
				self.color
			)
			self:move(-0.5)
		else
			self:move(-1)
		end
	end,
	X = function(self)
		self:turn(Vector3.new(1,0,0), self.turnAngle)
	end,
	x = function(self)
		self:turn(Vector3.new(1,0,0), -self.turnAngle)
	end,
	Y = function(self)
		self:turn(Vector3.new(0,1,0), self.turnAngle)
	end,
	y = function(self)
		self:turn(Vector3.new(0,1,0), -self.turnAngle)
	end,
	Z = function(self)
		self:turn(Vector3.new(0,0,1), self.turnAngle)
	end,
	z = function(self)
		self:turn(Vector3.new(0,0,1), -self.turnAngle)
	end,
	P = function(self)
		self.pendown = true
	end,
	p = function(self)
		self.pendown = false
	end,
}

function Turtle.proto:build(str)
	for letter in string.gmatch(str, ".") do
		local handle = self.rules[letter]
		if handle then
			handle(self)
		end
	end
end
function Turtle.proto:reset()
	self.pos = original.pos
	self.dir = original.dir
	self.speed = original.speed
	self.transparency = original.transparency
	self.color = original.color
	self.pendown = original.pendown
	self.turnAngle = original.turnAngle
	self.lineWidth = original.lineWidth
	self.canCollide = original.canCollide
	self.castShadow = original.castShadow
end

return Turtle
