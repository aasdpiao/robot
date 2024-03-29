local skynet = require "skynet"
local sprotoparser = require "sprotoparser"
local sprotoloader = require "sprotoloader"
local service = require "skynet.service"

local root = skynet.getenv("root")

local attr_file = SPROTO_FILE.attr
local c2s_sproto_file = SPROTO_FILE.c2s
local s2c_sproto_file = SPROTO_FILE.s2c

local function read_file(name)
	local filename = string.format(root.."protocal/%s.sproto", name)
	local f = assert(io.open(filename), "Can't open " .. name)
	local t = f:read "a"
	f:close()
	return t
end

local function load_c2s_sproto()
	local attr = read_file(attr_file)
	local sp = "\n"
	for i,file_name in ipairs(c2s_sproto_file) do
		local name = "c2s/"..file_name
		sp = sp .. read_file(name).."\n"
	end
	local content = attr..sp
	return sprotoparser.parse(content)
end

local function load_s2c_sproto()
	local attr = read_file(attr_file)
	local sp = "\n"
	for i,file_name in ipairs(s2c_sproto_file) do
		local name = "s2c/"..file_name
		sp = sp .. read_file(name).."\n"
	end
	local content = attr..sp
	return sprotoparser.parse(content)
end

skynet.start(function()
	local c2s = load_c2s_sproto()
	sprotoloader.save(c2s, MSG.c2s)
	local s2c = load_s2c_sproto()
	sprotoloader.save(s2c, MSG.s2c)
end)
