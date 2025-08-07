local LSystem = require(script.LSystem)
local Turtle = require(script.Turtle)

local plant1 = LSystem{
	axiom = "A",
	rules = {
		A = {
			["P[F][zF][ZF]pFA"]=1,
			["PFpA"]=1,
		},
	},
}

local folder = Instance.new("Folder")
folder.Parent = workspace
local t1 = Turtle{
	pos = Vector3.zero,
	container = folder,
}

local function growPlant(plant, turtle, pos, color, steps)
	turtle:reset()
	turtle.pos = pos
	turtle.color = color
	turtle:build(plant:run(steps,false))
end


growPlant(plant1, t1, Vector3.new(-20,10,10), Color3.new(1,0,0),5)
growPlant(plant1, t1, Vector3.new(-10,10,10), Color3.new(0,1,0),10)
growPlant(plant1, t1, Vector3.new(0,10,10), Color3.new(0,0,1),15)
growPlant(plant1, t1, Vector3.new(10,10,10), Color3.new(0,1,0),10)
growPlant(plant1, t1, Vector3.new(20,10,10), Color3.new(1,0,0),5)



local plant2 = LSystem{
	axiom = "PG",
	rules = {
		G = {
			["FG"] = 1,
			["[xF][XF][zF][ZF]F"] = 3,
		},
		F = "FFG",
	},
}

local model = Instance.new("Model")
model.Parent = workspace
t1.container = model
t1.turnAngle = math.rad(15)

growPlant(plant2, t1, Vector3.new(0,10,20), Color3.new(1,1,1),5)



local plant3 = LSystem{
	axiom = "PF",
	rules = {
		F = "FF[xF][XF][zF][ZF]-"
	},
}

local folder2 = Instance.new("Folder")
folder2.Parent = workspace
local t2 = Turtle{
	pos = Vector3.zero,
	container = folder2,
	lineWidth = 1,
	speed = 3,
	rules = {
		["-"] = function(self)
			self.lineWidth /= 1.2
			self.speed /= 1.1
		end,
	},
}


growPlant(plant3, t2, Vector3.new(0,10,-20), Color3.new(0,0,0), 6)
growPlant(plant3, t2, Vector3.new(0,10,-40), Color3.new(0,0,0), 5)
