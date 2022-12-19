-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE USERS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_vrp_users","SELECT * FROM vrp_users WHERE id = @id")
vRP.prepare("vRP/get_vrp_registration","SELECT id FROM vrp_users WHERE registration = @registration")
vRP.prepare("vRP/get_vrp_phone","SELECT id FROM vrp_users WHERE phone = @phone")
vRP.prepare("vRP/get_characters","SELECT id,registration,phone,name,name2,bank FROM vrp_users WHERE steam = @steam and deleted = 0")
vRP.prepare("vRP/create_characters","INSERT INTO vrp_users(steam,name,name2) VALUES(@steam,@name,@name2)")
vRP.prepare("vRP/remove_characters","UPDATE vrp_users SET deleted = 1 WHERE id = @id")
vRP.prepare("vRP/update_characters","UPDATE vrp_users SET registration = @registration, phone = @phone WHERE id = @id")
vRP.prepare("vRP/update_name","UPDATE vrp_users SET name = @name, name2 = @name2 WHERE id = @id") 
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE BANK
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/set_bank","UPDATE vrp_users SET bank = @bank WHERE id = @id")
vRP.prepare("vRP/add_bank","UPDATE vrp_users SET bank = bank + @bank WHERE id = @id")
vRP.prepare("vRP/del_bank","UPDATE vrp_users SET bank = bank - @bank WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_vrp_infos","SELECT * FROM vrp_infos WHERE steam = @steam")
vRP.prepare("vRP/create_user","INSERT INTO vrp_infos(steam,discord) VALUES(@steam,@discord)")
vRP.prepare("vRP/update_discord","UPDATE vrp_infos SET discord = @discord WHERE steam = @steam")
vRP.prepare("vRP/update_whitelist","UPDATE vrp_infos SET whitelist = @whitelist WHERE steam = @steam")
vRP.prepare("vRP/set_banned","UPDATE vrp_infos SET banned = @banned WHERE steam = @steam")
vRP.prepare("vRP/set_whitelist","UPDATE vrp_infos SET whitelist = @whitelist WHERE steam = @steam")
vRP.prepare("vRP/update_gems","UPDATE vrp_infos SET gems = gems + @gems WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("playerdata/getUserdata","SELECT dvalue FROM vrp_users_data WHERE user_id = @user_id AND dkey = @key")
vRP.prepare("playerdata/setUserdata","REPLACE INTO vrp_users_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
vRP.prepare("playerdata/remUserdata","DELETE FROM vrp_users_data WHERE dkey = @dkey AND user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_SRV_DATA
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/set_srvdata","REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@key,@value)")
vRP.prepare("vRP/get_srvdata","SELECT dvalue FROM vrp_srv_data WHERE dkey = @key")

vRP.prepare("entitydata/removeData","DELETE FROM vrp_srv_data WHERE dkey = @dkey")
vRP.prepare("entitydata/getData","SELECT dvalue FROM vrp_srv_data WHERE dkey = @dkey")
vRP.prepare("entitydata/setData","REPLACE INTO vrp_srv_data(dkey,dvalue) VALUES(@dkey,@value)")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_PRIORITY
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/set_premium","UPDATE vrp_infos SET premium = @premium, predays = @predays, priority = @priority WHERE steam = @steam")
vRP.prepare("vRP/set_class","UPDATE vrp_users SET class = @class WHERE steam = @steam")
vRP.prepare("vRP/get_class","SELECT * FROM vrp_users WHERE id = @id AND class = @class")
vRP.prepare("vRP/update_priority","UPDATE vrp_infos SET premium = 0, predays = 0, priority = 0 WHERE steam = @steam")
vRP.prepare("vRP/set_priority","UPDATE vrp_infos SET priority = @priority WHERE steam = @steam")
vRP.prepare("vRP/update_premium","UPDATE vrp_infos SET predays = predays + @predays WHERE steam = @steam")
vRP.prepare("vRP/update_document","UPDATE vrp_users SET registration = @registration WHERE id = @id")
vRP.prepare("vRP/update_number","UPDATE vrp_users SET phone = @phone WHERE id = @id")
vRP.prepare("vRP/set_rank","UPDATE vrp_infos SET rank = @rank, level = @level WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_HOMES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/homePermission", "SELECT * FROM vrp_homes WHERE name = @name")
vRP.prepare("vRP/homeUserList", "SELECT * FROM vrp_homes WHERE user_id = @user_id AND premium = 0")
vRP.prepare("vRP/homeUserListPremium", "SELECT * FROM vrp_homes WHERE user_id = @user_id AND premium = 1")
vRP.prepare("vRP/homesCountPermiss", "SELECT COUNT(*) as qtd FROM vrp_homes WHERE name = @name")
vRP.prepare("vRP/homesRemPermission", "DELETE FROM vrp_homes WHERE name = @name AND user_id = @user_id")
vRP.prepare("vRP/homeUserPermission", "SELECT * FROM vrp_homes WHERE name = @name AND user_id = @user_id")
vRP.prepare("vRP/homeUserPermissionPremium", "SELECT * FROM vrp_homes WHERE user_id = @user_id and premium = 1")
vRP.prepare("vRP/homesNewPermission", "INSERT INTO vrp_homes(name,pricemin,interior,tax,user_id,owner,premium) VALUES (@name,@pricemin,@interior,@tax,@user_id,@owner,@premium)")
vRP.prepare("vRP/homesBuy", "INSERT INTO vrp_homes(name,user_id,interior,price,pricemin,residents,vault,fridge,owner,tax,premium) VALUES(@name,@user_id,@interior,@price,@pricemin,@residents,@vault,@fridge,1,@tax,@premium)")
vRP.prepare("vRP/homesRemAllPermission","DELETE FROM vrp_homes WHERE name = @name")
vRP.prepare("vRP/homesClearPermission", "DELETE FROM vrp_homes WHERE name = @name AND owner = 0")
vRP.prepare("vRP/homesSelling", "DELETE FROM vrp_homes WHERE name = @name")
vRP.prepare("vRP/homesCount","SELECT COUNT(*) as qtd FROM vrp_homes WHERE user_id = @user_id")	
vRP.prepare("vRP/homesVault", "UPDATE vrp_homes SET vault = vault + @vault WHERE name = @name AND owner = 1")
vRP.prepare("vRP/homesFridge", "UPDATE vrp_homes SET fridge = fridge + @fridge WHERE name = @name AND owner = 1")
vRP.prepare("vRP/homesResidents", "UPDATE vrp_homes SET residents = residents + @residents WHERE name = @name AND owner = 1")
vRP.prepare("vRP/homesTax", "UPDATE vrp_homes SET tax = @tax WHERE name = @name")
vRP.prepare("vRP/homesSeg", "UPDATE vrp_homes SET pricemin = @pricemin WHERE name = @name")
vRP.prepare("vRP/homesInterior", "UPDATE vrp_homes SET interior = @interior, price = @price, pricemin = @pricemin, residents = @residents, vault = @vault, fridge = @fridge, tax = @tax WHERE user_id = @user_id AND name = @name")
vRP.prepare("vRP/homesInteriorPermission", "UPDATE vrp_homes SET interior = @interior, pricemin = @pricemin WHERE name = @name")
vRP.prepare("vRP/homesOwnerPermission", "UPDATE vrp_homes SET owner = @owner WHERE user_id = @user_id AND name = @name")
vRP.prepare("vRP/updateOwnerHomes", "UPDATE vrp_homes SET user_id = @nuser_id WHERE user_id = @user_id AND name = @name")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE HOUSERENTAL
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_rental_time_home","SELECT * FROM vrp_homes WHERE user_id = @user_id AND rentalhome = 1")
vRP.prepare("vRP/set_rental_time_home","UPDATE vrp_homes SET home_time = @home_time, rentalhome = 1 WHERE user_id = @user_id AND home = @home")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_vehicle","SELECT * FROM vrp_users_vehicles WHERE user_id = @user_id")
vRP.prepare("vRP/get_vehicle_plate","SELECT * FROM vrp_users_vehicles WHERE plate = @plate")
vRP.prepare("vRP/rem_vehicle","DELETE FROM vrp_users_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/get_vehicles","SELECT * FROM vrp_users_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/set_update_vehicles","UPDATE vrp_users_vehicles SET engine = @engine, body = @body, fuel = @fuel, doors = @doors, windows = @windows, tyres = @tyres WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/set_arrest","UPDATE vrp_users_vehicles SET arrest = @arrest, time = @time WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vehicles/updateVehiclesTax","UPDATE vrp_users_vehicles SET tax = @tax WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/move_vehicle","UPDATE vrp_users_vehicles SET user_id = @nuser_id WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/add_vehicle","INSERT IGNORE INTO vrp_users_vehicles(user_id,vehicle,plate,work) VALUES(@user_id,@vehicle,@plate,@work)")
vRP.prepare("vRP/con_maxvehs","SELECT COUNT(vehicle) as qtd FROM vrp_users_vehicles WHERE user_id = @user_id AND work = 'false'")
vRP.prepare("vRP/rem_srv_data","DELETE FROM vrp_srv_data WHERE dkey = @dkey")
vRP.prepare("vRP/update_garages","UPDATE vrp_users SET garage = garage + 1 WHERE id = @id")
vRP.prepare("vRP/lose_garages","UPDATE vrp_users SET garage = garage - 1 WHERE id = @id")
vRP.prepare("vRP/update_plate_vehicle","UPDATE vrp_users_vehicles SET plate = @plate WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/set_dismantle","UPDATE vrp_users_vehicles SET dismantle = @dismantle WHERE user_id = @user_id AND vehicle = @vehicle")
vRP.prepare("vRP/get_rental_time","SELECT * FROM vrp_users_vehicles WHERE user_id = @user_id AND rental = 1")
vRP.prepare("vRP/set_rental_time","UPDATE vrp_users_vehicles SET rental_time = @rental_time, rental = 1 WHERE user_id = @user_id AND vehicle = @vehicle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("chests/getChests","SELECT * FROM vrp_chests WHERE name = @name")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_FINES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/add_fines","INSERT INTO vrp_fines(user_id,nuser_id,date,price,text) VALUES(@user_id,@nuser_id,@date,@price,@text)")
vRP.prepare("vRP/get_fines","SELECT * FROM vrp_fines WHERE user_id = @user_id")
vRP.prepare("vRP/del_fines","DELETE FROM vrp_fines WHERE id = @id AND user_id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_GEMS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/set_vrp_gems","UPDATE vrp_infos SET gems = gems + @gems WHERE steam = @steam")
vRP.prepare("vRP/rem_vrp_gems","UPDATE vrp_infos SET gems = gems - @gems WHERE steam = @steam")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE APPEARENCE
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_appearence","SELECT * FROM vrp_users WHERE id = @id")
vRP.prepare("vRP/set_appearence","UPDATE vrp_users SET appearence = 0 WHERE id = @id")
vRP.prepare("vRP/rem_appearence","UPDATE vrp_users SET appearence = 0 WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE PRISON
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/set_prison","UPDATE vrp_users SET prison = prison + @prison, locate = @locate WHERE id = @user_id")
vRP.prepare("vRP/rem_prison","UPDATE vrp_users SET prison = prison - @prison WHERE id = @user_id")
vRP.prepare("vRP/fix_prison","UPDATE vrp_users SET prison = 1 WHERE id = @user_id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_MDT
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/add_mdt","INSERT INTO vrp_mdt(user_id,officer,type,fine,prison,date,text) VALUES(@user_id,@officer,@type,@fine,@prison,@date,@text)")
vRP.prepare("vRP/get_mdt","SELECT * FROM vrp_mdt WHERE user_id = @user_id")
vRP.prepare("vRP/del_mdt","DELETE FROM vrp_mdt WHERE id = @id and user_id = @user_id")
vRP.prepare("vRP/get_mdt_type","SELECT * FROM vrp_mdt WHERE type = @type")
vRP.prepare("vRP/get_mdt_type_user","SELECT * FROM vrp_mdt WHERE user_id = @user_id AND type = @type")
vRP.prepare("vRP/add_weaponport","UPDATE vrp_users SET weaponport = 1 WHERE id = @id")
vRP.prepare("vRP/rem_weaponport","UPDATE vrp_users SET weaponport = 0 WHERE id = @id")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE VRP_MDTHOSPITAL
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/add_mdtmedic","INSERT INTO vrp_paramedic(user_id,medic,utils,type,box,date,text) VALUES(@user_id,@medic,@utils,@type,@box,@date,@text)")
vRP.prepare("vRP/update_mdtmedic","UPDATE vrp_paramedic SET medic = @medic, type = @type, date2 = @date2, text2 = @text2 WHERE id = @id")
vRP.prepare("vRP/update_prontuario","UPDATE vrp_paramedic SET medic = @medic, utils = @utils, type = @type, date2 = @date2, text2 = @text2 WHERE id = @id")
vRP.prepare("vRP/update_finalconsult","UPDATE vrp_paramedic SET date2 = @date2, text2 = @text2, utils = @utils WHERE id = @id")
vRP.prepare("vRP/get_medic_type","SELECT * FROM vrp_paramedic WHERE type = @type")
vRP.prepare("vRP/get_all_medic","SELECT * FROM vrp_paramedic WHERE id = @id")
vRP.prepare("vRP/get_medic_type_user","SELECT * FROM vrp_paramedic WHERE user_id = @user_id AND type = @type")
vRP.prepare("vRP/get_medic_type_user_medic","SELECT * FROM vrp_paramedic WHERE medic = @user_id AND type = @type")
vRP.prepare("vRP/update_consultas","UPDATE vrp_paramedic SET type = @type, medic = @user_id WHERE id = @id")
vRP.prepare("vRP/update_myconsults","UPDATE vrp_paramedic SET date = @date WHERE id = @id")
vRP.prepare("vRP/del_consultas","DELETE FROM vrp_paramedic WHERE id = @id")
vRP.prepare("vRP/add_usermedic","INSERT INTO vrp_usermedic(user_id,type,quantity,text,date) VALUES(@user_id,@type,@quantity,@text,@date)")
vRP.prepare("vRP/get_usermedic","SELECT * FROM vrp_usermedic WHERE type = @type AND user_id = @user_id")
vRP.prepare("vRP/get_allmedic","SELECT * FROM vrp_usermedic WHERE type = @type")
vRP.prepare("vRP/update_usermedic","UPDATE vrp_usermedic SET text = @text WHERE user_id = @user_id AND type = @type")
vRP.prepare("vRP/update_blood","UPDATE vrp_usermedic SET quantity = quantity + 1, date = @date WHERE user_id = @user_id AND type = @type")
vRP.prepare("vRP/del_usermedic","DELETE FROM vrp_usermedic WHERE id = @id")
vRP.prepare("vRP/set1_paramedic_promotion","UPDATE vrp_permissions SET paramedic_time = paramedic_time + 1 WHERE user_id = @user_id AND permiss = @permiss")
vRP.prepare("vRP/rem_paramedic_promotion","UPDATE vrp_permissions SET paramedic_time = paramedic_time - 1 WHERE user_id = @user_id AND permiss = @permiss")
vRP.prepare("vRP/get_top_working","SELECT * FROM vrp_worktime WHERE job = @job ORDER BY time DESC LIMIT @limit")
vRP.prepare("vRP/get_top_working_by_user_id","SELECT * FROM vrp_worktime WHERE user_id = @user_id AND job = @job")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLEARTABLES
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("hiro/ClearPlayerData","DELETE FROM vrp_users_data WHERE dvalue = '[]' OR dvalue = '{}'")
vRP.prepare("hiro/ClearEntityData","DELETE FROM vrp_srv_data WHERE dvalue = '[]' OR dvalue = '{}'")
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADCLEANERS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	vRP.query("hiro/ClearPlayerData")
	vRP.query("hiro/ClearEntityData")
end)