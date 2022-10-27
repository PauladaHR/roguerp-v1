local userGroups = {}
local userRanks = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function updateGroup(user_id)
	local source = vRP.getUserSource(user_id)
	if source then
		local identifiers = vRP.getIdentifiers(source)
		local groupQuery = exports["oxmysql"]:executeSync("SELECT `permiss` FROM `vrp_permissions` WHERE `user_id` = ?",{ user_id })
		local rankQuery = exports["oxmysql"]:executeSync("SELECT * FROM vrp_infos WHERE `steam` = ?",{ identifiers["steam"] })
		local rankDecode = json.decode(rankQuery[1]["rank"]) or rankQuery[1]["rank"]

		local groupList = {}
		for k,v in pairs(groupQuery) do
			table.insert(groupList,{ permission = vRP.groupWait(v["permiss"]) })
		end

		local rankList = {}
		if type(rankDecode) == "string" then
			for k,v in pairs(rankQuery) do
				table.insert(rankList,{ rank = v["rank"], level = v["rankLevel"] })
			end
		elseif type(rankDecode) == "table" then
			for k,v in pairs(rankDecode) do
				table.insert(rankList,{ rank = v, level = rankQuery[1]["rankLevel"] })
			end
		end

		userGroups[user_id] = groupList
		userRanks[user_id] = rankList
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updateRank(user_id)
	local source = vRP.getUserSource(user_id)
	if source then
		local identifiers = vRP.getIdentifiers(source)
		local rankQuery = exports["oxmysql"]:executeSync("SELECT * FROM vrp_infos WHERE `steam` = ?",{ identifiers["steam"] })
		local rankDecode = json.decode(rankQuery[1]["rank"]) or rankQuery[1]["rank"]

		local rankList = {}
		if type(rankDecode) == "string" then
			for k,v in pairs(rankQuery) do
				table.insert(rankList,{ rank = v["rank"], level = v["rankLevel"] })
			end
		elseif type(rankDecode) == "table" then
			for k,v in pairs(rankDecode) do
				table.insert(rankList,{ rank = v, level = rankQuery[1]["rankLevel"] })
			end
		end

		userRanks[user_id] = rankList
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HAS PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasPermission(user_id,permiss,data)
	if type(permiss) == "string" then
		if string.find(permiss,"cellphone") then
			local len = string.len(permiss)
			local permissCheck = string.sub(permiss,10,len)
			if permissCheck == "Admin" then
				return vRP.hasRank(user_id,"Admin",40)
			elseif permissCheck == "Police" then
				if userGroups[user_id] then
					for k,v in pairs(userGroups[user_id]) do
						if v["permission"] == "Police" or v["permission"] == "waitPolice" then
							return true
						end
					end
				end
			end
		end
	end

	if data then
		if type(permiss) == "string" then
			local consult = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ? ",{ user_id,permiss })
			if consult[1] then
				return true
			end
		elseif type(permiss) == "table" then
			local userPermiss = exports["oxmysql"]:executeSync("SELECT permiss FROM `vrp_permissions` WHERE `user_id` = ?",{ user_id })
			for k,v in pairs(permiss) do
				for z,w in pairs(userPermiss) do
					if v == w["permiss"] then
						return true
					end
				end
			end
		end
	else
		if userGroups[user_id] then
			if type(permiss) == "string" then
				for k,v in pairs(userGroups[user_id]) do
					if v["permission"] == permiss then
						return true
					end
				end
			elseif type(permiss) == "table" then
				for k,v in pairs(permiss) do
					for z,w in pairs(userGroups[user_id]) do
						if w["permission"] == v then
							return true
						end
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.addPermission(user_id,permiss,data)
	if data then
		if vRP.hasPermission(user_id,permiss,true) then
			return { code = 200 }
		end

		local maxPermiss = vRP.groupMax(permiss)
		if maxPermiss then
			local numPermiss = vRP.numPermission(permiss,true)
			if #numPermiss > maxPermiss then
				return { code = 300 }
			end
		end

        local typePermiss = vRP.groupType(permiss)
        local cooldownPermiss = vRP.groupCooldown(permiss)
        if cooldownPermiss then
            local query = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_permissions_blacklist` WHERE `user_id` = ? AND `type` = ?",{ user_id,typePermiss})
			if query[1] then
				if query[1]["type"] == typePermiss then
					if os.time() <= query[1]["time"] then
						local nSource = vRP.getUserSource(user_id)
						if nSource then
							TriggerClientEvent("Notify",nSource,"warn","Você não pode ser contratado aguarde "..completeTimers(parseInt(query[1]["time"] - os.time())).."",5000)
							return { code = 400 }
						end
					else
						exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions_blacklist` WHERE `user_id` = ? AND `type` = ?",{ user_id,typePermiss })
					end
				end
			end
        end

		if typePermiss == "jobPrimary" then
			if permiss == "Police" or permiss == "Juiz" then
				vRP.removePermissionByType(user_id,"all")
				vRP.removeBlacklist(user_id,"all")
			else
				vRP.removePermissionByType(user_id,{"jobPrimary","gueto"})
				vRP.removeBlacklist(user_id,{"jobPrimary","gueto"})
			end
		end

		if typePermiss == "jobSecondary" then
			vRP.removePermission(user_id,"Police",true)
			vRP.removePermissionByType(user_id,"jobSecondary")
			vRP.removeBlacklist(user_id,"jobSecondary")
		end

		if typePermiss == "gueto" then
			vRP.removePermissionByType(user_id,{"jobPrimary","gueto","mafia"})
			vRP.removeBlacklist(user_id,"all")
		end

		if typePermiss == "mafia" then
			vRP.removePermissionByType(user_id,{"jobPrimary","gueto","mafia"})
			vRP.removeBlacklist(user_id,{"jobPrimary","gueto","mafia"})
		end

		local insertCooldown = vRP.groupCooldown(permiss)
		if insertCooldown then
			exports["oxmysql"]:executeSync("INSERT INTO `vrp_permissions_blacklist`(user_id,type,time) VALUES(?,?,?)",{ user_id, typePermiss, vRP.groupCooldown(permiss) })
		end
		exports["oxmysql"]:executeSync("INSERT INTO `vrp_permissions`(user_id,permiss,type,hired) VALUES(?,?,?,?)",{ user_id, permiss, typePermiss, os.time() })
		updateGroup(user_id)
		return { code = 800 }
	else
		local source = vRP.getUserSource(user_id)
		if source then
			local groupList = {}
			if userGroups[user_id] then
				for k,v in pairs(userGroups[user_id]) do
					if v["permission"] ~= permiss then
						table.insert(groupList,{ permission = v["permission"]})
					end
				end
			end

			table.insert(groupList,{ permission = permiss })
			userGroups[user_id] = groupList
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE BLACKLIST
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removeBlacklist(user_id,permiss)
	if permiss == "all" then
		local checkBlacklist = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_permissions_blacklist` WHERE user_id = ?", { user_id })
		if checkBlacklist[1] then
			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions_blacklist` WHERE `user_id` = ?",{ user_id })
		end
	elseif type(permiss) == "string" then
		local checkBlacklist = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_permissions_blacklist` WHERE user_id = ? AND type = ?", { user_id,permiss })
		if checkBlacklist[1] then
			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions_blacklist` WHERE `user_id` = ? AND `type` = ?",{ user_id,permiss })
		end
	elseif type(permiss) == "table" then
		for k,v in pairs(permiss) do
			local checkBlacklist = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_permissions_blacklist` WHERE user_id = ? AND type = ?", { user_id,v })
			if checkBlacklist[1] then
				exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions_blacklist` WHERE `user_id` = ? AND `type` = ?",{ user_id,v })
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE PERMISS TYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removePermissionByType(user_id,permissType)
	if permissType == "all" then
		exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `type` <> 'noDelete' ",{ user_id })
	elseif type(permissType) == "string" then
		exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `type` = ?",{ user_id,permissType })
	elseif type(permissType) == "table" then
		for k,v in pairs(permissType) do
			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `type` = ?",{ user_id,v })
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVE PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.removePermission(user_id,permiss,data)
	if data then
		if type(permiss) == "string" then
			if not vRP.hasPermission(user_id,permiss,true) then
				return { code = 200 }
			end

			exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ user_id,permiss })
			updateGroup(user_id)

			return { code = 800 }
		elseif type(permiss) == "table" then
			for k,v in pairs(permiss) do
				if vRP.hasPermission(user_id,v,true) then
					exports["oxmysql"]:executeSync("DELETE FROM `vrp_permissions` WHERE `user_id` = ? AND `permiss` = ?",{ user_id,v })
				end
			end

			updateGroup(user_id)
			return { code = 800 }
		end
	else
		local player = vRP.getUserSource(user_id)
		if player then
			if type(permiss) == "string" then
				local groupList = {}
				if userGroups[user_id] then
					for k,v in pairs(userGroups[user_id]) do
						if v["permission"] ~= permiss then
							table.insert(groupList,{ permission = v["permission"] })
						end
					end
				end
				userGroups[user_id] = groupList
				return { code = 800 }
			elseif type(permiss) == "table" then
				local groupList = {}
				if userGroups[user_id] then
					for k,v in pairs(userGroups[user_id]) do
						for z,w in pairs(permiss) do
							if v["permission"] ~= w then
								table.insert(groupList,{ permission = v["permission"] })
							end
						end
					end
				end
				userGroups[user_id] = groupList
				return { code = 800 }
			end
		end
	end
	return { code = 200 }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.updatePermission(user_id,permiss,newPermiss,data)
	if data then
		if not vRP.hasPermission(user_id,newPermiss,true) then
			exports["oxmysql"]:executeSync("UPDATE vrp_permissions SET permiss = ? WHERE permiss = ? AND user_id = ?",{ newPermiss,permiss,user_id })

			updateGroup(user_id)
		end
	else
		local source = vRP.getUserSource(user_id)
		if source then
			if not vRP.hasPermission(user_id,newPermiss,false) then

				local groupList = {}
				if userGroups[user_id] then
					for k,v in pairs(userGroups[user_id]) do
						if v["permission"] ~= permiss then
							table.insert(groupList,{ permission = v["permission"] })
						end
					end
				end

				table.insert(groupList,{ permission = newPermiss })
				userGroups[user_id] = groupList
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUMPERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.numPermission(permiss,data)
	if data then
		return exports["oxmysql"]:executeSync("SELECT * FROM `vrp_permissions` WHERE `permiss` = ?",{ permiss })
	else
		local groupList = {}
		for k,v in pairs(userGroups) do
			for _,v2 in pairs(v) do
				if v2["permission"] == permiss then
					table.insert(groupList,vRP.getUserSource(k))
				end
			end
		end
		return groupList
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET PERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getPermissions(user_id,data)
	if data then
		local groupList = {}
		local groupQuery = exports["oxmysql"]:executeSync("SELECT `permiss` FROM `vrp_permissions` WHERE `user_id` = ?",{ user_id })
		for k,v in pairs(groupQuery) do
			table.insert(groupList,{ permission = v["permiss"] })
		end

		return groupList
	else
		if userGroups[user_id] then
			return userGroups[user_id]
		end

		return {}
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HAS RANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.hasRank(user_id,rank,level)
	local levelRank = (level == nil) and 0 or level
	if userRanks[user_id] then
		if type(rank) == "string" then
			for k,v in pairs(userRanks[user_id]) do
				if v["rank"] == rank then
					if v["level"] then
						if parseInt(v["level"]) >= levelRank then
							return true
						end
					else
						return true
					end
				end
			end
		elseif type(rank) == "table" then
			for k,v in pairs(rank) do
				for z,w in pairs(userRanks[user_id]) do
					if w["rank"] == v then
						return true
					end
				end
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD RANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.addRank(user_id,rankName,data)
	if data then
		local identity = vRP.getUserIdentity(user_id)
		local rankQuery = exports["oxmysql"]:executeSync("SELECT * FROM vrp_infos WHERE `steam` = ?",{ identity["steam"] })
		local rankDecode = json.decode(rankQuery[1]["rank"]) or rankQuery[1]["rank"]

		if vRP.premiumExist(rankName) then
			local userRank = vRP.getRank(user_id,"rank")
			local insertRank = { userRank,rankName }
			exports["oxmysql"]:executeSync("UPDATE vrp_infos SET rank = ? WHERE steam = ?",{ json.encode(insertRank),identity["steam"] })
		else
			local userRank = vRP.getRank(user_id,"premium")
			if userRank then
				local insertRank = { userRank,rankName }
				exports["oxmysql"]:executeSync("UPDATE vrp_infos SET rank = ? WHERE steam = ?",{ json.encode(insertRank),identity["steam"] })
			else
				exports["oxmysql"]:executeSync("UPDATE vrp_infos SET rank = ? WHERE steam = ?",{ rankName,identity["steam"] })
			end
		end
	else


	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GET RANK
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getRank(user_id,rankType)
	if userRanks[user_id] then
		local rankArray = {}
		for k,v in pairs(userRanks[user_id]) do
			if rankType == "rank" then
				if v["rank"] then
					rankArray["rank"] = v["rank"]
				end
			elseif rankType == "all" then
				if v["rank"] then
					rankArray["rank"] = v["rank"]
				end
			end
		end

		if rankType == "all" then
			return rankArray
		end

		if rankArray[rankType] then
			return rankArray[rankType]
		end
	end
	return nil
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETUSERBYPERMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.getUsersByPermission(permiss)
	local groupList = {}
	for k,v in pairs(userGroups) do
		for _,v2 in pairs(v) do
			if v2["permission"] == permiss then
				table.insert(groupList,k)
			end
		end
	end
	return groupList
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE COMMAND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("update",function(source,args,rawCommand)
	local user_id = vRP.getUserId(source)
	updateGroup(user_id)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	updateGroup(user_id)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	userGroups[user_id] = nil
	userRanks[user_id] = nil

	if vRP.hasPermission(user_id,"Taxi") then
		vRP.removePermission(user_id,"Taxi")
	end
end)