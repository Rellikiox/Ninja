

last_update = love.timer.getMicroTime()
prev_fram = 0
fps = 9001
function load()
	TLbind,control = love.filesystem.load("libs/TLbind.lua")()
	require("libs/SICK")
	require("libs/anal")
	require("libs/TEsound")
	require("states/game/entities")
	--require("states/game/entities/snow")
	
	ents.load()
	ents:add( "player", 400, 300 )	

	-- sky
	bgImage = love.graphics.newImage("textures/background.png")
	bgImage:setWrap("repeat", "clamp")
	bgQuad = love.graphics.newQuad(
		0, 0,
		800, bgImage:getHeight(),
		bgImage:getWidth(), bgImage:getHeight()
	)

	-- stars
	stars = love.graphics.newImage( "textures/stars.png" )
	
	stars_quads = {
		[0] = love.graphics.newQuad( 0,  0, 6, 6, stars:getWidth(), stars:getHeight() ),
		[1] = love.graphics.newQuad( 6,  0, 6, 6, stars:getWidth(), stars:getHeight() ),
		[2] = love.graphics.newQuad( 12, 0, 6, 6, stars:getWidth(), stars:getHeight() )
	}
	stars_batch = love.graphics.newSpriteBatch( stars, 100 )
	
	for i = 1, 20, 1 do
		stars_batch:addq( stars_quads[0], math.random( 0, 800), math.random( 0, 300) )
	end
	for i = 1, 30, 1 do
		stars_batch:addq( stars_quads[1], math.random( 0, 800), math.random( 0, 300) )
	end
	for i = 1, 50, 1 do
		stars_batch:addq( stars_quads[2], math.random( 0, 800), math.random( 0, 300) )
	end
	
	-- moon
	
	ents:add( "moon", 0, 0, 100, 100 )
end

function love.draw()
	love.graphics.setColor(255, 255, 255)
	--love.graphics.print(fps, 20, 20)
	love.graphics.drawq(bgImage, bgQuad, 0, 0)
	--love.graphics.draw(moon, 40, 10)
	
	love.graphics.draw(stars_batch)
	
--	snow:drawBG()
	
	ents:draw()
	
	--snow:drawFG()
	
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("fill", 0, 300, 800, 300)
end

function love.update(dt)
	if (love.timer.getMicroTime() - last_update > 1) then
		fps = math.floor(1 / (love.timer.getMicroTime() - prev_frame))
		last_update = love.timer.getMicroTime()
	end
	prev_frame = love.timer.getMicroTime()
	ents:update(dt)
	TLbind:update()
	
	--snow:update(dt)
	
	if control.tap.exit then
		love.event.push("quit")
	end
end

function love.focus(bool)
end

function love.keypressed( key, unicode )
end

function love.keyreleased( key, unicode )
	
end

function love.mousepressed( x, y, button )
end

function love.mousereleased( x, y, button )
end

function love.quit()
end
