local skynet = require "skynet"
local c = require "skynet.core"

-- 以下功能转移到launch DUMPSNLUA
--local snlua_list ={}
--function skynet.dump_snlua()
--    skynet.error("+++++++++++++++++++++++++++++++++++++++++++++++++")
--    for k, v in pairs( snlua_list ) do
--        skynet.error( k, v )
--    end
--end

--function snlua_name(add, type, name )
--    if type == "snlua" then
--        local handle = tonumber("0x" .. string.sub(add , 2))
--        snlua_list[handle] = name
--        snlua_list[add] = name
--        print("--------------------------" ,  name ,add, handle, skynet.self())
--    end
--end


function skynet.launch(...)
    local addr = c.command("LAUNCH", table.concat({...}," "))
--    snlua_name(addr, ...)
    if addr then
		return tonumber("0x" .. string.sub(addr , 2))
	end
end

function skynet.kill(name)
	if type(name) == "number" then
		skynet.send(".launcher","lua","REMOVE",name, true)
		name = skynet.address(name)
	end
	c.command("KILL",name)
end

function skynet.abort()
	c.command("ABORT")
end

local function globalname(name, handle)
	local c = string.sub(name,1,1)
	assert(c ~= ':')
	if c == '.' then
		return false
	end

	assert(#name <= 16)	-- GLOBALNAME_LENGTH is 16, defined in skynet_harbor.h
	assert(tonumber(name) == nil)	-- global name can't be number

	local harbor = require "skynet.harbor"

	harbor.globalname(name, handle)

	return true
end

function skynet.register(name)
	if not globalname(name) then
		c.command("REG", name)
	end
end

function skynet.name(name, handle)
	if not globalname(name, handle) then
		c.command("NAME", name .. " " .. skynet.address(handle))
	end
end

local dispatch_message = skynet.dispatch_message

function skynet.forward_type(map, start_func)
	c.callback(function(ptype, msg, sz, ...)
		local prototype = map[ptype]
		if prototype then
			dispatch_message(prototype, msg, sz, ...)
		else
			dispatch_message(ptype, msg, sz, ...)
			c.trash(msg, sz)
		end
	end, true)
	skynet.timeout(0, function()
		skynet.init_service(start_func)
	end)
end

function skynet.filter(f ,start_func)
    skynet.error("<skynet.filter>")
    c.callback(function(...)
		dispatch_message(f(...))
	end)
	skynet.timeout(0, function()
		skynet.init_service(start_func)
	end)
end

function skynet.monitor(service, query)
	local monitor
	if query then
		monitor = skynet.queryservice(true, service)
	else
		monitor = skynet.uniqueservice(true, service)
	end
	assert(monitor, "Monitor launch failed")
	c.command("MONITOR", string.format(":%08x", monitor))
	return monitor
end

return skynet
