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
src = {}
Tunnel.bindInterface("vrp_inventory",src)
vCLIENT = Tunnel.getInterface("vrp_inventory")
vGARAGE = Tunnel.getInterface("vrp_garages")
vPLAYER = Tunnel.getInterface("vrp_player")
vTASKBAR = Tunnel.getInterface("vrp_taskbar")
vADMIN = Tunnel.getInterface("vrp_admin")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local active = {}
local Active = {}
local dropList = {}
local firecracker = {}
local syringeTime = {}
local Trashs = {}
local Trunks = {}
local verifyObjects = {}
local Stockade = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- FIRECRACKER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		for k,v in pairs(firecracker) do
			if firecracker[k] > 0 then
				firecracker[k] = firecracker[k] - 30
				if firecracker[k] <= 0 then
					firecracker[k] = nil
				end
			end
		end
		Wait(30000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYRINGETIME
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		for k,v in pairs(syringeTime) do
			if syringeTime[k] > 0 then
				syringeTime[k] = v - 1
				if syringeTime[k] <= 0 then
					syringeTime[k] = nil
				end
			end
		end
		Wait(60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		for k,v in pairs(active) do
			if active[k] > 0 then
				active[k] = active[k] - 1
			end
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MOCHILA
-----------------------------------------------------------------------------------------------------------------------------------------
function src.Mochila()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local inv = vRP.getInventory(user_id)
		if inv then
			local inventory = {}
			for k,v in pairs(inv) do
				if (parseInt(v.amount) <= 0 or vRP.itemBodyList(v.item) == nil) then
					vRP.removeInventoryItem(user_id,v.item,parseInt(v.amount),false)
				else

					v.amount = parseInt(v.amount)
					v.name = vRP.itemNameList(v.item)
					v.peso = vRP.itemWeightList(v.item)
					v.index = vRP.itemIndexList(v.item)
					v.max = vRP.itemMaxAmount(v.item)
					v.type = vRP.itemTypeList(v.item)
					v.hunger = vRP.itemHungerList(v.item)
					v.thirst = vRP.itemWaterList(v.item)
					v.stress = vRP.itemStressList(v.item)
					v.economy = vRP.itemEconomyList(v.item)
					v.desc = vRP.itemDescList(v.item)
					v.key = v.item
					v.slot = k

					inventory[k] = v
				end
			end

			local identity = vRP.getUserIdentity(user_id)
			return inventory,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.name2,parseInt(user_id),parseInt(identity.bank),parseInt(vRP.getUserGems(user_id)),identity.phone,identity.registration }
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:populateSlot")
AddEventHandler("vrp_inventory:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
			vRP.giveInventoryItem(user_id,itemName,amount,false,target)
			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:updateSlot")
AddEventHandler("vrp_inventory:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
					vRP.giveInventoryItem(user_id,itemName,amount,false,target)
				end
			else
				vRP.swapSlot(user_id,slot,target)
			end

			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- NOFULL
-----------------------------------------------------------------------------------------------------------------------------------------
local noFull = {
	["premiumBooster00"] = true,
	["premiumSilver50"] = true,
	["premiumGold60"] = true,
	["premiumPlatinum70"] = true,
	["premiumDiamond90"] = true,
	["newgarage"] = true,
	["newchars"] = true,
	["newprops"] = true
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:dropItem")
AddEventHandler("vrp_inventory:dropItem",function(itemName,slot,amount)
	local source = source
	if vCLIENT.checkConnection(source) then
		local user_id = vRP.getUserId(source)
		if user_id then
			if active[user_id] == nil and not Player(source)["state"]["Handcuff"] then
				if amount == nil then amount = 1 end
				if amount <= 0 then amount = 1 end

				if noFull[itemName] then
					TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
					TriggerClientEvent("Notify",source,"INFORMAÇÃO","Armazenamento proibido.",5000,'info')
					return
				end

				if not vRP.wantedReturn(user_id) then
					if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
						TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("inventory:Close",source)

						local x,y,z,h = vRPC.getPositions(source)
						local grid = vRP.getGridzone(x,y)
						if dropList[grid] == nil then
							dropList[grid] = {}
						end

						table.insert(dropList[grid],{ itemName,amount,x,y,z,1800 })

						TriggerClientEvent("vrp_inventory:dropUpdates",-1,dropList)

						vRPC._playAnim(source,false,{"pickup_object","putdown_low"},false)
						Wait(2000)
						vRPC._removeObjects(source)
						TriggerClientEvent("inventory:Buttons",source,false)
						TriggerEvent("webhooks","drop","```ini\n[ID]: "..user_id.." \n[ITEM] "..vRP.itemNameList(itemName).." [QUANTIDADE]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_ITEMDROP:CREATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_itemdrop:Create")
AddEventHandler("vrp_itemdrop:Create",function(itemName,count,x,y,z,grid)
	if dropList[grid] == nil then
		dropList[grid] = {}
	end

	table.insert(dropList[grid],{ itemName,count,x,y,z,1800 })
	TriggerClientEvent("vrp_inventory:dropUpdates",-1,dropList)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMPICKUP
-----------------------------------------------------------------------------------------------------------------------------------------
function src.itemPickup(grid,id)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if dropList[grid][id] == nil then
			return
		else
			if dropList[grid][id] then
				if vRP.getInventoryItemMax(user_id,tostring(dropList[grid][id][1]),parseInt(dropList[grid][id][2])) then
					if vRP.computeInvWeight(user_id) + vRP.itemWeightList(tostring(dropList[grid][id][1])) * parseInt(dropList[grid][id][2]) <= vRP.getBackpack(user_id) then
						if dropList[grid][id] == nil then
							return
						end

						vRP.giveInventoryItem(user_id,tostring(dropList[grid][id][1]),parseInt(dropList[grid][id][2]),true)
						TriggerEvent("webhooks","take","```ini\n[ID]: "..user_id.." \n[ITEM] "..vRP.itemNameList(tostring(dropList[grid][id][1])).." [QUANTIDADE]: "..parseInt(dropList[grid][id][2]).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						dropList[grid][id] = nil

						vRPC._playAnim(source,true,{"pickup_object","putdown_low"},false)
						TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
						TriggerClientEvent("vrp_inventory:dropUpdates",-1,dropList)

						Wait(750)
						vRPC._removeObjects(source)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Você não pode carregar essa quantidade de itens.",5000)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		for k,v in pairs(dropList) do
			for y,w in pairs(v) do
				if w[6] > 0 then
					w[6] = w[6] - 10
					if w[6] <= 0 then
						dropList[k][y] = nil
						TriggerClientEvent("vrp_inventory:dropUpdates",-1,dropList)

					end
				end
			end
		end
		Wait(10000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SENDITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:sendItem")
AddEventHandler("vrp_inventory:sendItem",function(itemName,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] == nil and not Player(source)["state"]["Handcuff"] then
			if amount == nil then amount = 1 end
			if amount <= 0 then amount = 1 end

			if noFull[itemName] then
				TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
				TriggerClientEvent("Notify",source,"INFORMAÇÃO","Armazenamento proibido.",5000)
				return
			end

			if not vRP.wantedReturn(user_id) then
				local nplayer = vRPC.nearestPlayer(source,3)
				if nplayer then
					local nuser_id = vRP.getUserId(nplayer)
					if nuser_id then
						if vRP.getInventoryItemMax(nuser_id,itemName,parseInt(amount)) then
							if vRP.computeInvWeight(nuser_id) + vRP.itemWeightList(itemName) * parseInt(amount) <= vRP.getBackpack(nuser_id) then
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								if vRP.tryGetInventoryItem(user_id,itemName,parseInt(amount),true) then
									vRP.giveInventoryItem(nuser_id,itemName,parseInt(amount),true)
									TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
									TriggerClientEvent("vrp_inventory:Update",nplayer,"updateMochila")
									vRPC.createObjects(source,"mp_safehouselost@","package_dropoff","prop_paper_bag_small",16,28422,0.0,-0.05,0.05,180.0,0.0,0.0)
									Wait(3000)
									vRPC.removeObjects(source)
									TriggerClientEvent("inventory:Buttons",source,false)
									TriggerEvent("webhooks","send","```ini\n[ID]: "..user_id.." \n[ID DO ENVIADO]: "..nuser_id.." \n[ITEM] "..vRP.itemNameList(itemName).." [QUANTIDADE]: "..parseInt(amount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								end
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_inventory:useItem")
AddEventHandler("vrp_inventory:useItem",function(slot,rAmount)
	local source = source
    local user_id = vRP.getUserId(source)
	if user_id then
		if rAmount == nil then rAmount = 1 end
		if rAmount <= 0 then rAmount = 1 end

		if active[user_id] == nil and not Player(source)["state"]["Handcuff"] then
			local inv = vRP.getInventory(user_id)
			if inv then
				if not inv[tostring(slot)] or inv[tostring(slot)].item == nil then
					return
				end

				local itemName = inv[tostring(slot)].item

				if vRP.itemTypeList(itemName) == "Usável" or vRP.itemTypeList(itemName) == "Stress" then
					if itemName == "bandage" then
						if vRPC.getHealth(source) > 120 and vRPC.getHealth(source) < 200 then
							active[user_id] = 5
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,5000)
							vRPC._playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPC._stopAnim(source,false)
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRP.upgradeStress(user_id,2)
										vRPC.updateHealth(source,15)
									end
								end
								Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"vermelho","Você não pode utilizar de vida cheia ou muito ferido.",5000)
						end
					end
					

					if itemName == "syringe" then
						TriggerClientEvent("inventory:Close",source)
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local nuser_id = vRP.getUserId(nplayer)
								local nidentity = vRP.getUserIdentity(nuser_id)
								local identity = vRP.getUserIdentity(user_id)
								if syringeTime[parseInt(nuser_id)] == 0 or not syringeTime[parseInt(nuser_id)] then
									local request = vRP.request(nplayer,"Hospital","Você aceita que "..identity.name.." "..identity.name2.." retire seu sangue?",30)
									if request then
										active[user_id] = 8
										syringeTime[nuser_id] = 60
										TriggerClientEvent("Notify",source,"verde","O paciente aceitou a retirada de sangue.",5000)
										TriggerClientEvent("Progress",source,8000)
										TriggerClientEvent("inventory:Buttons",source,true)

										repeat
											if active[user_id] == 0 then
												active[user_id] = nil
												TriggerClientEvent("inventory:Buttons",source,false)
												if vRP.tryGetInventoryItem(user_id,"syringe",1,true) then
													vRP.giveInventoryItem(user_id,"bloodbag",5,true)
													vRPC.downHealth(nplayer,50)
													TriggerClientEvent("Notify",source,"verde","<b>Syringe</b> utilizada com sucesso.",5000)
													TriggerEvent("webhooks","sangue","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[RETIROU SANGUE]: "..nuser_id.." "..nidentity.name.." "..nidentity.name2.." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Retirar sangue")
												end
											end
											Wait(0)
										until active[user_id] == nil
									else
										TriggerClientEvent("Notify",source,"vermelho","O paciente negou a retirada de sangue.",5000)
									end
								else
									TriggerClientEvent("Notify",source,"azul","Aguarde "..completeTimers(syringeTime[nuser_id]*60)..".",5000)
								end
							end
						end
					end
					
					if itemName == "plaster" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local nuser_id = vRP.getUserId(nplayer)
								local identity = vRP.getUserIdentity(user_id)
								local nidentity = vRP.getUserIdentity(nuser_id)
								TriggerClientEvent("inventory:Close",source)

								local body = vRP.prompt(source,"Parte do Corpo: (1 = Corpo Inteiro, 2 = Tronco, 3 = Pernas, 4 = Pés)","")
								if body == "" then
									return
								end
								
								local duration = vRP.prompt(source,"Duração (Minutos):","")
								if duration == "" or tonumber(duration) == 0 or tonumber(duration) > 30 then
									return
								end

								local bodyCheck = sanitizeString(body,"1234",true)
								if bodyCheck and duration then
									local namebody = {
										[1] = "Corpo Inteiro",
										[2] = "Braços",
										[3] = "Pernas",
										[4] = "Pés"
									}

									vPLAYER.setPlaster(nplayer,bodyCheck)
									vRPC.startCure(nplayer)
									vRP.updateRepose(nuser_id,parseInt(duration*60))

									TriggerClientEvent("resetDiagnostic",nplayer)
									TriggerClientEvent("Notify",nplayer,"verde","Você foi engessado por "..identity.name.." "..identity.name2.." e deverá ficar em repouso por "..completeTimers(parseInt(duration)*60)..".",10000)
									TriggerClientEvent("Notify",source,"verde","O gesso foi aplicado com sucesso e o paciente deverá ficar em repouso por "..completeTimers(parseInt(duration)*60)..".",10000)
									TriggerEvent("webhooks","gesso","```ini\n[DOUTOR]: "..identity.id.." "..identity.name.." "..identity.name2.." \n[ENGESSOU]: "..nidentity.id.." "..nidentity.name.." "..nidentity.name2.." \n[PARTE DO CORPO]: "..namebody[parseInt(bodyCheck)].." \n[TEMPO DO GESSO]: "..parseInt(duration).." Minutos "..os.date("\n[DATA]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								end

							end
						end
					end

					if itemName == "bloodbag" then
						TriggerClientEvent("inventory:Close",source)
                		if vRP.hasPermission(user_id,"Paramedic") then
                	    	local nplayer = vRPC.nearestPlayer(source,3)
							local nuser_id = vRP.getUserId(nplayer)
                	    	if nplayer then
                	       		local nuser_id = vRP.getUserId(nplayer)
                	        	local identity = vRP.getUserIdentity(user_id)
                	        	local health = vRPC.getHealth(nplayer)
                	        	if vRPC.getHealth(nplayer) > 101 and vRPC.getHealth(nplayer) < 130 then
                	            	local request = vRP.request(nplayer,"Hospital","Você aceita receber tratamento de "..identity.name.." "..identity.name2.."?",30)
                	            	if request then
										if vRP.tryGetInventoryItem(user_id,"bloodbag",1,true) then
											vRPC.startCure(nplayer)
		
											TriggerClientEvent("resetDiagnostic",nplayer)
											vRP.upgradeHunger(nuser_id,20)
											vRP.upgradeThirst(nuser_id,20)
											TriggerClientEvent("Notify",source,"verde","Tratamento no paciente iniciado com sucesso.",10000)
                	                	end
                	            	else
										TriggerClientEvent("Notify",source,"vermelho","O paciente recusou o tratamento.",10000)
									end
								else
									TriggerClientEvent("Notify",source,"amarelo","Não necessario receber transfusão de sangue.",8000)
                	        	end
                	    	end
						end
					end
				
					if itemName == "serum" then
						TriggerClientEvent("inventory:Close",source)
            		    if vRP.hasPermission(user_id,"Paramedic") then
            		        local nplayer = vRPC.nearestPlayer(source,3)
            		        if nplayer then
            		            local nuser_id = vRP.getUserId(nplayer)
            		            local identity = vRP.getUserIdentity(user_id)
            		            local health = vRPC.getHealth(nplayer)
								local nuser_id = vRP.getUserId(nplayer)
            		            if vRPC.getHealth(nplayer) > 129 and vRPC.getHealth(nplayer) < 200 then
            		                local request = vRP.request(nplayer,"Hospital","Você aceita receber tratamento de "..identity.name.." "..identity.name2.."?",30)
            		                if request then
            		                    if vRP.tryGetInventoryItem(user_id,"serum",1,true) then
            		                        vRPC.startCure(nplayer)
            		                        TriggerClientEvent("resetDiagnostic",nplayer)
											vRP.upgradeHunger(nuser_id,20)
											vRP.upgradeThirst(nuser_id,20)
											TriggerClientEvent("Notify",source,"verde","Tratamento no paciente iniciado com sucesso.",10000)
            		                    end
									else
										TriggerClientEvent("Notify",source,"vermelho","O paciente recusou o tratamento.",10000)
									end
            		            else
									TriggerClientEvent("Notify",source,"amarelo","Necessario receber transfusão de sangue.",8000)
            		            end
            		        end
						end
					end
				
					if itemName == "defibrillator" or itemName == "defibrillatorkids" then
						local nplayer = vRPC.nearestPlayer(source,3)
						local nuser_id = vRP.getUserId(nplayer)
						if vRP.hasPermission(user_id,{"Paramedic","Police"}) and not vRPC.inVehicle(source) then

							local parAmount = vRP.numPermission("Paramedic")
							if vRP.hasPermission(user_id,"Police") then
								if parseInt(#parAmount) > 0 then
									return
								end
							end

							if nplayer then
								if vRPC.inKnockout(nplayer) then
									active[user_id] = 10
									TriggerClientEvent("inventory:Buttons",source,true)
									vRPC._playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)
									TriggerClientEvent("Progress",source,10000)
									TriggerClientEvent("inventory:Close",source)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vRPC._stopAnim(source,false)
											TriggerClientEvent("inventory:Buttons",source,false)
											vRPC.revivePlayer(nplayer,110)
											vRP.upgradeHunger(nuser_id,15)
											vRP.upgradeThirst(nuser_id,15)
		
											TriggerEvent("resetPulse",nplayer)
										end
										Wait(0)
									until active[user_id] == nil
								end
							end
						end
					end

					if itemName == "thermometer" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local temperature = math.random(35, 42)
								active[user_id] = 3
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,3000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)
										TriggerClientEvent("Notify",source,"amarelo","A Temperatura do paciente está <b>"..temperature.."º</b>", 5000)
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "testx" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							active[user_id] = 10
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,10000)
							vRPC._playAnim(source,true,{"misscarsteal2peeing","peeing_intro"},false)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									TriggerClientEvent("inventory:Buttons",source,false)
									vRPC._removeObjects(source,"one")
									if math.random(100) >= 90 then
										TriggerClientEvent("Notify",source,"verde","Resultado positivo.",5000)
									else
										TriggerClientEvent("Notify",source,"vermelho","Resultado negativo.",5000)
									end
								end
								
								Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "dnatest" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local dna = math.random(100)
								active[user_id] = 3
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,3000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)
										TriggerClientEvent("Notify",source,"amarelo","Resultado: <b>"..dna.."</b>", 5000)
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "bloodtest" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local bloodType = {"A+","A-",  "B+",  "B-", "O+", "O-", "AB+", "AB-"}
								local blood = bloodType[math.random(#bloodType)]
								active[user_id] = 3
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,3000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)
										TriggerClientEvent("Notify",source,"amarelo","Sangue do tipo: <b>"..blood.."</b>", 5000)
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end
					
					if itemName == "alergictest" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local alergicType = {"Leite","Farinha","Morango","Ovo","Peixe","Camarão","Cacau","Batata"}
								local alergic = alergicType[math.random(#alergicType)]
								active[user_id] = 3
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,3000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)
										TriggerClientEvent("Notify",source,"amarelo","Sangue do tipo: <b>"..alergic.."</b>", 5000)
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "pregnantrisk" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local pregnantRisk = { "Hipertensão","Anemia Ferropriva","Diabetes gestacional","Risco de parto prematuro"}
								local pregRisk = pregnantRisk[math.random(#pregnantRisk)]
								active[user_id] = 3
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,3000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)
										TriggerClientEvent("Notify",source,"amarelo","Sangue do tipo: <b>"..pregRisk.."</b>", 5000)
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "pressure" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								local getHealth = vRPC.getHealth(nplayer) - 100
								active[user_id] = 3
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,3000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)
										TriggerClientEvent("Notify",source,"amarelo","A pressão do paciente está <b>12/"..getHealth.."</b>", 5000)
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "dressing" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							if nplayer then
								active[user_id] = 3
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,3000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)
	
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "deadbag" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							local nuser_id = vRP.getUserId(nplayer)
							local identity = vRP.getUserIdentity(user_id)
							local nidentity = vRP.getUserIdentity(nuser_id)
							active[user_id] = 3
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,3000)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPC._stopAnim(source,false)
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRPC.inKnockout(nplayer) then
										vRP.createBodyBag(source)
										vRPC.finishDeath(nplayer)
										vRPC._revivePlayer(nplayer,200)
	
										TriggerClientEvent("resetDiagnostic",nplayer)
										TriggerEvent("resetPulse",nplayer)
										TriggerEvent("webhooks","deadbag","```ini\n[======== DEADBAG ========]\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[FALECIDO]: "..nuser_id.." "..nidentity.name.." "..nidentity.name2.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Deadbag")
									end
								end
								Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar este item em pessoas que não estão em coma.",5000)
						end
					end

					if itemName == "anesthesia" then
						if vRP.hasPermission(user_id,"Paramedic") then
							local nplayer = vRPC.nearestPlayer(source,3)
							local nuser_id = vRP.getUserId(nplayer)
							local identity = vRP.getUserIdentity(user_id)
							local nidentity = vRP.getUserIdentity(nuser_id)
							if nplayer then
								TriggerClientEvent("vrp_hud:toggleAnestesia",nplayer)
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("Notify",source,"verde","<b>Anestesia</b> utilizado/removido com sucesso.",5000)
								TriggerEvent("webhooks","anestesia","```ini\n[======== ANESTESIA ========]\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[APLICOU/REMOVEU]: "..nuser_id.." "..nidentity.name.." "..nidentity.name2.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Anestesia")
							end
						end
					end

					if itemName == "analgesic" then
						if vRPC.getHealth(source) > 120 and vRPC.getHealth(source) < 200 then
							active[user_id] = 3
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,3000)
							vRPC._playAnim(source,true,{"mp_suicide","pill"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPC._stopAnim(source,false)
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRP.upgradeStress(user_id,1)
										vRPC.updateHealth(source,2)
									end
								end
								Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar de vida cheia ou muito ferido.",5000)
						end
					end

					if itemName == "watermedic" then
						if vCLIENT.hospitalFarm(source) and vRP.hasPermission(user_id,"Paramedic") then
							active[user_id] = parseInt(2*3)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,parseInt(2*3000))
							vRPC._playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRP.getInventoryItemAmount(user_id,"watermedic") >= parseInt(1) and vRP.getInventoryItemAmount(user_id,"reagentmedic") >= parseInt(1) and vRP.getInventoryItemAmount(user_id,"bagempty") >= parseInt(1) then
										if vRP.tryGetInventoryItem(user_id,"watermedic",parseInt(1),true) and vRP.tryGetInventoryItem(user_id,"reagentmedic",parseInt(1),true) and vRP.tryGetInventoryItem(user_id,"bagempty",parseInt(1),true) then
											vRP.giveInventoryItem(user_id,"serum",parseInt(3),true)
										end
									end
								end
								Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "joint" then
						if vRP.getInventoryItemAmount(user_id,"lighter") < 1 then
							return
						end

						active[user_id] = 30
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,30000)
						vRPC._createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPC._removeObjects(source)
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.weedTimer(user_id,1)
									vRP.downgradeHunger(user_id,10)
									vRP.downgradeThirst(user_id,10)
									vRP.downgradeStress(user_id,2)
									vPLAYER.movementClip(source,"move_m@shadyped@a")
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cocaine" then
						active[user_id] = 10
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPC._stopAnim(source)
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									vRP.downgradeHunger(user_id,10)
									vRP.downgradeThirst(user_id,10)
									TriggerClientEvent("setEnergetic",source,10,1.45)
									TriggerClientEvent("setMeth",source)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "meth" then
						active[user_id] = 10
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._playAnim(source,true,{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPC._stopAnim(source)
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									vRPC.setArmour(source,10)
									vRP.downgradeHunger(user_id,10)
									vRP.downgradeThirst(user_id,10)
									TriggerClientEvent("setMeth",source)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "lean" then
						active[user_id] = 3
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,3000)
						vRPC._playAnim(source,true,{"mp_suicide","pill"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPC._stopAnim(source,false)
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									vRP.downgradeStress(user_id,15)
									TriggerClientEvent("cleanEffectDrugs",source)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "ecstasy" then
						active[user_id] = 3
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,3000)
						vRPC._playAnim(source,true,{"mp_suicide","pill"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPC._stopAnim(source,false)
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.chemicalTimer(user_id,2)
									TriggerClientEvent("setEcstasy",source)
									TriggerClientEvent("setEnergetic",source,10,1.45)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "cigarette" then
						if vRP.getInventoryItemAmount(user_id,"lighter") < 1 then
							return
						end

						active[user_id] = 60
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,60000)
						vRPC._createObjects(source,"amb@world_human_aa_smoke@male@idle_a","idle_c","prop_cs_ciggy_01",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPC._removeObjects(source)
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.downgradeStress(user_id,15)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "vape" then
						active[user_id] = 30
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,30000)
						vRPC._createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","ba_prop_battle_vape_01",49,18905,0.08,-0.00,0.03,-150.0,90.0,-10.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRP.downgradeStress(user_id,25)
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._removeObjects(source,"one")
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "dildo" then
						active[user_id] = 30
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,30000)
						vRPC._playAnim(source,true,{"mp_player_int_upperarse_pick","mp_player_int_arse_pick"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRP.downgradeStress(user_id,15)
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._removeObjects(source,"one")
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "warfarin" then
						if vRPC.getHealth(source) > 120 and vRPC.getHealth(source) < 200 then
							active[user_id] = 15
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,15000)
							vRPC._createObjects(source,"amb@world_human_clipboard@male@idle_a","idle_c","v_ret_ta_firstaid",49,60309)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPC._removeObjects(source)
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRPC.updateHealth(source,45)
									end
								end
								Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar de vida cheia ou muito ferido.",5000)
						end
					end

					if itemName == "gauze" then
						if vRPC.getHealth(source) > 101 and vRPC.getHealth(source) < 200 then
							active[user_id] = 3
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,3000)
							vRPC._playAnim(source,true,{"amb@world_human_clipboard@male@idle_a","idle_c"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPC._stopAnim(source,false)
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRPC.updateHealth(source,25)
									end
								end
								Wait(0)
							until active[user_id] == nil
						else
							TriggerClientEvent("Notify",source,"amarelo","Você não pode utilizar de vida cheia ou nocauteado.",5000)
						end
					end

					if itemName == "binoculars" then
						active[user_id] = 2
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,2000)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._createObjects(source,"amb@world_human_binoculars@male@enter","enter","prop_binoc_01",50,28422)
								Wait(750)
								TriggerClientEvent("useBinoculos",source)
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "camera" then
						active[user_id] = 2
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,2000)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._createObjects(source,"amb@world_human_paparazzi@male@base","base","prop_pap_camera_01",49,28422)
								Wait(100)
								TriggerClientEvent("useCamera",source)
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "dorflex" or itemName == "bepantol" or itemName == "buscopan" or itemName == "heparina" or itemName == "paracetamol" then
						if vRPC.getHealth(source) > 120 and vRPC.getHealth(source) < 200 then
							vRPC.stopActived(source)
							active[user_id] = 15
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,15000)
							vRPC._createObjects(source,"mp_player_intdrink","loop_bottle","ng_proc_drug01a002",49,60309)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									TriggerClientEvent("inventory:Buttons",source,false)
									vRPC.removeObjects(source)
	
									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										vRPC.playScreenEffect(source,"RaceTurbo",16)
										vRPC.playScreenEffect(source,"DrugsTrevorClownsFight",16)
									end
								end
								Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "adrenaline" then
						local distance = vCLIENT.adrenalineDistance(source)
						local parAmount = vRP.numPermission("Paramedic")
						if parseInt(#parAmount) > 0 and not distance then
							return
						end

						local nplayer = vRPC.nearestPlayer(source,2)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								if Player(nplayer)["state"]["DeadPlayer"] then
									active[user_id] = 10
									vRPC.stopActived(source)
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("inventory:Buttons",source,true)
									TriggerClientEvent("Progress",source,10000)
									vRPC._playAnim(source,false,{"mini@cpr@char_a@cpr_str","cpr_pumpchest"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											TriggerClientEvent("inventory:Buttons",source,false)
											if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
												TriggerClientEvent("Notify",source,"sucesso","<b>Adrenalina</b> vencida. Chame os <b>Paramédicos</b>",8000)
												vRP.upgradeStress(user_id,10)
												vRP.upgradeStress(nuser_id,10)
												vRP.upgradeThirst(nuser_id,10)
												vRP.upgradeHunger(nuser_id,10)
												vRP.chemicalTimer(nuser_id,1)
												vRPC.revivePlayer(nplayer,110)
			
											end
										end
										Wait(0)
									until active[user_id] == nil
								end
							end
						end
					end

					if itemName == "teddy" then
						TriggerClientEvent("inventory:Close",source)
						vRPC._createObjects(source,"impexp_int-0","mp_m_waremech_01_dual-0","v_ilev_mr_rasberryclean",49,24817,-0.20,0.46,-0.016,-180.0,-90.0,0.0)
					end

					if itemName == "rose" then
						TriggerClientEvent("inventory:Close",source)
						vRPC._createObjects(source,"anim@heists@humane_labs@finale@keycards","ped_a_enter_loop","prop_single_rose",49,18905,0.13,0.15,0.0,-100.0,0.0,-20.0)
					end

					if itemName == "identity" then
						local identity = vRP.getUserIdentity(user_id)
						local nplayer = vRPC.nearestPlayer(source,2)
						if nplayer then
							if identity then
								TriggerClientEvent("Notify",nplayer,"amarelo","<b>Passaporte:</b> "..vRP.format(parseInt(identity.id)).."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone,10000)
							end
						end
						TriggerClientEvent("Notify",source,"amarelo","<b>Passaporte:</b> "..vRP.format(parseInt(identity.id)).."<br><b>Nome:</b> "..identity.name.." "..identity.name2.."<br><b>RG:</b> "..identity.registration.."<br><b>Telefone:</b> "..identity.phone,10000)
					end

					if itemName == "firecracker" then
						if firecracker[user_id] == nil then
							active[user_id] = 3
							firecracker[user_id] = 300
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,3000)
							vRPC._playAnim(source,false,{"anim@mp_fireworks","place_firework_3_box"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									vRPC._stopAnim(source,false)
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										TriggerClientEvent("vrp_inventory:Firecracker",source)
									end
								end
								Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "gsrkit" then
						local nplayer = vRPC.nearestPlayer(source,5)
						if nplayer then
							if vPLAYER.getHandcuff(nplayer) then
								active[user_id] = 10
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,10000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)

										if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
											local check = vPLAYER.gsrCheck(nplayer)
											if parseInt(check) > 0 then
												TriggerClientEvent("Notify",source,"verde","Resultado positivo.",5000)
											else
												TriggerClientEvent("Notify",source,"vermelho","Resultado negativo.",5000)
											end
										end
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "gdtkit" then
						local nplayer = vRPC.nearestPlayer(source,5)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								active[user_id] = 10
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("Progress",source,10000)

								repeat
									if active[user_id] == 0 then
										active[user_id] = nil
										TriggerClientEvent("inventory:Buttons",source,false)

										if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
											local weed = vRP.weedReturn(nuser_id)
											local chemical = vRP.chemicalReturn(nuser_id)
											local alcohol = vRP.alcoholReturn(nuser_id)

											local chemStr = ""
											local alcoholStr = ""
											local weedStr = ""

											if chemical == 0 then
												chemStr = "Nenhum"
											elseif chemical == 1 then
												chemStr = "Baixo"
											elseif chemical == 2 then
												chemStr = "Médio"
											elseif chemical >= 3 then
												chemStr = "Alto"
											end

											if alcohol == 0 then
												alcoholStr = "Nenhum"
											elseif alcohol == 1 then
												alcoholStr = "Baixo"
											elseif alcohol == 2 then
												alcoholStr = "Médio"
											elseif alcohol >= 3 then
												alcoholStr = "Alto"
											end

											if weed == 0 then
												weedStr = "Nenhum"
											elseif weed == 1 then
												weedStr = "Baixo"
											elseif weed == 2 then
												weedStr = "Médio"
											elseif weed >= 3 then
												weedStr = "Alto"
											end

											TriggerClientEvent("Notify",source,"QUIMICOS","<b>Químicos:</b> "..chemStr.."<br><b>Álcool:</b> "..alcoholStr.."<br><b>Drogas:</b> "..weedStr,5000)
										end
									end
									Wait(0)
								until active[user_id] == nil
							end
						end
					end

					if itemName == "vest" then
						active[user_id] = 10
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._playAnim(source,true,{"clothingtie","try_tie_negative_a"},true)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								vRPC._stopAnim(source,false)
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRPC.setArmour(source,100)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "GADGET_PARACHUTE" then
						active[user_id] = 10
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vCLIENT.parachuteColors(source)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "blocksignal" then
						if not Player(source)["state"]["Handcuff"] then
							local vehicle,vehNet,vehPlate = vRPC.vehList(source,4)
							if vehicle and vRPC.inVehicle(source) then
								if exports["vrp_garages"]:vehSignal(vehPlate) == nil then
									vRPC.stopActived(source)
									vGARAGE.startAnimHotwired(source)
									active[user_id] = 30
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("inventory:Buttons",source,true)
		
									if vTASKBAR.taskLockpick(source) then
										if vRP.tryGetInventoryItem(user_id,itemName,1,true,Slot) then
											TriggerClientEvent("Notify",source,"amarelo","<b>Bloqueador de Sinal</b> instalado.",5000)
											TriggerEvent("signalRemove",vehPlate)
										end
									end
		
									TriggerClientEvent("inventory:Buttons",source,false)
									vGARAGE.stopAnimHotwired(source)
									active[user_id] = nil
								else
									TriggerClientEvent("Notify",source,"amarelo","<b>Bloqueador de Sinal</b> já instalado.",5000)
								end
							end
						end
					end

					if itemName == "tires" then
						if not vRPC.inVehicle(source) then
							local tyreStatus,Tyre,vehNet,vehPlate = vCLIENT.tyreStatus(source)
							if tyreStatus then
								local Vehicle = NetworkGetEntityFromNetworkId(vehNet)
								if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
									if vCLIENT.tyreHealth(source,vehNet,Tyre) ~= 1000.0 then
										vRPC.stopActived(source)
										Active[user_id] = os.time() + 100
										TriggerClientEvent("inventory:Close",source)
										TriggerClientEvent("inventory:Buttons",source,true)
										vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
		
										if vTASKBAR.taskTyre(source) then
											if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
												TriggerClientEvent("inventory:repairTyre",-1,vehNet,Tyre,vehPlate)
												if vRP.hasPermission(user_id,"Mechanic") then
													vRP.generateItem(user_id,"tires",1,false)
												end
											end
										end
		
										TriggerClientEvent("inventory:Buttons",source,false)
										vRPC.stopAnim(source,false)
										Active[user_id] = nil
									end
								end
							end
						end
					return end

					if itemName == "toolbox" then
						if not vRPC.inVehicle(source) then
							local vehicle,vehNet,vehPlate = vRPC.vehList(source,4)
							if vehicle then
								vRPC.stopActived(source)
								Active[user_id] = os.time() + 100
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								vRPC.playAnim(source,false,{"mini@repair","fixing_a_player"},true)
		
								local Players = vRPC.Players(source)
								for _,v in ipairs(Players) do
									async(function()
										TriggerClientEvent("player:syncHoodOptions",v,vehNet,"open")
									end)
								end
		
								if vTASKBAR.taskMechanic(source) then
									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										if vRP.hasPermission(user_id,{"Mechanic","Mechanic02"})  then
											TriggerClientEvent("inventory:repairVehicle",-1,vehNet,vehPlate)
											vRP.generateItem(user_id,"toolbox",1,false)
										else
											TriggerClientEvent("inventory:repairBody",-1,vehNet,vehPlate)
										end
		
										vRP.upgradeStress(user_id,2)
									end
								end
		
								local Players = vRPC.Players(source)
								for _,v in ipairs(Players) do
									async(function()
										TriggerClientEvent("player:syncHoodOptions",v,vehNet,"close")
									end)
								end
		
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC.stopAnim(source,false)
								Active[user_id] = nil
							end
						end
					return end

					if itemName == "scan" then
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("scanner:updateScanner",source,true)
						vRPC.createObjects(source,"mini@golfai","wood_idle_a","w_am_digiscanner",49,18905,0.15,0.1,0.0,-270.0,-180.0,-170.0)
					return end

					if itemName == "knifehunter" then
						local status = vCLIENT.removeMeat(source)
						if status then
							active[user_id] = 10
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("Progress",source,10000)
							vRPC._playAnim(source,false,{"amb@medic@standing@kneel@idle_a","idle_a"},true)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									TriggerClientEvent("inventory:Buttons",source,false)
									vADMIN.deleteNpcs(source)
									vRP.giveInventoryItem(user_id,"meat",math.random(1,3),true)
									vRPC._stopAnim(source,false)
								end
								Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "lockpick" then
						local user_id = vRP.getUserId(source)
						local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock,vehHealth,vehModel,vehClass = vRPC.vehList(source,3)
						local identity = vRP.getUserIdentity(user_id)
						local x,y,z = vRPC.getPositions(source)
						if vehicle and vehClass ~= 15 and vehClass ~= 16 then
							if vRPC.inVehicle(source) then
								active[user_id] = 100
								vRPC.stopActived(source)
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								vGARAGE.startAnimHotwired(source)
					
								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									vRP.upgradeStress(user_id,4)
									TriggerEvent("webhooks","rouboveiculos","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n [ROUBOU]: "..vehName.."\n [COORDS]: "..x..","..y..","..z.." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Roubo de veiculo")
									
									if math.random(100) >= 20 then
										TriggerEvent("setPlateEveryone",vehPlate)
										TriggerEvent("setPlatePlayers",vehPlate,user_id)
									end
					
									if math.random(100) >= 40 then
										local x,y,z = vRPC.getPositions(source)
										local copAmount = vRP.numPermission("Police")
										for k,v in pairs(copAmount) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Roubo de Veículo", x = x, y = y, z = z, vehicle = vRP.vehicleName(vehName).." - "..vehPlate, rgba = {15,110,110} })
											end)
										end
									end
								end
					
								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end
					
								TriggerClientEvent("inventory:Buttons",source,false)
								vGARAGE.stopAnimHotwired(source,vehicle)
								active[user_id] = nil
							else
								active[user_id] = 100
								vRPC.stopActived(source)
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								vRPC._playAnim(source,false,{"missfbi_s4mop","clean_mop_back_player"},true)
					
								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									vRP.upgradeStress(user_id,4)
									TriggerEvent("webhooks","rouboveiculos","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.."\n[ROUBOU]: "..vehName.." [COORDS]: "..x..","..y..","..z.." \n"..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Roubo de veiculo")

									if math.random(100) >= 50 then
										TriggerEvent("setPlateEveryone",vehPlate)
										TriggerClientEvent("vrp_inventory:lockpickVehicle",-1,vehNet)
									end
					
									if math.random(100) >= 75 then
										local x,y,z = vRPC.getPositions(source)
										local copAmount = vRP.numPermission("Police")
										for k,v in pairs(copAmount) do
											async(function()
												TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Roubo de Veículo", x = x, y = y, z = z, vehicle = vRP.vehicleName(vehName).." - "..vehPlate, rgba = {15,110,110} })
											end)
										end
									end
								end
					
								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end
					
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._stopAnim(source,false)
								active[user_id] = nil
							end
						else
							local homeName = exports["vrp_homes"]:checkHomesTheft(source)
							local identity = vRP.getUserIdentity(user_id)
							local x,y,z = vRPC.getPositions(source)
							if homeName then

								local copAmount = vRP.numPermission("Police")
								if parseInt(#copAmount) <= 1 then
									TriggerClientEvent("Notify",source,"amarelo", "Sistema indisponível no momento, tente mais tarde.", 5000, 'info')
									return false
								end

								active[user_id] = 100
								vRPC.stopActived(source)
								TriggerClientEvent("inventory:Close",source)
								TriggerClientEvent("inventory:Buttons",source,true)
								vRPC.playAnim(source,false,{"missheistfbi3b_ig7","lift_fibagent_loop"},false)

								local taskResult = vTASKBAR.taskLockpick(source)
								if taskResult then
									vRP.upgradeStress(user_id,4)
									exports["vrp_homes"]:enterHomes(source,homeName,true,false,false)
									TriggerEvent("webhooks","rouboresidencia","```ini\n[ID]: "..user_id.." "..identity.name.." "..identity.name2.." \n[RESIDENCIA]: "..homeName.." \n[COORDS]: "..x..","..y..","..z.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Roubo a Residencia")
								else
									exports["vrp_homes"]:resetHomesTheft(homeName)
								end

								if parseInt(math.random(1000)) >= 950 then
									vRP.removeInventoryItem(user_id,itemName,1,true,slot)
								end

								vRPC._stopAnim(source,false)
								TriggerClientEvent("inventory:Buttons",source,false)
								active[user_id] = nil
							end
						end
					end
					
					if itemName == "sinkalmy" then
						active[user_id] = 10
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_ld_flow_bottle",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,5)
									vRP.chemicalTimer(user_id,1)
									vRP.downgradeStress(user_id,15)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "ritmoneury" then
						active[user_id] = 10
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._createObjects(source,"amb@world_human_drinking@beer@male@idle_a","idle_a","prop_ld_flow_bottle",49,28422)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,5)
									vRP.chemicalTimer(user_id,1)
									vRP.downgradeStress(user_id,35)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "fishingrod" then
						if vCLIENT.fishingCoords(source) then
							active[user_id] = 30
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)

							if not vCLIENT.fishingAnim(source) then
								vRPC.stopActived(source)
								vRPC._createObjects(source,"amb@world_human_stand_fishing@idle_a","idle_c","prop_fishing_rod_01",49,60309)
							end

							if vTASKBAR.taskFishing(source) then
								local payment = parseInt(math.random(2,4))
								local rand = parseInt(math.random(6))
								local fishs = { "octopus","shrimp","carp","salmon","crab","tuna" }

								if vRP.computeInvWeight(user_id) + vRP.itemWeightList(fishs[rand]) * rand <= vRP.getBackpack(user_id) then
									if vRP.tryGetInventoryItem(user_id,"bait",payment,true) then
										vRP.giveInventoryItem(user_id,fishs[rand],payment,true)
									else
										TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>"..vRP.format(rand).."x "..vRP.itemNameList("bait").."</b>.",5000)
									end
								else
									TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
								end
							end

							TriggerClientEvent("inventory:Buttons",source,false)
							active[user_id] = nil
						end
					end

					if itemName == "emptybottle" then
						local status,style = vCLIENT.checkFountain(source)
						if status then
							if style == "milk" then
								active[user_id] = 30
								vRPC.stopActived(source)
								TriggerClientEvent("inventory:Buttons",source,true)
								TriggerClientEvent("inventory:Close",source)
								vRPC._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

								if vTASKBAR.taskFishing(source) then
									if vRP.computeInvWeight(user_id) + vRP.itemWeightList(itemName) * 1 <= vRP.getBackpack(user_id) then
										if vRP.tryGetInventoryItem(user_id,itemName,1,false) then
											vRP.giveInventoryItem(user_id,"FoodmilkThirst",1,true)
										else
											TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>"..vRP.format(1).."x "..vRP.itemNameList(itemName).."</b>.",5000)
										end
									else
										TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
									end
								end
	
								vRPC._stopAnim(source,false)
								TriggerClientEvent("inventory:Buttons",source,false)
								active[user_id] = nil
							end
						end
					end

					if itemName == "cartelaovo" then
						local status = vCLIENT.checkHen(source)
						if status then
							active[user_id] = 30
							vRPC.stopActived(source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("inventory:Close",source)
							vRPC._playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

							if vTASKBAR.taskFishing(source) then
								if vRP.computeInvWeight(user_id) + vRP.itemWeightList(itemName) * 1 <= vRP.getBackpack(user_id) then
									if vRP.tryGetInventoryItem(user_id,itemName,1,false) then
										vRP.giveInventoryItem(user_id,"ovo",1,true)
									else
										TriggerClientEvent("Notify",source,"amarelo","Você precisa de <b>"..vRP.format(1).."x "..vRP.itemNameList(itemName).."</b>.",5000)
									end
								else
									TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
								end
							end

							vRPC._stopAnim(source,false)
							TriggerClientEvent("inventory:Buttons",source,false)
							active[user_id] = nil
						end

					end

					if itemName == "bluecard" then
                        local policia = vRP.numPermission("Police")
                        local policiaction = vRP.numPermission("actionPolice")
                        if vRP.tryGetInventoryItem(user_id,"bluecard",1) then
                            TriggerClientEvent("inventory:Close",source)
                            Wait(2000)
                            TriggerClientEvent('smartphone:createSMS',source,'3301','', 'https://i.imgur.com/G9EUYb8.gif')
                            Wait(6000)
                            TriggerClientEvent('smartphone:createSMS',source,'3301','Policiais em serviço: '..#policia..'. em ação: '..#policiaction..'')
                            Wait(3000)
                            TriggerClientEvent('smartphone:createSMS',source,'3301','3301, EVERYWHERE')
                        end
                    end
                    
					if itemName == "notepad" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("vrp_notepad:createNotepad",source)
						end
					end

					if itemName == "vehiclesound" then
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)

						if vRPC.inVehicle(source) then
							local vehicle,vehNet,vehPlate,vehName,vehLock,vehBlock,vehHealth,vehModel,vehClass = vRPC.vehList(source,3)
							if vehicle then
								local installed = vRP.getSData("sound:" .. vehName .. ":" .. vehPlate) == "installed"
								if not installed then
									TriggerClientEvent("Notify",source,"importante","Instalando sistema de som...")
									TriggerClientEvent("Progress",source,15000,"Instalando...")
									SetTimeout(15000,function()
										if vRPC.inVehicle(source) then
											if vRP.tryGetInventoryItem(user_id, "vehiclesound", 1) then
												vRP.setSData("sound:" .. vehName .. ":" .. vehPlate, "installed")
												TriggerClientEvent("Notify",source,"sucesso","Equipamento de som instalado!")
											end
										else
											TriggerClientEvent("Notify",source,"aviso","Instalação cancelada. Você saiu do veículo!")
										end
									end)
								else
									TriggerClientEvent("Notify",source,"negado","Este veículo já possui som instalado!")
								end
							end
						else
							TriggerClientEvent("Notify",source,"negado","Você precisa estar em um veículo para utilizar isso!")
						end
					end

					if itemName == "backpack" then
						local exp = vRP.getBackpack(user_id)
						if exp >= 50 and exp < 100 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.setBackpack(user_id,100)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","No momento você não pode usar essa mochila.",5000)
						end
					end

					if itemName == "plate" then
						if vCLIENT.FreezeVehicle(source) then
							active[user_id] = 10
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,10000)

							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									TriggerClientEvent("inventory:Buttons",source,false)

									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										local plate = vRP.genPlate()
										vCLIENT.plateApply(source,plate)
										TriggerEvent("setPlateEveryone",plate)
										TriggerEvent("setPlatePlayers",plate,user_id)
									end
								end
								Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "fueltech" then
						if vRPC.inVehicle(source) then
							if vCLIENT.FreezeVehicle(source) then
								local vehPlate = vRPC.vehiclePlate(source)
								local plateUsers = vRP.getVehiclePlate(vehPlate)
								if not plateUsers then
									active[user_id] = 30
									TriggerClientEvent("inventory:Close",source)
									TriggerClientEvent("inventory:Buttons",source,true)
									TriggerClientEvent("Progress",source,30000)
									vRPC._playAnim(source,true,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

									repeat
										if active[user_id] == 0 then
											active[user_id] = nil
											vRPC._stopAnim(source,false)
											TriggerClientEvent("inventory:Buttons",source,false)

											if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
												TriggerClientEvent("vrp_admin:vehicleTuning",source)
												vCLIENT.unfreezeVehicle(source)
											end
										end
										Wait(0)
									until active[user_id] == nil
								end
							end
						end
					end

					if itemName == "radio" then
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("vrp_radio:openSystem",source)
					end

					if itemName == "divingsuit" then
						TriggerClientEvent("hud:setDiving",source)
					end

					if itemName == "handcuff" then
						if not vRPC.inVehicle(source) then
							local nplayer = vRPC.nearestPlayer(source,1)
							if nplayer then
								if vPLAYER.getHandcuff(nplayer) then
									vPLAYER.toggleHandcuff(nplayer)
									vRPC._stopAnim(nplayer,false)
									TriggerClientEvent("sounds:Private",source,"uncuff",0.5)
									TriggerClientEvent("sounds:Private",nplayer,"uncuff",0.5)
								else
									active[user_id] = 30
									local taskResult = vTASKBAR.taskTree(nplayer)
									if not taskResult then
										vPLAYER.toggleHandcuff(nplayer)
										TriggerClientEvent("inventory:Close",nplayer)
										TriggerClientEvent("sounds:Private",source,"cuff",0.5)
										TriggerClientEvent("sounds:Private",nplayer,"cuff",0.5)
										vRPC._playAnim(source,false,{"mp_arrest_paired","cop_p2_back_left"},false)
										vRPC._playAnim(nplayer,true,{"mp_arresting","idle"},true)
									end
									active[user_id] = nil
								end
							end
						end
					end

					if itemName == "hood" then
						local nplayer = vRPC.nearestPlayer(source,2)
						if nplayer and vPLAYER.getHandcuff(nplayer) then
							TriggerClientEvent("hud:toggleHood",nplayer)
						end
					end

					if itemName == "rope" then
						local nplayer = vRPC.nearestPlayer(source,2)
						if nplayer and (vRPC.getHealth(nplayer) <= 101 or vPLAYER.getHandcuff(nplayer)) then
							TriggerClientEvent("vrp_rope:toggleRope",source,nplayer)
						end
					end

					if itemName == "c4" then
						TriggerClientEvent("doors:placeBomb",source)
					end
					
					if itemName == "pager" then
						local nplayer = vRPC.nearestPlayer(source,2)
						if nplayer then
							local nuser_id = vRP.getUserId(nplayer)
							if nuser_id then
								if vRP.hasPermission(nuser_id,"Police") then
									TriggerClientEvent("vrp_radio:outServers",nplayer)
									TriggerEvent("vrp_blipsystem:serviceExit",nplayer)
									vRP.updatePermission(nuser_id,"Police","waitPolice")
									TriggerClientEvent("Notify",source,"amarelo","Todas as comunicações da polícia foram retiradas.",5000)
								end
							end
						end
					end

					TriggerEvent("webhooks","use","```ini\n[ID]: "..user_id.." \n[ITEM] "..itemName.." [QUANTIDADE]: "..rAmount.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
				end

				if vRP.itemTypeList(itemName) == "Alimento" then
					
					if string.find(itemName,"Food") then
						local checkFood = vRP.itemBodyList(itemName)
						if checkFood then
							active[user_id] = 10
							vRPC.stopActived(source)
							TriggerClientEvent("inventory:Close",source)
							TriggerClientEvent("inventory:Buttons",source,true)
							TriggerClientEvent("Progress",source,10000)
							
							local foodAnim = json.decode(vRP.itemAnim(tostring(itemName))) or {}
							if foodAnim["type"] == "defaultHunger" then
								vRPC._playAnim(source,true,{"mp_player_inteat@burger","mp_player_int_eat_burger"},true)
							elseif foodAnim["type"] == "defaultThrist" then
								vRPC._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309,0.0,0.0,0.02,0.0,0.0,130.0)
							elseif foodAnim["pos1"] then
								vRPC._createObjects(source,foodAnim["dict"],foodAnim["anim"],foodAnim["prop"],49,foodAnim["hand"],foodAnim["pos1"],foodAnim["pos2"],foodAnim["pos3"],foodAnim["pos4"],foodAnim["pos5"],foodAnim["pos6"])
							else
								vRPC._createObjects(source,foodAnim["dict"],foodAnim["anim"],foodAnim["prop"],49,foodAnim["hand"])
							end
	
							repeat
								if active[user_id] == 0 then
									active[user_id] = nil
									TriggerClientEvent("inventory:Buttons",source,false)
									vRPC._removeObjects(source,"one")
	
									if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
										if checkFood["energetic"] then
											TriggerClientEvent("setEnergetic",source,30,checkFood["energetic"])
										end
	
										if checkFood["alcohol"] then
											vRP.alcoholTimer(user_id,checkFood["alcohol"])
											TriggerClientEvent("inventory:drunkPlayer",source,checkFood["alcohol"])
										end
	
										if checkFood["stress"] then
											vRP.downgradeStress(user_id,checkFood["stress"])
										end
	
										if checkFood["hunger"] then
											vRP.upgradeHunger(user_id,checkFood["hunger"])
										end
	
										if checkFood["thirst"] then
											vRP.upgradeThirst(user_id,checkFood["thirst"])
										end
	
									end
								end
								Wait(0)
							until active[user_id] == nil
						end
					end

					if itemName == "water" then
						active[user_id] = 10
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309,0.0,0.0,0.02,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeThirst(user_id,10)
									vRP.giveInventoryItem(user_id,"emptybottle",1)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "dirtywater" then
						active[user_id] = 10
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._createObjects(source,"mp_player_intdrink","loop_bottle","prop_ld_flow_bottle",49,60309)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,4)
									vRP.upgradeThirst(user_id,25)
									vRPC.downHealth(source,10)
									vRP.giveInventoryItem(user_id,"emptybottle",1)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

					if itemName == "energetic" then
						active[user_id] = 10
						vRPC.stopActived(source)
						TriggerClientEvent("inventory:Close",source)
						TriggerClientEvent("inventory:Buttons",source,true)
						TriggerClientEvent("Progress",source,10000)
						vRPC._createObjects(source,"mp_player_intdrink","loop_bottle","prop_energy_drink",49,60309,0.0,0.0,0.0,0.0,0.0,130.0)

						repeat
							if active[user_id] == 0 then
								active[user_id] = nil
								TriggerClientEvent("inventory:Buttons",source,false)
								vRPC._removeObjects(source,"one")

								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.upgradeStress(user_id,4)
									TriggerClientEvent("setEnergetic",source,90,1.10)
								end
							end
							Wait(0)
						until active[user_id] == nil
					end

				end

				if vRP.itemTypeList(itemName) == "Premium" then

					if itemName == "apparencechange" then
						local request = vRP.request(source,"Aparência","Deseja desconectar para efetuar a mudança de aparência?",120)
						if request then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								exports["oxmysql"]:executeSync("UPDATE vrp_users SET appearence = ? WHERE id = ?", { 1, user_id })
								Wait(100)
								vRP.kick(user_id,"Você foi desconectado.")
							end
						end
					end

					if itemName == "renewcar" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							TriggerClientEvent("inventory:Close",source)

							local vehModel = vRP.prompt(source,"Vehicle Model:","")
							if vehModel == "" then
								return
							end

							local ownerVehicles = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehModel) })
							if ownerVehicles[1] then
								if vRP.vehicleClass(tostring(vehModel)) == "rental" and ownerVehicles[1]["rental"] == 1 then
									vRP.execute("vRP/set_rental_time",{ user_id = parseInt(user_id), vehicle = tostring(vehModel), rental_time = parseInt(os.time()+30*24*60*60) })
									TriggerClientEvent("Notify",source,"verde","O veiculo <b>"..vRP.vehicleName(vehModel).."</b> foi renovado com sucesso.",5000)
								end
							end
						end
					end

					if string.find(itemName,"rental") then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							local user_id = vRP.getUserId(source)
							local identity = vRP.getUserIdentity(user_id)
							local len = string.len(itemName)
							local time = string.sub(itemName,len-1,len)
							local vehicle = string.sub(itemName,7,len-2)
							local accountInfo = vRP.getInfos(identity.steam)
							local discord = ""
							if accountInfo[1].discord then
								discord = accountInfo[1].discord
							end

							vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = vehicle, plate = vRP.generatePlateNumber(), work = tostring(false) })
							vRP.execute("vRP/set_rental_time",{ user_id = parseInt(user_id), vehicle = vehicle, rental_time = parseInt(os.time()+parseInt(time)*24*60*60) })
							TriggerClientEvent("Notify",source,"amarelo","O veiculo <b>"..vRP.vehicleName(vehicle).."</b> foi adicionado a sua garagem.",5000)

							TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818481939731841086","Rental")
							
						end
					end

					if string.find(itemName,"premium") then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							local len = string.len(itemName)
							local priority = string.sub(itemName,len-1,len)
							local class = string.sub(itemName,8,len-2)
							local identity = vRP.getUserIdentity(user_id)
							local accountInfo = vRP.getInfos(identity["steam"])
							local discord = ""
							if accountInfo[1]["discord"] then
								discord = accountInfo[1]["discord"]
							end

							if identity then
								
								if class ~= "Booster" or class ~= "Silver" then
									local checkExist = vRP.query("vRP/instagram_verified", { user_id = identity["id"] })
									if checkExist[1] then
										vRP.execute("vRP/update_verified",{ user_id = identity["id"], verified = 1 })
									end

									if class == "Diamond" then
										vRP.execute("vRP/set_premium",{ steam = identity["steam"], premium = 1, predays = 2147483647, priority = parseInt(priority) })
									else
										vRP.execute("vRP/set_premium",{ steam = identity["steam"], premium = parseInt(os.time()), predays = 30, priority = parseInt(priority) })
									end
									
									vRP.execute("vRP/set_class",{ steam = identity["steam"], class = class })
									TriggerClientEvent("Notify",source,"amarelo","O VIP <b>"..class.."</b> foi ativado com sucesso.",5000)
								end
							end
							
							if class == "Diamond" then
								local gainGaragem = 10
								while gainGaragem ~=0 do
									vRP.execute("vRP/update_garages",{  id = parseInt(user_id) })
									gainGaragem = gainGaragem - 1
								end
								vRP.giveInventoryItem(user_id,"carpass",3,true)
								vRP.giveInventoryItem(user_id,"vehiclesound",3,true)
								vRP.giveInventoryItem(user_id,"keyplate",2,true)
								vRP.giveInventoryItem(user_id,"housekey",1,true)
								vRP.giveInventoryItem(user_id,"numberchange",1,true)
								vRP.giveInventoryItem(user_id,"rgchange",1,true)
								vRP.giveInventoryItem(user_id,"discount",2,true)
								vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = "benson", plate = vRP.generatePlateNumber(), work = tostring(false) })
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818535224395956245","VIP Diamond")
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818481939731841086","VIP Diamond")
							end

							if class == "Platinum" then
								local gainGaragem = 7
								while gainGaragem ~=0 do
									vRP.execute("vRP/update_garages",{  id = parseInt(user_id) })
									gainGaragem = gainGaragem - 1
								end
								vRP.giveInventoryItem(user_id,"carpass",2,true)
								vRP.giveInventoryItem(user_id,"keyplate",2,true)
								vRP.giveInventoryItem(user_id,"vehiclesound",2,true)
								vRP.giveInventoryItem(user_id,"numberchange",1,true)
								vRP.giveInventoryItem(user_id,"discount",1,true)
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818535814606356560","VIP Platinum")
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818481939731841086","VIP Platinum")
							end

							if class == "Gold" then
								local gainGaragem = 5
								while gainGaragem ~=0 do
									vRP.execute("vRP/update_garages",{  id = parseInt(user_id) })
									gainGaragem = gainGaragem - 1
								end
								vRP.giveInventoryItem(user_id,"carpass",1,true)
								vRP.giveInventoryItem(user_id,"vehiclesound",2,true)
								vRP.giveInventoryItem(user_id,"numberchange",1,true)
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818535830452699163","VIP Gold")
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818481939731841086","VIP Gold")
							end

							if class == "Kids" then
								local gainGaragem = 2
								while gainGaragem ~=0 do
									vRP.execute("vRP/update_garages",{  id = parseInt(user_id) })
									gainGaragem = gainGaragem - 1
								end
								vRP.giveInventoryItem(user_id,"carpass",1,true)
								vRP.giveInventoryItem(user_id,"numberchange",1,true)
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818535830452699163","VIP Kids")
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818481939731841086","VIP Kids")
							end

							if class == "Silver" then
								local gainGaragem = 2
								while gainGaragem ~=0 do
									vRP.execute("vRP/update_garages",{  id = parseInt(user_id) })
									gainGaragem = gainGaragem - 1
								end
								vRP.giveInventoryItem(user_id,"numberchange",1,true)
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818535832221777930","VIP Silver")
								TriggerEvent("webhooks-noembed","vip",discord.." #"..user_id.." "..identity.name.." "..identity.name2.. " 818481939731841086","VIP Silver")
							end

							if class == "Booster" then
								vRP.execute("vRP/add_vehicle",{ user_id = parseInt(user_id), vehicle = "panto", plate = vRP.generatePlateNumber(), work = tostring(false) })
							end
							
						end
					end

					if itemName == "rgchange" then
						TriggerClientEvent("inventory:Close",source)

						local rgChange = vRP.prompt(source,"RG Change:","")
						if rgChange == "" or string.upper(rgChange) == "HVRP" then
							return
						end

						local rgUserId = vRP.getUserIdRegistration(rgChange)
						if rgUserId then
							TriggerClientEvent("Notify",source,"vermelho","O RG escolhido já está sendo usado por outra pessoa.",5000)
							return
						end

						local rgCheck = sanitizeString(rgChange,"abcdefghijklmnopqrstuvwxyz0123456789",true)
						if rgCheck and string.len(rgCheck) == 8 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.execute("vRP/update_document",{ id = parseInt(user_id), registration = string.upper(tostring(rgChange)) })
								TriggerClientEvent("Notify",source,"verde","Seu novo documento: <b>"..string.upper(tostring(rgChange)).."</b> foi registrado com sucesso.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","O nome da definição para documentos deve conter no máximo 8 caracteres e podem ser usados números e letras minúsculas.",5000)
						end
					end

					if itemName == "numberchange" then
						TriggerClientEvent("inventory:Close",source)

						local finalnumber = ""
						local firstNumber = vRP.prompt(source,"Primeiros 3 Números:","")
						if firstNumber == "" or string.upper(firstNumber) == "HVRP" or string.len(firstNumber) ~= 3 then
							return
						end

						local secondNumber = vRP.prompt(source,"Últimos 3 Números:","")
						if secondNumber == "" or string.upper(secondNumber) == "HVRP" or string.len(secondNumber) ~= 3 then
							return
						end

						finalNumber = ""..firstNumber.."-"..secondNumber..""

						local numberUserId = vRP.getUserByPhone(finalNumber)
						if numberUserId then
							TriggerClientEvent("Notify",source,"vermelho","O Número escolhido já está sendo utilizado por outro usuário.",5000)
							return
						end

						local numberCheck = sanitizeString(finalNumber,"0123456789",true)
						if numberCheck and string.len(numberCheck) == 6 then
							if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
								vRP.execute("vRP/update_number",{ id = parseInt(user_id), phone = finalNumber })
								TriggerClientEvent("Notify",source,"verde","Seu novo número: <b>"..finalNumber.."</b> foi registrado com sucesso.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"amarelo","Utilize apenas números.",5000)
						end
					end
					
					if itemName == "keyplate" then
						TriggerClientEvent("inventory:Close",source)

						local vehModel = vRP.prompt(source,"Vehicle Model:","")
						if vehModel == "" then
							return
						end

						local vehicle = vRP.query("vRP/get_vehicles",{ user_id = parseInt(user_id), vehicle = tostring(vehModel) })
						if vehicle[1] then
							local vehPlate = vRP.prompt(source,"Vehicle Plate:","")
							if vehPlate == "" or string.upper(vehPlate) == "HVRP" then
								return
							end

							local plateUserId = vRP.getVehiclePlate(vehPlate)
							if plateUserId then
									TriggerClientEvent("Notify",source,"vermelho","A placa escolhida já está sendo usada por outro veículo.",5000)
								return
							end

							local plateCheck = sanitizeString(vehPlate,"abcdefghijklmnopqrstuvwxyz0123456789",true)
							if plateCheck and string.len(plateCheck) == 8 then
								if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
									vRP.execute("vRP/update_plate_vehicle",{ user_id = parseInt(user_id), vehicle = tostring(vehModel), plate = string.upper(tostring(vehPlate)) })
									TriggerClientEvent("Notify",source,"verde","Placa atualizada para <b>"..string.upper(tostring(vehPlate)).."</b> com sucesso.",5000)
								end
							else
								TriggerClientEvent("Notify",source,"amarelo","O nome da definição para placas deve conter no máximo 8 caracteres e podem ser usados números e letras minúsculas.",5000)
							end
						else
							TriggerClientEvent("Notify",source,"vermelho","Modelo de veículo não encontrado em sua garagem.",5000)
						end
					end

					if itemName == "namechange" then
						TriggerClientEvent("inventory:Close",source)

						local name = vRP.prompt(source,"Primeiro Nome:","")
						if name == "" then
							return
						end

						local name2 = vRP.prompt(source,"Sobrenome:","")
						if name2 == "" then
							return
						end

						finalName = ""..name.." "..name2..""

						local nameCheck = sanitizeString(finalName," aáâàãbcdeéêfghiíjklmnoóôõpqrstuúvwxyzAÁÂÀÃBCDEÉÊFGHIÍJKLMNOÓÔÕPQRSTUÚVWXYZ",true)
						if nameCheck then
							vRP.execute("vRP/update_name",{ id = parseInt(user_id), name = name, name2 = name2 })
							TriggerClientEvent("Notify",source,"verde","O seu nome foi alterado para <b>"..finalName.."</b> com sucesso.",5000)
						end
					end

					if itemName == "keygarage" then
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vRP.execute("vRP/update_garages",{ id = parseInt(user_id) })
							TriggerClientEvent("Notify",source,"verde","Garagem adicionada com sucesso.",5000)
						end
					end

					if itemName == "newchars" then
						local identity = vRP.getUserIdentity(user_id)
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							exports["oxmysql"]:executeSync("UPDATE vrp_infos SET chars = chars + 1 where steam = ?", { identity["steam"] })
							TriggerClientEvent("Notify",source,"verde","Novo personagem adicionado.",5000)
						end
					end

				end

				if vRP.itemTypeList(itemName) == "Armamento" then
					if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
						TriggerEvent("webhooks","use","```ini\n[ID]: "..user_id.." \n[ITEM] "..itemName.." [QUANTIDADE]: 1 "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
						vRPC.putWeaponHands(source,itemName,0)
						TriggerClientEvent("itensNotify",source,{ "equipou",vRP.itemIndexList(itemName),1,vRP.itemNameList(itemName) })
					end
				end

				if vRP.itemTypeList(itemName) == "Munição" then
					local checkWeapon = vRPC.rechargeCheck(source,itemName)

					if checkWeapon then
						if rAmount >= 250 then
							if vRP.tryGetInventoryItem(user_id,itemName,250,true,slot) then
								vRPC.rechargeWeapon(source,itemName,250)
								TriggerEvent("webhooks","use","```ini\n[ID]: "..user_id.." \n[ITEM] "..itemName.." [QUANTIDADE]: 250 "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								TriggerClientEvent("itensNotify",source,{ "equipou",vRP.itemIndexList(itemName),1,vRP.itemNameList(itemName) })
							end
						end 

						if rAmount <= 250 then
							if vRP.tryGetInventoryItem(user_id,itemName,parseInt(rAmount),true,slot) then
								vRPC.rechargeWeapon(source,itemName,parseInt(rAmount))
								TriggerEvent("webhooks","use","```ini\n[ID]: "..user_id.." \n[ITEM] "..itemName.." [QUANTIDADE]: "..parseInt(rAmount).." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
								TriggerClientEvent("itensNotify",source,{ "equipou",vRP.itemIndexList(itemName),1,vRP.itemNameList(itemName) })
							end
						end
						
					end

				end

				if vRP.itemTypeList(itemName) == "Throwing" then
					local checkWeapon = vCLIENT.returnWeapon(source)
					if checkWeapon then
						local weaponStatus,weaponAmmo,hashItem = vCLIENT.storeWeaponHands(source)
						if weaponStatus then
							TriggerClientEvent("itensNotify",source,{ "guardou",vRP.itemIndexList(hashItem),1,vRP.itemNameList(hashItem) })
						end
					else
						if vRP.getInventoryItemAmount(user_id,itemName) <= 0 then
							return
						end
		
						if vRP.tryGetInventoryItem(user_id,itemName,1,true,slot) then
							vRPC.putWeaponHands(source,itemName,1)
							TriggerClientEvent("itensNotify",source,{ "equipou",vRP.itemIndexList(itemName),1,vRP.itemNameList(itemName) })
						end
					end
				return end
			end


			TriggerClientEvent("vrp_inventory:Update",source,"updateMochila")
			
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERLEAVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerLeave",function(user_id,source)
	if not vRP.userPremium(user_id) then
		local identity = vRP.getUserIdentity(user_id)
		if identity then
			vRP.execute("vRP/update_priority",{ steam = identity.steam })
			if vRP.hasClass(user_id,"Gold") then
				vRP.execute("vRP/set_class",{ steam = identity.steam, class = nil})
			end
			if vRP.hasClass(user_id,"Silver") then
				vRP.execute("vRP/set_class",{ steam = identity.steam, class = nil})
			end
			if vRP.hasClass(user_id,"Bronze") then
				vRP.execute("vRP/set_class",{ steam = identity.steam, class = nil})
			end
			local checkExist = vRP.query("vRP/instagram_verified", { user_id = parseInt(user_id) })
			if checkExist[1] then
				vRP.execute("vRP/update_verified",{ user_id = parseInt(user_id), verified = 0 })
			end
		end
	end

	if active[user_id] then
		active[user_id] = nil
	end

	if verifyObjects[user_id] then
		verifyObjects[user_id] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERSPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("vRP:playerSpawn",function(user_id,source)
	TriggerClientEvent("vrp_inventory:dropUpdates",source,dropList)
		-- Checa o tempo do Veículo
	local rows2 = vRP.query("vRP/get_rental_time",{ user_id = user_id })
	if #rows2 then 
		for k,v in pairs(rows2) do
			if v["rental_time"] ~= 0 and v["rental"] == 1 then
				if parseInt(os.time()) >= parseInt(v["rental_time"]+3*24*60*60) then
					-- Remover Carro
					TriggerClientEvent("Notify",source,"amarelo","<b>"..vRP.vehicleName(v["vehicle"]).."</b> removido por falta de renovação.",20000)
					vRP.execute("vRP/rem_vehicle",{ user_id = parseInt(user_id), vehicle = v["vehicle"] })
					return
				end
				if parseInt(os.time()) >= v["rental_time"] then
					TriggerClientEvent("Notify",source,"amarelo","<b>"..vRP.vehicleName(v["vehicle"]).."</b> vencido, efetue a renovação para não perde-lo.",30000)
				end

			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP_INVENTORY:CANCEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("vrp_inventory:Cancel")
AddEventHandler("vrp_inventory:Cancel",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			active[user_id] = nil
			TriggerClientEvent("Progress",source,1500)

			SetTimeout(1000,function()
				vRPC._removeObjects(source)
				TriggerClientEvent("inventory:Buttons",source,false)
				vGARAGE.updateHotwired(source,false)
			end)
		else
			vRPC._removeObjects(source)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkInventory()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if active[user_id] ~= nil and active[user_id] > 0 then
			return false
		end
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVETHROWABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function src.removeThrowable(nameItem)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.removeInventoryItem(user_id,nameItem,1,true)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:EMPTYBOTTLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:emptyBottle")
AddEventHandler("inventory:emptyBottle",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		
		if vRP.getInventoryItemAmount(user_id,"emptybottle") <= 0 then
			TriggerClientEvent("Notify",source,"amarelo","Necessário possuir <b>1x Garrafa Vazia</b>.",5000)
			return
		end
		
		if vRP.getInventoryItemMax(user_id,"water",1) then	
			vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
			
			vRPC.stopActived(source)
			active[user_id] = 3
			TriggerClientEvent("inventory:Close",source)
			TriggerClientEvent("inventory:Buttons",source,true)
			TriggerClientEvent("Progress",source,3000)
			
			repeat
				if active[user_id] == 0 then
					active[user_id] = nil
					vRPC.removeObjects(source)
					TriggerClientEvent("inventory:Buttons",source,false)
					
					vRP.removeInventoryItem(user_id,"emptybottle",1,false)
					vRP.giveInventoryItem(user_id,"water",1,true)
				end
				
				Wait(100)
			until active[user_id] == nil
		else
			TriggerClientEvent("Notify",source,"vermelho","Limite Atingido",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:DRINK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:Drink")
AddEventHandler("inventory:Drink",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRPC.createObjects(source,"mp_player_intdrink","loop_bottle","prop_plastic_cup_02",49,60309,0.0,0.0,0.1,0.0,0.0,130.0)
		
		vRPC.stopActived(source)
		active[user_id] = 15
		TriggerClientEvent("inventory:Close",source)
		TriggerClientEvent("inventory:Buttons",source,true)
		TriggerClientEvent("Progress",source,15000)
		
		repeat
			if active[user_id] == 0 then
				active[user_id] = nil
				vRPC.removeObjects(source)
				TriggerClientEvent("inventory:Buttons",source,false)
				vRP.upgradeThirst(user_id,20)
			end
			
			Wait(100)
		until active[user_id] == nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LIXEIRO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:verifyObjects")
AddEventHandler("inventory:verifyObjects",function(Entity,Service)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and active[user_id] == nil then
		if Service == "Lixeiro" then
			if not vRPC.lastVehicle(source,"trash") then
				TriggerClientEvent("Notify",source,"amarelo","Precisa utilizar o veículo do <b>Lixeiro</b>.",3000)
				return
			end
		end

		if Entity[1] ~= nil and Entity[2] ~= nil and Entity[4] ~= nil then
			local hash = Entity[1]
			local model = Entity[2]
			local coords = Entity[4]

			if verifyObjects[user_id] == nil then
				if Trashs[model] == nil then
					Trashs[model] = {}
				end

				if Trashs[model][hash] then
					TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
					return
				end

				for k,v in pairs(Trashs[model]) do
					if #(v["coords"] - coords) <= 0.75 and os.time() <= v["timer"] then
						TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
						return
					end
				end

				active[user_id] = 5
				TriggerClientEvent("Progress",source,5000)
				vRPC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)

				verifyObjects[user_id] = { model,hash }
				TriggerClientEvent("inventory:Close",source)
				TriggerClientEvent("inventory:Buttons",source,true)
				Trashs[model][hash] = { ["coords"] = coords, ["timer"] = os.time() + 3600 }

				repeat
					if active[user_id] == 0 then
						active[user_id] = nil
						vRPC.stopAnim(source,false)
						TriggerClientEvent("inventory:Buttons",source,false)

						local itemSelect = { "",1 }

						if Service == "Lixeiro" then
							local randItem = math.random(90)
							if parseInt(randItem) >= 61 and parseInt(randItem) <= 70 then
								itemSelect = { "aluminium",math.random(2) }
							elseif parseInt(randItem) >= 51 and parseInt(randItem) <= 60 then
								itemSelect = { "copper",math.random(2) }
							elseif parseInt(randItem) >= 41 and parseInt(randItem) <= 50 then
								itemSelect = { "rubber",math.random(2) }
							elseif parseInt(randItem) >= 21 and parseInt(randItem) <= 40 then
								itemSelect = { "plastic",math.random(2) }
							elseif parseInt(randItem) <= 20 then
								itemSelect = { "glass",math.random(2) }
							end
						end

						if itemSelect[1] == "" then
							TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
						else
							if (vRP.computeInvWeight(user_id) + (vRP.itemWeightList(itemSelect[1]) * itemSelect[2])) <= vRP.getBackpack(user_id) then
								vRP.generateItem(user_id,itemSelect[1],itemSelect[2],true)
								vRP.upgradeStress(user_id,1)
							else
								TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
								Trashs[model][hash] = nil
							end
						end

						verifyObjects[user_id] = nil
					end

					Wait(100)
				until active[user_id] == nil
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- STEALITENS
-----------------------------------------------------------------------------------------------------------------------------------------
local stealItens = {
	[1] = { ["item"] = "pendrive", ["min"] = 1, ["max"] = 1, ["rand"] = 150 },
	[2] = { ["item"] = "slipper", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	[3] = { ["item"] = "soap", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	[4] = { ["item"] = "pliers", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	[5] = { ["item"] = "deck", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	[6] = { ["item"] = "floppy", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	[7] = { ["item"] = "domino", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	[8] = { ["item"] = "brush", ["min"] = 1, ["max"] = 4, ["rand"] = 225 },
	[9] = { ["item"] = "rimel", ["min"] = 2, ["max"] = 4, ["rand"] = 225 },
	[10] = { ["item"] = "Fooddonut", ["min"] = 1, ["max"] = 2, ["rand"] = 225 },
	[11] = { ["item"] = "dices", ["min"] = 2, ["max"] = 4, ["rand"] = 225 },
	[12] = { ["item"] = "racketicket", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	[13] = { ["item"] = "lockpick", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	[14] = { ["item"] = "dildo", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	[15] = { ["item"] = "cellphone", ["min"] = 2, ["max"] = 3, ["rand"] = 225 },
	[16] = { ["item"] = "bracelet", ["min"] = 2, ["max"] = 4, ["rand"] = 200 },
	[17] = { ["item"] = "xbox", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	[18] = { ["item"] = "playstation", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	[19] = { ["item"] = "watch", ["min"] = 2, ["max"] = 3, ["rand"] = 200 },
	[20] = { ["item"] = "goldcoin", ["min"] = 4, ["max"] = 6, ["rand"] = 175 },
	[21] = { ["item"] = "silvercoin", ["min"] = 4, ["max"] = 8, ["rand"] = 175 },
	[22] = { ["item"] = "goldring", ["min"] = 1, ["max"] = 2, ["rand"] = 175 },
	[23] = { ["item"] = "silverring", ["min"] = 1, ["max"] = 2, ["rand"] = 175 },
	[24] = { ["item"] = "joint", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	[25] = { ["item"] = "analgesic", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	[26] = { ["item"] = "firecracker", ["min"] = 1, ["max"] = 2, ["rand"] = 200 },
	[27] = { ["item"] = "pager", ["min"] = 1, ["max"] = 1, ["rand"] = 150 },
	[28] = { ["item"] = "GADGET_PARACHUTE", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	[29] = { ["item"] = "WEAPON_SNSPISTOL", ["min"] = 1, ["max"] = 1, ["rand"] = 50 },
	[30] = { ["item"] = "WEAPON_WRENCH", ["min"] = 1, ["max"] = 1, ["rand"] = 125 },
	[31] = { ["item"] = "WEAPON_POOLCUE", ["min"] = 1, ["max"] = 1, ["rand"] = 125 },
	[32] = { ["item"] = "WEAPON_BAT", ["min"] = 1, ["max"] = 1, ["rand"] = 125 },
	[33] = { ["item"] = "notebook", ["min"] = 1, ["max"] = 1, ["rand"] = 75 },
	[34] = { ["item"] = "camera", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	[35] = { ["item"] = "binoculars", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	[36] = { ["item"] = "hennessy", ["min"] = 1, ["max"] = 3, ["rand"] = 225 },
	[37] = { ["item"] = "dewars", ["min"] = 1, ["max"] = 3, ["rand"] = 225 },
	[38] = { ["item"] = "teddy", ["min"] = 1, ["max"] = 1, ["rand"] = 225 },
	[39] = { ["item"] = "Foodchocolate", ["min"] = 1, ["max"] = 3, ["rand"] = 225 },
	[40] = { ["item"] = "lighter", ["min"] = 1, ["max"] = 1, ["rand"] = 225 },
	[41] = { ["item"] = "divingsuit", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	[42] = { ["item"] = "cellphone", ["min"] = 1, ["max"] = 1, ["rand"] = 150 },
	[43] = { ["item"] = "tyres", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	[44] = { ["item"] = "notepad", ["min"] = 1, ["max"] = 5, ["rand"] = 225 },
	[45] = { ["item"] = "plate", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	[46] = { ["item"] = "emptybottle", ["min"] = 2, ["max"] = 5, ["rand"] = 225 },
	[47] = { ["item"] = "bait", ["min"] = 1, ["max"] = 6, ["rand"] = 225 },
	[48] = { ["item"] = "switchblade", ["min"] = 1, ["max"] = 1, ["rand"] = 175 },
	[49] = { ["item"] = "bluecard", ["min"] = 1, ["max"] = 1, ["rand"] = 200 },
	[50] = { ["item"] = "blackcard", ["min"] = 1, ["max"] = 1, ["rand"] = 200 }
}
function src.stealTrunk(Entity)
	local source = source
	local vehNet = Entity[4]
	local vehPlate = Entity[1]
	local vehModels = Entity[2]
	local user_id = vRP.getUserId(source)
	if user_id and Active[user_id] == nil then
		local userPlate = vRP.getVehiclePlate(vehPlate)
		if not userPlate then
			if Trunks[vehPlate] == nil then
				Trunks[vehPlate] = os.time()
			end

			if os.time() >= Trunks[vehPlate] then
				vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)
				Active[user_id] = os.time() + 100

				if vTASKBAR.stealTrunk(source) then
					Active[user_id] = os.time() + 30
					TriggerClientEvent("Progress",source,30000)
					TriggerClientEvent("inventory:Buttons",source,true)

					local Players = vRPC.Players(source)
					for _,v in ipairs(Players) do
						async(function()
							TriggerClientEvent("player:syncDoorsOptions",v,vehNet,"open")
						end)
					end

					repeat
						if os.time() >= parseInt(Active[user_id]) then
							Active[user_id] = nil
							vRPC.stopAnim(source,false)
							TriggerClientEvent("inventory:Buttons",source,false)

							local Players = vRPC.Players(source)
							for _,v in ipairs(Players) do
								async(function()
									TriggerClientEvent("player:syncDoorsOptions",v,vehNet,"close")
								end)
							end

							if os.time() >= Trunks[vehPlate] then
								local randItens = math.random(#stealItens)
								if math.random(250) <= stealItens[randItens]["rand"] then
									local randAmounts = math.random(stealItens[randItens]["min"],stealItens[randItens]["max"])

									if (vRP.computeInvWeight(user_id) + (vRP.itemWeightList(stealItens[randItens]["item"]) * randAmounts)) <= vRP.getBackpack(user_id) then
										vRP.generateItem(user_id,stealItens[randItens]["item"],randAmounts,true)
										Trunks[vehPlate] = os.time() + 3600
										vRP.upgradeStress(user_id,2)
									else
										TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
									end
								else
									TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
									Trunks[vehPlate] = os.time() + 3600
									vRP.upgradeStress(user_id,1)
								end
							end
						end

						Wait(100)
					until Active[user_id] == nil
				else
					local Players = vRPC.Players(source)
					for _,v in ipairs(Players) do
						async(function()
							TriggerClientEvent("inventory:vehicleAlarm",v,vehNet,vehPlate)
						end)
					end

					vRPC.stopAnim(source,false)
					Active[user_id] = nil

					local x, y, z = vRPC.getPositions(source)
					local policeResult = vRP.numPermission("Police")
					for k,v in pairs(policeResult) do
						async(function()
							TriggerClientEvent("NotifyPush",v,{ code = 20, title = "Roubo de Veículo", x = x, y = y, z = z, rgba = {15,110,110} })
						end)
					end
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Nada encontrado.",5000)
			end
		else
			TriggerClientEvent("Notify",source,"amarelo","Veículo protegido pela seguradora.",1000)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CHECKSTOCKADE
-----------------------------------------------------------------------------------------------------------------------------------------
local Plates = {}
RegisterServerEvent("inventory:checkStockade")
AddEventHandler("inventory:checkStockade",function(Entity)
	local policeResult = vRP.numPermission("Police")
	if parseInt(#policeResult) <= 4 then
		TriggerClientEvent("Notify",source,"amarelo","Sistema indisponível no momento.",5000)
		return false
	else
		local source = source
		local vehPlate = Entity[1]
		local user_id = vRP.getUserId(source)
		if user_id and Active[user_id] == nil then
			if Plates[vehPlate] then
				TriggerClientEvent("Notify",source,"vermelho","Não foi encontrado o registro do veículo no sistema.",5000)
				return
			end

			if Stockade[vehPlate] == nil then
				Stockade[vehPlate] = 0
			end

			if Stockade[vehPlate] >= 15 then
				TriggerClientEvent("Notify",source,"amarelo","Vazio.",5000)
				return
			end

			if vRP.getVehiclePlate(vehPlate) then
				TriggerClientEvent("Notify",source,"amarelo","Veículo protegido pela seguradora.",5000)
				return
			end

			local stockadeItens = { "WEAPON_CROWBAR","lockpick" }
			for k,v in pairs(stockadeItens) do
				if vRP.getInventoryItemAmount(user_id,v) < 1 then
					TriggerClientEvent("Notify",source,"amarelo","<b>"..vRP.itemNameList(v).."</b> não encontrado.",5000)
					return
				end
			end

			Stockade[vehPlate] = Stockade[vehPlate] + 1

			if vTASKBAR.stealTrunk(source) then
				vRP.upgradeStress(user_id,10)
				Active[user_id] = os.time() + 15
				TriggerClientEvent("Progress",source,15000)
				TriggerClientEvent("player:applyGsr",source)
				TriggerClientEvent("inventory:Buttons",source,true)
				vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

				repeat
					if os.time() >= parseInt(Active[user_id]) then
						Active[user_id] = nil
						vRPC.stopAnim(source,false)
						TriggerClientEvent("inventory:Buttons",source,false)
						vRP.generateItem(user_id,"dollars",math.random(725,975),true)
					end

					Wait(100)
				until Active[user_id] == nil
			else
				local x, y, z = vRPC.getPositions(source)
				Stockade[vehPlate] = Stockade[vehPlate] - 1

				for k,v in pairs(policeResult) do
					async(function()
						vRPC.playSound(v,"ATM_WINDOW","HUD_FRONTEND_DEFAULT_SOUNDSET")
						TriggerClientEvent("NotifyPush",v,{ code = 31, title = "Roubo ao Carro Forte", x = x, y = y, z = z, vehicle = "Carro Forte".." - "..vehPlate, rgba = {15,110,110} })
					end)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:REMOVETYRES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("inventory:removeTyres")
AddEventHandler("inventory:removeTyres",function(Entity,Tyre)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id and Active[user_id] == nil then
		local Vehicle = NetworkGetEntityFromNetworkId(Entity[4])
		if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
			if vCLIENT.tyreHealth(source,Entity[4],Tyre) == 1000.0 then
				if vRP.checkMaxItens(user_id,"tyres",1) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					return
				end

				if vRP.getVehiclePlate(Entity[1]) then
					TriggerClientEvent("inventory:Close",source)
					TriggerClientEvent("inventory:Buttons",source,true)
					vRPC.playAnim(source,false,{"anim@amb@clubhouse@tutorial@bkr_tut_ig3@","machinic_loop_mechandplayer"},true)

					if vTASKBAR.taskTyre(source) then
						Active[user_id] = os.time() + 10
						TriggerClientEvent("Progress",source,10000)

						repeat
							if os.time() >= parseInt(Active[user_id]) then
								Active[user_id] = nil

								local Vehicle = NetworkGetEntityFromNetworkId(Entity[4])
								if DoesEntityExist(Vehicle) and not IsPedAPlayer(Vehicle) and GetEntityType(Vehicle) == 2 then
									if vCLIENT.tyreHealth(source,Entity[4],Tyre) == 1000.0 then
										vRP.generateItem(user_id,"tires",1,true)

										local Players = vRPC.Players(source)
										for _,v in ipairs(Players) do
											async(function()
												TriggerClientEvent("inventory:explodeTyres",v,Entity[4],Entity[1],Tyre)
											end)
										end
									end
								end
							end

							Wait(100)
						until Active[user_id] == nil
					end

					TriggerClientEvent("inventory:Buttons",source,false)
					vRPC.removeObjects(source)
				end
			end
		end
	end
end)