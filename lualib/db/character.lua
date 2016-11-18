local syslog = require "syslog"
--local packer = require "db.packer"

local character = {}
local connection_handler

function character.init(ch)
   --error("+++++++++++++++++++++")
	connection_handler = ch
end

local function make_list_key(account)
	local major = account // 100
	local minor = account % 100
    --print("make_list_key")
	return connection_handler(account), string.format("char-list:%d", major), minor
end

local function make_character_key(id)
	local major = id // 100
	local minor = id % 100
	return connection_handler(id), string.format("character:%d", major), minor
end

local function make_name_key(name)
	syslog.debug("<make_name_key>",name)
	return connection_handler(name), "char-name", name
end

function character.reserve(id, name)
	syslog.debug("<character.reserve(id, name) >",id, name)
	local connection, key, field = make_name_key(name)
	syslog.debug("\t+-- ", connection, key, field)

	local hs = connection:hsetnx(key, field, id)
	syslog.debug("\t+-- hs", hs)
	assert(hs ~= 0)
	syslog.debug("<character.reserve/>")
	return id
end

function character.save(id, data)
	connection, key, field = make_character_key(id)
	connection:hset(key, field, data)
end

function character.load(id)
    syslog.debug("character.load")
	connection, key, field = make_character_key(id)
	local data = connection:hget(key, field) or error()
	return data
end

function character.list(account)
    syslog.debug("character.list:"..account)
	local connection, key, field = make_list_key(account)
    --print("->", connection, key, field)

	local v = connection:hget(key, field) or error()
    --print("\tv:",v)
	return v
end

function character.savelist(id, data)
	connection, key, field = make_list_key(id)
	connection:hset(key, field, data)
end

return character

