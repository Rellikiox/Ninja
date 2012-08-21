local ent = ents:derive("base")

ent.speed = 500 -- pixels per second

function ent:load( x, y, dir )
	self:setPos(x, y, 0)
	self.pos_x = x
	self.pos_y = y
	self.speed = self.speed * dir
	self.rot = math.random(0, 360)

	self.img = love.graphics.newImage("textures/shuriken.png")
end

function ent:update(dt)
	self.pos_x = self.pos_x + self.speed * dt
	self.rot = self.rot + self.speed * dt
end

function ent:draw()
	love.graphics.draw(self.img, self.pos_x, self.pos_y, math.rad(self.rot), 1, 1, self.img:getWidth() / 2, self.img:getHeight() / 2)
end

return ent