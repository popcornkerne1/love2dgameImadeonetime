local cron = require("cron")

local seconds = 0
local timer = cron.every(1, function() seconds = seconds + 1 end)
function love.load()
   
end

function love.update(dt)
    
    if GameOver == false and stop_stage_2_banner == false and printing_stage2_banner == true then
        new_time = love.timer.getTime()
        local time_diff = new_time - old_time
        if time_diff > 3 then
            love.timer.sleep(2)
            stop_stage_2_banner = true  
            Misses = 0
            Target.draw = true
            Target2.draw = true
        end 
    end

    TestForBackground2Image()
    if GameOver == false and stop_stage_2_banner == true then
        if seconds > 0 and check_that_timer_is_zero_or_if_it_isnt_then_make_it_zero == false then
            seconds = 0
            check_that_timer_is_zero_or_if_it_isnt_then_make_it_zero = true
        end
        timer:update(dt)
        if seconds == 5 and (Target.hit == false or Target2.hit == false) then
            Misses = Misses + 1
            Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
            Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius) 
            Target2.x = math.random(Target2.radius, love.graphics.getWidth() - Target2.radius)
            Target2.y = math.random(Target2.radius, love.graphics.getHeight() - Target2.radius) 
            seconds = 0
            Target.hit = false
            Target2.hit = false
            Target.resettimer = false
            Target2.resettimer = false
            Target.missed = false
            Target2.missed = false
            Target.draw = true
            Target2.draw = true
        end

        if seconds < 5 and Target.resettimer == true and Target2.resettimer == true then
            seconds = 0
            Target.resettimer = false
            Target2.resettimer = false
            Target.hit = false
            Target2.hit = false
            Target.missed = false
            Target2.missed = false
            Target.draw = true
            Target2.draw = true
        end
        
        if Score > Highscore then
            Highscore = Score
        end  

        if Misses >= 3  then 
            GameOver = true    
        end

        
        if Score > 24 then
            Source2:stop()
            Source3:play()
            Target.draw = false
            Target2.draw = false
            Target3.draw = false
            dofile("C:\\Users\\marie\\Desktop\\Lua\\amoogus\\stage3.lua")
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
    Background2:play()
    love.graphics.draw(Background2)
    love.graphics.setColor(1, 1, 1, 1)
    if Target.resettimer == false and Target.draw == true then
        love.graphics.draw(Spaceship, Target.x, Target.y, Target.radius)
    end
    if Target2.resettimer == false and Target2.draw == true then
        love.graphics.draw(Spaceship2, Target2.x, Target2.y, Target2.radius)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(GameFont)
    love.graphics.print(Score, 0, 0)
    love.graphics.print(Misses, 0, 430)
    love.graphics.print(Highscore, 740, 430)
    love.graphics.print(seconds, 760, 0)

        
    if stop_stage_2_banner == false then
        love.graphics.print("Stage 2", GameFont, bx + 60, by + 20)
        love.graphics.print("GO!", GameFont, bx + 60, by2 + 20)
        printing_stage2_banner = true 
    end
end




function love.mousepressed( x, y, button, istouch, presses )
    if button == 1 and stop_stage_2_banner == true  then
        MouseToTarget = DistanceBetween(x, y, Target.x, Target.y)
        MouseToTarget2 = DistanceBetween(x, y, Target2.x, Target2.y)
        if MouseToTarget < Target.radius and Target.hit == false then
            Score = Score + 1
            Target.x = math.random(Target.radius, love.graphics.getWidth() - Target.radius)
            Target.y = math.random(Target.radius, love.graphics.getHeight() - Target.radius)
            Gunshot:stop()
            Gunshot:play()
            Target.hit = true
            Target.resettimer = true
            Target.draw = false

        elseif MouseToTarget2 < Target2.radius and Target2.hit == false then
            Score = Score + 1
            Target2.x = math.random(Target2.radius, love.graphics.getWidth() - Target2.radius)
            Target2.y = math.random(Target2.radius, love.graphics.getHeight() - Target2.radius)
            Gunshot:stop()
            Gunshot:play()
            Target2.hit = true
            Target2.resettimer = true
            Target2.draw = false
    
        elseif ((MouseToTarget > Target.radius)and Target.hit == false) or ((MouseToTarget2 > Target2.radius)and Target2.hit == false) and stop_stage_2_banner == true then
            Target.missed = true
        end
        
        if Target.missed == true then
            Misses = Misses + 1
            Target.missed = false
            seconds = 0
        end
    end
end



