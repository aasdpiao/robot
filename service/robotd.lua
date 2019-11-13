
skynet.start(function ()
    local ip = "127.0.0.1"
    local port = 8001
    for i=0,100 do
        local agent = skynet.newservice("agent")
        skynet.call(agent,"lua","connect",{
            ip = ip,
            port = port,
            index = i
        })
    end
    skynet.exit()
end)
