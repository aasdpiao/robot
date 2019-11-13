local debug_console_port = tonumber(skynet.getenv "debug_console_port")

skynet.start(function()
    
    skynet.newservice("debug_console",debug_console_port)
    
    skynet.newservice("robotd")

	skynet.exit()
end)
