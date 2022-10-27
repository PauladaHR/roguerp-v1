local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

local emservico = false
local fogo = {}
local selecionado = nil
local nveh = nil
local cooldown = 0
local old_custom = nil
local armor = 0
local health = 0


local output = nil
RegisterNetEvent('lixeiroBombeiros:getPerm')
AddEventHandler('lixeiroBombeiros:getPerm', function(ret)
    output = ret
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		local bowz,cdz = GetGroundZFor_3dCoord(Config.blipEmprego[1],Config.blipEmprego[2],Config.blipEmprego[3])
		local distance = GetDistanceBetweenCoords(Config.blipEmprego[1],Config.blipEmprego[2],cdz,x,y,z,true)

		if distance <= 20 then
			DrawMarker(21,Config.blipEmprego[1],Config.blipEmprego[2],Config.blipEmprego[3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
			if distance <= 2.0 then
				if cooldown > 0 then
					DrawText3D(Config.blipEmprego[1],Config.blipEmprego[2],Config.blipEmprego[3], "~w~Aguarde ~r~"..cooldown.." SEGUNDOS~w~ para ~y~INICIAR~w~ o expediente.",255,255,255)
				else
					if not emservico then
						DrawText3D(Config.blipEmprego[1],Config.blipEmprego[2],Config.blipEmprego[3], "~w~Pressione ~g~[E] ~w~para ~y~INICIAR~w~ o expediente.",255,255,255)
					else
						DrawText3D(Config.blipEmprego[1],Config.blipEmprego[2],Config.blipEmprego[3], "~w~Pressione ~g~[E] ~w~para ~r~FINALIZAR~w~ o expediente.",255,255,255)
					end
					if IsControlJustPressed(0,38) then
					
						if Config.permissao == false or Config.permissao == "false" then
							output = true
						else
							output = nil
							TriggerServerEvent('lixeiroBombeiros:getPerm')
							while output == nil do 
								Wait(10)
							end
						end
						
						if output == true then
							if not emservico then
								emservico = true
								
								-- old_custom = vRP.getCustomization(source)
								-- health = GetEntityHealth(PlayerPedId())
								-- armor = GetPedArmour(PlayerPedId())
								-- TriggerEvent("skinmenu","s_m_y_fireman_01")
								-- Wait(1000)
								-- SetEntityHealth(PlayerPedId(),health)
								-- SetPedArmour(PlayerPedId(),armor)
								
								TriggerEvent("Notify","sucesso","Você entrou em serviço. Pegue seu caminhão na garagem ao lado.")
							else
								if selecionado then
									selecionado = nil
									for k,v in pairs(fogo) do
										RemoveScriptFire(v)
									end
								end
								
								-- health = GetEntityHealth(PlayerPedId())
								-- armor = GetPedArmour(PlayerPedId())
								-- vRP.setCustomization(old_custom)
								-- SetEntityHealth(PlayerPedId(),health)
								-- SetPedArmour(PlayerPedId(),armor)
								
								DeleteEntity(nveh)
								cooldown = Config.cooldown
								emservico = false
								TriggerEvent("Notify","sucesso","Você saiu de serviço.")
							end
						else
							TriggerEvent("Notify","negado","Você não tem permissão.")
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local x,y,z = table.unpack(GetEntityCoords(PlayerPedId()))
		local bowz,cdz = GetGroundZFor_3dCoord(Config.blipCaminhao[1],Config.blipCaminhao[2],Config.blipCaminhao[3])
		local distance = GetDistanceBetweenCoords(Config.blipCaminhao[1],Config.blipCaminhao[2],cdz,x,y,z,true)

		if distance <= 20 then
			DrawMarker(21,Config.blipCaminhao[1],Config.blipCaminhao[2],Config.blipCaminhao[3]-0.6,0,0,0,0.0,0,0,0.5,0.5,0.4,255,0,0,50,0,0,0,1)
			if distance <= 2.0 then
				if emservico then
					DrawText3D(Config.blipCaminhao[1],Config.blipCaminhao[2],Config.blipCaminhao[3], "~w~Pressione ~g~[E] ~w~para pegar seu caminhão.",255,255,255)
					if IsControlJustPressed(0,38) then
						if emservico then
							spawnVehicle(Config.caminhao,Config.blipCaminhao[1],Config.blipCaminhao[2],Config.blipCaminhao[3],Config.blipCaminhao[4])
							TriggerEvent("Notify","sucesso","Você pegou seu caminhão, use-o para apagar os incêndios.")
							TriggerEvent("Notify","sucesso","Em breve você será alertado sobre novos incêndios")
						end
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		if selecionado ~= nil then
			local apagouTodos = true
			for k,v in pairs(Config.locais[selecionado]) do
				local temFogo, cds = GetClosestFirePos(v[1], v[2], v[3]-1)
				if temFogo then
					apagouTodos = false
					break
				end
			end
			if apagouTodos then
				selecionado = nil
				TriggerServerEvent('lixeiroBombeiros:dinheiro')
				TriggerEvent("Notify","sucesso","<b>Parabéns!</b> Você apagou todos os incêndios deste local.")
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if cooldown > 0 then
			cooldown = cooldown - 1
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(Config.tempo*1000)
		if emservico == true and selecionado == nil then
			selecionado = math.random(#Config.locais)
			SetNewWaypoint(Config.locais[selecionado][1][1],Config.locais[selecionado][1][2])
			for k,v in pairs(Config.locais[selecionado]) do
				fogo[k] = StartScriptFire(v[1], v[2], v[3]-1, 1, false)
			end
			TriggerEvent("Notify","importante","Há um novo incêndio na cidade! Corra até o ponto no seu GPS.")
		end
	end
end)

function spawnVehicle(name,x,y,z,h)
	local mhash = GetHashKey(name)
	while not HasModelLoaded(mhash) do
		RequestModel(mhash)
		Citizen.Wait(10)
	end
	DeleteEntity(nveh)
	if HasModelLoaded(mhash) then
		nveh = CreateVehicle(mhash,x,y,z+0.5,h,true,false)
		local netveh = VehToNet(nveh)
		local id = NetworkGetNetworkIdFromEntity(nveh)

		NetworkRegisterEntityAsNetworked(nveh)
		while not NetworkGetEntityIsNetworked(nveh) do
			NetworkRegisterEntityAsNetworked(nveh)
			Citizen.Wait(1)
		end

		if NetworkDoesNetworkIdExist(netveh) then
			SetEntitySomething(nveh,true)
			if NetworkGetEntityIsNetworked(nveh) then
				SetNetworkIdExistsOnAllMachines(netveh,true)
			end
		end

		local plate = "CAMINHAO"

		SetNetworkIdCanMigrate(id,true)
		SetVehicleNumberPlateText(NetToVeh(netveh),plate)
		Citizen.InvokeNative(0xAD738C3085FE7E11,NetToVeh(netveh),true,true)
		SetVehicleHasBeenOwnedByPlayer(NetToVeh(netveh),true)
		SetVehicleNeedsToBeHotwired(NetToVeh(netveh),false)
		SetModelAsNoLongerNeeded(mhash)
		TaskWarpPedIntoVehicle(PlayerPedId(),nveh,-1)

		TriggerServerEvent("setPlateEveryone",plate)
	end
end

function DrawText3D(x,y,z, text, r,g,b)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextScale(0.0*scale, 0.55*scale)
        SetTextFont(0)
        SetTextProportional(1)
        -- SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end