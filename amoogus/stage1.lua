local cron = require("cron")

local seconds = 0
local timer = cron.every(1, function() seconds = seconds + 1 end)
function love.load()
   
end

function love.update(dt)
    
    if GameOver == false and stop_stage_1_banner == false and printing_stage_banner == true then
        new_time = love.timer.getTime()
        local time_diff = new_time - old_time
        if time_diff > 3 then
            love.timer.sleep(2)
            stop_stage_1_banner = true  
            Misses = 0
            Target.draw = true
        end 
    end

    TestForBackgroundImage()
    if GameOver == false and stop_stage_1_banner == true then
        if seconds > 0 and check_that_timer_is_zero_or_if_it_isnt_then_make_it_zero == false then
            seconds = 0
            Misses = 0
            check_that_timer_is_zero_or_if_it_isnt_then_make_it_zero = true
        end
        timer:update(dt)
        if seconds == 5 then
            Misses = Misses + 1
            Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
            Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius) 
            seconds = 0
        end
        
        if Score > Highscore then
            Highscore = Score
        end  
        
        if Score > 9 then
            Source:stop()
            Source2:play()
            Target.draw = false
            dofile("C:\\Users\\marie\\Desktop\\Lua\\amoogus\\stage2.lua")
        end

        if Misses >= 3  then 
            GameOver = true    
        end
    
    end
    
    if GameOver == true then
        if Score >= Highscore then
            table.insert(AllHighScoresTable, 1 , {name = "Your Highscore", score = Highscore})
            table.sort(AllHighScoresTable, sort)        
        end

        while AllHighScoresTable_table_size >= 11 do
            table.remove(AllHighScoresTable, 11)
            AllHighScoresTable_table_size = getTableSize(AllHighScoresTable)
        end
        table.save(AllHighScoresTable ,"C:\\Users\\marie\\AppData\\Roaming\\LOVE\\src\\allhighscores.lua")
        love.event.quit('restart')
    end
end


function love.draw()
    love.graphics.setFont(GameFont) 
    love.graphics.print(Score, 0, 0)
    love.mouse.setCursor(Cursor)
    Background:play()
    if Background:isPlaying() == false then
        Background:play()
    end
    love.graphics.draw(Background)
    love.graphics.setColor(1, 1, 1, 1)
    if Target.draw == true then
        love.graphics.draw(Spaceship, Target.x, Target.y, Target.radius)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(GameFont)
    love.graphics.print(Score, 0, 0)
    love.graphics.print(Misses, 0, 430)
    love.graphics.print(Highscore, 740, 430)
    love.graphics.print(seconds, 760, 0)

        
    if stop_stage_1_banner == false then
        love.graphics.print("Stage 1", GameFont, bx + 60, by + 20)
        love.graphics.print("GO!", GameFont, bx + 60, by2 + 20)
        printing_stage_banner = true 
    end
end




function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 and stop_stage_1_banner == true  then
        MouseToTarget = DistanceBetween(x, y, Target.x, Target.y)
        if MouseToTarget < Target.radius then
            Score = Score + 1
            Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
            Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)
            Gunshot:stop()
            Gunshot:play()
            seconds = 0
        end
        

        if MouseToTarget > Target.radius and stop_stage_1_banner == true then
            Misses = Misses + 1
            seconds = 0
        end
    end
end