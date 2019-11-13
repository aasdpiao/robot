local socket = require "skynet.socket"
local crypt = require "skynet.crypt"

local CMD = {}

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
	syslog.debug("package",bin2hex(package))
	return package
end

local function encode_token(index)
	return string.format("%s@%s:%s",
		crypt.base64encode("user"..index),
		crypt.base64encode("township"),
		crypt.base64encode("123456"))
end

local function connect(host,port,index)
	local fd,err = socket.open(host,port)
	syslog.debug("connect",fd,err)
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

	fd,err = socket.open(host, 8888)
	syslog.debug("connect",fd,err)
	
	local handshake = string.format("%s@%s:%d", crypt.base64encode(account_id), crypt.base64encode("township"), 1)
	local hmac = crypt.hmac64(crypt.hashkey(handshake), secret)
    write("login",fd,handshake .. ":" .. crypt.base64encode(hmac))
	local result = read_msg(fd)
	syslog.debug("login",result)
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
    skynet.dispatch("lua",function (session,source,cmd,...)
        local func = CMD[cmd]
        skynet.retpack(func(...))
    end)
end)