local skynet = require "skynet"
local Timer = class()

function Timer:ctor()
    self.__timer_id = 0
    self.__callbacks = {}
    self.__timestamp = 0
    self.__cancel = {}
    self.__timedefault = 0
    self.__timestep = 0
end

function Timer:fix_timestamp(timestamp)
    self.__timedefault = timestamp - os.time() 
end

function Timer:init()
    self.__timestamp = os.time()
    self.__timestep = os.time() 
    skynet.timeout(100, function()
        self:on_time_out()
    end)
end

function Timer:get_timer_id()
    self.__timer_id = self.__timer_id + 1
    return self.__timer_id
end

function Timer:on_time_out()
    self.__timestamp = os.time() + self.__timedefault
    local callbacks = {}
    for i=self.__timestep,self.__timestamp do
        local cb = self.__callbacks[i] or {}
        table.contain(callbacks,cb)
        self.__callbacks[i] = nil
    end
    self.__timestamp = self.__timestamp
    if table.empty(callbacks) then
        return skynet.timeout(100, function()
            self:on_time_out()
        end)
    end
    for timer_id, action in pairs(callbacks) do
        local callback = action.callback
        local interval = action.interval
        local loop = action.loop
        if loop then
            self:loop_call(timer_id,interval,callback)
        else
            self.__cancel[timer_id] = nil
        end
        callback()
    end
    return skynet.timeout(100, function()
        self:on_time_out()
    end)
end

function Timer:register(interval, callback, loop)
    assert(type(interval) == "number" and interval > 0)
    local timestamp = self.__timestamp + interval
    local timer_id = self:get_timer_id()
    if not self.__callbacks[timestamp] then
        self.__callbacks[timestamp] = {}
    end
    local callbacks = self.__callbacks[timestamp]
    local action = {}
    action.callback = callback
    action.interval = interval
    action.loop = loop or false
    callbacks[timer_id] = action
    self.__cancel[timer_id] = function()
        callbacks[timer_id] = nil
    end
    return timer_id
end

function Timer:loop_call(timer_id,interval,callback)
    local timestamp = self.__timestamp + interval
    if not self.__callbacks[timestamp] then
        self.__callbacks[timestamp] = {}
    end
    local callbacks = self.__callbacks[timestamp]
    local action = {}
    action.callback = callback
    action.interval = interval
    action.loop = true
    callbacks[timer_id] = action
    self.__cancel[timer_id] = function()
        callbacks[timer_id] = nil
    end
end

function Timer:unregister(timer_id)
    local callcel = self.__cancel[timer_id]
    if not callcel then return end
    callcel()
end

return Timer