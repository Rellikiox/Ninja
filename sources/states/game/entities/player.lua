local ent = ents:derive("base")

local shuriken_delay = 0.3

function ent:load( x, y )
	self:setPos(x, y, 1)
	self.velocity = 0
	self.health = 100
	self.max_health = self.health
	self.jump_count = 0
	self.attack_time = 0
	self.dir = 1
	self.last_throw = 0
	
	-- Sounds
	self.sounds = {
		hit = "sounds/hit.wav",
		jump = "sounds/jump.wav"
	}
	
	-- Animation
	self.animations = {
		body = {
			getAnim = 
				function () 
					return self.animations.body[self.animations.body.current][self.dir] 
				end,
			current = "stance",
			["stance"] = {
				[1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/body_stance_r.png"), 
						25, 
						42, 
						3, 
						0),
					x = 0,
					y = 41
				},
				[-1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/body_stance_l.png"), 
						25, 
						42, 
						3, 
						0),
					x = 0,
					y = 41
				}
			},
			["run"] = {
				[1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/body_run_r.png"), 
						25, 
						42, 
						0.2, 
						0),
					x = 0,
					y = 41
				},
				[-1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/body_run_l.png"), 
						25, 
						42, 
						0.2, 
						0),
					x = 0,
					y = 41
				}
			},
			["jump"] = {
				[1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/body_jump_r.png"), 
						24, 
						35, 
						0.2, 
						0),
					x = 0,
					y = 40
				},
				[-1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/body_jump_l.png"), 
						24, 
						35, 
						0.2, 
						0),
					x = 0,
					y = 40
				}
			}
		},
		band = {
			getAnim = 
				function () 
					return self.animations.band[self.animations.band.current][self.dir] 
				end,
			current = "stance",
			["stance"] = {
				[1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/band_stance_r.png"), 
						5, 
						8, 
						0.2, 
						0),
					x = 4,
					y = 11
				},
				[-1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/band_stance_l.png"), 
						5, 
						8, 
						0.2, 
						0),
					x = -24,
					y = 11
				}
			},
			["run"] = {
				[1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/band_run_r.png"), 
						35, 
						12, 
						0.2, 
						0),
					x = 32,
					y = 43
				},
				[-1] = {
					anim = newAnimation(
						love.graphics.newImage("textures/band_run_l.png"), 
						35, 
						12, 
						0.2, 
						0),
					x = -22,
					y = 43
				}
			}
		},
		sword = {
			getAnim = 
				function () 
					return self.animations.sword[self.dir] 
				end,
			[1] = {
				anim = newAnimation(
					love.graphics.newImage("textures/sword_swing_r.png"), 
					45, 
					48, 
					0.03, 
					0),
				x = -6,
				y = 42
			},
			[-1] = {
				anim = newAnimation(
					love.graphics.newImage("textures/sword_swing_l.png"), 
					45, 
					48, 
					0.03, 
					0),
				x = 26,
				y = 42
			}
		}
	}

	self.animations.body["stance"][1].anim:setDelay(2,0.15)
	self.animations.body["stance"][-1].anim:setDelay(2,0.15)
end

function ent:update(dt) 

	self:checkInput()
	
	self:updateFlags()
	
	-- update position
	self:updateMovement(dt)
	-- check for collisions
	
	-- update the animations
	self:updateAnimations(dt)
end

function ent:updateFlags()
	local prev_ori = self.dir
	if (ent.vel_x < 0) then
		self.dir = -1
	elseif (ent.vel_x > 0) then
		self.dir = 1
	end
	
	if (prev_ori ~= self.dir) then
		self.attack_time = 0
	end
	
	if(self.pos_y > 300) then
		self.pos_y = 300
		self.ground = true
		self.jump_count = 0
	end
end

function ent:updateAnimations(dt)
	if self.attack_time ~= 0 then
		if (love.timer.getMicroTime() - self.attack_time) > 0.180 then
			self.attack_time = 0
		end
		self.animations.sword[1].anim:update(dt)
		self.animations.sword[-1].anim:update(dt)
	elseif not self.ground then
		self.animations.body.current = "jump"
		self.animations.band.current = "run"
	elseif self.vel_x ~= 0 then
		self.animations.body.current = "run"
		self.animations.band.current = "run"
	else
		self.animations.body.current = "stance"
		self.animations.band.current = "stance"
	end
	
	self.animations.body.getAnim().anim:update(dt)
	self.animations.band.getAnim().anim:update(dt)
end

function ent:checkInput()
	local vel_x = 0
	if control.left then
		vel_x = -100
	end
	if control.right then
		vel_x = vel_x + 100
	end
	ent.vel_x = vel_x
	
	if control.tap.jump and ent.jump_count < 2 then
		ent.jump_count = ent.jump_count + 1
		ent.ground = false
		ent.vel_y = 300
		TEsound.play(self.sounds.jump)
	end
	if control.tap.attack then
		ent:attack()
	end
	if control.throw and (love.timer.getMicroTime() - self.last_throw > shuriken_delay) then
		ents:add( "shuriken", self.pos_x + 14, self.pos_y - 20, self.dir)
		self.last_throw = love.timer.getMicroTime()
	end
end

function ent:attack()
	self.attack_time = love.timer.getMicroTime()
	self.animations.sword.getAnim().anim:reset()
	TEsound.play(self.sounds.hit)
end

function ent:draw() 
	love.graphics.setColor( 255, 255, 255, 255 )

	local body_x, band_x = self.pos_x, self.pos_x
	local body_y, band_y = self.pos_y, self.pos_y
	
	body_x = body_x - self.animations.body.getAnim().x
	body_y = body_y - self.animations.body.getAnim().y
	
	band_x = band_x - self.animations.band.getAnim().x
	band_y = band_y - self.animations.band.getAnim().y
	
	self.animations.body.getAnim().anim:draw(body_x, body_y)
	self.animations.band.getAnim().anim:draw(band_x, band_y)
	
	if self.attack_time ~= 0 then
		local sword_x = self.pos_x - self.animations.sword.getAnim().x
		local sword_y = self.pos_y - self.animations.sword.getAnim().y
		
		self.animations.sword.getAnim().anim:draw(sword_x, sword_y)
	end
end

return ent