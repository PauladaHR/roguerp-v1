-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRPC = Tunnel.getInterface("vRP")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_trucker",cRP)
vGARAGE = Tunnel.getInterface("vrp_trucker")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local deliveryPackage = {}
local itensList = {"plastic","glass","rubber","aluminum","copper","eletronics"}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKEXIST
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.checkExist()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if deliveryPackage[user_id] then
			if vRP.userPremium(user_id) then
				if deliveryPackage[user_id] >= 2 then
					TriggerClientEvent("Notify",source,"vermelho","Atingiu o limite diário.",5000)
					return true
				end
			else
				TriggerClientEvent("Notify",source,"vermelho","Atingiu o limite diário.",5000)
				return true
			end
		end

		return false
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTMETHOD
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.paymentMethod()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if deliveryPackage[user_id] == nil then
			deliveryPackage[user_id] = 0
		end

		vRP.generateItem(user_id,"dollars",5000,true)
        for k,v in pairs(itensList) do
            vRP.giveInventoryItem(user_id,v,math.random(40,60),true)
        end
		deliveryPackage[user_id] = deliveryPackage[user_id] + 1
	end
end