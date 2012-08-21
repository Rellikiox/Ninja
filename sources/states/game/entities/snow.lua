snow = {}

snow.FGflakes = {}
snow.BGflakes = {}
snow.textures = {}
snow.x = 0
snow.y = 0
snow.w = 0
snow.h = 0

function snow:load(x, y, w, h, n, textures)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.textures = textures
	local textures_size = table.getn(textures)
	
	for i = 1, n, 1 do
		flake = {	
			start_x = math.random(x, w),
			pos_x = x,
			pos_y = math.random(y - h, y),
			birth = love.timer.getMicroTime() + math.random(- math.pi, math.pi),
			fall_speed = math.random(20,40),
			rot_speed = math.random(math.rad(-4),math.rad(4)),
			rot = math.random(- math.pi, math.pi),
			img_index = math.random(0, textures_size - 1)
		}
		if i > n / 2 then
			table.insert(self.FGflakes, flake)
		else
			table.insert(self.BGflakes, flake)
		end
	end
end

function snow:update(dt)

	update_flake = function (flake) 
		flake.rot = flake.rot + flake.rot_speed * dt
		flake.pos_y = flake.pos_y + flake.fall_speed * dt
		if (flake.pos_y > self.y + self.h) then
			flake.pos_y = 0
			flake.speed = math.random(20,40)
			flake.pos_x = math.random(self.x, self.w)
		else
			flake.pos_x = flake.start_x + math.sin(flake.birth - love.timer.getMicroTime())
		end
	end

	for k,flake in pairs(self.FGflakes) do
		update_flake(flake)
	end
	for k,flake in pairs(self.BGflakes) do
		update_flake(flake)
	end
	
end

function snow:drawFG()
	love.graphics.setColor(255, 255, 255, 255)
	for k,flake in pairs(self.FGflakes) do
		--love.graphics.rectangle("fill", flake.pos_x, flake.pos_y, 1, 1)
		love.graphics.draw(self.textures[flake.img_index], flake.pos_x, flake.pos_y, flake.rot)
	end
end

function snow:drawBG()
	love.graphics.setColor(255, 255, 255, 255)
	for k,flake in pairs(self.BGflakes) do
		--love.graphics.rectangle("fill", flake.pos_x, flake.pos_y, 1, 1)
		love.graphics.draw(self.textures[flake.img_index], flake.pos_x, flake.pos_y, 0, 1.5, 1.5)
	end
end

return snow