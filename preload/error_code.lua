local errors = {}

function error_msg(ec)
	if not ec then
		return "nil"
	end
	return errors[ec].desc
end

local function add(err)
	assert(errors[err.code] == nil, string.format("have the same error code[%x], msg[%s]", err.code, err.message))
	errors[err.code] = {desc = err.desc , type = err.type}
	return err.code
end

SYSTEM_ERROR = {
	success            = add{code = 0x0000, desc = " "},
	unknow             = add{code = 0x0001, desc = "未知错误"},
	argument           = add{code = 0x0002, desc = "参数错误"},
	busy               = add{code = 0x0003, desc = "服务繁忙"},
	forward            = add{code = 0x0004, desc = "协议转发"},
	decode_failure     = add{code = 0x0005, desc = "解析协议失败"},
	decode_header      = add{code = 0x0006, desc = "解析包头出错"},
	decode_data        = add{code = 0x0007, desc = "解析包体出错"},
	unknow_protoid     = add{code = 0x0008, desc = "未知协议id"},
	unknow_proto       = add{code = 0x0009, desc = "未知协议"},
	unknow_roomproxy   = add{code = 0x000a, desc = "未知房间地址"},
	invalid_proto      = add{code = 0x000b, desc = "非法协议"},
	no_auth_account    = add{code = 0x000c, desc = "未登录帐号"},
	service_stoped     = add{code = 0x000d, desc = "服务故障"},
	no_login_game      = add{code = 0x000e, desc = "未登陆游戏"},
	service_not_impl   = add{code = 0x000f, desc = "服务未实现"},
	module_not_impl    = add{code = 0x0010, desc = "模块未实现"},
	func_not_impl      = add{code = 0x0011, desc = "函数未实现"},
	service_maintance  = add{code = 0x0012, desc = "服务维护"},
	permission         = add{code = 0x0013, desc = "权限不够"},
}

AUTH_ERROR = {
	account_nil        = add{code = 0x0101, desc = "帐号为空"},
	password_nil       = add{code = 0x0102, desc = "密码为空"},
	account_exist      = add{code = 0x0103, desc = "帐号存在"},
	repeat_login       = add{code = 0x0104, desc = "重复登录"},
	account_not_exist  = add{code = 0x0105, desc = "不存在此帐号"},
	password_wrong     = add{code = 0x0106, desc = "密码错误"},
	player_not_exist   = add{code = 0x0107, desc = "对应的玩家不存在"},
	forbid_login       = add{code = 0x0108, desc = "禁止登陆"},
	register_failure   = add{code = 0x0109, desc = "注册失败"},
	
}

GAME_ERROR = {
	gold_not_enough    			= add{code = 0x1001, desc = "金币不足"},
	cash_not_enough    			= add{code = 0x1002, desc = "钞票不足"},
	topaz_not_enough   			= add{code = 0x1003, desc = "黄玉不足"},
	emerald_not_enough 			= add{code = 0x1004, desc = "祖母绿不足"},
	ruby_not_enough    			= add{code = 0x1005, desc = "红宝石不足"},
	amethyst_not_enough			= add{code = 0x1006, desc = "紫水晶不足"},
	level_not_enough			= add{code = 0x1007, desc = "等级不够"},
	formula_not_enough			= add{code = 0x1008, desc = "配方不够"},
	item_not_enough			    = add{code = 0x1009, desc = "物品不够"},
	people_not_enough			= add{code = 0x100a, desc = "人口不足"},
	people_upper_not_enough	    = add{code = 0x100b, desc = "人口上限不足"},
	item_capacity_not_enough    = add{code = 0x100c, desc = "背包容量不足"},
	cloud_not_enough            = add{code = 0x100e, desc = "云朵不足"},
	friendly_not_enough         = add{code = 0x100f, desc = "爱心点数不足"},
	packet_not_enough           = add{code = 0x1010, desc = "红包不足"},
	contribution_not_enough     = add{code = 0x1011, desc = "贡献不足"},

	cant_add_worker    			= add{code = 0x2001, desc = "不能上岗"},
	cant_operate_building 		= add{code = 0x2002, desc = "不能操作建築"},
	cant_feed_operate  			= add{code = 0x2003, desc = "不能喂养"},
	cant_sign_in  			    = add{code = 0x2004, desc = "不能签到"},
	cant_finish  			    = add{code = 0x2005, desc = "不能完成"},
	cant_promote  			    = add{code = 0x2006, desc = "不能加速"},
	cant_add_slot  			    = add{code = 0x2007, desc = "不能增加槽位"},
	cant_harvest  			    = add{code = 0x2008, desc = "不能收获"},
	cant_unlock  			    = add{code = 0x2009, desc = "不能解锁"},
	cant_reward  			    = add{code = 0x200a, desc = "不能奖励"},
	cant_help  			        = add{code = 0x200b, desc = "不能帮助"},
	cant_set_sail  	            = add{code = 0x200c, desc = "不能出海"},
	cant_refresh  	            = add{code = 0x200d, desc = "不能刷新"},
	cant_buy    	            = add{code = 0x200e, desc = "不能购买"},
	cant_employ   	            = add{code = 0x200f, desc = "不能雇佣"},
	cant_search  	            = add{code = 0x2010, desc = "不能搜索"},
	cant_delete  	            = add{code = 0x2011, desc = "不能删除"},
	cant_upgrade  	            = add{code = 0x2012, desc = "不能升级"},
	cant_take_off  	            = add{code = 0x2013, desc = "不能起飞"},
	cant_read_mail  	        = add{code = 0x2014, desc = "不能读邮件"},
	cant_receive_mail  	        = add{code = 0x2015, desc = "不能接收邮件"},
	cant_delete_mail  	        = add{code = 0x2016, desc = "不能删除邮件"},
	cant_receive_achievement    = add{code = 0x2017, desc = "不能获取成就"},
	cant_create_cloud           = add{code = 0x2018, desc = "不能生成云朵"},
	cant_create_event           = add{code = 0x2019, desc = "不能生成事件"},
	cant_receive_daily          = add{code = 0x201a, desc = "不能接收日常奖励"},
	cant_watering               = add{code = 0x201b, desc = "不能浇水"},
	cant_return_consume         = add{code = 0x201c, desc = "不能返还"},
	cant_math_profession        = add{code = 0x201d, desc = "不能匹配职业"},
	cant_join_faction           = add{code = 0x201e, desc = "不能加入公會"},
	cant_pray                   = add{code = 0x201f, desc = "不能许愿"},

	build_id_exist              = add{code = 0x3001, desc = "build_id重复"},
	grid_id_exist               = add{code = 0x3002, desc = "grid_id重复"},
	production_not_exist 		= add{code = 0x3003, desc = "不包含的生产"},
	worker_not_exist 			= add{code = 0x3004, desc = "员工不存在"},
	building_not_exist 			= add{code = 0x3005, desc = "建築不存在"},
	undevelop_not_exist 	    = add{code = 0x3006, desc = "未开发地区不存在"},
	storage_not_exist 	        = add{code = 0x3007, desc = "存储位不存在"},
	product_not_exist 	        = add{code = 0x3008, desc = "生产位不存在"},
	trains_not_exist 	        = add{code = 0x3009, desc = "火车不存在"},
	order_not_exist 	        = add{code = 0x300a, desc = "订单不存在"},
	terminal_not_exist 	        = add{code = 0x300b, desc = "车站不存在"},
	reward_not_exist 	        = add{code = 0x300c, desc = "奖励不存在"},
	ship_not_exist 	            = add{code = 0x300d, desc = "船只不存在"},
	island_not_exist 	        = add{code = 0x300e, desc = "海岛不存在"},
	sale_not_exist 	            = add{code = 0x300f, desc = "商品不存在"},
	businessman_not_exist       = add{code = 0x3010, desc = "商人不存在"},
	mail_not_exist              = add{code = 0x3011, desc = "邮件不存在"},
	friend_not_exist            = add{code = 0x3012, desc = "好友不存在"},
	friend_exist                = add{code = 0x3013, desc = "好友已在好友列表"},
	invite_exist                = add{code = 0x3014, desc = "不在邀请列表"},
	verify_exist                = add{code = 0x3015, desc = "不在验证列表"},
	thumb_up_exist              = add{code = 0x3016, desc = "已点赞"},
	event_not_exist             = add{code = 0x3017, desc = "事件不存在"},
	task_not_exist              = add{code = 0x3018, desc = "任务不存在"},
	stall_not_exist             = add{code = 0x3019, desc = "摊位不存在"},
	ad_not_exist                = add{code = 0x301a, desc = "广告不存在"},
	cdkey_not_exist             = add{code = 0x301b, desc = "cdkey不存在"},
	faction_not_exist           = add{code = 0x301c, desc = "公会不存在"},
	member_not_exist            = add{code = 0x301d, desc = "成員不存在"},
	request_not_exist           = add{code = 0x301e, desc = "请求不存在"},
	faction_member_fall         = add{code = 0x301f, desc = "人数已经达到上限"},
	faction_member_limit        = add{code = 0x3020, desc = "工会成员限定"},
	entry_not_exist             = add{code = 0x3021, desc = "配置不存在"},
	pray_not_exist              = add{code = 0x3022, desc = "许愿不存在"},

	operate_not_unlock 			= add{code = 0x4001, desc = "操作未解鎖"},
	number_not_match 			= add{code = 0x4002, desc = "数据不匹配"},
	parameter_invalid 			= add{code = 0x4003, desc = "参数不合法"},
	price_invalid 			    = add{code = 0x4004, desc = "定价不合法"},
	stall_index_invalid         = add{code = 0x4005, desc = "摊位编号不合法"},
	cdkey_invalid               = add{code = 0x4006, desc = "cdkey已使用"},
	cdkey_overdue               = add{code = 0x4007, desc = "cdkey已过期"},
	cdkey_collision             = add{code = 0x4008, desc = "cdkey同批次已使用"},

	production_queue_full 		= add{code = 0x5001, desc = "生产队列满"},
	cloud_queue_full 		    = add{code = 0x5002, desc = "云朵满"},
	ad_times_full    		    = add{code = 0x5003, desc = "广告次数满"},
}

DB_ERROR = {
	SQL_ERROR    			= add{code = 0x9001, desc = "SQL执行出错"},
}

return errors