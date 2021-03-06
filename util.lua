--[[
    util.lua
    Contains global utility functions

    Authors:
        Daniel Rolandi
--]]

function string.startsWith(word, substr)
    return (substr == '') or (string.sub(word, 1, string.len(substr)) == substr)
end

function string.endsWith(word, substr)
    return (substr == '') or (string.sub(word, -string.len(substr)) == substr)
end

function round(number, place)
    if place < 0 then
        if DEBUG then
            print("Bad rounding -- 2nd argument must be at least 0")
        end
        return number
    end

    return math.floor(number * math.pow(10, place)) / math.pow(10, place)
end

function distance(x1, y1, x2, y2)
    local deltaX = x2 - x1
    local deltaY = y2 - y1
    return math.sqrt( deltaX * deltaX + deltaY * deltaY )
end