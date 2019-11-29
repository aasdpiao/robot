
skynet.start(function()
    skynet.newservice("debug_console",6000)
    --加载协议
    skynet.uniqueservice "sprotod"

    skynet.newservice("robotd",2000,1)

	skynet.exit()
end)
