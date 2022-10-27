-----------------------------------------------------------------------------------------------------------------------------------------
-- SMARTPHONE:SERVERREQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("smartphone:service_request")
AddEventHandler("smartphone:service_request",function(data)
    local Answered = false
    local source = vRP.getUserSource(data['user_id'])
    local Services = vRP.numPermission(data.service['permission'])
    
	TriggerClientEvent("Notify",source,"verde", "Chamado efetuado com sucesso, aguarde no local.", 10000)

    for Index,Players in pairs(Services) do
        local OtherUser = vRP.getUserId(Players)
        local OtherIdentity = vRP.getUserIdentity(OtherUser)
        if Players and Players ~= source then
            async(function()
                TriggerClientEvent("NotifyPush",Players,{ code = 20, title = "Chamado de "..data['name'], x = data['location'][1], y = data['location'][2], z = data['location'][3], time = "Recebido às "..os.date("%H:%M"), text = data['content'], phone = data['phone'] })
                local Request = vRP.request(Players,"Chamado","Aceitar o chamado de <b>"..data['name'].."</b>?",30)
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
end)