local skynet = require "skynet"
local netpack = require "netpack"

local CMD = {}
local SOCKET = {}
local gate
local agent = {}

function SOCKET.open(fd, addr)
    skynet.error("+++ New client from : " .. addr)
    agent[fd] = skynet.newservice("agent")
    skynet.error("watchdog call agent start")
    skynet.call(agent[fd], "lua", "start", { gate = gate, client = fd, watchdog = skynet.self() })
end

local function close_agent(fd)
	local a = agent[fd]
	agent[fd] = nil
	if a then
		skynet.call(gate, "lua", "kick", fd)
		-- disconnect never return
		skynet.send(a, "lua", "disconnect")
	end
end

function SOCKET.close(fd)
	print("socket close",fd)
	close_agent(fd)
end

function SOCKET.error(fd, msg)
	print("socket error",fd, msg)
	close_agent(fd)
end

function SOCKET.warning(fd, size)
	-- size K bytes havn't send out in fd
	print("socket warning", fd, size)
end

function SOCKET.data(fd, msg)
end

function CMD.start(conf)
    print("<watchdog.CMD.start>")
    skynet.call(gate, "lua", "open" , conf)
end

function CMD.close(fd)
	close_agent(fd)
end

local dispatch = function(session, source, cmd, subcmd, ...)
    skynet.error("--- watchdog dispatch ---");
    skynet.error(string.format("[watchdog] session:%d, source:%s, cmd:%s, subcmd:%s, args:%s",
    session, skynet.address(source), cmd, subcmd, table.concat({...},", ")    ) )
    --print("[watchdog]",session, skynet.add(source), skynet.address(source), cmd, subcmd, ...)
	if cmd == "socket" then
		local f = SOCKET[subcmd]
		f(...)
		-- socket api don't need return
	else
		local f = assert(CMD[cmd])
		skynet.ret(skynet.pack(f(subcmd, ...)))
	end
end

local function entry()
	skynet.dispatch("lua", dispatch)
    gate = skynet.newservice("gate")

    --debug only
    skynet.timeout (1, function ()
        skynet.error(":::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::")
        skynet.error("watchdog running...")
        skynet.call(".launcher", "lua", "DUMPSNLUA")
    end)
end

--skynet.error("watchdog entry:", entry)
skynet.start(entry)

