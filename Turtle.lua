local Turtle = {}

-- lua class setup
Turtle.proto = {}
Turtle.meta = {}

Turtle.meta.__index = Turtle.proto

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
Turtle.proto.rules = {
	["["] = function(self)
		local c = self.color
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
			self.pos = self.pos + self.dir.Unit * self.speed/2
			
			local part = Instance.new("Part")
			part.Size = Vector3.new(self.lineWidth,self.lineWidth,self.speed)
			part.CanCollide=self.canCollide
			part.CastShadow=self.castShadow
			part.Material=self.material
			part.Transparency=self.transparency
			part.Anchored = true
			part.Color = self.color
			part.CFrame = CFrame.lookAt(self.pos, self.pos + self.dir)
			part.Parent = self.container
			
			self.pos = self.pos + self.dir.Unit * self.speed/2
		else
			self.pos = self.pos + self.dir.Unit * self.speed
		end
	end,
	f = function(self)
		if self.pendown then
			self.pos = self.pos + self.dir.Unit * self.speed/2 * -1

			local part = Instance.new("Part")
			part.Size = Vector3.new(self.lineWidth,self.lineWidth,self.speed)
			part.CanCollide=self.canCollide
			part.CastShadow=self.castShadow
			part.Material=self.material
			part.Transparency=self.transparency
			part.Anchored = true
			part.Color = self.color
			part.CFrame = CFrame.lookAt(self.pos, self.pos - self.dir)
			part.Parent = self.container

			self.pos = self.pos + self.dir.Unit * self.speed/2 * -1
		else
			self.pos = self.pos + self.dir.Unit * self.speed * -1
		end
	end,
	X = function(self)
		self.dir = (CFrame.fromAxisAngle(Vector3.new(1, 0, 0), self.turnAngle) * self.dir)
	end,
	x = function(self)
		self.dir = (CFrame.fromAxisAngle(Vector3.new(1, 0, 0), -self.turnAngle) * self.dir)
	end,
	Y = function(self)
		self.dir = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), self.turnAngle) * self.dir)
	end,
	y = function(self)
		self.dir = (CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -self.turnAngle) * self.dir)
	end,
	Z = function(self)
		self.dir = (CFrame.fromAxisAngle(Vector3.new(0, 0, 1), self.turnAngle) * self.dir)
	end,
	z = function(self)
		self.dir = (CFrame.fromAxisAngle(Vector3.new(0, 0, 1), -self.turnAngle) * self.dir)
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

return Turtle
