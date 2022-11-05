-----------------------------------------------------------------------------------------------------------------------------------------
-- SMARTPHONE:SERVERREQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("smartphone:service_request")
AddEventHandler("smartphone:service_request",function(Data)
    local Answered = false
    local source = vRP.getUserSource(Data['user_id'])
    local Services = vRP.numPermission(Data.service['permission'])
    
	TriggerClientEvent("Notify",source,"verde", "Chamado efetuado com sucesso, aguarde no local.", 10000)

    for Index,Players in pairs(Services) do
        local OtherUser = vRP.getUserId(Players)
        local OtherIdentity = vRP.getUserIdentity(OtherUser)
        if Players and Players ~= source then
            async(function()
                TriggerClientEvent("NotifyPush",Players,{ code = 20, title = "Chamado de "..Data['name'], x = Data['location'][1], y = Data['location'][2], z = Data['location'][3], time = "Recebido às "..os.date("%H:%M"), text = Data['content'], phone = Data['phone'] })
                local Request = vRP.request(Players,"Chamado","Aceitar o chamado de <b>"..Data['name'].."</b>?",30)
                if Request then
                    if not Answered then
                        Answered = true
                        vRPC.playSound(source,"Event_Message_Purple","GTAO_FM_Events_Soundset")
						TriggerClientEvent("Notify",source,"amarelo", "Chamado atendido por <b>"..OtherIdentity.name.." "..OtherIdentity.name2.."</b>, aguarde no local.", 10000)
                    else
						TriggerClientEvent("Notify",Players,"amarelo", "Chamado já foi atendido por outra pessoa.", 5000)
                        vRPC.playSound(Players,"CHECKPOINT_MISSED","HUD_MINI_GAME_SOUNDSET")
                    end
                end
            end)
        end
    end

    SetTimeout(30000,function()
        if not Answered then
            TriggerClientEvent("smartphone:pusher",Data["source"],"SERVICE_REJECT",{})
        end
    end)
end)