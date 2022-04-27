local margin = 16
BUTTON_HEIGHT = 64
Gameactive = false


local function exportstring( s )
    return string.format("%q", s)
end
 
 --// The Save Function
function table.save(  tbl,filename )
    local charS,charE = "   ","\n"
    local file,err = io.open( filename, "wb" )
    if err then return err end

    -- initiate variables for save procedure
    local tables,lookup = { tbl },{ [tbl] = 1 }
    file:write( "return {"..charE )

    for idx,t in ipairs( tables ) do
        file:write( "-- Table: {"..idx.."}"..charE )
        file:write( "{"..charE )
        local thandled = {}
  
        for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
                if not lookup[v] then
                    table.insert( tables, v )
                    lookup[v] = #tables
                end
                file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
                file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
                file:write(  charS..tostring( v )..","..charE )
            end
        end
  
        for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
                local str = ""
                local stype = type( i )
                -- handle index
                if stype == "table" then
                    if not lookup[i] then
                        table.insert( tables,i )
                        lookup[i] = #tables
                    end
                    str = charS.."[{"..lookup[i].."}]="
                elseif stype == "string" then
                    str = charS.."["..exportstring( i ).."]="
                elseif stype == "number" then
                    str = charS.."["..tostring( i ).."]="
                end
             
                if str ~= "" then
                    stype = type( v )
                    -- handle value
                    if stype == "table" then
                        if not lookup[v] then
                            table.insert( tables,v )
                            lookup[v] = #tables
                        end
                        file:write( str.."{"..lookup[v].."},"..charE )
                    elseif stype == "string" then
                        file:write( str..exportstring( v )..","..charE )
                    elseif stype == "number" then
                        file:write( str..tostring( v )..","..charE )
                    end
                end
            end
        end
    file:write( "},"..charE )
    end
    file:write( "}" )
    file:close()
end
    
 --// The Load Function
function table.load( sfile )
   local ftables,err = loadfile( sfile )
   if err then return _,err end
   local tables = ftables()
   for idx = 1,#tables do
      local tolinki = {}
      for i,v in pairs( tables[idx] ) do
         if type( v ) == "table" then
            tables[idx][i] = tables[v[1]]
         end
         if type( i ) == "table" and tables[i[1]] then
            table.insert( tolinki,{ i,tables[i[1]] } )
         end
      end
      -- link indices
      for _,v in ipairs( tolinki ) do
         tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
      end
   end
   return tables[1]
end

function sort(a,b)
    return a.score > b.score
end

function getTableSize(t)
    local count = 0
    for _, __ in pairs(t) do
        count = count + 1
    end
    return count
end

function DistanceBetween(x1, y1, x2, y2)
    return math.sqrt( (x2 - x1)^2 + (y2 - y1)^2 )
end

function TestForBackgroundImage()
    if Background:isPlaying() then return end
    Background:rewind()
    Background:play()
end

function TestForBackground2Image()
    if Background2:isPlaying() then return end
    Background2:rewind()
    Background2:play()
end
function TestForBackground3Image()
    if Background3:isPlaying() then return end
    Background3:rewind()
    Background3:play()
end

while Gameactive == false do
    local function newButton(text, fn)
        return {
            text = text,
            fn = fn,
            now = false,
            last = false
        }
    end

    Button1 = newButton("Start Game",  function()
        Gameactive = true
       end )
    
    local buttons = {}

    
    function love.load()
        local chkfile_allhighscores = io.open("C:\\Users\\marie\\AppData\\Roaming\\LOVE\\src\\allhighscores.lua", "r")
        if chkfile_allhighscores == nil then
            chkfile_allhighscores = love.filesystem.newFile("allhighscores.lua")
            chkfile_allhighscores:open("w")
            love.filesystem.write( "allhighscores.lua", "return {\n")
            love.filesystem.append( "allhighscores.lua", "-- Table: {1}\n")
            love.filesystem.append( "allhighscores.lua", "{\n")
            love.filesystem.append( "allhighscores.lua", "   {2},\n")
            love.filesystem.append( "allhighscores.lua", "},\n")
            love.filesystem.append( "allhighscores.lua", "-- Table: {2}\n")
            love.filesystem.append( "allhighscores.lua", "{\n")
            love.filesystem.append( "allhighscores.lua", "   [\"name\"]=\"Your Highscore\",\n")
            love.filesystem.append( "allhighscores.lua", "   [\"score\"]=0,")
            love.filesystem.append( "allhighscores.lua", "},\n")
            love.filesystem.append( "allhighscores.lua", "}\n")
        end
        chkfile_allhighscores:close()
        GameOver = true
        Target = {}
        Target2 = {}
        Target3 = {}
        Target.x = 300
        Target.y = 300
        Target.radius = 70
        Target.hit = false
        Target.resettimer = false
        Target.missed = false
        Target.draw = false
        Target2.x = 200
        Target2.y = 200
        Target2.radius = 70
        Target2.hit = false
        Target2.resettimer = false
        Target2.missed = false
        Target2.draw = false
        Target3.x = 400
        Target3.y = 300
        Target3.radius = 50
        Target3.hit = false
        Target3.resettimer = false
        Target3.missed = false
        Target3.draw = false
        Score = 0
        Highscore = 0
        Misses = 0
        old_time = 0
        new_time = 0
        Source = love.audio.newSource("music.ogg", "static")
        Source2 = love.audio.newSource("hahafuni.ogg", "static")
        Source3 = love.audio.newSource("Duel-of-the-Fates-Recorder.ogg", "static")
        GameFont = love.graphics.newFont("Pixeltype.ttf", 40)
        Title = love.window.setTitle("Fireball Conflicts")
        Gunshot = love.audio.newSource("pewpew.mp3", "static")
        Cursor = love.mouse.newCursor("output-onlinepngtools (2).png", 0, 0)
        Background = love.graphics.newVideo("outerspace-58.ogv")
        Background2 = love.graphics.newVideo("stage2background.ogv")
        Background3 = love.graphics.newVideo("outerspace-67.ogv")
        Spaceship = love.graphics.newImage("e.png")
        Spaceship2 = love.graphics.newImage("e2.png")
        FriendlySpaceship = love.graphics.newImage("e3.png")
        Music = love.audio.play(Source)
        SingularSaveFile = love.filesystem.newFile("yourhighscore.txt")
        love.window.setMode(800, 450)    
        AllHighScoresTable = table.load("C:\\Users\\marie\\AppData\\Roaming\\LOVE\\src\\allhighscores.lua")
        Highscore = AllHighScoresTable[1]['score']
        AllHighScoresTable_table_size =  getTableSize(AllHighScoresTable)
        if AllHighScoresTable_table_size < 10 then
            table.insert( AllHighScoresTable, 1 , {name = "Made by Caleb Serrano", score = math.random(5,6)} )
            table.insert( AllHighScoresTable, 1 , {name = "With help from his amazing dad", score = math.random(4,5)} )
            table.sort(AllHighScoresTable, sort)
            table.save(AllHighScoresTable, "C:\\Users\\marie\\AppData\\Roaming\\LOVE\\src\\allhighscores.lua")
        end
        Highscore = AllHighScoresTable[1]['score']
        stop_stage_1_banner = false
        printing_stage_banner = false
        stop_stage_2_banner = false
        printing_stage2_banner = false
        stop_stage_3_banner = false
        printing_stage3_banner = false
        check_that_timer_is_zero_or_if_it_isnt_then_make_it_zero = false
        checkpos = DistanceBetween(Target.x, Target.y, Target3.x, Target3.y)
        checkpos2 = DistanceBetween(Target2.x, Target2.y, Target3.x, Target3.y)
    end

    function love.update()
        TestForBackgroundImage()

    end

    function love.draw()
        local ww = love.graphics.getWidth()
        local wh = love.graphics.getHeight()
        local margin = 16
        local breakloop = false
        local button_width = ww * (1/3)
        local total_heigth = (BUTTON_HEIGHT + margin) * #buttons
        local Cursor_y = 0
        bx = (ww * 0.5) - (button_width * 0.5)
        by = (wh * 0.5) - (total_heigth * 0.5) + Cursor_y
        by2 = by + 80
        local color = {188/255, 126/255, 220/255, 0.6}
        local mx, my = love.mouse.getPosition()
        local hot = mx > bx and mx < bx + button_width and my > by and my < by + BUTTON_HEIGHT
        local hot2 = mx > bx and mx < bx + button_width and my > by2 and my < by2 + BUTTON_HEIGHT
        Button1.now = love.mouse.isDown(1)
        
        while hot and breakloop == false do
            color = {115/255, 51/255, 153/255, 0.9}
            if Button1.now == true then
                old_time = love.timer.getTime()
                dofile("C:\\Users\\marie\\Desktop\\Lua\\amoogus\\stage1.lua")
                breakloop = true
                GameOver = false
            end
        break
        end
        while hot2 and breakloop == false do
            color = {115/255, 51/255, 153/255, 0.9}
            if Button1.now == true then
                dofile("C:\\Users\\marie\\Desktop\\Lua\\amoogus\\highscores.lua")
                Gameactive = true
                breakloop = true
            end
        break
        end
        love.graphics.draw(Background)
        love.graphics.setColor(unpack(color))
        love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT )
        love.graphics.rectangle("fill", bx, by2, button_width, BUTTON_HEIGHT )
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print("Start Game", GameFont, bx + 60, by + 20)
        love.graphics.print("Highscores", GameFont, bx + 60, by2 + 20)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(Highscore, GameFont, 740, 430)    
        Cursor_y = Cursor_y + (BUTTON_HEIGHT + margin)
    end
    
break
end

