--
-- Minetest cloaking mod: chat3 fixes
--
-- © 2018 by luk3yx
--

-- Override minetest.get_connected_players() so it lists cloaked players for
--   chat3.
local get_uncloaked_players = minetest.get_connected_players

minetest.get_connected_players = function()
    local d = debug.getinfo(2)
    if d.func == chat3.send or d.func == minetest.chatcommands['me'].func then
        return cloaking.get_connected_players()
    else
        return get_uncloaked_players()
    end
end

-- Override get_player_by_name() to allow chat3 to access cloaked players.
local get_uncloaked_player_by_name = minetest.get_player_by_name

minetest.get_player_by_name = function(player)
    local d = debug.getinfo(2)
    if d.func == chat3.send or d.func == minetest.chatcommands["me"].func then
        return cloaking.get_player_by_name(player)
    else
        return get_uncloaked_player_by_name(player)
    end
end

-- Override chat3.send() to obey cloaked players.
local chat3_send = chat3.send
chat3.send = function(name, msg, ...)
    if cloaking.on_chat_message(name, msg) then return true end
    return chat3_send(name, msg, ...)
end
