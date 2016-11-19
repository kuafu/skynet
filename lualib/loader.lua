--print("<file:loader>")

-- loader.lua在snlua中用loadfile加载
--snlua.so!_init
--snlua.so!_launch
--skynet.exe!dispatch_message
--skynet.exe!skynet_context_message_dispatch
--skynet.exe!thread_worker

--print(debug.traceback() )

--print("")
--print("-------------------")
--print("loader args:",...)

local args = {}
for word in string.gmatch(..., "%S+") do
	table.insert(args, word)
end

SERVICE_NAME = args[1]

local main, pattern

local err = {}
for pat in string.gmatch(LUA_SERVICE, "([^;]+);*") do
	local filename = string.gsub(pat, "?", SERVICE_NAME)
    --print("filename:", filename)
	local f, msg = loadfile(filename)
    --print("f:",f,", msg:",msg)
	if not f then
		table.insert(err, msg)
	else
		pattern = pat
		main = f
        --print("\tfilename:",filename)
		break
	end
end

if not main then
	error(table.concat(err, "\n"))
end

LUA_SERVICE = nil
package.path , LUA_PATH = LUA_PATH
package.cpath , LUA_CPATH = LUA_CPATH

local service_path = string.match(pattern, "(.*/)[^/?]+$")

if service_path then
	service_path = string.gsub(service_path, "?", args[1])
	package.path = service_path .. "?.lua;" .. package.path
	SERVICE_PATH = service_path
else
	local p = string.match(pattern, "(.*/).+$")
	SERVICE_PATH = p
end

if LUA_PRELOAD then
	local f = assert(loadfile(LUA_PRELOAD))
	f(table.unpack(args))
	LUA_PRELOAD = nil
end

--print("\targs:",select(2, table.unpack(args)))
main(select(2, table.unpack(args)) )
