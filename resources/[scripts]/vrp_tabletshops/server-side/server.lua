-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPC = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("tabletshops",cRP)
vCLIENT = Tunnel.getInterface("tabletshops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PREPARE BANK BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
vRP.prepare("vRP/get_business","SELECT * FROM vrp_business WHERE user_id = @user_id AND business = @business")
vRP.prepare("vRP/getname_business","SELECT * FROM vrp_business WHERE business = @business AND owner = 1")
vRP.prepare("vRP/get_owner_business","SELECT * FROM vrp_business WHERE user_id = @user_id AND business = @business AND owner = 1")
vRP.prepare("vRP/rem_permission","DELETE FROM business WHERE vrp_business = @business AND user_id = @user_id")
vRP.prepare("vRP/put_business","INSERT INTO vrp_business(business,user_id,owner,cash) VALUES(@business,@user_id,@owner,@cash)")
vRP.prepare("vRP/deposit_business","UPDATE vrp_business SET cash = cash + @cash WHERE business = @business AND owner = 1")
vRP.prepare("vRP/withdraw_business","UPDATE vrp_business SET cash = cash - @cash WHERE business = @business AND owner = 1")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLE
-----------------------------------------------------------------------------------------------------------------------------------------
local shopsRestaurant = {
    ["catCoffe"] = {
        ["permiss"] = "catCoffe",
        ["masterPermiss"] = "catCoffeMaster",
        ["businessName"] = "catCoffe",
        ["sellItems"] = {
            "FoodTorradacomgeleia",
            "FoodTapioca",
            "Foodhamburger",
            "Fooddonut",
            "FoodSonho",
            "FoodBrigadeiro",
            "FoodSanduichenatural",
            "FoodMacaron",
            "FoodCheesecake",
            "FoodCoxinha",
            "FoodBolo",
            "FoodPudim",
            "FoodTortaAlema",
            "FoodLimonada",
            "FoodMilkshake",
            "FoodChurros",
        },
        ["buyItems"] = {
			"farinhadetrigo",
			"geleia",
			"torrada",
			"ovo",
			"FoodmilkThirst",
			"acucar",
			"cacau",
			"frango",
			"pao",
			"proteina",
			"queijo",
			"morangocortado",
			"bananacortada",
			"laranjacortada",
			"potatos",
			"claraemneve",
			"massa",
			"leitecondensado",
			"goma",
			"sorvete",
			"salada",
			"meat",
            
        }
    },
    ["coolBeans"] = {
        ["permiss"] = "coolBeans",
        ["masterPermiss"] = "coolBeansMaster",
        ["businessName"] = "coolBeans",
        ["sellItems"] = {
            "FoodPaodequeijo",
            "FoodBolo",
            "FoodSanduichenatural",
            "FoodPastel",
            "Foodhamburger",
            "Foodsaladadefrutas",
            "FoodBatataFrita",
            "FoodBaguette",
            "FoodPaonachapa",
            "FoodMistoquente",
            "FoodCroissant",
            "FoodCoxinha",
            "FoodChurros",
        },
        ["buyItems"] = {
			"farinhadetrigo",
			"geleia",
			"torrada",
			"ovo",
			"FoodmilkThirst",
			"acucar",
			"cacau",
			"frango",
			"pao",
			"proteina",
			"queijo",
			"morangocortado",
			"bananacortada",
			"laranjacortada",
			"potatos",
			"claraemneve",
			"massa",
			"leitecondensado",
			"goma",
			"sorvete",
			"salada",
			"meat",
            "manteiga"
        }
    },
    ["Pearls"] = {
        ["permiss"] = "Pearls",
        ["masterPermiss"] = "PearlsMaster",
        ["businessName"] = "Pearls",
        ["sellItems"] = {
            "FoodHotrollSalmao",
            "FoodHotrollAtum",
            "FoodNiguiriSalmao",
            "FoodNiguiriAtum",
            "FoodTemakiSalmao",
            "FoodTemakiAtum",
            "FoodSashimiSalmao",
            "FoodSashimiAtum",
            "FoodHossomakiSalmao",
            "FoodHossomakiAtum",
            "FoodCeviche",
            "FoodYakisoba",
            "FoodPudim",
            "FoodTortaAlema",
            "FoodLimonada",
            "FoodMilkshake",
        },
        ["buyItems"] = {
			"farinhadetrigo",
			"geleia",
			"torrada",
			"ovo",
			"FoodmilkThirst",
			"acucar",
			"cacau",
			"frango",
			"pao",
			"proteina",
			"queijo",
			"morangocortado",
			"bananacortada",
			"laranjacortada",
			"potatos",
			"claraemneve",
			"massa",
			"leitecondensado",
			"goma",
			"sorvete",
			"salada",
			"meat"
        }
    },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPEN RESTAURANT-
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.openRestaurant(restaurantName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if shopsRestaurant[restaurantName] then
            local inventoryShop = {}
            for k,v in pairs(shopsRestaurant[restaurantName]["sellItems"]) do
                table.insert(inventoryShop,{ name = vRP.itemNameList(v), index = vRP.itemIndexList(v), indexName = v, key = k })
            end

            local inventoryShop2 = {}
            for k,v in pairs(shopsRestaurant[restaurantName]["buyItems"]) do
                table.insert(inventoryShop2,{ name = vRP.itemNameList(v), index = vRP.itemIndexList(v), indexName = v, key = k })
            end

            local consult = exports["oxmysql"]:executeSync("SELECT `cash` FROM `vrp_business` WHERE `business` = ?",{ shopsRestaurant[restaurantName]["businessName"] })

            return inventoryShop,inventoryShop2,vRP.hasPermission(user_id,shopsRestaurant[restaurantName]["masterPermiss"]),parseFormat(consult[1]["cash"])
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST PERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(restaurantName)
    local source = source
    local user_id = vRP.getUserId(source)
	return (user_id and not vRP.wantedReturn(user_id) and vRP.hasPermission(user_id,shopsRestaurant[restaurantName]["permiss"]))
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADD BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.addBusiness(nuser_id,restaurantName)
    local source = source 
    local user_id = vRP.getUserId(source)
    if user_id then
        local query = vRP.query("vRP/get_business",{ user_id = nuser_id, business = shopsRestaurant[restaurantName]["businessName"] })
        if not query[1] then
            local business = vRP.query("vRP/get_business",{ user_id = user_id, business = shopsRestaurant[restaurantName]["businessName"] })
            if business[1] then
                if vRP.hasPermission(nuser_id,shopsRestaurant[restaurantName]["permiss"]) then
                    vRP.query("vRP/put_business",{ user_id = nuser_id, business = shopsRestaurant[restaurantName]["businessName"], cash = 0, owner = 0 })
                    local identity = vRP.getUserIdentity(nuser_id)
                    if identity then
                        TriggerClientEvent("Notify",source,"success","Sociedade adicionada para <b>"..identity["name"].." "..identity["name2"].."</b>.",5000)
                    end
                else
                    TriggerClientEvent("Notify",source,"error","O passaporte <b>"..nuser_id.."</b> não faz parte da sua empresa.",5000)
                end
            end
        else
            TriggerClientEvent("Notify",source,"error","O passaporte <b>"..nuser_id.."</b> já faz parte da sua empresa.",5000)
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.remBusiness(nuser_id,restaurantName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local business = vRP.query("vRP/get_business",{ user_id = user_id, business = shopsRestaurant[restaurantName]["businessName"] })
        if business[1] then
            vRP.query("vRP/rem_permission",{ user_id = nuser_id, business = shopsRestaurant[restaurantName]["businessName"] })
            local identity = vRP.getUserIdentity(nuser_id)
            if identity then
                TriggerClientEvent("Notify",source,"success","Sociedade retirada de <b>"..identity["name"].." "..identity["name2"].."</b>.",5000)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEPOSIT BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.depositBusiness(amount,restaurantName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        if vRP.hasPermission(user_id,shopsRestaurant[restaurantName]["permiss"]) then 
            if vRP.paymentBank(user_id,parseInt(amount)) then
                setCashBusiness(user_id,shopsRestaurant[restaurantName]["businessName"],parseInt(amount))
                TriggerClientEvent("Notify",source,"success","Você adicionou <b>"..parseFormat(amount).."</b> ao caixa de <b>"..shopsRestaurant[restaurantName]["businessName"].."</b>.",5000)
                TriggerClientEvent("tabletshops:Update",source,"buyPage")
            else
                TriggerClientEvent("Notify",source,"error","Dinheiro insuficiente na sua conta bancária.",5000)
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REM BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.withdrawBusiness(amount,restaurantName)
    local source = source
    local user_id = vRP.getUserId(source)
    if user_id then
        local business = vRP.query("vRP/get_business",{ user_id = user_id, business = shopsRestaurant[restaurantName]["businessName"] })
        if business[1] then
            if vRP.hasPermission(user_id,shopsRestaurant[restaurantName]["masterPermiss"]) then
                if paymentBusiness(user_id,shopsRestaurant[restaurantName]["businessName"],parseInt(amount)) then
                    vRP.addBank(user_id, parseInt(amount))
                    TriggerClientEvent("Notify",source,"success","Você sacou <b>"..parseFormat(amount).."</b> do caixa de <b>"..shopsRestaurant[restaurantName]["businessName"].."</b>.",5000)
                    TriggerClientEvent("tabletshops:Update",source,"buyPage")
				else
					TriggerClientEvent("Notify",source,"negado","O restaurante especificado não possui saldo suficiente!")
				end
            end
        else
			TriggerClientEvent("Notify",source,"negado","Você não possui permissão suficiente!")
		end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function paymentBusiness(user_id,shopid,amount)
    if amount > 0 then
        local consult = vRP.query("vRP/getname_business",{ business = tostring(shopid) })
        if consult[1] and consult[1]["cash"] >= amount then
			vRP.query("vRP/withdraw_business",{ business = tostring(shopid), cash = parseInt(amount)  })
			return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SET CASH BUSINESS
-----------------------------------------------------------------------------------------------------------------------------------------
function setCashBusiness(user_id,shopid,amount)
    if amount > 0 then
        local consult = vRP.query("vRP/getname_business",{ business = tostring(shopid) })
        if consult[1] then
            vRP.query("vRP/deposit_business",{ business = tostring(shopid), cash = parseInt(amount)  })
        end
    end
end

function printError(...)
	print("^1[ERRO]^7", ...)
end