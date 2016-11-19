local print = print
local tconcat = table.concat
local tinsert = table.insert
local srep = string.rep
local type = type
local pairs = pairs
local tostring = tostring
local next = next
local syslog = require "syslog"

local function print_r(root)
	local cache = {  [root] = "." }
	local function _dump(t,space,name)
		local temp = {""}
		for k,v in pairs(t) do
			local key = tostring(k)
			if cache[v] then
				tinsert(temp,"+-" .. string.format("%-6s", key) .. ": {" .. cache[v].."}")
			elseif type(v) == "table" then
				local new_key = name .. "." .. key
				cache[v] = new_key
				tinsert(temp,"+-" .. string.format("%-6s", key) .. _dump(v,space ..(next(t,k) and "|" or " " ).. srep(" ",5),new_key))
			else
				tinsert(temp,"+-" .. string.format("%-6s", key) .. ": [" .. tostring(v).."]")
			end
		end
		return tconcat(temp,"\n"..space)
	end
	syslog.debug(_dump(root, "",""))
end

return print_r