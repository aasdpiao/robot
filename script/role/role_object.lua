local TimeManager = require "time.time_manager"
local RoleDispatcher = require "role.role_dispatcher"
local RoleObject = class()

function RoleObject:ctor(send_request)
    self.__send_request = send_request
end

function RoleObject:init()
    self.__time_manager = TimeManager.new()
    self.__role_dispatcher = RoleDispatcher.new()
    self.__role_dispatcher:init()
end

function RoleObject:get_handle_response(name)
    return self.__role_dispatcher:get_handle_response(name)
end

function RoleObject:get_handle_request(name)
    return self.__role_dispatcher:get_handle_request(name)
end

function RoleObject:send_message(name,args)
    self.__send_request(name,args)
end

function RoleObject:update_heartbeat()
    self:send_message("heartbeat",{})
end

return RoleObject