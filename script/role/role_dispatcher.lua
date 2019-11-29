local RoleDispatcher = class()

function RoleDispatcher:ctor()
    self.__s2c_protocal = {}
    self.__c2s_protocal = {}
end

function RoleDispatcher:register_s2c_callback(name,callback)
    self.__s2c_protocal[name] = callback
end

function RoleDispatcher:register_c2s_callback(name,callback)
    self.__c2s_protocal[name] = callback
end

function RoleDispatcher:get_handle_request(name)
    return self.__c2s_protocal[name]
end

function RoleDispatcher:get_handle_response(name)
    return self.__s2c_protocal[name]
end

function RoleDispatcher:init()
    self:register_s2c_callback("login_callback",self.dispatcher_s2c_login_callback)
    self:register_s2c_callback("heartbeat",self.dispatcher_s2c_heartbeat)
    self:register_c2s_callback("heartbeat",self.dispatcher_c2s_heartbeat)
end

function RoleDispatcher.dispatcher_s2c_heartbeat(role_object,args)
    return {}
end

function RoleDispatcher.dispatcher_s2c_login_callback(role_object,args)
    local result = args.result
    local msg = args.msg
    if result == 200 then
        skynet.fork(function(  )
            while true do
                skynet.sleep(50)
                role_object:update_heartbeat()
            end
        end)
    else
        syslog.err(msg)
    end
end

function RoleDispatcher.dispatcher_c2s_heartbeat(role_object,params,args)
    return {}
end

return RoleDispatcher

