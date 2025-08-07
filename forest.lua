local Trees = require(game.ReplicatedStorage.Trees)

local size = 60
for x=-size,size,20 do
	for z=-size,size,20 do
		Trees:growApple(Vector3.new(x,10,z),4)
	end
end

--Trees:growSakura(Vector3.new(0,10,120),8)
