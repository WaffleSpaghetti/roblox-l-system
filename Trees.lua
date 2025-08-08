local LSystem = require(game.ReplicatedStorage.LSystem)
local Turtle = require(game.ReplicatedStorage.Turtle)

local function chooseColor(colors)
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
			F = "G[[XvF]xvF][YvF]yvF",
			G = {
				["G"] = 3,
				["GG"] = 1,
			},
		}
	}
}
trees.turtles = {
	appleTurtle = Turtle{
		lineWidth = 3,
		speed = 3,
		rules = {
			["v"] = function(self)
				self.lineWidth /= 1.5
				self.speed /= 1.2
			end,
			["F"] = function(self)
				local colors = {
					["#669900"] = 10,
					["#00FF00"] = 10,
					["#FF0000"] = 1,
				}
				local pickedColor = chooseColor(colors)

				self:move(0.5)
				self:buildBranch(
					CFrame.lookAt(self.cframe.Position, self.cframe.Position + self.cframe.LookVector),
					Vector3.one*self.lineWidth*2,
					Color3.fromHex(pickedColor)
				)
				self:move(0.5)
			end,
			["G"] = function(self)
				self:move(0.5)
				self:buildBranch(
					CFrame.lookAt(self.cframe.Position, self.cframe.Position + self.cframe.LookVector),
					Vector3.new(self.lineWidth,self.lineWidth,self.speed),
					Color3.new(0.55,0.35,0)
				)
				self:move(0.5)
			end,
		},
	}
}

function trees:growApple(pos,dir,steps,container)
	local plant = self.plants.appleTree
	local turtle = self.turtles.appleTurtle

	turtle.container = container
	turtle:reset()
	turtle.cframe = CFrame.lookAt(pos,pos+dir.Unit)
	turtle:build(plant:run(steps,false))
end

return trees
