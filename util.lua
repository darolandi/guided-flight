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

function table.removeByKey(target, key)
    print(key)
    target[key] = nil
end