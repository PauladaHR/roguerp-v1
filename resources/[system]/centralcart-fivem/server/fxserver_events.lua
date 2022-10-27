local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
vRP = Proxy.getInterface("vRP")

centralcart_script = GetCurrentResourceName()

local SqlCommands = module(centralcart_script, "server/sql_commands_vrp")
local Command = module(centralcart_script, "server/commands")

local framework = "VRP"

-------------------------------------------- DETECT BASE TYPE ------------------------------------------------
Citizen.CreateThread(function()
    local rows = MySQL.Sync.fetchAll("SELECT table_name AS name FROM information_schema.tables WHERE table_schema = DATABASE()")

    for index, value in ipairs(rows) do
        if value.name == 'summerz_bank' then
            framework = "CREATIVE"

            vRP.getUserSource = vRP.userSource
            vRP.getUserIdentity = vRP.userIdentity

            SqlCommands = module(centralcart_script, "server/sql_commands_creative")
            break
        end

        if value.name == 'summerz_accounts' then
            framework = "CREATIVE4"

            vRP.getUserSource = vRP.userSource
            vRP.getUserIdentity = vRP.userIdentity

            SqlCommands = module(centralcart_script, "server/sql_commands_creative4")
            break
        end

        if value.name == 'vrp_fines' then
            framework = "CREATIVE3"

            SqlCommands = module(centralcart_script, "server/sql_commands_creative3")
            break
        end

        if value.name == 'vrp_homes_permissions' then
            framework = "VRPEX"

            SqlCommands = module(centralcart_script, "server/sql_commands_vrpex")
            break
        end
    end

    print('^3[CENTRALCART]: Executando no framework ' .. framework .. '.')
end)

------------------------------------ CREATE SCHEDULE TABLE & START TASKS -------------------------------------

Citizen.CreateThread(function()
    SqlCommands["fxserver-events-createRemovalsTable"]()

    local function checkRemovals()
        SetTimeout(10000, function()
            local result = SqlCommands["fxserver-events-getRemovals"]()

            for key, value in pairs(result) do
                TriggerEvent(value['command'], value['user_id'], value['value'], 0, function() end)
                SqlCommands["fxserver-events-destroyRemoval"](value['id'])
            end

            checkRemovals()
        end)
    end

    checkRemovals()
end)

--------------------------------------------- tempovip COMMAND ------------------------------------------------
RegisterCommand(Config.vip_info_command, function(source, args, raw)
    if source == 0 then
        local user_id = args[1]

        if user_id == nil then
            print('^1Digite um id para verificar os produtos do jogador.^0')
            return
        end

        local result = SqlCommands["fxserver-events-getUserRemovals"](user_id)

        if #result <= 0 then
            print('^1Nenhum produto encontrado para este id.^0')
            return
        end

        print('')
        print('^5[PRODUTOS ' .. ' DE #' .. user_id .. ']^0')
        for index, removal in ipairs(result) do
            local time = os.date('%d/%m/%Y as %H:%M', tonumber(tostring(removal['expiry_date']):sub(1, -4)))
            print(index .. ' - ' .. string.upper(removal['value']) .. ' acaba em => ' .. time)
        end
        print('')
    else
        local id = vRP.getUserId(source)

        local result = SqlCommands["fxserver-events-getUserRemovals"](id)

        local nsource = vRP.getUserSource(tonumber(id))

        if nsource then
            TriggerClientEvent("fxserver_c_events:user-check-time", nsource, result)
        end

    end
end)

--------------------------------------------- ban/unban EVENTS --------------------------------------------------------
RegisterNetEvent("fxserver-events-ban")
AddEventHandler("fxserver-events-ban", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        Command.ban(framework, user_id)
    end

    SqlCommands["fxserver-events-ban"](user_id)

    callback(true)
end)

RegisterNetEvent("fxserver-events-unban")
AddEventHandler("fxserver-events-unban", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)

    SqlCommands["fxserver-events-unban"](user_id)

    callback(true)
end)

--------------------------------------------- group/ungroup EVENTS -----------------------------------------------
RegisterNetEvent("fxserver-events-group")
AddEventHandler("fxserver-events-group", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        Command.group(framework, user_id, argument)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        local rows = SqlCommands["fxserver-get-user-datatables"](user_id)

        if #rows > 0 then
            local parsed_dvalue = json.decode(rows[1].dvalue)

            if framework == "CREATIVE" then
                if parsed_dvalue["perm"] == nil then
                    parsed_dvalue["perm"] = {}
                end

                if parsed_dvalue["perm"][argument] == nil then
                    parsed_dvalue["perm"][argument] = true
                end
            end

            if framework == "CREATIVE4" then
                if parsed_dvalue["permission"] == nil then
                    parsed_dvalue["permission"] = {}
                end

                if parsed_dvalue["permission"][argument] == nil then
                    parsed_dvalue["permission"][argument] = true
                end
            end

            if framework == "CREATIVE3" then
                vRP.execute("vRP/add_group", { user_id = user_id, permiss = argument })
            end

            if framework == "VRP" or framework == "VRPEX" then
                if parsed_dvalue["groups"] == nil then
                    parsed_dvalue["groups"] = {}
                end

                if parsed_dvalue["groups"][argument] == nil then
                    parsed_dvalue["groups"][argument] = true
                end
            end

            SqlCommands["fxserver-events-group"](user_id, parsed_dvalue)

            callback(true)
        end
    end

end)

RegisterNetEvent("fxserver-events-ungroup")
AddEventHandler("fxserver-events-ungroup", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        Command.ungroup(framework, user_id, argument)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        local rows = SqlCommands["fxserver-get-user-datatables"](user_id)

        if #rows > 0 then
            local parsed_dvalue = json.decode(rows[1].dvalue)

            if framework == "CREATIVE" then
                for k, v in pairs(parsed_dvalue.perm) do
                    if k == argument then
                        parsed_dvalue.perm[k] = nil
                    end
                end
            end

            if framework == "CREATIVE4" then
                for k, v in pairs(parsed_dvalue.permission) do
                    if k == argument then
                        parsed_dvalue.permission[k] = nil
                    end
                end
            end

            if framework == "CREATIVE3" then
                vRP.execute("vRP/del_group", { user_id = user_id, permiss = argument })
            end

            if framework == "VRP" or framework == "VRPEX" then
                for k, v in pairs(parsed_dvalue.groups) do
                    if k == argument then
                        parsed_dvalue.groups[k] = nil
                    end
                end
            end

            SqlCommands["fxserver-events-ungroup"](user_id, parsed_dvalue)

            callback(true)
        end
    end
end)

--------------------------------------------- addMoney/removeMoney EVENTS -----------------------------------------------
RegisterNetEvent("fxserver-events-addBank")
AddEventHandler("fxserver-events-addBank", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        Command.addMoney(framework, user_id, tonumber(argument))

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        SqlCommands["fxserver-events-addBank"](user_id, argument)

        callback(true)
    end
end)

RegisterNetEvent("fxserver-events-removeBank")
AddEventHandler("fxserver-events-removeBank", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        Command.removeMoney(framework, user_id, argument)
        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        SqlCommands["fxserver-events-removeBank"](user_id, argument)

        callback(true)
    end
end)

------------------------------------------ addInventory/removeInventory-----------------------------------------------
RegisterNetEvent("fxserver-events-addInventory")
AddEventHandler("fxserver-events-addInventory", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        Command.addInventory(framework, user_id, argument, amount)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        local rows = SqlCommands["fxserver-get-user-datatables"](user_id)

        if #rows > 0 then
            local parsed_dvalue = json.decode(rows[1].dvalue)

            if framework == "CREATIVE" or framework == "CREATIVE4" then
                local initial = 0

                repeat
                    initial = initial + 1
                until parsed_dvalue.inventory[tostring(initial)] == nil or
                    (
                    parsed_dvalue.inventory[tostring(initial)] and
                        parsed_dvalue.inventory[tostring(initial)]["item"] == argument)

                local slot = tostring(initial)

                if parsed_dvalue.inventory[slot] == nil then
                    parsed_dvalue.inventory[slot] = { item = argument, amount = amount }
                elseif parsed_dvalue.inventory[slot] and parsed_dvalue.inventory[slot]["item"] == argument then
                    parsed_dvalue.inventory[slot]["amount"] = tonumber(parsed_dvalue.inventory[slot]["amount"]) +
                        amount
                end
            end

            if framework == "CREATIVE3" then
                local initial = 0
                repeat
                    initial = initial + 1
                until parsed_dvalue.inventorys[tostring(initial)] == nil or
                    (
                    parsed_dvalue.inventorys[tostring(initial)] and
                        parsed_dvalue.inventorys[tostring(initial)].item == argument)

                local slot = tostring(initial)

                if parsed_dvalue.inventorys[slot] == nil then
                    parsed_dvalue.inventorys[slot] = { item = argument, amount = amount }
                elseif parsed_dvalue.inventorys[slot] and parsed_dvalue.inventorys[slot].item == argument then
                    parsed_dvalue.inventorys[slot].amount = parsed_dvalue.inventorys[slot].amount + amount
                end

            end

            if framework == "VRP" or framework == "VRPEX" then
                if parsed_dvalue.inventory[argument] then
                    parsed_dvalue.inventory[argument].amount = parsed_dvalue.inventory[argument].amount + amount;
                else
                    parsed_dvalue.inventory[argument] = { amount = amount }
                end
            end

            SqlCommands["fxserver-events-addInventory"](user_id, parsed_dvalue)

            callback(true)
        end
    end
end)

------------------------------------------ addHome/removeHome ----------------------------------------------------------
RegisterNetEvent("fxserver-events-addHome")
AddEventHandler("fxserver-events-addHome", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    local rows = SqlCommands["fxserver-events-checkHome"](argument)

    if #rows > 0 then
        if not rows["user_id"] == user_id then
            print('^3[CENTRALCART] Nao foi possivel entregar a casa ' .. argument .. ' ao ID #' ..
                user_id .. ' pois o imovel ja tem um dono.')
        else
            print('^3[CENTRALCART] Nao foi possivel entregar a casa ' ..
                argument .. ' ao ID #' .. user_id .. ' pois esta casa ja o pertence.')
        end

        callback(true)
        do return end
    end

    if source then
        Command.addHome(framework, user_id, argument)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        if framework == "CREATIVE" or framework == "CREATIVE4" or
            framework == "CREATIVE3" or framework == "VRPEX" then

            SqlCommands["fxserver-events-addHome"](user_id, argument)

            callback(true)
        end

        if framework == "VRP" then
            local number = nil

            number = vRP.findFreeNumber(argument, 1000)

            SqlCommands["fxserver-events-addHome"](user_id, argument, number)

            callback(true)
        end
    end
end)

RegisterNetEvent("fxserver-events-removeHome")
AddEventHandler("fxserver-events-removeHome", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        --Command.remHome(framework, user_id, argument)
        SqlCommands["fxserver-events-removeHome"](user_id, argument)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        SqlCommands["fxserver-events-removeHome"](user_id, argument)

        callback(true)
    end
end)

------------------------------------------ addVehicle/removeVehicle ----------------------------------------------------------
RegisterNetEvent("fxserver-events-addVehicle")
AddEventHandler("fxserver-events-addVehicle", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    local rows = SqlCommands["fxserver-events-hasVehicle"](user_id, argument)

    if #rows > 0 then
        callback(true)
        return
    end

    if source then
        SqlCommands["fxserver-events-addVehicle"](user_id, argument)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        SqlCommands["fxserver-events-addVehicle"](user_id, argument)

        callback(true)
    end
end)

RegisterNetEvent("fxserver-events-removeVehicle")
AddEventHandler("fxserver-events-removeVehicle", function(user_id, argument, amount, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    local rows = SqlCommands["fxserver-events-hasVehicle"](user_id, argument)

    if #rows <= 0 then
        callback(true)
        return
    end

    if source then
        SqlCommands["fxserver-events-removeVehicle"](user_id, argument)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        SqlCommands["fxserver-events-removeVehicle"](user_id, argument)

        callback(true)
    end
end)

RegisterNetEvent("fxserver-events-customSQL")
AddEventHandler("fxserver-events-customSQL", function(sql, user_id, callback)
    local user_id = tonumber(user_id)
    local source = vRP.getUserSource(user_id)

    if source then
        SqlCommands["fxserver-events-customSQL"](sql, user_id)

        callback(true)
    else
        if not Config.offline_deliveries then
            do return end
        end

        SqlCommands["fxserver-events-customSQL"](sql, user_id)

        callback(true)
    end
end)

------------------------------------------ createRemoval/deleteRemoval ----------------------------------------------------------
RegisterNetEvent("fxserver-events-addRemoval")
AddEventHandler("fxserver-events-addRemoval", function(user_id, command, value, expiry_date)

    local rows = SqlCommands["fxserver-events-checkRemoval"](user_id, command, value)

    if #rows > 0 then
        local current_timestamp = tostring(rows[1].expiry_date):sub(1, 10);

        local date_table = os.date('*t', tonumber(current_timestamp));

        date_table["sec"] = date_table["sec"] + expiry_date.days * 24 * 60 * 60

        local updated_sql_date = os.date("!%Y-%m-%d %H:%M:%S", os.time(date_table))

        SqlCommands["fxserver-events-updateRemoval"](user_id, command, value, updated_sql_date)
    else
        SqlCommands["fxserver-events-addRemoval"](user_id, command, value, expiry_date.sql)
    end
end)


RegisterNetEvent("fxserver_events:user-notify")
AddEventHandler("fxserver_events:user-notify", function(user_id, argument, amount)
    local nsource = vRP.getUserSource(tonumber(user_id))

    if nsource then
        TriggerClientEvent("fxserver_c_events:user-notify", nsource, user_id, argument, amount)
    end
end)

RegisterNetEvent("fxserver_events:global_chat_message")
AddEventHandler("fxserver_events:global_chat_message", function(user_id, argument, amount)
    if not Config.global_notify then
        do return end
    end

    local identity = vRP.getUserIdentity(tonumber(user_id))

    if identity ~= nil then
        local name = identity['name'] or identity['firstname']

        local message = name .. " comprou " .. argument .. " na nossa loja!"
        TriggerClientEvent('chat:addMessage', -1, {
            template = '<div style="font-size: 16px; display: flex; align-items: center; padding: 0.7vw; background-image: linear-gradient(to right, #00dc82 3%, rgba(0, 0, 0,0) 95%); border-radius: 5px;"><img src="data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0idXRmLTgiPz4NCjwhLS0gR2VuZXJhdG9yOiBBZG9iZSBJbGx1c3RyYXRvciAxNi4wLjAsIFNWRyBFeHBvcnQgUGx1Zy1JbiAuIFNWRyBWZXJzaW9uOiA2LjAwIEJ1aWxkIDApICAtLT4NCjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+DQo8c3ZnIHZlcnNpb249IjEuMSIgaWQ9IkxheWVyXzEiIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgeG1sbnM6eGxpbms9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkveGxpbmsiIHg9IjBweCIgeT0iMHB4Ig0KCSB3aWR0aD0iMzU3Ny4xMzlweCIgaGVpZ2h0PSIzMzY0LjU3NHB4IiB2aWV3Qm94PSIwIDAgMzU3Ny4xMzkgMzM2NC41NzQiIGVuYWJsZS1iYWNrZ3JvdW5kPSJuZXcgMCAwIDM1NzcuMTM5IDMzNjQuNTc0Ig0KCSB4bWw6c3BhY2U9InByZXNlcnZlIj4NCjxwYXRoIGZpbGwtcnVsZT0iZXZlbm9kZCIgY2xpcC1ydWxlPSJldmVub2RkIiBmaWxsPSIjODdEOEI1IiBkPSJNMTA0NS4yNDIsMjAxOC42MDRjMjkuMzEzLDE3Ni4xNzQsMzUuNTI1LDM5Ny43MTgsMjgyLjA1NCwzOTcuNzE4DQoJaDE0MjQuMDNjMjMzLjM1NywwLDI0Mi43MTgtMTkzLjc2OSwyODMuNjAzLTM1Ny41ODNsMjk5LjAxNi0xMTk1Ljk0N0g4NTIuNTZMMTA0NS4yNDIsMjAxOC42MDR6Ii8+DQo8cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGNsaXAtcnVsZT0iZXZlbm9kZCIgZmlsbD0iIzAwREM4MiIgZD0iTTIwODguNDMxLDEzNjcuNzk3DQoJYy0xOTkuMTQzLDM0NC45Mi0zMjQuNjUxLDcwNC41NDItMzc5LjI0OCwxMDQ4LjUzNGgxMDQyLjE0MmMyMzMuMzU3LDAsMjQyLjcxMi0xOTMuNzc3LDI4My42MDMtMzU3LjU5MmwyOTkuMDE2LTExOTUuOTQ3aC04ODYuMDQ1DQoJQzIzMTYuNjQ1LDEwMTMuNTQ3LDIxOTUuMzkxLDExODIuNTMzLDIwODguNDMxLDEzNjcuNzk3eiIvPg0KPHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGZpbGw9IiMwMDFFMjYiIGQ9Ik0yNDk1LjQ3MiwyODYxLjUzNmMtMTM4Ljg1NSwwLTI1MS41MzcsMTEyLjY4LTI1MS41MzcsMjUxLjUzNw0KCWMwLDEzOC44MjYsMTEyLjY4MiwyNTEuNTAxLDI1MS41MzcsMjUxLjUwMWMxMzguODMsMCwyNTEuNDc2LTExMi42NzUsMjUxLjQ3Ni0yNTEuNTAxDQoJQzI3NDcuMDA3LDI5NzQuMjE2LDI2MzQuMjY3LDI4NjEuNTM2LDI0OTUuNDcyLDI4NjEuNTM2eiIvPg0KPHBhdGggZmlsbC1ydWxlPSJldmVub2RkIiBjbGlwLXJ1bGU9ImV2ZW5vZGQiIGZpbGw9IiMwMDFFMjYiIGQ9Ik0xNTMxLjk2NSwyODYxLjUzNmMtMTM4LjgyNCwwLTI1MS41MzcsMTEyLjY4LTI1MS41MzcsMjUxLjUzNw0KCWMwLjAzMywxMzguODI2LDExMi42ODEsMjUxLjUwMSwyNTEuNTM3LDI1MS41MDFjMTM4Ljg1OCwwLDI1MS41MDQtMTEyLjY3NSwyNTEuNTA0LTI1MS41MDENCglDMTc4My41MDEsMjk3NC4yMTYsMTY3MC44MjQsMjg2MS41MzYsMTUzMS45NjUsMjg2MS41MzZ6Ii8+DQo8cGF0aCBmaWxsLXJ1bGU9ImV2ZW5vZGQiIGNsaXAtcnVsZT0iZXZlbm9kZCIgZmlsbD0iIzAwMUUyNiIgZD0iTTM0NjkuOTQ0LDYzMy41MDFIODQyLjM2bC03MC42OTUtNTI0LjgxNQ0KCUM3NjEuNDUxLDMyLjY0Myw3MTkuMDYzLDAsNjQzLjgzNSwwSDEyNS43NzRDNTYuMjYzLDAsMCw1Ni4zOTIsMCwxMjUuODMyYzAsNjkuNDc5LDU2LjIyOCwxMjUuNzY2LDEyNS43NzQsMTI1Ljc2Nmw0MTAuMTMtMC4wMjYNCglsMjkzLjg2NSwxNzg4LjI1MWM0OC45ODUsMzA3Ljc5NywxMTkuNDY0LDYwNS44NDcsNTE5LjQxNiw2MDUuODQ3bDEzODMuMzYzLTAuMDI2YzQwNS4wNDUsMCw0NDkuNTY1LTI4OS4wNTcsNTIyLjI1NS01NzkuOTIxDQoJTDM1NjMuMzgsODMxLjM2NkMzNTg3LjI0OCw3MzUuOTYyLDM1OTMuMTIsNjMzLjUwMSwzNDY5Ljk0NCw2MzMuNTAxeiBNMzIxOC45MzYsMTIwMy4xMTFoLTE3MTEuOQ0KCWMtNjkuMTkyLDAtMTI1LjczNyw1Ni41NzMtMTI1LjczNywxMjUuNzM5djAuMDYxYzAsNjkuMTY2LDU2LjU0NCwxMjUuNzM3LDEyNS43MzcsMTI1LjczN2gxNjQ5LjAxOGwtNzEuNzg0LDI4Ny4xODFIMTgxNC41NTMNCgljLTY5LjEzNCwwLTEyNS43MDQsNTYuNTc4LTEyNS43MDQsMTI1LjczOHYwLjA5MmMwLDY5LjE2NCw1Ni41NywxMjUuNzA5LDEyNS43MDQsMTI1LjcwOUgzMDIxLjM1bC0xMy4zMzgsNTMuMzg5DQoJYy0zOS43MzYsMTU5LjEyNi00OC44MjIsMzQ3LjM3Ni0yNzUuNDk5LDM0Ny4zNzZIMTM0OS4xODVjLTIzOS40NzcsMC0yNDUuNTEtMjE1LjIzNC0yNzMuOTk5LTM4Ni4zNjRMODg4LjAzNyw4ODUuMDA1aDI0MTAuNDQNCglMMzIxOC45MzYsMTIwMy4xMTF6Ii8+DQo8L3N2Zz4NCg" height="20" style="margin-right: 12px;" />{1}</div>',
            args = { "Central Cart:", message }
        })
    end
end)
