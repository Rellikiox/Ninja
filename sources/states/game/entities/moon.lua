local ent = ents:derive("base")

function ent:load( x1, y1, x2, y2 )
	self:setPos(x1, y1, 10)
	local x_dif = x2 - x1
	local y_dif = y2 - y1
	local dist = math.sqrt( x_dif * x_dif + y_dif * y_dif )
	self.x_inc = x_dif / dist
	self.y_inc = y_dif / dist
	self.x_end = x2
	self.y_end = y2
	self.img = love.graphics.newImage("textures/moon.png")
end

function ent:update(dt)
	self.pos_x = self.pos_x + self.x_inc * dt * 5
	self.pos_y = self.pos_y + self.y_inc * dt * 5
end

function ent:draw()
	love.graphics.draw(self.img, self.pos_x, self.pos_y)
end

return ent
