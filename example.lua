local LSystem = require(script.LSystem)
local Turtle = require(script.Turtle)

local obj1 = LSystem{
	axiom = "A",
	rules = {
		A = {
			["P[F][zF][ZF]pFA"]=1,
			["PFpA"]=1,
		},
	},
}
local obj2 = LSystem{
	axiom = "PF",
	rules = {
		F = "FF",
	},
}

print(obj2:run(4))

local folder = Instance.new("Folder")
local t1 = Turtle{
	pos = Vector3.new(0,10,-10),
	container = folder,
}

t1:build(obj1:run(10,false))

t1.pos = Vector3.new(-10,10,-10)
t1.color = Color3.new(0,0,1)
t1:build(obj1:run(15,false))
folder.Parent = workspace



local model = Instance.new("Model")
t1.pos = Vector3.new(10,10,-10)
t1.container = model
t1.color = Color3.new(0,1,0)
t1:build(obj2.string)
model.Parent = workspace
