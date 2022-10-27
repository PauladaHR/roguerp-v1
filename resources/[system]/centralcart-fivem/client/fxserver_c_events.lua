RegisterNetEvent("fxserver_c_events:user-notify")
AddEventHandler("fxserver_c_events:user-notify", function(user_id, argument, amount)
    SendNUIMessage({
        action = "user-notify",
        user_id = user_id,
        product = argument,
        amount = amount,
        temporary = temporary,
    })
end)

RegisterNetEvent("fxserver_c_events:user-check-time")
AddEventHandler("fxserver_c_events:user-check-time", function(products)
    SendNUIMessage({
        action = 'user-check-time',
        products = products,
    })
end)
