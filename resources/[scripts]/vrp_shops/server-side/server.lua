-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
cRP = {}
Tunnel.bindInterface("vrp_shops",cRP)
vCLIENT = Tunnel.getInterface("vrp_shops")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local shops = {
	["departamentStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["notepad"] = 20,
			["energetic"] = 220,
			["emptybottle"] = 75,
			["cigarette"] = 25,
			["lighter"] = 175,
			["backpack"] = 5000,
			["clothes"] = 10000,
			["rope"] = 975,
			["teddy"] = 500,
			["rose"] = 25,
			["firecracker"] = 175,
			["aliancas"] = 1500,
			["Foodcookies"] = 25,
		}
	},
	["ingredientsStore"] = {
		["mode"] = "Buy",
		["type"] = "Market",
		["list"] = {
			["farinhadetrigo"] = 10,
			["geleia"] = 10,
			["torrada"] = 10,
			["ovo"] = 10,
			["milk"] = 10,
			["acucar"] = 10,
			["cacau"] = 10,
			["frango"] = 10,
			["pao"] = 10,
			["proteina"] = 10,
			["queijo"] = 10,
			["morangocortado"] = 10,
			["bananacortada"] = 10,
			["laranjacortada"] = 10,
			["potatos"] = 10,
			["claraemneve"] = 10,
			["massa"] = 10,
			["leitecondensado"] = 10,
			["goma"] = 10,
			["sorvete"] = 10,
			["salada"] = 10,
			["Gohan"] = 10,
			["salmaocortado"] = 10,
			["Nori"] = 10,
			["atumcortado"] = 10,
			["lulacortada"] = 10,
			["camaraolimpo"] = 10,
			["tomatecortado"] = 10,
			["Macarrao"] = 10,
			["caldadechocolate"] = 10,
			["carp"] = 10,
			["Foodsorvete"] = 10,
			["meat"] = 10,
			["alfacelavada"] = 10,
			["manteiga"] = 10,
		}
	},
	["pharmacyStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Paramedic",
		["list"] = {
			["gauze"] = 40,
			["syringe"] = 40,
			["bandage"] = 37,
			["serum"] = 25,
			["analgesic"] = 5,
			["warfarin"] = 125,
			["sinkalmy"] = 75,
			["ritmoneury"] = 100,
			["adrenaline"] = 250,
			["WEAPON_FLASHLIGHT"] = 1,
			["gsrkit"] = 1,
			["gdtkit"] = 1,
			["bagempty"] = 1,
			["reagentmedic"] = 1,
			["watermedic"] = 1,
			["dorflex"] = 1,
			["bepantol"] = 1,
			["buscopan"] = 1,
			["heparina"] = 1,
			["paracetamol"] = 1,
			["defibrillator"] = 1,
			["pressure"] = 1,
			["plaster"] = 1,
			["anesthesia"] = 1,
			["deadbag"] = 1,
			["testx"] = 1,
		}
	},
	["pediatraStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Paramedic",
		["list"] = {
			["defibrillatorkids"] = 1,
			["thermometer"] = 1,
			["dnatest"] = 1,
			["bloodtest"] = 1,
			["alergictest"] = 1,
			["pregnantrisk"] = 1
		}
	},
	["pharmacyMasterStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "ParMaster",
		["list"] = {
			["apparencechange"] = 15000
		}
	},
	["weedStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "weedStore",
		["list"] = {
			["FoodBrisadeiro"] = 15,
			["FoodCoxonha"] = 15,
			["FoodRefrigeronha"] = 15,
			["vape"] = 2500
		}
	},
	["ammunationStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["GADGET_PARACHUTE"] = 975,
			["WEAPON_KNIFE"] = 975,
			["WEAPON_HATCHET"] = 975,
			["WEAPON_BAT"] = 975,
			["WEAPON_BATTLEAXE"] = 975,
			["WEAPON_BOTTLE"] = 975,
			["WEAPON_CROWBAR"] = 975,
			["WEAPON_DAGGER"] = 975,
			["WEAPON_GOLFCLUB"] = 975,
			["WEAPON_HAMMER"] = 975,
			["WEAPON_MACHETE"] = 975,
			["WEAPON_POOLCUE"] = 975,
			["WEAPON_STONE_HATCHET"] = 975,
			["WEAPON_SWITCHBLADE"] = 975,
			["WEAPON_KNUCKLE"] = 975,
			["WEAPON_FLASHLIGHT"] = 975
		}
	},
	["rentalStore"] = {
		["mode"] = "Buy",
		["type"] = "Consume",
		["item"] = "carpass",
		["list"] = {
            ["rentalaudir899"] = 1,
			["rentalbmwgs1200r99"] = 1,
			["rentalbmwm3gtr99"] = 1,
            ["rentalcb500x99"] = 1,
			["rentalcullinan99"] = 1,
			["rentale40099"] = 1,
			["rentalferrari48899"] = 1,
			["rentaljeepcherokee99"] = 1,
			["rentallamborghiniurus99"] = 1,
			["rentallancerevolutionx99"] = 1,
			["rentalmazdarx799"] = 1,
			["rentalnissanskyliner3499"] = 1,
			["rentalpts2199"] = 1,
			["rentalr3299"] = 1,
			["rentalsilvia99"] = 1,
			["rentalsubaruwrx200499"] = 1,
			["rentalvwgolfgti99"] = 1,
			["rentalcelta99"] = 1,
			["rentaleg699"] = 1,

			["rentalhondafk830"] = 1,
			["rentallamborghinihuracan30"] = 1,
			["rentalnissangtr30"] = 1,
			["rentalporschepanamera30"] = 1,
			["rentaltoyotasupra30"] = 1,
			["rentalvwamarok30"] = 1,
			["rentalrmodgt6330"] = 1
		}
	},
	["fishingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["shrimp"] = 60,
			["octopus"] = 40,
			["carp"] = 30,
			["salmon"] = 25,
			["crab"] = 30,
			["tuna"] = 30,
		}
	},
	["hunterSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["meat"] = 110
		}
	},
	["recyclingSell"] = {
		["mode"] = "Sell",
		["type"] = "Cash",
		["list"] = {
			["plastic"] = 22,
			["glass"] = 22,
			["rubber"] = 25,
			["aluminum"] = 25,
			["copper"] = 40,
			["cellphone"] = 675,
			["notepad"] = 10,
			["camera"] = 275,
			["eletronics"] = 25,
			["binoculars"] = 275,
			["teddy"] = 250,
			["emptybottle"] = 25,
			["lighter"] = 100,
		}
	},
	["megaMall"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["plastic"] = 42,
			["glass"] = 42,
			["rubber"] = 55,
			["aluminum"] = 45,
			["copper"] = 80
		}
	},
	["fishingStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["bait"] = 15,
			["fishingrod"] = 525
		}
	},
	["hunterStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["WEAPON_MUSKET"] = 7000,
			["WEAPON_MUSKET_AMMO"] = 20,
			["knifehunter"] = 976
		}
	},
	["capsuleSell"] = {
		["mode"] = "Buy",
		["type"] = "Sell",
		["list"] = {
			["capsule"] = 20,
		}
	},
	["motoclubeStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Municao03",
		["list"] = {
			["Foodamendoim"] = 80,
			["Foodmilhocozido"] = 130,
			["energetic"] = 70,
			["Foodcola"] = 38,
			["Foodsoda"] = 38,
			["Foodabsolut"] = 70,
			["Foodheineken"] = 65,
			["FoodAmantegada"] = 55,
			["Foodjackdaniels"] = 60,
			["Foodbeer"] = 25
		}
	},
	["digitalDen"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["radio"] = 970,
			["cellphone"] = 975,
			["binoculars"] = 575,
			["camera"] = 575,
			["vape"] = 4250
		}
	},
	["coolBeans"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "coolBeans",
		["list"] = {
			["Foodcola"] = 16,
			["Foodsoda"] = 16,
			["FoodCafecomleite"] = 16,
			["FoodCapuccino"] = 16,
			["FoodChocohot"] = 15,
			["Foodchocolate"] = 15,
			["Foodsucodelaranja"] = 15,
			["FoodCha"] = 15,
			["FoodSaque"] = 15,
			["Foodbeer"] = 25,
		}
	},
	["catCoffe"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "catCoffe",
		["list"] = {
			["FoodCha"] = 15,
			["FoodSaque"] = 15,
			["Foodcola"] = 16,
			["Foodsoda"] = 16,
			["Foodbeer"] = 12,
			["Foodsucodelaranja"] = 15,
			["FoodCafecomleite"] = 16,
			["FoodCapuccino"] = 16,
			["FoodChocohot"] = 16,
			["Foodchocolate"] = 15,
		}
	},
	["Pearls"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Pearls",
		["list"] = {
			["FoodCha"] = 15,
			["FoodSaque"] = 15,
			["Foodcola"] = 16,
			["Foodsoda"] = 16,
			["Foodbeer"] = 12,
			["Foodsucodelaranja"] = 15,
			["FoodCafecomleite"] = 16,
			["FoodCapuccino"] = 16,
			["FoodChocohot"] = 16,
			["Foodchocolate"] = 15,
		}
	},
	["TequilalaBar"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Tequilala",
		["list"] = {
			["energetic"] = 70,
			["Foodcola"] = 38,
			["Foodsoda"] = 38,
			["Foodabsolut"] = 70,
			["Foodheineken"] = 65,
			["FoodAmantegada"] = 55,
			["Foodjackdaniels"] = 60,
			["Foodbeer"] = 25
		}
	},
	["Galaxy"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Galaxy",
		["list"] = {
			["energetic"] = 70,
			["Foodcola"] = 38,
			["Foodsoda"] = 38,
			["Foodabsolut"] = 70,
			["Foodchandon"] = 65,
			["Fooddewars"] = 55,
			["Foodhennessy"] = 60,
			["Foodbeer"] = 25
		}
	},
	["Bahamas"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Bahamas",
		["list"] = {
			["energetic"] = 50,
			["Foodcola"] = 38,
			["Foodsoda"] = 38,
			["Foodabsolut"] = 40,
			["Foodchandon"] = 45,
			["Fooddewars"] = 25,
			["Foodsarradinha"] = 70,
			["Foodbeer"] = 25,
			["Foodmargarita"] = 50,
			["Foodchampanhe"] = 50,
		}
	},
	["Vanilla"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Vanilla",
		["list"] = {
			["energetic"] = 50,
			["Foodcola"] = 38,
			["Foodsoda"] = 38,
			["Foodabsolut"] = 40,
			["Foodchandon"] = 45,
			["Fooddewars"] = 25,
			["Foodhennessy"] = 30,
			["Foodbeer"] = 25,
			["pinklemonade"] = 50,
			["Foodboanoite"] = 50,
		}
	},
	["Cassino"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Cassino",
		["list"] = {
			["energetic"] = 50,
			["Foodcola"] = 38,
			["Foodsoda"] = 38,
			["Foodabsolut"] = 40,
			["Foodchandon"] = 45,
			["Fooddewars"] = 25,
			["Foodhennessy"] = 30,
			["Foodbeer"] = 25,
			["Foodmartini"] = 50,
			["Foodmanhattan"] = 50,
			["Foodgintonic"] = 50,
			["Foodwhiskey"] = 50
		}
	},
	["coffeeMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["Foodcoffee"] = 130
		}
	},
	["sodaMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["Foodsoda"] = 130
		}
	},
	["colaMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["Foodcola"] = 130
		}
	},
	["donutMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["Fooddonut"] = 120,
			["Foodchocolate"] = 150
		}
	},
	["burgerMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["Foodhamburger"] = 130
		}
	},
	["hotdogMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["Foodhotdog"] = 130
		}
	},
	["waterMachine"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["water"] = 85
		}
	},
	["advancedStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Mechanic",
		["list"] = {
			["oil"] = 200,
			["brake_pads"] = 200,
			["shock_absorber"] = 200,
			["clutch"] = 200,
			["air_filter"] = 200,
			["fuel_filter"] = 200,
			["spark_plugs"] = 200,
			["serpentine_belt"] = 200,
			["susp"] = 200,
			["susp1"] = 200,
			["susp2"] = 200,
			["susp3"] = 200,
			["susp4"] = 200,
			["piston"] = 200,
			["gear"] = 200,
			["scanner"] = 200
		}
	},
	["mechanicStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Mechanic",
		["list"] = {
			["toolbox"] = 100,
			["WEAPON_FIREEXTINGUISHER"] = 150,
			["tires"] = 50,
			["WEAPON_WRENCH"] = 725
		}
	},
	["Desmanche01"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Desmanche01",
		["list"] = {
			["plate"] = 750,
			["fueltech"] = 2500,
			["nitrous"] = 5000
		}
	},		
	["policeStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "Police",
		["list"] = {
			["WEAPON_SMG"] = 1,
			["WEAPON_COMBATPDW"] = 1,
			["WEAPON_PUMPSHOTGUN"] = 1,
			["WEAPON_CARBINERIFLE"] = 1,
			["WEAPON_CARBINERIFLE_MK2"] = 1,
			-- ["WEAPON_FNFAL"] = 1,
			["WEAPON_COMBATPISTOL"] = 1,
			-- ["WEAPON_REVOLVER"] = 1,
			["WEAPON_HEAVYPISTOL"] = 1,
			["WEAPON_STUNGUN"] = 1,
			["WEAPON_FIREEXTINGUISHER"] = 1,
			["WEAPON_PISTOL_AMMO"] = 1,
			["WEAPON_SMG_AMMO"] = 1,
			["WEAPON_RIFLE_AMMO"] = 1,
			["WEAPON_SHOTGUN_AMMO"] = 1,
			["WEAPON_FLASHLIGHT"] = 1,
			["gsrkit"] = 1,
			["gdtkit"] = 1,
			["handcuff"] = 1,
			["radio"] = 1,
			["WEAPON_NIGHTSTICK"] = 1,
			["vest"] = 1
		}
    },
	["PolicePort"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["perm"] = "PoliceMaster",
		["list"] = {
			["WEAPON_PISTOL"] = 50000,
			["WEAPON_PISTOL_AMMO"] = 300,
		}
	},
	["lesterStore"] = {
	    ["mode"] = "Sell",
	    ["type"] = "Cash2",
	    ["list"] = {
			["keyboard"] = 1000,
			["mouse"] = 700,
			["ring"] = 400, 
			["watch"] = 2340, 
			["playstation"] = 700,
			["xbox"] = 1000,
			["legos"] = 1000,
			["ominitrix"] = 1000,
			["bracelet"] = 1000,
			["dildo"] = 900,
			["caneta"] = 400
		}
	},
	["TiresTool"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["tires"] = 1500,
			["toolbox"] = 5000
		}
	},
	["IdentityStore"] = {
		["mode"] = "Buy",
		["type"] = "Cash",
		["list"] = {
			["identity"] = 500
		}
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(shopType)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.wantedReturn(user_id) then
			return false
		end

		if shops[shopType]["perm"] ~= nil then
			if not vRP.hasPermission(user_id,shops[shopType]["perm"]) then
				return false
			end
		end
		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSLOTS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getSlots(name)
	local count = 0
	for k,v in pairs(shops[name]["list"]) do
		count = count + 1
	end

	if count <= 19 then
		count = 30
	end
	
	return count
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestShop(name)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	local slotShops = cRP.getSlots(name)
	if user_id then
		local inventoryShop = {}
		for k,v in pairs(shops[name]["list"]) do
			table.insert(inventoryShop,
			{ 
				price = parseInt(v), 
				name = vRP.itemNameList(k), 
				index = vRP.itemIndexList(k), 
				key = k, 
				weight = vRP.itemWeightList(k), 
				amount = parseInt(k), 
				max = vRP.itemMaxAmount(k), 
				type = vRP.itemTypeList(k), 
				hunger = vRP.itemHungerList(k), 
				thirst = vRP.itemWaterList(k), 
				economy = vRP.itemEconomyList(k)
			})
		end

		local inventoryUser = {}
		local inv = vRP.getInventory(user_id)
		if inv then
			for k,v in pairs(inv) do
				
				v.amount = parseInt(v.amount)
				v.name = vRP.itemNameList(v.item)
				v.peso = vRP.itemWeightList(v.item)
				v.index = vRP.itemIndexList(v.item)
				v.max = vRP.itemMaxAmount(v.item)
				v.type = vRP.itemTypeList(v.item)
				v.hunger = vRP.itemHungerList(v.item)
				v.thirst = vRP.itemWaterList(v.item)
				v.economy = vRP.itemEconomyList(v.item)
				v.key = v.item
				v.slot = k

				inventoryUser[k] = v
			end
		end

		return inventoryShop,inventoryUser,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.name2,parseInt(user_id),parseInt(identity.bank),parseInt(vRP.getUserGems(user_id)),identity.phone,identity.registration }, slotShops
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSHOPTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.getShopType(name)
    return shops[name].mode
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionShops(shopType,shopItem,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end

		if vRP.getInventoryItemMax(user_id,shopItem,shopAmount) then

			if shops[shopType]["mode"] == "Buy" then
				if vRP.computeInvWeight(parseInt(user_id)) + vRP.itemWeightList(shopItem) * parseInt(shopAmount) <= vRP.getBackpack(parseInt(user_id)) then
					if shops[shopType]["type"] == "Cash" then
						if shops[shopType]["list"][shopItem] then
							if vRP.paymentBank(parseInt(user_id),parseInt(shops[shopType]["list"][shopItem]*shopAmount)) then
								vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
								if shops[shopType]["perm"] == "Police" then
									TriggerEvent("webhooks","arsenalpolicia","```ini\n[ID]: "..user_id.." ( RETIROU )\n[ITEM]: "..shopItem.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```","Arsenal")
								end
								TriggerClientEvent("vrp_shops:webhooks",source,user_id,shopType,vRP.itemNameList(shopItem),shopAmount,os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"))
							else
								TriggerClientEvent("Notify",source,"vermelho","Dinheiro insuficiente.",5000)
							end
						end
					elseif shops[shopType]["type"] == "Consume" then
						if vRP.tryGetInventoryItem(parseInt(user_id),shops[shopType]["item"],parseInt(shops[shopType]["list"][shopItem]*shopAmount)) then
							vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
							TriggerClientEvent("sounds:Private",source,"cash",0.1)
						else
							TriggerClientEvent("Notify",source,"vermelho","Insuficiente "..vRP.itemNameList(shops[shopType]["item"])..".",5000)
						end
					elseif shops[shopType]["type"] == "Market" then
						if vRP.hasPermission(user_id,"Market") then
							if vRP.paymentBank(parseInt(user_id),parseInt(shops[shopType]["list"][shopItem]*shopAmount *0.80)) then
								vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
							else
								TriggerClientEvent("Notify",source,"vermelho","Insuficiente "..vRP.itemNameList(shops[shopType]["item"])..".",5000)
							end
						else
							if vRP.paymentBank(parseInt(user_id),parseInt(shops[shopType]["list"][shopItem]*shopAmount)) then
								vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
								TriggerClientEvent("sounds:Private",source,"cash",0.1)
							else
								TriggerClientEvent("Notify",source,"vermelho","Insuficiente "..vRP.itemNameList(shops[shopType]["item"])..".",5000)
							end
						end

					elseif shops[shopType]["type"] == "Premium" then
						local identity = vRP.getUserIdentity(parseInt(user_id))
						local consult = vRP.getInfos(identity.steam)
						if parseInt(consult[1].gems) >= parseInt(shops[shopType]["list"][shopItem]*shopAmount) then
							vRP.giveInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),false,slot)
							TriggerClientEvent("sounds:Private",source,"cash",0.1)
							vRP.execute("vRP/rem_vrp_gems",{ steam = identity.steam, gems = parseInt(shops[shopType]["list"][shopItem]*shopAmount) })
							TriggerClientEvent("Notify",source,"verde","Você comprou <b>"..vRP.format(parseInt(shopAmount)).."x "..vRP.itemNameList(shopItem).."</b> por <b>"..vRP.format(parseInt(shops[shopType]["list"][shopItem]*shopAmount)).." Gemas</b>.",5000)
							TriggerClientEvent("vrp_shops:webhooks",source,user_id,shopType,vRP.itemNameList(shopItem),shopAmount,os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"))
						else
							TriggerClientEvent("Notify",source,"vermelho","Gemas Insuficientes.",5000)
						end
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
				end
			elseif shops[shopType]["mode"] == "Sell" then
				if shops[shopType]["list"][shopItem] then
					if shops[shopType]["type"] == "Cash" then
						if vRP.tryGetInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),true,slot) then
							vRP.giveInventoryItem(parseInt(user_id),"dollars",parseInt(shops[shopType]["list"][shopItem]*shopAmount),false)
							TriggerClientEvent("sounds:Private",source,"cash",0.1)
						end
					elseif shops[shopType]["type"] == "Cash2" then
						if vRP.tryGetInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),true,slot) then
							vRP.giveInventoryItem(parseInt(user_id),"dollars2",parseInt(shops[shopType]["list"][shopItem]*shopAmount),false)
							TriggerClientEvent("sounds:Private",source,"cash",0.1)
						end
					elseif shops[shopType]["type"] == "Consume" then
						if vRP.tryGetInventoryItem(parseInt(user_id),shopItem,parseInt(shopAmount),true,slot) then
							vRP.giveInventoryItem(parseInt(user_id),shops[shopType]["item"],parseInt(shops[shopType]["list"][shopItem]*shopAmount),false)
							TriggerClientEvent("sounds:Private",source,"cash",0.1)
						end
					end
					TriggerClientEvent("vrp_shops:webhooks",source,user_id,shopType,vRP.itemNameList(shopItem),shopAmount,os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"))
				end
			end
		else
			TriggerClientEvent("Notify",source,"vermelho","Limite Atingido!",5000)
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_shops:populateSlot")
AddEventHandler("vrp_shops:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(parseInt(user_id),itemName,amount,false,slot) then
			vRP.giveInventoryItem(parseInt(user_id),itemName,amount,false,target)
			vCLIENT.updateShops(source,"requestShop")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_shops:updateSlot")
AddEventHandler("vrp_shops:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(parseInt(user_id))
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(parseInt(user_id),itemName,amount,false,slot) then
					vRP.giveInventoryItem(parseInt(user_id),itemName,amount,false,target)
				end
			else
				vRP.swapSlot(parseInt(user_id),slot,target)
			end
		end

		vCLIENT.updateShops(source,"requestShop")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPS:DIVINGSUIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("shops:divingSuit")
AddEventHandler("shops:divingSuit",function()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.request(source,"Traje de Mergulho","Comprar <b>Roupa de Mergulho</b> por <b>$975</b>?",30) then
			if vRP.paymentFull(user_id,975) then
				vRP.generateItem(user_id,"divingsuit",1,true)
			else
				TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
			end
		end
	end
end)