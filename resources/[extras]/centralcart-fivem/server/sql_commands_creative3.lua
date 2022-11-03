--=======================================================================
--============================= [LISTA SQL] =============================
--=======================================================================

local SqlCommands = {}


--============================= [BAN] =============================
SqlCommands["fxserver-events-ban"] = function(user_id)

    local steam_id = vRP.getUserIdentity(user_id)["steam"]
    local rows = MySQL.Sync.fetchAll("UPDATE vrp_infos SET banned = 1 WHERE steam = @steam", {
        ["@steam"] = steam_id
    })

    return rows
end

--============================= [UNBAN] =============================
SqlCommands["fxserver-events-unban"] = function(user_id)

    local steam_id = vRP.getUserIdentity(user_id)["steam"]
    local rows = MySQL.Sync.fetchAll("UPDATE vrp_infos SET banned = 0 WHERE steam = @steam", {
        ["@steam"] = steam_id
    })

    return rows
end

--============================= [GET USER DATA TABLE] =============================
SqlCommands["fxserver-get-user-datatables"] = function(user_id)

    -- ver como funciona datatable
    local rows = MySQL.Sync.fetchAll("SELECT * FROM vrp_user_data WHERE dkey = 'Datatable' AND user_id = @user_id",
        {
            ["@user_id"] = user_id
        })

    return rows
end

--============================= [ADD GROUP] =============================
SqlCommands["fxserver-events-group"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'Datatable' AND user_id = @user_id"
        , {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end

--============================= [REM GROUP] =============================
SqlCommands["fxserver-events-ungroup"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'Datatable' AND user_id = @user_id"
        , {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end

--============================= [ADDBANK] =============================
SqlCommands["fxserver-events-addBank"] = function(user_id, amount)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_users SET bank = bank + @incrementval WHERE id = @user_id",
        {
            ['@user_id'] = user_id,
            ['@incrementval'] = tonumber(amount),
        })

    return rows
end

--============================= [REM BANK] =============================
SqlCommands["fxserver-events-removeBank"] = function(user_id, amount)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_users SET bank = bank - @incrementval WHERE id = @user_id",
        {
            ['@user_id'] = user_id,
            ['@incrementval'] = tonumber(amount),
        })

    return rows
end

--============================= [ADD ITEM] =============================
SqlCommands["fxserver-events-addInventory"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'Datatable' AND user_id = @user_id"
        , {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end

--============================= [REM ITEM] =============================
SqlCommands["fxserver-events-removeInventory"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE vrp_user_data SET dvalue = @dvalue WHERE dkey = 'Datatable' AND user_id = @user_id"
        , {
        ['@dvalue'] = json.encode(parsed_dvalue),
        ['@user_id'] = user_id,
    })

    return rows
end

--============================= [CHECK HOME] =============================
SqlCommands["fxserver-events-checkHome"] = function(argument)

    local rows = MySQL.Sync.fetchAll("SELECT * from vrp_homes WHERE home = @home", {
        ["@home"] = argument
    })

    return rows
end

--============================= [ADD HOME] =============================
SqlCommands["fxserver-events-addHome"] = function(user_id, argument, number)

    local rows = MySQL.Sync.fetchAll("INSERT INTO vrp_homes (user_id, home) VALUES(@user_id, @home)"
        , {
        ["@user_id"] = user_id,
        ["@home"] = argument,
    })

    return rows
end

--============================= [REM HOME] =============================
SqlCommands["fxserver-events-removeHome"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("DELETE FROM vrp_homes WHERE user_id = @user_id AND home = @home", {
        ["@user_id"] = user_id,
        ["@home"] = argument
    })

    return rows
end

--============================= [HAS VEHICLE] =============================
SqlCommands["fxserver-events-hasVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("SELECT user_id FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle"
        , {
        ["@user_id"] = user_id,
        ["@vehicle"] = argument
    })

    return rows
end

--============================= [ADD VEHICLE] =============================
SqlCommands["fxserver-events-addVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("INSERT INTO vrp_user_vehicles (user_id, vehicle, plate, phone) VALUES(@user_id, @vehicle, @plate, @phone)"
        , {
        ["@user_id"] = user_id,
        ["@vehicle"] = argument,
        ["@plate"] = vRP.generatePlateNumber(),
        ["@phone"] = vRP.getPhone(user_id)
    })

    return rows
end

--============================= [REM VEHICLE] =============================
SqlCommands["fxserver-events-removeVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("DELETE FROM vrp_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle",
        {
            ["@user_id"] = user_id,
            ["@vehicle"] = argument
        })

    return rows
end

--============================= [EXEC SQL] =============================
SqlCommands["fxserver-events-customSQL"] = function(sql, user_id)

    local rows = MySQL.Sync.fetchAll(sql, {
        ["@user_id"] = user_id,
    })

    return rows
end

--============================= [CREATE REMOVALS TABLE] ===================
SqlCommands["fxserver-events-createRemovalsTable"] = function()

    MySQL.Sync.execute("CREATE TABLE IF NOT EXISTS centralcart_removals (id int(11) NOT NULL AUTO_INCREMENT, command varchar(255) NOT NULL, user_id int(11) NOT NULL, value varchar(255) NOT NULL, expiry_date timestamp NOT NULL DEFAULT current_timestamp(), PRIMARY KEY (id))")

end

--============================= [CHECK REMOVAL EXISTS] ===================
SqlCommands["fxserver-events-checkRemoval"] = function(user_id, command, value)

    local rows = MySQL.Sync.fetchAll("SELECT expiry_date FROM centralcart_removals WHERE user_id = @user_id AND command = @command AND value = @value"
        ,
        {
            ["@user_id"] = user_id,
            ["@command"] = command,
            ["@value"] = value,
        })

    return rows

end

--============================= [ADD REMOVAL] =============================
SqlCommands["fxserver-events-addRemoval"] = function(user_id, command, value, expiry_date)

    local rows = MySQL.Sync.fetchAll("INSERT INTO centralcart_removals (user_id, command, value, expiry_date) VALUES(@user_id, @command, @value, @expiry_date)"
        , {
        ["@user_id"] = user_id,
        ["@command"] = command,
        ["@value"] = value,
        ["@expiry_date"] = expiry_date
    })

    return rows
end

--============================= [UPDATE REMOVAL] =============================
SqlCommands["fxserver-events-updateRemoval"] = function(user_id, command, value, expiry_date)

    local rows = MySQL.Sync.fetchAll("UPDATE centralcart_removals SET expiry_date = @expiry_date WHERE user_id = @user_id AND command = @command AND value = @value"
        , {
        ["@expiry_date"] = expiry_date,
        ["@user_id"] = user_id,
        ["@command"] = command,
        ["@value"] = value
    })

    return rows
end

--============================= [DESTROY REMOVAL] =============================
SqlCommands["fxserver-events-destroyRemoval"] = function(removal_id)

    local rows = MySQL.Sync.fetchAll('DELETE FROM centralcart_removals WHERE id = @id', {
        ['@id'] = removal_id
    })

    return rows
end

--============================= [GET REMOVALS] ============================
SqlCommands["fxserver-events-getRemovals"] = function()

    local rows = MySQL.Sync.fetchAll("SELECT * FROM centralcart_removals WHERE expiry_date < current_timestamp()")

    return rows
end

--============================= [GET USER REMOVALS] ============================
SqlCommands["fxserver-events-getUserRemovals"] = function(user_id)

    local rows = MySQL.Sync.fetchAll("SELECT * FROM centralcart_removals WHERE user_id = @user_id"
        , {
        ['@user_id'] = user_id
    })

    return rows
end


return SqlCommands
