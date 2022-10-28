-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_player",cRP)
vCLIENT = Tunnel.getInterface("vrp_player")
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
vSKINSHOP = Tunnel.getInterface("vrp_skinshop")
 -----------------------------------------------------------------------------------------------------------------------------------------
-- UPGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("upgradeStress")
AddEventHandler("upgradeStress",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.upgradeStress(user_id,number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOWNGRADESTRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("downgradeStress")
AddEventHandler("downgradeStress",function(number)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.downgradeStress(user_id,number)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:KICKSYSTEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:kickSystem")
AddEventHandler("player:kickSystem",function(message)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if not vRP.hasRank(user_id,"Admin",20) then
			vRP.kick(user_id,message)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WESTORE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("garmas",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		local identity = vRP.getUserIdentity(user_id)
		if user_id then
			if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then

				local request = vRP.prompt(source,"Deseja guardar as armas?: sim/não","")
				if request == "" then
					return
				end

				if request == "sim" then
					Citizen.Wait(2500)
					local weapons = vRPC.replaceWeapons(source)
					for k,v in pairs(weapons) do
						vRP.giveInventoryItem(user_id,k,1)
						if v.ammo > 0 then
							vRP.giveInventoryItem(user_id,vRP.weaponAmmo(k),v.ammo)
							TriggerEvent("webhooks","garmas","```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[GUARDOU]: "..k.." \n[QUANTIDADE]: "..v.ammo.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						else
							TriggerEvent("webhooks","garmas","```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[GUARDOU]: "..k.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						end
					end
					vRPC.updateWeapons(source)
					TriggerClientEvent("Notify",source,"verde","O seu armamento foi todo guardado.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WECOLOR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("wecolor",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if parseInt(args[1]) >= 0 and parseInt(args[1]) <= 32 then
				if vRP.userPremium(user_id) then
					vCLIENT.weColors(source,parseInt(args[1]))
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WELUX
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("welux",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRP.userPremium(user_id) then
				vCLIENT.weLux(source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREMIUM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkPremium")
AddEventHandler("player:checkPremium",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			local consult = vRP.getInfos(identity.steam)
			if consult[1] and parseInt(os.time()) <= parseInt(consult[1].premium+24*consult[1].predays*60*60) then
				TriggerClientEvent("Notify",source,"amarelo", "Você ainda tem "..completeTimers(parseInt(86400*consult[1].predays-(os.time()-consult[1].premium))).." de benefícios <b>Premium</b>.", 5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DOORS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vehmenu:doors")
AddEventHandler("vehmenu:doors",function(doors)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			local vehicle,vehNet = vRPC.vehList(source,7)
			if vehicle then
				TriggerClientEvent("vrp_player:syncDoors",-1,vehNet,doors)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WINS
-----------------------------------------------------------------------------------------------------------------------------------------
local showWins = true
RegisterNetEvent("vehmenu:wins")
AddEventHandler("vehmenu:wins",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			local vehicle,vehNet = vRPC.vehList(source,7)
			if vehicle then
				showWins = not showWins
				TriggerClientEvent("vrp_player:syncWins",-1,vehNet,showWins)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RECEIVESALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.receiveSalary()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then

		-- if vRP.userPremium(user_id) then
		-- 	local premiumRank = vRP.getRank(user_id,"premium")
		-- 	local premiumSalary = vRP.premiumInfo(premiumRank,"salary")
		-- 	if premiumSalary then
		-- 		vRP.addBank(user_id,premiumSalary)
		-- 	end 
		-- end

		if vRP.userPremium(user_id) then
			if vRP.hasClass(user_id,"Diamond") then
				vRP.addBank(user_id,900)
			end
			if vRP.hasClass(user_id,"Platinum") then
				vRP.addBank(user_id,750)
			end
			if vRP.hasClass(user_id,"Gold") then
				vRP.addBank(user_id,600)
			end
			if vRP.hasClass(user_id,"Kids") then
				vRP.addBank(user_id,600)
			end
			if vRP.hasClass(user_id,"Silver") then
				vRP.addBank(user_id,500)
			end
			if vRP.hasClass(user_id,"Booster") then
				vRP.addBank(user_id,200)
			end
		end

		local permissions = vRP.getPermissions(user_id,true)
		for k,v in pairs(permissions) do
			if v["permission"] then
				if vRP.groupMinSalary(v["permission"]) then
					if vRP.hasPermission(user_id,v["permission"],false) then
						local maxPayment = vRP.groupMaxSalary(v["permission"])
						local minPayment = vRP.groupMinSalary(v["permission"])
						local bonusPayment = vRP.groupBonusSalary(v["permission"])
						
						local promotion = exports["oxmysql"]:executeSync("SELECT `promotion` FROM `vrp_permissions` WHERE user_id = ? AND permiss = ?",{ user_id, v["permission"]})
						if parseInt(promotion[1]["promotion"]) ~= 0 or parseInt(promotion[1]["promotion"]) ~= nil then
							for x = 1, parseInt(promotion[1]["promotion"]) do
								minPayment = minPayment + bonusPayment
							end
						end
						if minPayment >= maxPayment then
							minPayment = maxPayment
						end
						vRP.addBank(user_id,parseInt(minPayment))
					end
				end
			end
		end

		if vRP.hasPermission(user_id,"ActionPolice") then
			vRP.addBank(user_id,4000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("pd",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] then
			if vRP.hasPermission(user_id,{"Police","actionPolice"})  then
				if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
					local identity = vRP.getUserIdentity(user_id)
					local police = vRP.numPermission("Police")
					local action = vRP.numPermission("actionPolice")
					for k,v in pairs(police) do
						async(function()
							TriggerClientEvent("chatMessage",v,identity.name.." "..identity.name2,{93,153,253},rawCommand:sub(3))
						end)
					end
					for k,v in pairs(action) do
						async(function()
							TriggerClientEvent("chatMessage",v,identity.name.." "..identity.name2,{93,153,2535},rawCommand:sub(3))
						end)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hr",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id and args[1] then
			if vRP.hasPermission(user_id,"Paramedic") then
				if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
					local identity = vRP.getUserIdentity(user_id)
					local police = vRP.numPermission("Paramedic")
					for k,v in pairs(police) do
						async(function()
							TriggerClientEvent("chatMessage",v,identity.name.." "..identity.name2,{255,175,175},rawCommand:sub(3))
						end)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOTSFIRED
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.shotsFired()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local ped = GetPlayerPed(source)
		local coords = GetEntityCoords(ped)
		local policeResult = vRP.numPermission("Police")

		for k,v in pairs(policeResult) do
			async(function()
				TriggerClientEvent("NotifyPush",v,{ code = 10, title = "Confronto em andamento", x = coords["x"], y = coords["y"], z = coords["z"], criminal = "Disparos de arma de fogo", blipColor = 6 })
			end)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:carryFunctions")
AddEventHandler("player:carryFunctions",function(preCarry)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,{"Police","actionPolice","Paramedic"})  or vRP.hasRank(user_id,"Admin",60) then
			if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
				local nplayer = vRPC.nearestPlayer(source,2)
				if nplayer then
					if preCarry == "bracos" then
						vCLIENT.toggleCarry(nplayer,source)
					end
					if preCarry == "ombros" then
						TriggerClientEvent("vrp_rope:toggleRope",source,nplayer)
					end
					TriggerClientEvent("vrp_dynamic:closeSystem",source)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CARRY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("carrybaby",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPC.nearestPlayer(source,30)
		local nuser_id = vRP.getUserId(nplayer)
		if nplayer then
			if vRP.hasPermission(nuser_id,"Baby") then
				vCLIENT.toggleBaby(nplayer,source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ID
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("id",function(source,rawCommand)    
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		local nplayer = vRPC.nearestPlayer(source,2)
		local nuser_id = vRP.getUserId(nplayer)
		if nuser_id then
			TriggerClientEvent("Notify",source,"amarelo", "Player mais proximo <b>"..nuser_id.."</b>.", 10000)
			if not vRP.hasRank(user_id,"Admin",40) then
				TriggerClientEvent("Notify",nplayer,"info", "Seu passaporte está sendo <b>Verificado</b>.", 10000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:CVFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:cvFunctions")
AddEventHandler("player:cvFunctions",function(mode)
	local source = source
	local distance = 1.1

	if mode == "rv" then
		distance = 10.0
	end

	local otherPlayer = vRPC.nearestPlayer(source,distance)
	if otherPlayer then
		local user_id = vRP.getUserId(source)
		if vRP.hasPermission(user_id,"Police") or vRP.getInventoryItemAmount(user_id,"rope") >= 1 then
			local vehicle,vehNet,vehPlate,vehName,vehLock = vRPC.vehList(source,5)
			if vehicle then
				if vehLock ~= 1 then
					if mode == "rv" then
						vCLIENT.removeVehicle(otherPlayer)
					elseif mode == "cv" then
						vCLIENT.putVehicle(otherPlayer,vehNet)
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OUTFIT - REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
local removeFit = {
	["Remove"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 14, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 5, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 15, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 15, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 17, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 5, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 18, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 15, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Naked"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 2, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 5, texture = 0 },
			["tshirt"] = { item = 8, texture = 0 },
			["torso"] = { item = 15, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 7, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 21, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 35, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 82, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 15, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("updateRoupasInv")
AddEventHandler("updateRoupasInv",function(user_id,presetname,presetnumber,sex)
	local source = vRP.getUserSource(user_id)
	TriggerClientEvent("updateRoupas",source,preset[presetname][tostring(presetnumber)][sex])
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- JOBSOUTFIT
-----------------------------------------------------------------------------------------------------------------------------------------
local jobsOutfit = {
	["Motorista"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 8, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 36, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 321, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 42, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 10 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 52, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 327, texture = 5 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 1, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Piscineiro"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 17, texture = 2 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 16, texture = 0 },
			["tshirt"] = { item = 2, texture = 0 },
			["torso"] = { item = 8, texture = 8 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 2, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 51, texture = 2 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 1, texture = 2 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 117, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 11, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Taxi"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 8, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 7, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 133, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 0, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 50, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 20, texture = 1 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 180, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 7, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Construtor"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 39, texture = 1 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 97, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 66, texture = 1 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 7, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = 144, texture = 0 },
			["pants"] = { item = 32, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 338, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Lixeiro"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 13, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 51, texture = 0 },
			["tshirt"] = { item = 59, texture = 0 },
			["torso"] = { item = 56, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 0, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 30, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 36, texture = 0 },
			["shoes"] = { item = 26, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 428, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 20, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Delivery"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 25, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 31, texture = 1 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 17, texture = 5 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 5, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 73, texture = 1 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 103, texture = 3 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 402, texture = 2 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 3, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["coolBeans"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 26, texture = 7 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 26, texture = 2 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 221, texture = 3 },
			["accessory"] = { item = 22, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 4, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 15, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 72, texture = 17 },
			["tshirt"] = { item = 273, texture = 6 },
			["torso"] = { item = 459, texture = 16 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 4, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["catCoffe"] = {
		["homem"] = {
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 26, texture = 4 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 36, texture = 9 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 349, texture = 11 },
			["accessory"] = { item = 22, texture = 13 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 4, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {
			["hat"] = { item = 0, texture = 2 },
            ["pants"] = { item = 101, texture = 0 },
            ["vest"] = { item = 0, texture = 0 },
            ["bracelet"] = { item = -1, texture = 0 },
            ["decals"] = { item = 0, texture = 0 },
            ["mask"] = { item = 0, texture = 0 },
            ["shoes"] = { item = 60, texture = 7 },
            ["tshirt"] = { item = 8, texture = 0 },
            ["torso"] = { item = 82, texture = 6 },
            ["accessory"] = { item = 0, texture = 0 },
            ["watch"] = { item = -1, texture = 0 },
            ["arms"] = { item = 15, texture = 0 },
            ["glass"] = { item = -1, texture = 0 },
            ["ear"] = { item = -1, texture = 0 }
		}
	},
	["Paramedico"] = {
		["homem"] = {                                                                   -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 96, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 103, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 249, texture = 0 },
			["accessory"] = { item = 154, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 24, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                  -----OK-----
			["hat"] = { item = 0, texture = 0 },
			["pants"] = { item = 133, texture = 3 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 103, texture = 0 },
			["tshirt"] = { item = 17, texture = 0 },
			["torso"] = { item = 257, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 105, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
	},
	["Enfermeiro"] = {
		["homem"] = {                                                                        -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 25, texture = 5 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 7, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 324, texture = 0 },
			["accessory"] = { item = 154, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 74, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                       -----OK-----
			["hat"] = { item = 0, texture = 2 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 10, texture = 0 },
			["tshirt"] = { item = 17, texture = 0 },
			["torso"] = { item = 337, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 96, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Residente"] = {
		["homem"] = {                                                                       -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 25, texture = 5 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 7, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 324, texture = 1 },
			["accessory"] = { item = 154, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 74, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                      -----OK-----
			["hat"] = { item = 0, texture = 2 },
			["pants"] = { item = 23, texture = 8 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 10, texture = 0 },
			["tshirt"] = { item = 17, texture = 0 },
			["torso"] = { item = 337, texture = 1 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 96, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Medico"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 25, texture = 5 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 7, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 187, texture = 0 },
			["accessory"] = { item = 154, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 74, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                     -----OK-----
			["hat"] = { item = 0, texture = 2 },
			["pants"] = { item = 56, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 6, texture = 0 },
			["tshirt"] = { item = 17, texture = 0 },
			["torso"] = { item = 68, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 2, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Diretor"] = {
		["homem"] = {                                                                      -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 4, texture = 1 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 36, texture = 3 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 322, texture = 0 },
			["accessory"] = { item = 154, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 4, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                      -----OK-----
			["hat"] = { item = 0, texture = 2 },
			["pants"] = { item = 24, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 6, texture = 0 },
			["tshirt"] = { item = 17, texture = 0 },
			["torso"] = { item = 332, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 101, texture = 0 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
	},
	["Pediatria"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 20, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 7, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 133, texture = 0 },
			["accessory"] = { item = 154, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 92, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 23, texture = 0 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 103, texture = 0 },
			["tshirt"] = { item = 17, texture = 0 },
			["torso"] = { item = 4, texture = 0 },
			["accessory"] = { item = -1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 101, texture = 1 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
	},
	["Cirurgia"] = {
		["homem"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 25, texture = 5 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 7, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 273, texture = 20 },
			["accessory"] = { item = 154, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 0, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 50, texture = 3 },
			["vest"] = { item = 0, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 103, texture = 0 },
			["tshirt"] = { item = 17, texture = 0 },
			["torso"] = { item = 2, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 98, texture = 1 },
			["glass"] = { item = -1, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["Mecanica"] = {
		["homem"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 345, texture = 0 },
			["vest"] = { item = 90, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 5, texture = 0 },
			["tshirt"] = { item = 90, texture = 0 },
			["torso"] = { item = 345, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 7, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 24, texture = 0 },
			["vest"] = { item = 19, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 10, texture = 0 },
			["tshirt"] = { item = 19, texture = 0 },
			["torso"] = { item = 395, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["MecânicaGerencia"] = {
		["homem"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 4, texture = 0 },
			["vest"] = { item = 90, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 5, texture = 0 },
			["tshirt"] = { item = 90, texture = 0 },
			["torso"] = { item = 345, texture = 1 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 24, texture = 0 },
			["vest"] = { item = 19, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 10, texture = 0 },
			["tshirt"] = { item = 19, texture = 0 },
			["torso"] = { item = 395, texture = 1 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 14, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["MecânicaAluno"] = {
		["homem"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 5, texture = 1 },
			["vest"] = { item = 90, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 5, texture = 0 },
			["tshirt"] = { item = 90, texture = 0 },
			["torso"] = { item = 345, texture = 2 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 7, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 24, texture = 0 },
			["vest"] = { item = 19, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 10, texture = 0 },
			["tshirt"] = { item = 19, texture = 0 },
			["torso"] = { item = 395, texture = 2 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 1, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["PoliceGRR"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 130, texture = 1 },
			["vest"] = { item = 70, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 35, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 341, texture = 0 },
			["accessory"] = { item = 157, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 38, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 134, texture = 0 },
			["vest"] = { item = 19, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 36, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 361, texture = 0 },
			["accessory"] = { item = 0, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 44, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["PoliceRP"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 33, texture = 0 },
			["vest"] = { item = 71, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 338, texture = 0 },
			["accessory"] = { item = 157, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 44, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 136, texture = 1 },
			["vest"] = { item = 201, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 355, texture = 0 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 44, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["PoliceRP2"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 33, texture = 0 },
			["vest"] = { item = 71, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 339, texture = 0 },
			["accessory"] = { item = 157, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 30, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 136, texture = 1 },
			["vest"] = { item = 201, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 358, texture = 0 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 44, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["PoliceGIT"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 33, texture = 0 },
			["vest"] = { item = 71, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 339, texture = 1 },
			["accessory"] = { item = 157, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 30, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 136, texture = 1 },
			["vest"] = { item = 201, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 358, texture = 1 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 44, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["PoliceAluno"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 33, texture = 0 },
			["vest"] = { item = 153, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 340, texture = 0 },
			["accessory"] = { item = 157, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 30, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----OK-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 136, texture = 1 },
			["vest"] = { item = 201, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 359, texture = 0 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 44, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["BombeiroAcao"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = 137, texture = 0 },
			["pants"] = { item = 124, texture = 0 },
			["vest"] = { item = 153, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 228, texture = 0 },
			["accessory"] = { item = 157, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 166, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    -----não coloquei pq não tem-----
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 136, texture = 1 },
			["vest"] = { item = 201, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 25, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 359, texture = 0 },
			["accessory"] = { item = 1, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 44, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["BombeiroQG"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = 137, texture = 0 },
			["pants"] = { item = 129, texture = 0 },
			["vest"] = { item = 153, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 339, texture = 0 },
			["accessory"] = { item = 157, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 132, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                    
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 124, texture = 1 },
			["vest"] = { item = 201, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 85, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 117, texture = 0 },
			["accessory"] = { item = 88, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 50, texture = 0 },
			["glass"] = { item = 43, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
	["BombeiroAtendimento"] = {
		["homem"] = {                                                                     -----OK-----
			["hat"] = { item = 137, texture = 0 },
			["pants"] = { item = 129, texture = 0 },
			["vest"] = { item = 153, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 24, texture = 0 },
			["tshirt"] = { item = 15, texture = 0 },
			["torso"] = { item = 421, texture = 0 },
			["accessory"] = { item = 126, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 135, texture = 0 },
			["glass"] = { item = 0, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		},
		["mulher"] = {                                                                  
			["hat"] = { item = -1, texture = 0 },
			["pants"] = { item = 109, texture = 1 },
			["vest"] = { item = 201, texture = 0 },
			["bracelet"] = { item = -1, texture = 0 },
			["decals"] = { item = 0, texture = 0 },
			["mask"] = { item = 0, texture = 0 },
			["shoes"] = { item = 85, texture = 0 },
			["tshirt"] = { item = 14, texture = 0 },
			["torso"] = { item = 337, texture = 0 },
			["accessory"] = { item = 14, texture = 0 },
			["watch"] = { item = -1, texture = 0 },
			["arms"] = { item = 109, texture = 0 },
			["glass"] = { item = 43, texture = 0 },
			["ear"] = { item = -1, texture = 0 }
		}
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:jobOutfitFunctions")
AddEventHandler("player:jobOutfitFunctions",function(jobOutift)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.wantedReturn(user_id) or vRP.reposeReturn(user_id) then
			return
		end

		if jobOutift == jobsOutfit then
			local model = vRPC.ModelPlayer(source)
			if model == "mp_m_freemode_01" then
				TriggerClientEvent("updateRoupas",source,jobsOutfit[jobOutift]["homem"])
			elseif model == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,jobsOutfit[jobOutift]["mulher"])
			end
			TriggerClientEvent("Notify",source,"verde","Roupas Aplicadas.",5000)
		else
			return
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYER:PRESETFUNCTIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("player:outfitFunctions")
AddEventHandler("player:outfitFunctions",function(mode)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and not vRP.reposeReturn(user_id) and not vRP.wantedReturn(user_id) then
		if mode == "aplicar" then
			local result = vRP.getSrvdata("Clothes:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif mode == "preaplicar" then
			local result = vRP.getSrvdata("ClothesPremium:"..user_id)
			if result["pants"] ~= nil then
				TriggerClientEvent("updateRoupas",source,result)
				TriggerClientEvent("Notify",source,"verde","Roupas aplicadas.",3000)
			else
				TriggerClientEvent("Notify",source,"amarelo","Roupas não encontradas.",3000)
			end
		elseif mode == "salvar" then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then
				vRP.setSrvdata("Clothes:"..user_id,custom)
				TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
			end
		elseif mode == "presalvar" then
			local custom = vSKINSHOP.getCustomization(source)
			if custom then
				vRP.setSrvdata("ClothesPremium:"..user_id,custom)
				TriggerClientEvent("Notify",source,"verde","Roupas salvas.",3000)
			end
		elseif mode == "remover" then
			local model = vRPC.ModelPlayer(source)
			if model == "mp_m_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["Remove"]["homem"])
			elseif model == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["Remove"]["mulher"])
			end
		elseif mode == "pelado" then
			local model = vRPC.ModelPlayer(source)
			if model == "mp_m_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["Naked"]["homem"])
			elseif model == "mp_f_freemode_01" then
				TriggerClientEvent("updateRoupas",source,removeFit["Naked"]["mulher"])
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("garagem",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			local request = vRP.request(source,"Garagem","Deseja comprar uma vaga na garagem por $<b>50.000 dólares</b>?",30)
			if request then
				if vRP.paymentBank(user_id,50000) then
					vRP.execute("vRP/update_garages",{ id = parseInt(user_id) })
				else
					TriggerClientEvent("Notify",source,"vermelho", "Dinheiro insuficiente.", 5000)
				end
			end
		end
	end
end)
------------------------------------------------------------------------------------rv-----------------------------------------------------
-- CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrunk");
AddEventHandler("player:checkTrunk",function(nplayer)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.getHealth(source) > 101 and not vRPC.inVehicle(source) and not vCLIENT.getHandcuff(source) then
			local nplayer = vRPC.nearestPlayer(source,2)
			if nplayer then
				TriggerClientEvent("vrp_player:CheckTrunk",nplayer)
			end
		end
	end
end)
------------------------------------------------------------------------------------rv-----------------------------------------------------
-- CHECKTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:checkTrash");
AddEventHandler("player:checkTrash",function(nplayer)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.getHealth(source) > 101 and not vRPC.inVehicle(source) and not vCLIENT.getHandcuff(source) then
			local nplayer = vRPC.nearestPlayer(source,2)
			if nplayer then
				TriggerClientEvent("player:CheckTrunk",nplayer)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:seatPlayer");
AddEventHandler("player:seatPlayer",function(location)
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRPC.getHealth(source) > 101 and not vCLIENT.getHandcuff(source) then
			TriggerClientEvent("vrp_player:SeatPlayer",source,location)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEAT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("player:servicoFunctions");
AddEventHandler("player:servicoFunctions",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.hasPermission(user_id,{"Police","actionPolice","Paramedic"})  then
			local nonDuty = 0
			local onDuty = ""
			local service = {}

			if vRP.hasPermission(user_id,"Police") then
				service = vRP.numPermission("Police")
				emprego = "Policiais"
				emprego2 = "em serviço."
			elseif vRP.hasPermission(user_id,"Paramedic") then
				service = vRP.numPermission("Paramedic")
				emprego = "Paramedicos"
				emprego2 = "em serviço."
			elseif vRP.hasPermission(user_id,"actionPolice") then
				service = vRP.numPermission("actionPolice")
				emprego = "Policiais"
				emprego2 = "em ação."
			end

			for k,v in pairs(service) do
				local nuser_id = vRP.getUserId(v)
				local identity = vRP.getUserIdentity(nuser_id)

				onDuty = onDuty.." #<b>"..vRP.format(parseInt(nuser_id)).."</b> - "..identity["name"].." "..identity["name2"].."<br>"
				nonDuty = nonDuty + 1
			end
			TriggerClientEvent("Notify",source,"amarelo", "Atualmente há <b>"..nonDuty.." "..emprego.."</b> "..emprego2.."<br> "..onDuty, 30000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NUISPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
-- RegisterCommand("nuispawn",function(source,args,rawCommand)
-- 	TriggerClientEvent("vrp_spawn:setupChars",source)
-- end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MORTE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("deathLogs")
AddEventHandler("deathLogs",function(nplayer)
	local source = source
	local user_id = vRP.getUserId(source)
	local x,y,z = vRPC.getPositions(source)
	if user_id then
		local identity = vRP.getUserIdentity(user_id)
		if nplayer > 0 then
		 	local killerUser = vRP.getUserId(nplayer)
		 	local identity2 = vRP.getUserIdentity(killerUser)
			local x2,y2,z2 = vRPC.getPositions(nplayer)
			 
			TriggerEvent("webhooks","kill","```ini\n[MATADOR]: "..killerUser.." "..identity2.name.." "..identity2.name2.."\n[COORDS]: "..x2..","..y2..","..z2.."\n[MATOU]: "..user_id.." "..identity.name.." "..identity.name2.."\n[COORDS]: "..x..","..y..","..z.." \n[DATA E HORA]: "..os.date("%d/%m/%Y %H:%M:%S").." \r```", "MATOU ALGUEM")
		else
			TriggerEvent("webhooks","kill","```ini\n[MORREU]: "..user_id.." "..identity.name.." "..identity.name2.." \n[COORDS]: "..x..","..y..","..z.." \n[DATA E HORA]: "..os.date("%d/%m/%Y %H:%M:%S").." \r```"," MORREU SOZIN")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- /CAMPING
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("camping",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
    	vCLIENT.insertObjects(source,tostring(args[1]))
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANCORAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ancorar",function(source,args,rawCommand)
	if exports["chat"]:statusChat(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if vRPC.inVehicle(source) then
				local vehicle,vnetid,placa,vname,lock,banned = vRPC.vehList(source,7)
				if vehicle then
					vCLIENT.boatAnchor(source,vehicle)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- COMANDOS PTR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("ptr",function(source)
    local user_id = vRP.getUserId(source)
    if user_id then
		local policiais = vRP.numPermission("Police")
		TriggerClientEvent("Notify",source,"amarelo","Atualmente <b>"..#policiais.." Policiais</b> em serviço.<br>",5000)
		if vRP.hasRank(user_id,"Admin",40) then
			local cops = ""
			for k, v in ipairs(policiais) do
				local uid = vRP.getUserId(v)
				local identity = vRP.getUserIdentity(uid)
				cops = cops .. "<b>" .. uid .. " - " .. identity.name .. " " .. identity.name2 .. "</b><br/>"
			end

			local action = vRP.numPermission("actionPolice")
			TriggerClientEvent("Notify",source,"amarelo","Atualmente <b>"..#action.." Policiais</b> em ação.<br>",5000)
			local actions = ""
			for k, v in ipairs(action) do
				local uid = vRP.getUserId(v)
				local identity = vRP.getUserIdentity(uid)
				actions = actions .. "<b>" .. uid .. " - " .. identity.name .. " " .. identity.name2 .. "</b><br/>"
			end

			if cops ~= "" then
				TriggerClientEvent("Notify", source, "amarelo", cops)
			end
			if actions ~= "" then
				TriggerClientEvent("Notify", source, "amarelo", actions)
			end
		end
    end
end)
RegisterCommand("meds",function(source)
    local user_id = vRP.getUserId(source)
    if user_id then
		local medicos = vRP.numPermission("Paramedic")
		TriggerClientEvent("Notify",source,"amarelo","Atualmente <b>"..#medicos.." Médicos</b> em serviço.<br>",5000)
		if vRP.hasRank(user_id,"Admin",40) then
			local meds = ""
			for k, v in ipairs(medicos) do
				local uid = vRP.getUserId(v)
				local identity = vRP.getUserIdentity(uid)
				meds = meds .. "<b>" .. uid .. " - " .. identity.name .. " " .. identity.name2 .. "</b><br/>"
			end
			if meds == "" then
				TriggerClientEvent("Notify", source, "amarelo", meds)
			end
		end
    end
end)

RegisterCommand("mecs",function(source)
    local user_id = vRP.getUserId(source)
    if user_id then
		local mecanicos = vRP.numPermission("Mechanic")
		TriggerClientEvent("Notify",source,"amarelo","Atualmente <b>"..#mecanicos.." Mecânicos</b> em serviço.<br>",5000)
		if vRP.hasRank(user_id,"Admin",40) then
			local mecs = ""
			for k, v in ipairs(mecanicos) do
				local uid = vRP.getUserId(v)
				local Identity = vRP.getUserIdentity(uid)
				mecs = mecs .. "<b>" .. uid .. " - " .. Identity.name .. " " .. Identity.name2 .. "</b><br/>"
			end
			if mecs == "" then
				TriggerClientEvent("Notify", source, "amarelo", mecs)
			end
		end
    end
end)