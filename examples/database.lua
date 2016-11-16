print("<examples/database>")
local skynet = require "skynet"
local redis = require "redis"

local config = require "config.database"
local account = require "db.account"
local character = require "db.character"

local print_r = require "print_r"

local center
local group = {}
local ngroup

local function hash_str(str)
	local hash = 0
	string.gsub(str, "(%w)", function(c)
		hash = hash + string.byte(c)
	end)
	return hash
end

local function hash_num(num)
	local hash = num << 8
	return hash
end

function connection_handler(key)
	local hash
	local t = type(key)
	if t == "string" then
		hash = hash_str(key)
	else
		hash = hash_num(assert(tonumber(key)))
	end

	return group[hash % ngroup + 1]
end


local MODULE = {}
local function module_init(name, mod)
	MODULE[name] = mod
	mod.init(connection_handler)
end

local traceback = debug.traceback

skynet.start(function()
	module_init("account", account)
	module_init("character", character)

    print("conneting redis...")
	center = redis.connect(config.center)
    print("--------------------------------------")
    print(">", center)
	ngroup = #config.group
	for _, c in ipairs(config.group) do
        print("\tc:",c)
        print_r(c)
		table.insert(group, redis.connect(c))
        print("\t--")
	end
    print("--------------------------------------")
    --table.insert(group, redis.connect(c))

	skynet.dispatch("lua", function(_, _, mod, cmd, ...)
        print("database mod:"..mod..", cmd:"..cmd)
		local m = MODULE[mod]
		if not m then
			return skynet.ret()
		end
		local f = m[cmd]
		if not f then
			return skynet.ret()
		end
		
		local function ret(ok, ...)
			if not ok then
				skynet.ret()
			else
				skynet.retpack(...)
			end

		end
		ret(xpcall(f, traceback, ...))
	end)
end)
