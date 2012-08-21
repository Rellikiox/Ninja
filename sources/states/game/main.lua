TLbind,control = love.filesystem.load("libs/TLbind.lua")()
require("libs/SICK")
require("libs/anal")
require("libs/TEsound")

last_update = love.timer.getMicroTime()
prev_fram = 0
fps = 9001
function load()
	require("states/game/entities")
	require("states/game/entities/snow")
	
	ents.load()
	ents:add( "player", 400, 300 )	
	
	fsharp = love.graphics.newImage("textures/fsharpposter.png")
	
	textures = {
		[0] = love.graphics.newImage("textures/flake_01.png"),
		[1] = love.graphics.newImage("textures/flake_02.png"),
		[2] = love.graphics.newImage("textures/flake_03.png"),
		[3] = love.graphics.newImage("textures/flake_04.png"),
	}
	snow:load(0, 0, 800, 300, 100, textures)
end

function love.draw()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.line(0,300,800,300)
	--love.graphics.print(fps, 20, 20)
	love.graphics.setColor(255, 0, 0)
	love.graphics.rectangle("fill", 100, 300, 1, 1)
	
	snow:drawBG()
	
	love.graphics.draw(fsharp, 500, 268)
	
	ents:draw()
	
	snow:drawFG()
end

function love.update(dt)
	if (love.timer.getMicroTime() - last_update > 1) then
		fps = math.floor(1 / (love.timer.getMicroTime() - prev_frame))
		last_update = love.timer.getMicroTime()
	end
	prev_frame = love.timer.getMicroTime()
	ents:update(dt)
	TLbind:update()
	
	snow:update(dt)
	
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
