local cjson = require "cjson"
cjson.encode_sparse_array(true, 1, 1)

local print_r = require "print_r"

local packer = {}
g_packer_debug_v = nil
function packer.packjson(v)
    print("")
    print("packer.packjson:", v)
    print_r(v)
    print("-----------------------")
    g_packer_debug_v = v
    print(debug.traceback() )
	return cjson.encode(v)
	--return v
end

function packer.unpackjson(v)
    print("")
    print("packer.unpackjson:", v)
	return cjson.decode(v)
	--return v
end

return packer
