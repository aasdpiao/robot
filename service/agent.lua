local socket = require "skynet.socket"
local crypt = require "skynet.crypt"
local sprotoloader = require "sprotoloader"
local RoleObject = require "role.role_object"

local CMD = {}
local role_object
local session = {}
local session_id = 1

local connect_fd
local host = sprotoloader.load(MSG.s2c):host "package"
local request = host:attach (sprotoloader.load (MSG.c2s))

local function assert_socket(service, v, fd)
	if v then
		return v
	else
		skynet.error(string.format("%s failed: socket (fd = %d) closed", service, fd))
		error(socket_error)
	end
end

local function write(service, fd, text)
	local package = string.pack (">s2", text)
	assert_socket(service, socket.write(fd, package), fd)
end

local function read(fd, size)
	return socket.read (fd, size) or error ()
end

local function read_msg (fd)
	local s = read(fd, 2)
	local size = s:byte(1) * 256 + s:byte(2)
	local package = read (fd, size)
	-- syslog.debug("package",bin2hex(package))
	return package
end

local function encode_token(index)
	return string.format("%s@%s:%s",
		crypt.base64encode("user"..index),
		crypt.base64encode("township"),
		crypt.base64encode("123456"))
end

local function send_message(message)
	write("message",connect_fd,message)
	-- syslog.debug("message",bin2hex(message))
end

local function handle_request(name, args, response)
	local f = role_object:get_handle_response(name)
	if f then
		local ret = f(role_object,args)
		if not ret then return end
		send_message(response(ret))
	else
		print("unhandle_request : "..name)
	end
end

function handle_response (id, args)
	local s = assert (session[id])
	session[id] = nil
	local f = role_object:get_handle_request(s.name)
	if f then
		f (role_object,s.args, args)
	else
		print("unhandle_response : "..s.name)
	end
end

function send_request (name, args)
	session_id = session_id + 1
	local message = request(name, args,session_id)
	send_message ( message)
	session[session_id] = { name = name, args = args }
end

local function handle_message(t, ...)
	if t == "REQUEST" then
		handle_request (...)
	else
		handle_response (...)
	end
end

local function message_route()
	local package = read_msg(connect_fd)
	handle_message (host:dispatch (package))	
end

local function update()
	while true do
		message_route()
		skynet.sleep(10)
	end
end

local function connect(host,port,index)
	local fd,err = socket.open(host,port)
	-- syslog.debug("connect",fd,err)
    assert(fd)
    local challenge = crypt.base64decode(read_msg(fd))
    local clientkey = crypt.randomkey()
    write("auth",fd,crypt.base64encode(crypt.dhexchange(clientkey)))
	local secret = crypt.dhsecret(crypt.base64decode(read_msg(fd)), clientkey)
    local hmac = crypt.hmac64(challenge, secret)
    write("auth",fd,crypt.base64encode(hmac))
	local etoken = crypt.desencode(secret, encode_token(index))
    write("auth",fd,crypt.base64encode(etoken))
	local result = read_msg(fd)
	local code = tonumber(string.sub(result, 1, 3))
	assert(code == 200)
	socket.close(fd)
	local account_id = crypt.base64decode(string.sub(result, 5))
	account_id = tonumber(account_id)
	syslog.debug("account_id",account_id)

	connect_fd,err = socket.open(host, 8888)
	
	local handshake = string.format("%s@%s:%d", crypt.base64encode(account_id), crypt.base64encode("township"), 1)
	local hmac = crypt.hmac64(crypt.hashkey(handshake), secret)
    write("login",connect_fd,handshake .. ":" .. crypt.base64encode(hmac))
	skynet.fork(update)
end

function CMD.connect(conf)
    local ip = assert(conf.ip)
	local port = assert(conf.port)
	local index = assert(conf.index)
    connect(ip,port,index)
end

function CMD.close()
    skynet.exit()
end

skynet.start(function ()
	role_object = RoleObject.new(send_request)
	role_object:init()
    skynet.dispatch("lua",function (session,source,cmd,...)
        local func = CMD[cmd]
        skynet.retpack(func(...))
    end)
end)