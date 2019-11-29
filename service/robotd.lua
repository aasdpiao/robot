
local num,startpid = ...
num = assert(tonumber(num))
startpid = assert(tonumber(startpid))

skynet.start(function ()
    local ip = "192.168.1.201"
    local port = 8001
    for i=0,num - 1 do
        local agent = skynet.newservice("agent")
        skynet.call(agent,"lua","connect",{
            ip = ip,
            port = port,
            index = startpid + i
        })
        skynet.sleep(10)
    end
    skynet.exit()
end)
