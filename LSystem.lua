local LSystem = {}

-- lua class setup
LSystem.proto = {}
LSystem.meta = {}

LSystem.meta.__index = LSystem.proto

function LSystem.new(obj)
	obj = obj or {}
	obj.string = obj.string or obj.axiom or ""
	setmetatable(obj, LSystem.meta)
	return obj
end

setmetatable(LSystem, {
	__call = function(_, ...) return LSystem.new(...) end
})

-- helpers
local function choose(rules, letter)
	local replacement = rules[letter] or letter
	if type(replacement) == "table" then
		local accumulator = 0
		for _, weight in pairs(replacement) do
			accumulator += weight
		end
		local random = math.random()*accumulator
		for pick, weight in pairs(replacement) do
			if random<weight then return pick end
			random -= weight
		end
	end
	return replacement
end

-- main
LSystem.proto.axiom = ""
LSystem.proto.rules = {}

function LSystem.proto:step(updateSelf)
	updateSelf = updateSelf~=false
	local old = self.string
	local new = {}
	for letter in string.gmatch(old, ".") do
		local replacement = choose(self.rules, letter)
		table.insert(new, replacement)
	end
	local newString = table.concat(new)
	self.string = (updateSelf and newString) or self.string
	return newString
end
function LSystem.proto:run(steps, updateSelf)
	updateSelf = updateSelf~=false
	local newString = nil
	for i=1, steps do
		newString = self:step()
	end
	self.string = updateSelf and self.string or self.axiom
	return newString
end
function LSystem.proto:reset()
	self.string = self.axiom or ""
end

return LSystem
