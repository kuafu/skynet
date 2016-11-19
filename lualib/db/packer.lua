local cjson = require "cjson"
cjson.encode_sparse_array(true, 1, 1)

local skynet = require "skynet"

local print_r = require "print_r"

local packer = {}
g_packer_debug_v = nil
function packer.packjson(v)
    --skynet.error("")
    --skynet.error("packer.packjson:", v)
    --print_r(v)
    --skynet.error("-----------------------")
    g_packer_debug_v = v
    --skynet.error(":",debug.traceback() )
	return cjson.encode(v)
	--return v
end

-- 将json数据组装成lua table
function packer.unpackjson(v)
	return cjson.decode(v)
	--return v
end

return packer
