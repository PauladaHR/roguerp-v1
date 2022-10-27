local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

src = {}
Tunnel.bindInterface("vrp_checkin",src)
vSERVER = Tunnel.getInterface("vrp_checkin")

local beds = {
    `v_med_bed2`,
    `v_med_bed1`,
    `gabz_pillbox_diagnostics_bed_02`,
    `gabz_pillbox_diagnostics_bed_03`
}

CreateThread(function()
    while true do
        local timeDistance = 999
        local ped = PlayerPedId()
        for k,v in pairs(beds) do
            local coords = GetEntityCoords(ped)
            local object = GetClosestObjectOfType(coords["x"],coords["y"],coords["z"],0.9,v,0,0,0)
            if DoesEntityExist(object) then
                local objectCds = GetEntityCoords(object)
                local distance = #(coords - objectCds)
                if distance <= 2.0 then
                    timeDistance = 4
                    drawText3D(objectCds[1],objectCds[2],objectCds[3]+0.93,"~p~E ~w~ TRATAMENTO\n~p~G ~w~ DEITAR")
                    if IsControlJustPressed(1,38) and distance <= 1.5 and vSERVER.checkServices()  then
                        if GetEntityHealth(ped) >= 102 and GetEntityHealth(ped) <= 199 then
                            if vSERVER.paymentCheckin() then
                                local x2,y2,z2 = table.unpack(GetEntityCoords(object))
                                vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
                                SetEntityCoords(ped,x2,y2,z2+0.0)
                                SetEntityHeading(ped,GetEntityHeading(object)+0.0-180.0)

                                vRP.startCure()
                            end
                        elseif GetEntityHealth(GetPlayerPed(-1)) <= 101 and vSERVER.checkServices() then
                            if vSERVER.paymentCheckin() then
                                local x2,y2,z2 = table.unpack(GetEntityCoords(object))
                                vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
                                SetEntityCoords(ped,x2,y2,z2+0.0)
                                SetEntityHeading(ped,GetEntityHeading(object)+0.0-180.0)
                                
                                DoScreenFadeOut(1000)
                                Wait(1000)
                                
                                vRP.revivePlayer()
                                vRP.startCure()

                                Wait(5000)
                                DoScreenFadeIn(1000)
                            end
                        else
                            TriggerEvent("Notify","vermelho","Vida cheía.",5000)
                        end
                    end
                    if IsControlJustPressed(1,47) and distance <= 1.5 and not LocalPlayer["state"]["Commands"] then
                        local x2,y2,z2 = table.unpack(GetEntityCoords(object))
                        vRP.playAnim(false,{"anim@gangops@morgue@table@","body_search"},true)
                        SetEntityCoords(ped,x2,y2,z2+0.0)
                        SetEntityHeading(ped,GetEntityHeading(object)+0.0-180.0)
                    end
                end
                break
            end
        end
        Wait(timeDistance)
    end
end)

function drawText3D(x, y, z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    SetTextScale(0.39, 0.39)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 235)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end