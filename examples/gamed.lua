local skynet = require "skynet"

local gameserver = require "gameserver.gameserver"
local syslog = require "syslog"


local loginserver = tonumber(...)

local gamed = {}

local pending_agent = {}
local pool = {}

local online_account = {}

function gamed.open(config)
	syslog.notice("gamed opened")

	local self = skynet.self()
	local n = config.pool or 0
	for i = 1, n do
		table.insert(pool, skynet.newservice("agent", self))
	end

	skynet.uniqueservice("gdd")
	skynet.uniqueservice("world")
end

function gamed.command_handler(cmd, ...)
	local CMD = {}

	function CMD.close(agent, account)
		syslog.debugf("agent %d recycled", agent)
        syslog.debugf("....................................................................................")
		syslog.debugf("")
		
		online_account[account] = nil
		table.insert(pool, agent)
	end

	function CMD.kick(agent, fd)
		gameserver.kick(fd)
	end

	local f = assert(CMD[cmd])
	return f(...)
end

function gamed.auth_handler(session, token)
	syslog.debug("gamed.auth_handler", session, token)
	syslog.debug("  +--loginserver", loginserver)
	return skynet.call(loginserver, "lua", "verify", session, token)	
end

function gamed.login_handler(fd, account)
	syslog.debug("----------------------------------------------------")
	local agent = online_account[account]
	if agent then
		syslog.warningf("multiple login detected for account %d(FD%d)", account, fd)
		skynet.call(agent, "lua", "kick", account)
	end

	if #pool == 0 then
		agent = skynet.newservice("agent", skynet.self())
		syslog.noticef("pool is empty, new agent(%d) created", agent)
	else
		agent = table.remove(pool, 1)
		syslog.debugf("agent(%d) assigned, %d remain in pool", agent, #pool)
	end

	syslog.debugf("new online account %s for agent %s", account, agent)
	online_account[account] = agent

	skynet.call(agent, "lua", "open", fd, account)
	gameserver.forward(fd, agent)
	return agent
end

gameserver.start(gamed)
