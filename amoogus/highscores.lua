
local highscores = table.load("C:\\Users\\marie\\AppData\\Roaming\\LOVE\\src\\allhighscores.lua")

function love.load(args)
end

function love.draw()
	local wh = love.graphics.getHeight()
	local by = (wh * 0.5) - 64
	local textoffset = 0
	love.graphics.draw(Background)
	love.graphics.print("Highscores", GameFont, 290, 0)

	for i,v in ipairs(highscores) do
		love.graphics.print(v.name.."    "..v.score, GameFont, 290, by + textoffset)
		textoffset = textoffset + 20
	end
end

function love.mousepressed( x, y, button, istouch, presses )
	if button == 1 then
		love.event.quit('restart')
	end
end

function love.quit()
	AllHighScoresTable.score = Highscore
end
