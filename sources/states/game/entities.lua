ents = {}

ents.objectsList = {}
ents.drawingList = {}
ents.objpath = "states/game/entities/"

local register = {}
local id = 0

function ents:load()
	register["player"] = love.filesystem.load( ents.objpath .. "player.lua" )
	register["shuriken"] = love.filesystem.load( ents.objpath .. "shuriken.lua" )
end

function ents:derive(name)
	return love.filesystem.load( ents.objpath .. name .. ".lua" )()
end

function ents:add(name, ...)
	if register[name] then
		id = id + 1
		local ent = register[name]()
		ent:load(unpack(arg))
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

function ents:remove(id)
	if ents.objectsList[id] then
		if ents.objectsList[id].Die then
			ents.objectsList[id]:Die()
		end
		ents.objectsList[id] = nil
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

return ents