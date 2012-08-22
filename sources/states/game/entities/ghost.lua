local ent = ents:derive("base")

local ghost_cooldown = 3

function ent:load( x, y, dir )
	self:setPos(x, y, 1)
	self.start_y = y
	self.velocity = 0
	self.health = 100
	self.max_health = self.health
	self.dir = 1
	self.target = nil
	self.timer = love.timer.getMicroTime()
	self.birth = self.timer
	self.img = love.graphics.newImage("textures/peasant_ghost.png")
end

function ent:update(dt)
	local curr_time = love.timer.getMicroTime()
	if self.target then
		if (ents:getEntity(self.target).pos_x - self.pos_x < - 14) then
			self.dir = -1
		else
			self.dir = 1
		end
		self.pos_x = self.pos_x + dt * self.dir * 25
	elseif (curr_time - self.timer > ghost_cooldown) then
		self.timer = curr_time
		local objs = ents:getEntities("player")
		if objs and #objs > 0 then
			self.target = objs[ math.random( #objs ) ].id
		end
	end
	self.pos_y = self.start_y + (math.sin( curr_time - self.birth ) - 1) * 4
end

function ent:draw()
	love.graphics.draw(self.img, self.pos_x, self.pos_y, 0, self.dir, 1, self.img:getWidth() / 2, self.img:getHeight())
end

return ent