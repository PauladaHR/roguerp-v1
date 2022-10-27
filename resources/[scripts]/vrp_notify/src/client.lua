RegisterNetEvent('Notify', function(type, message, time)
	if not time then
		time = 8000
	end

	SendNUIMessage({
		action = 'open', type = type, message = message, time = time,
	})
end)

RegisterNetEvent("NotifyAdmCallback")
AddEventHandler("NotifyAdmCallback",function(nomeadm,mensagem)
	SendNUIMessage({ action = 'open', type = "amarelo", message = "<b>"..mensagem.."</b><br>- Mensagem do adminstrador: "..nomeadm, time = 30000 })
end)