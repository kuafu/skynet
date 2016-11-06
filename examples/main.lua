local skynet = require "skynet"
local sprotoloader = require "sprotoloader"
print("---------------->a" )
sprotoloader = require "sprotoloader"
local max_client = 64
print("---------------->1" )

require "skynet.manager"	-- import skynet.register

local function entry()
	skynet.error("Server start")
	skynet.error("---------------->3")
	print("info 1", skynet.self(),skynet.address(skynet.self()) )
	skynet.register("mainentry---")
	print("info 2", skynet.self(),skynet.address(skynet.self()) )


	skynet.uniqueservice("protoloader")
    --local console = skynet.newservice("console")
    --skynet.newservice("debug_console",8000)
    --assert(false)
    --skynet.newservice("simpledb")
	print("---------------->4" )
    local watchdog = skynet.newservice ("watchdog")
	skynet.error("---------------->5" )
    skynet.call(watchdog, "lua", "start", {	port = 8888, maxclient = max_client,	nodelay = true,} )
	print("---------------->6" )
	print("Watchdog listen on ", 8888)


    print ("---------------->7")
    skynet.exit ()

end


skynet.start(entry)

print("---------------->2" )