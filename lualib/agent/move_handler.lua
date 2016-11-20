local skynet = require "skynet"

local syslog = require "syslog"
local handler = require "agent.handler"
local aoi_handler = require "agent.aoi_handler"
local print_r = require "print_r" 


local REQUEST = {}
local user
handler = handler.new(REQUEST)

handler:init(function(u)
	user = u
end)

function REQUEST.move(args)
	assert(args and args.pos)
	syslog.debug("move")
	print_r( args )
	local npos = args.pos
	local opos = user.character.movement.pos
	for k, v in pairs(opos) do
		if not npos[k] then
			npos[k] = v
		end
	end
	user.character.movement.pos = npos
	
	local ok = skynet.call(user.map, "lua", "move_blink", npos) 
	if not ok then
		user.character.movement.pos = opos
		error()
	end

	return { pos = npos }
end

return handler
