ents = {}
ents.objectsList = {}
ents.drawingList = {}
ents.objpath = "states/game/entities/"
local register = {}
local id = 0

function ents:Startup()
	register["player"] = love.filesystem.load( ents.objpath .. "player.lua" )
	--register["snowflake"] = love.filesystem.load( ents.objpath .. "snowflake.lua" )
end

function ents:Derive(name)
	return love.filesystem.load( ents.objpath .. name .. ".lua" )()
end

function ents:Create(name, x, y)
	if not x then
		x = 0
	end
	if not y then
		y = 0
	end

	if register[name] then
		id = id + 1
		local ent = register[name]()
		ent:load(x,y)
		ent.type = name
		ent.id = id
		if (ent.draw) then
			table.insert(ents.drawingList, ent)
			table.sort(ents.drawingList, function (a,b) return a:getZ() > b:getZ() end)
		end
		ents.objectsList[id] = ent
		return ents.objectsList[id]
	else
		print("Error: Entity " .. name .. " does not exist! Snap!")
		return false;
	end
end

function ents:Destroy( id )
	if ents.objects[id] then
		if ents.objects[id].Die then
			ents.objects[id]:Die()
		end
		ents.objects[id] = nil
	end
end

function ents:update(dt)
	for i, ent in pairs(ents.objectsList) do
		if ent.update then
			ent:update(dt)
		end
	end
end

function ents:draw()
	for i, ent in ipairs(ents.drawingList) do
		ent:draw()
	end
end