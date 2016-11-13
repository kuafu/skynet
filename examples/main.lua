local skynet = require "skynet"
local sprotoloader = require "sprotoloader"

sprotoloader = require "sprotoloader"
local max_client = 64


require "skynet.manager"	-- import skynet.register

local function entry()
	skynet.error("::: main service start")

	skynet.error("  self:", skynet.self(), skynet.address(skynet.self()) )


	skynet.uniqueservice("protoloader")
    --local console = skynet.newservice("console")
    --skynet.newservice("debug_console",8000)
    --assert(false)
    --skynet.newservice("simpledb")

    local watchdog = skynet.newservice ("watchdog")
    skynet.call(watchdog, "lua", "start", {	port = 8888, maxclient = max_client,	nodelay = true,} )
	skynet.error("Watchdog listen on ", 8888)

	skynet.error("::: main service end")
    skynet.exit ()

end


skynet.start(entry)
