local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface(GetCurrentResourceName(), src)
vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local blocked = false

-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENATM
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("bank:machineOpen",function()
	if not blocked and not vSERVER.isWanted() then 
		SetNuiFocus(true,true)	    
		SendNUIMessage({ action = "show" })
		vRP._playAnim(false,{"amb@prop_human_atm@male@base","base"},true)
	end
end)
----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hide" })
	vRP._stopAnim()
end)

RegisterNetEvent("bankActived", function(status)
	blocked = status
end)


RegisterNetEvent("vrp_atmCloseEvent")
AddEventHandler("vrp_atmCloseEvent", function()
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hide" })
	vRP._stopAnim()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT
-----------------------------------------------------------------------------------------------------------------------------------------
local pendent = false
RegisterNUICallback("deposit",function(data)
	if pendent then return end

	if parseInt(data["value"]) > 0 then
		pendent = true
		vSERVER.atmDeposit(data["value"])
		pendent = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WITHDRAW
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("withdraw",function(data)
	if pendent then return end
	
	if parseInt(data["value"]) > 0 then
		pendent = true
		vSERVER.atmWithdraw(data["value"])
		pendent = false
	end
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBANK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("saldodoBanco",function(data,cb)
	cb({ valorfinal = (vSERVER.getSaldo() or 0) })
end)

function src.checkConnection()
	return true
end