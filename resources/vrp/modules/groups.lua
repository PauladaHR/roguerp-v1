-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local groups = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD INIT
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
    Wait(1000)

	print('^3[!] ^0Criação de grupos ^3iniciada^0')
	local selectAll = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_groups`",{})
    for k,v in pairs(selectAll) do
        if v["available"] then

            groups[v["permiss"]] = {
                name = v["name"],
                permiss = v["permiss"],
                waitPermiss = v["waitPermiss"] or nil,
                type = v["typePermiss"],
                chest = v["chestPermiss"],
                master = v["masterPermiss"],
                max = v["max"] or nil,
                minSalary = v["minSalary"] or nil,
                maxSalary = v["maxSalary"] or nil,
                bonusSalary = v["bonusSalary"] or nil,
                cooldown = v["cooldown"] or nil
            }
        end
    end

	print('^2[!] ^0Criação de grupos ^2finalizada^0')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE GROUP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("updategroup",function(source,args,rawCommand)
	if source ~= 0 then
		return
	end
	Wait(1000)

    print('^3[!] ^0Atualização de grupos ^3iniciada^0')
	local selectAll = exports["oxmysql"]:executeSync("SELECT * FROM `vrp_groups`",{})
    for k,v in pairs(selectAll) do

        if v["available"] then

            groups[v["permiss"]] = {
                name = v["name"],
                permiss = v["permiss"],
                waitPermiss = v["waitPermiss"] or nil,
                type = v["typePermiss"] or nil, 
                chest = v["chestPermiss"],
                master = v["masterPermiss"],
                max = v["max"] or nil,
                minSalary = v["minSalary"] or nil,
                maxSalary = v["maxSalary"] or nil,
                bonusSalary = v["bonusSalary"] or nil,
                cooldown = v["cooldown"] or nil
            }

        end
    end

	print('^2[!] ^0Atualização de grupos ^2finalizada^0')
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP NAME
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupName(groupName)
    if groups[groupName] then
        if groups[groupName]["name"] then
            return groups[groupName]["name"]
        end
    end
    return ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP PERMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupPermiss(groupName)
    if groups[groupName] then
        if groups[groupName]["permiss"] then
            return groups[groupName]["permiss"]
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP PERMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupMaster(groupName)
    if groups[groupName] then
        if groups[groupName]["master"] then
            return groups[groupName]["master"]
        end
    end
    return ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP PERMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupMax(groupName)
    if groups[groupName] then
        if groups[groupName]["max"] then
            return groups[groupName]["max"]
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP PERMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupType(groupName)
    if groups[groupName] then
        if groups[groupName]["type"] then
            return groups[groupName]["type"]
        end
    end
    return ""
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP PERMISS
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupCooldown(groupName)
    if groups[groupName] then
        if groups[groupName]["cooldown"] then
            return parseInt(os.time()+parseInt(groups[groupName]["cooldown"])*24*60*60)
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP WAIT
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupWait(groupName)
    if groups[groupName] then
        if groups[groupName]["waitPermiss"] then
            return groups[groupName]["waitPermiss"]
        end
    end
    return groupName
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP MIN SALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupMinSalary(groupName)
    if groups[groupName] then
        if groups[groupName]["minSalary"] then
            return groups[groupName]["minSalary"]
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP MAX SALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupMaxSalary(groupName)
    if groups[groupName] then
        if groups[groupName]["maxSalary"] then
            return groups[groupName]["maxSalary"]
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUP BONUS SALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function vRP.groupBonusSalary(groupName)
    if groups[groupName] then
        if groups[groupName]["bonusSalary"] then
            return groups[groupName]["bonusSalary"]
        end
    end
    return false
end