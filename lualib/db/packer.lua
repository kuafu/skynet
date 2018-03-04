local cjson = require "cjson"
cjson.encode_sparse_array(true, 1, 1)

local skynet = require "skynet"

local print_r = require "print_r"

local packer = {}
g_packer_debug_v = nil

-- 将lua table组装成json
function packer.packjson(v)
    skynet.error("packer.packjson---------------------------------------------")
    skynet.error("")
    skynet.error("packer.packjson:", v)
    print_r(v)
    g_packer_debug_v = v
    --skynet.error(":",debug.traceback() )
	return cjson.encode(v)
	--return v
end

-- 将json数据组装成lua table
function packer.unpackjson(v)
	skynet.error("")
	skynet.error("--->unpackjson")
	skynet.error("v:", v)
	print("")
	print("--->unpackjson")
	print("v:", v)
	--print(":", debug.traceback())
	local tlb= cjson.decode(v)
	--print_r(tlb)

	for k, v in pairs(tlb) do
		skynet.error(k, v)
	end

	skynet.error("unpacked json:", tlb)
	return tlb
	--return v
end

return packer
