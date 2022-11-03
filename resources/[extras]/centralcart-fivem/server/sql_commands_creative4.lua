--=======================================================================
--======================= [LISTA SQL CREATIVE] ==========================
--=======================================================================

local SqlCommands = {}


--============================= [BAN] =============================
SqlCommands["fxserver-events-ban"] = function(user_id)

    local steam_id = vRP.getUserIdentity(user_id)["steam"]
    local rows = MySQL.Sync.fetchAll("INSERT INTO summerz_banneds (steam) VALUES (?)", {
        steam_id
    })

    return rows
end

--============================= [UNBAN] =============================
SqlCommands["fxserver-events-unban"] = function(user_id)

    local steam_id = vRP.getUserIdentity(user_id)["steam"]
    local rows = MySQL.Sync.fetchAll("DELETE FROM summerz_banneds WHERE steam = ?", {
        steam_id
    })

    return rows
end

--============================= [GET USER DATA TABLE] =============================
SqlCommands["fxserver-get-user-datatables"] = function(user_id)

    local rows = MySQL.Sync.fetchAll("SELECT * FROM summerz_playerdata WHERE dkey = 'Datatable' AND user_id = ?"
        ,
        {
            user_id
        })

    return rows
end

--============================= [ADD GROUP] =============================
SqlCommands["fxserver-events-group"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE summerz_playerdata SET dvalue = ? WHERE dkey = 'Datatable' AND user_id = ?"
        , {
        json.encode(parsed_dvalue),
        user_id,
    })

    return rows
end

--============================= [REM GROUP] =============================
SqlCommands["fxserver-events-ungroup"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE summerz_playerdata SET dvalue = ? WHERE dkey = 'Datatable' AND user_id = ?"
        , {
        json.encode(parsed_dvalue),
        user_id,
    })

    return rows
end

--============================= [ADDBANK] =============================
SqlCommands["fxserver-events-addBank"] = function(user_id, amount)

    local rows = MySQL.Sync.fetchAll("UPDATE summerz_characters SET bank = bank + ? WHERE id = ?"
        ,
        {
            tonumber(amount),
            user_id,
        })

    return rows
end

--============================= [REM BANK] =============================
SqlCommands["fxserver-events-removeBank"] = function(user_id, amount)

    local rows = MySQL.Sync.fetchAll("UPDATE summerz_characters SET bank = bank - ? WHERE id = ?"
        ,
        {
            tonumber(amount),
            user_id,
        })

    return rows
end

--============================= [ADD ITEM] =============================
SqlCommands["fxserver-events-addInventory"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE summerz_playerdata SET dvalue = ? WHERE dkey = 'Datatable' AND user_id = ?"
        , {
        json.encode(parsed_dvalue),
        user_id,
    })

    return rows
end

--============================= [REM ITEM] =============================
SqlCommands["fxserver-events-removeInventory"] = function(user_id, parsed_dvalue)

    local rows = MySQL.Sync.fetchAll("UPDATE summerz_playerdata SET dvalue = ? WHERE dkey = 'Datatable' AND user_id = ?"
        , {
        json.encode(parsed_dvalue),
        user_id,
    })

    return rows
end

--============================= [CHECK HOME] =============================
SqlCommands["fxserver-events-checkHome"] = function(argument)

    local rows = MySQL.Sync.fetchAll("SELECT * from summerz_propertys WHERE name = ?", {
        argument
    })

    return rows
end

--============================= [ADD HOME] =============================
SqlCommands["fxserver-events-addHome"] = function(user_id, argument, number)
    local rows = MySQL.Sync.fetchAll("INSERT IGNORE INTO summerz_propertys(name, user_id, interior, price, tax, residents, vault, fridge, contract) VALUES(?, ?, ?, ?, UNIX_TIMESTAMP() + 604800, ?, ?, ?, ?)"
        , {
        argument, user_id, "Middle", 125000,
        2, 50, 10, 1
    })

    return rows
end

--============================= [REM HOME] =============================
SqlCommands["fxserver-events-removeHome"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("DELETE FROM summerz_propertys WHERE user_id = ? AND name = ?", {
        user_id,
        argument
    })

    return rows
end

--============================= [HAS VEHICLE] =============================
SqlCommands["fxserver-events-hasVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("SELECT user_id FROM summerz_vehicles WHERE user_id = ? AND vehicle = ?", {
        user_id,
        argument
    })

    return rows
end

--============================= [ADD VEHICLE] =============================
SqlCommands["fxserver-events-addVehicle"] = function(user_id, argument)

    local lett = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local nums = "0123456789"

    local plate = string.gsub('KKIIIKKK', '[KI]', function(char)
        local all = char == 'D' and nums or lett
        local index = math.random(#all)
        return all:sub(index, index)
    end)

    local rows = MySQL.Sync.fetchAll("INSERT INTO summerz_vehicles (user_id, vehicle, plate) VALUES(?, ?, ?)"
        ,
        {
            user_id,
            argument,
            plate
        })

    return rows
end

--============================= [REM VEHICLE] =============================
SqlCommands["fxserver-events-removeVehicle"] = function(user_id, argument)

    local rows = MySQL.Sync.fetchAll("DELETE FROM summerz_vehicles WHERE user_id = ? AND vehicle = ?"
        , {
        user_id,
        argument
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

    MySQL.Sync.fetchAll("CREATE TABLE IF NOT EXISTS centralcart_removals (id int(11) NOT NULL AUTO_INCREMENT, command varchar(255) NOT NULL, user_id int(11) NOT NULL, value varchar(255) NOT NULL, expiry_date timestamp NOT NULL DEFAULT current_timestamp(), PRIMARY KEY (id))")

end

--============================= [CHECK REMOVAL EXISTS] ===================
SqlCommands["fxserver-events-checkRemoval"] = function(user_id, command, value)

    local rows = MySQL.Sync.fetchAll("SELECT expiry_date FROM centralcart_removals WHERE user_id = ? AND command = ? AND value = ?"
        ,
        {
            user_id,
            command,
            value,
        })

    return rows
end

--============================= [ADD REMOVAL] =============================
SqlCommands["fxserver-events-addRemoval"] = function(user_id, command, value, expiry_date)

    local rows = MySQL.Sync.fetchAll("INSERT INTO centralcart_removals (user_id, command, value, expiry_date) VALUES(?, ?, ?, ?)"
        , {
        user_id,
        command,
        value,
        expiry_date
    })

    return rows
end

--============================= [UPDATE REMOVAL] =============================
SqlCommands["fxserver-events-updateRemoval"] = function(user_id, command, value, expiry_date)

    local rows = MySQL.Sync.fetchAll("UPDATE centralcart_removals SET expiry_date = ? WHERE user_id = ? AND command = ? AND value = ?"
        , {
        expiry_date,
        user_id,
        command,
        value
    })

    return rows
end

--============================= [DESTROY REMOVAL] =============================
SqlCommands["fxserver-events-destroyRemoval"] = function(removal_id)

    local rows = MySQL.Sync.fetchAll('DELETE FROM centralcart_removals WHERE id = ?', {
        removal_id
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

    local rows = MySQL.Sync.fetchAll("SELECT * FROM centralcart_removals WHERE user_id = ?"
        , {
        user_id
    })

    return rows
end


return SqlCommands
