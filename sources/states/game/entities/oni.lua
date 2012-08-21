local ent = ents:derive("base")

function ent:load( x, y, dir )
	self:setPos(x, y, 1)
	self.velocity = 0
	self.health = 100
	self.max_health = self.health
	self.jump_count = 0
	self.attack_time = 0
	self.dir = 1
end