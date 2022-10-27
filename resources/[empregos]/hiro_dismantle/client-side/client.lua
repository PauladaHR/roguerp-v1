local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

vSERVER = Tunnel.getInterface(GetCurrentResourceName())

local doorsToDismantle
local vehicleInDismantle
local canSeeDoorText = true
local inDismantle = false

local doorsID = {
    "door_dside_f",
    "door_pside_f",
    "door_dside_r",
    "door_pside_r"
}

CreateThread(function()
    while true do
        local timeDistance = 999
        local ped = PlayerPedId()
        local pedCoords = GetEntityCoords(ped)
        local distanceMantle = #(pedCoords - vector3(cfg.locs.x,cfg.locs.y,cfg.locs.z))
        if distanceMantle <= 6 then
            timeDistance = 0
            DrawMarker(23,cfg.locs.x,cfg.locs.y,cfg.locs.z - 0.95,0.0,0.0,0.0,0.0,0.0,0.0,5.0,5.0,0.0,255,0,0,50,0,0,0)
        end
        Wait(timeDistance)
    end
end)

function isVehicleAMotorcycle(vehicle)
    local vehicleClass = GetVehicleClass(vehicle)
    return vehicleClass ~= 8 and vehicleClass ~= 13
end

RegisterCommand("dismantle", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped,true)
    local pedCoords = GetEntityCoords(ped)
    local distanceMantle = #(pedCoords - vector3(cfg.locs.x,cfg.locs.y,cfg.locs.z))
    if distanceMantle <= 6 then
        if DoesEntityExist(vehicle) then
            if isVehicleAMotorcycle(vehicle) then
                if not IsPedInAnyVehicle(ped, true) then
                    if not inDismantle then
                        if vSERVER.checkVehicleList() then
                            vehicleInDismantle = vehicle
                            startDismantle(vehicle)
                        else
                            TriggerEvent("Notify","vermelho","Veículo não listado.")
                        end
                    end
                else
                    TriggerEvent("Notify","vermelho","Saia do veículo para desmanchar")
                end
            else
                TriggerEvent("Notify","vermelho","Desmanche de motos não permitido")
            end
        end
    end
end)

RegisterKeyMapping('dismantle', 'Desmanchar veículo', 'keyboard', 'e')


function startDismantle(vehicle)
    inDismantle = true
    SetVehicleFixed(vehicle)
    for i = 0,3 do
        Wait(0)
        SetVehicleDoorOpen(vehicle,i,0)
    end
    FreezeEntityPosition(vehicle,true)

    local doorsQuantity = GetNumberOfVehicleDoors(vehicle)

    if doorsQuantity <= 4 then
        doorsToDismantle = 2
    else
        doorsToDismantle = 4
    end
    chopDoor(vehicle,doorsToDismantle)
end

function chopDoor(vehicle)
    while inDismantle do
        if canSeeDoorText then
            local doorsCds = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, doorsID[doorsToDismantle]))
            DrawText3D(doorsCds.x,doorsCds.y,doorsCds.z,"PRESSIONE ~r~[E] ~w~ PARA RETIRAR A PORTA")
            local ped = PlayerPedId()
            local pedCds = GetEntityCoords(ped)
            local distanceBetween = #(doorsCds - pedCds)
            if distanceBetween <= 1.5 and IsControlJustPressed(0, 38) then
                canSeeDoorText = false
                LocalPlayer["state"]["Commands"] = true
                TaskStartScenarioInPlace(ped,"WORLD_HUMAN_WELDING",0)
                TriggerEvent("Progress",15000)
                Wait(15000)
                playDismantleAnim()
                TriggerEvent("Progress",5000)
                Wait(5000)
                SetVehicleDoorBroken(vehicle, doorsToDismantle-1, true)
                ClearPedTasks(ped)
                createAndAttachDoor()
            end
        end
        Wait(0)
    end
end

function playGetDoorsAnim()
    local animDict = "anim@heists@box_carry@"
    local animName = "idle"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
	TaskPlayAnim(PlayerPedId(),animDict,animName,8.0,8.0,-1,49,5.0,0,0,0)
end

function playDismantleAnim()
    local animDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@"
    local animName = "machinic_loop_mechandplayer"
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(100)
    end
	TaskPlayAnim(PlayerPedId(),animDict,animName,8.0,8.0,-1,1,5.0,0,0,0)
end

function createAndAttachDoor()
    local objectHash = `prop_car_door_01`
    RequestModel(objectHash)
    while not HasModelLoaded(objectHash) do
        Wait(100)
    end
    local ped = PlayerPedId()
    local cds = GetEntityCoords(ped)
    local object = CreateObject(objectHash, cds.x, cds.y, cds.z, false)
    AttachEntityToEntity(object,ped,GetPedBoneIndex(ped, 28422),0.0,0.0,0.00,0.0,0.0,0.0,nil,true,false,false,true,true)
    playGetDoorsAnim()
    deliveryDoor(object)
end

local DELIVERY_DOORS_COORDS = vector3(cfg.locs.x-15,cfg.locs.y,cfg.locs.z)

function deliveryDoor(object)
    while true do
        DrawText3D(DELIVERY_DOORS_COORDS.x,DELIVERY_DOORS_COORDS.y,DELIVERY_DOORS_COORDS.z,"PRESSIONE ~r~[E] ~w~ PRA ENTREGAR A PEÇA")
        DisableControlAction(0,21) 
        DisableControlAction(0,22)
        local ped = PlayerPedId()
        local pedCds = GetEntityCoords(ped)
        local distance = #(pedCds - DELIVERY_DOORS_COORDS)
        if distance <= 2 and IsControlJustPressed(0, 38) then
            DeleteObject(object)
            ClearPedTasks(PlayerPedId())
            doorsToDismantle = doorsToDismantle - 1
            if doorsToDismantle == 0 then
                endDismantle()
            end
            LocalPlayer["state"]["Commands"] = false
            canSeeDoorText = true
            break
        end
        Wait(0)
    end
end

function endDismantle()
    inDismantle = false
    local plate = GetVehicleNumberPlateText(vehicleInDismantle)
    vSERVER.paymentMethod(vehicleInDismantle,plate)
    vehicleInDismantle = nil
end

function DrawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.39, 0.39)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 235)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 270
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.04, 0, 0, 0, 145)
end