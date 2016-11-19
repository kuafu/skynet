print("--- main 1 ---")
local skynet       = require "skynet"

local config       = require "config.system"
local login_config = require "config.loginserver"
local game_config  = require "config.gameserver"

local syslog = require( "syslog" )

local function handle_to_address(handle)
	return tonumber("0x" .. string.sub(handle , 2))
end

skynet.start(function()
	local file = io.open("protocol.txt", "w")
	file:close()

	skynet.newservice("debug_console", config.debug_port)
	skynet.newservice("protod")
	skynet.error("starting database...")
	skynet.uniqueservice("database")

	skynet.error("")
	skynet.error("starting loginserver...")
	local loginserver = skynet.newservice("loginserver")
	skynet.call(loginserver, "lua", "open", login_config)	
    skynet.error("finishing loginserver")

	local gamed = skynet.newservice("gamed", loginserver)
	skynet.call(gamed, "lua", "open", game_config)

    skynet.error ("::::::::::::::::::::::: Server Ready :::::::::::::::::::::::")


	syslog.debug("")
    syslog.debug("list current service:")
    local services = skynet.call(".launcher", "lua", "LIST")
    for k, v in pairs( services ) do
    	syslog.debugf("%s %d %s", k, handle_to_address(k), v )
    end

	local file = io.open("protocol.txt", "a")
	file:write(string.format("\nlist current service::\n") )

	for k, v in pairs( services ) do
		file:write(string.format("%s %d %s\n", k, handle_to_address(k), v ) )
	end
	file:close()


end)

