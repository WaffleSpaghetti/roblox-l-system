local LSystem = require(game.ReplicatedStorage.LSystem)
local Turtle = require(game.ReplicatedStorage.Turtle)

local function choose(colors)
	local accumulator = 0
	for _, weight in pairs(colors) do
		accumulator += weight
	end
	local random = math.random()*accumulator
	for pick, weight in pairs(colors) do
		if random<weight then return pick end
		random -= weight
	end
end

local trees = {}
trees.plants = {
	appleTree = LSystem{
		axiom = "GF",
		rules = {
			F = "G[[XvF]xvF][ZvF]zvF",
			G = {
				["G"] = 1,
				["GG"] = 1,
			},
		}
	}
}
trees.turtles = {
	appleTurtle = Turtle{
		lineWidth = 2,
		speed = 3,
		rules = {
			["v"] = function(self)
				self.lineWidth /= 1.5
				self.speed /= 1.2
			end,
			
			["F"] = function(self)
				self.pos = self.pos + self.dir.Unit * self.speed/2
				
				local colors = {
					["#669900"] = 10,
					["#00FF00"] = 10,
					["#FF0000"] = 1,
				}
				
				local part = Instance.new("Part")
				part.Size = Vector3.one * 1.5
				part.CanCollide=self.canCollide
				part.CastShadow=self.castShadow
				part.Material=self.material
				part.Transparency=self.transparency
				part.Anchored = true
				local pickedColor = choose(colors)
				part.Color = Color3.fromHex(pickedColor)
				part.CFrame = CFrame.lookAt(self.pos, self.pos + self.dir)
				part.Parent = self.container

				self.pos = self.pos + self.dir.Unit * self.speed/2
			end,
			["G"] = function(self)
				self.pos = self.pos + self.dir.Unit * self.speed/2
				
				local part = Instance.new("Part")
				part.Size = Vector3.new(self.lineWidth,self.lineWidth,self.speed)
				part.CanCollide=self.canCollide
				part.CastShadow=self.castShadow
				part.Material=self.material
				part.Transparency=self.transparency
				part.Anchored = true
				part.Color = Color3.new(0.55,0.35,0)
				part.CFrame = CFrame.lookAt(self.pos, self.pos + self.dir)
				part.Parent = self.container

				self.pos = self.pos + self.dir.Unit * self.speed/2
			end,
		},
	}
}

function trees:growApple(pos,steps,container)
	local plant = self.plants.appleTree
	local turtle = self.turtles.appleTurtle
	
	turtle.container = container
	turtle:reset()
	turtle.pos = pos
	turtle:build(plant:run(steps,false))
end

--[[
function trees:growSakura(pos,steps,container)
	local plant = self.plants.sakuraTree
	local turtle = self.turtles.sakuraTurtle
	
	turtle.container = container
	turtle:reset()
	turtle.pos = pos
	turtle:build(plant:run(steps,false))
end
]]

return trees
