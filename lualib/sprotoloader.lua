local parser = require "sprotoparser"
local core   = require "sproto.core"    --c中的sproto_core
local sproto = require "sproto"
local syslog = require "syslog"
--local print_r = require "print_r"


local loader = {}

function loader.register(filename, index)
    
    syslog.debug("------------------------------------------------------------>loader.register")
    syslog.debug("------ <sprotoloader>  -------")
    syslog.debug("loader.register file:",filename, ", index", index)
	local f = assert(io.open(filename), "Can't open sproto file")
	local data = f:read "a"
    f:close()
    

    local sp = core.newproto(parser.parse(data))
	core.saveproto(sp, index)
end

function loader.save(bin, index)
	local sp = core.newproto(bin)
	core.saveproto(sp, index)
end

--返回一个lua sproto表，c sproto是其成员
function loader.load(index)
    --返回c中的lightuserdata struct sproto*
	local sp = core.loadproto(index)
	--  no __gc in metatable
	return sproto.sharenew(sp)
end

return loader

