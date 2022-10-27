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
Tunnel.bindInterface("vrp_crafting",cRP)
vCLIENT = Tunnel.getInterface("vrp_crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local craftList = {
	["catCoffe"] = {
		["perm"] = "catCoffe",
		["list"] = {
			["FoodTorradacomgeleia"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["torrada"] = 1,
					["geleia"] = 1
				}
			},
			["FoodTapioca"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["goma"] = 2
				}
			},
			["Foodhamburger"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["pao"] = 1,
					["queijo"] = 1,
					["meat"] = 1
				}
			},
			["Fooddonut"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["acucar"] = 1,
					["milk"] = 1
				}
			},
			["FoodSonho"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["acucar"] = 1,
					["milk"] = 1
				}
			},
			["FoodBrigadeiro"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["cacau"] = 1,
					["milk"] = 1
				}
			},
			["FoodSanduichenatural"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["pao"] = 2,
					["salada"] = 1,
					["queijo"] = 1,
				}
			},
			["FoodMacaron"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["claraemneve"] = 1,
					["morangocortado"] = 1,
					["ovo"] = 1
				}
			},
			["FoodCheesecake"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["leitecondensado"] = 1,
					["ovo"] = 1,
					["queijo"] = 1,
					["morangocortado"] = 1,
				}
			},
			["FoodCoxinha"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["frango"] = 1,
					["ovo"] = 1,
				}
			},
			["FoodBolo"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["ovo"] = 1,
					["morangocortado"] = 1,
					["milk"] = 1,
				}
			},
			["FoodPudim"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["ovo"] = 3,
					["leitecondensado"] = 1,
					["milk"] = 1,
				}
			},
			["FoodTortaAlema"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["ovo"] = 3,
					["leitecondensado"] = 1,
					["milk"] = 1,
				}
			},
			["FoodLimonada"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["laranjacortada"] = 4,
					["water"] = 2,
				}
			},
			["FoodMilkshake"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["Foodsorvete"] = 2,
					["leitecondensado"] = 1,
					["caldadechocolate"] = 1,
				}
			},
			["delivery"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars"] = 50
				}
			}
		}
	},
	["coolBeans"] = {
		["perm"] = "coolBeans",
		["list"] = {
			["FoodPaodequeijo"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["queijo"] = 1
				}
			},
			["FoodBolo"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["ovo"] = 1,
					["morangocortado"] = 1,
					["milk"] = 1,
				}
			},
			["FoodSanduichenatural"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["pao"] = 1,
					["proteina"] = 1,
				}
			},
			["FoodPastel"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["proteina"] = 1
				}
			},
			["Foodhamburger"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["pao"] = 1,
					["ovo"] = 1,
					["proteina"] = 1
				}
			},
			["Foodsaladadefrutas"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["morangocortado"] = 2,
					["bananacortada"] = 2
				}
			},
			["FoodBatataFrita"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["potatos"] = 1,
				}
			},
			["FoodBaguette"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["massa"] = 1,
					["ovo"] = 1,
					["queijo"] = 1,
				}
			},
			["FoodPaonachapa"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["pao"] = 1,
					["manteiga"] = 1,
				}
			},
			["FoodMistoquente"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["pao"] = 1,
					["proteina"] = 1,
				}
			},
			["FoodCroissant"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["massa"] = 1,
					["queijo"] = 1,
				}
			},
			["FoodCoxinha"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["frango"] = 1,
					["ovo"] = 1,
				}
			},
			["FoodChurros"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["farinhadetrigo"] = 1,
					["milk"] = 1,
					["cacau"] = 1,
					["ovo"] = 1,
				}
			},
			["delivery"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars"] = 50
				}
			}
		}
	},

	["PearlsCrafting"] = {
		["perm"] = "Pearls",
		["list"] = {
			["FoodHotrollSalmao"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 1,
					["salmaocortado"] = 1,
					["Nori"] = 1,
				}
			},
			["FoodHotrollAtum"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 1,
					["atumcortado"] = 1,
					["Nori"] = 1,
				}
			},
			["FoodNiguiriSalmao"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 2,
					["salmaocortado"] = 2,
					["Nori"] = 1,
				}
			},
			["FoodNiguiriAtum"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 2,
					["atumcortado"] = 2,
					["Nori"] = 1,
				}
			},
			["FoodTemakiSalmao"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 2,
					["salmaocortado"] = 1,
					["Nori"] = 2,
					["water"] = 1,
				}
			},
			["FoodTemakiAtum"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 2,
					["atumcortado"] = 1,
					["Nori"] = 2,
					["water"] = 1,
				}
			},
			["FoodSashimiSalmao"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["salmaocortado"] = 1,
				}
			},
			["FoodSashimiAtum"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["atumcortado"] = 1,
				}
			},
			["FoodHossomakiSalmao"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 1,
					["salmaocortado"] = 1,
					["Nori"] = 1,
				}
			},
			["FoodHossomakiAtum"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["Gohan"] = 1,
					["atumcortado"] = 1,
					["Nori"] = 1,
				}
			},
			["FoodCeviche"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["camaraolimpo"] = 1,
					["lulacortada"] = 1,
					["alfacelavada"] = 1,
					["carp"] = 1,
				}
			},
			["FoodYakisoba"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["Macarrao"] = 2,
					["meat"] = 1,
					["tomatecortado"] = 2,
					["alfacelavada"] = 1,
				}
			},
			["FoodPudim"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["ovo"] = 3,
					["leitecondensado"] = 1,
					["milk"] = 1,
				}
			},
			["FoodTortaAlema"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["ovo"] = 3,
					["leitecondensado"] = 1,
					["milk"] = 1,
				}
			},
			["FoodLimonada"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["laranjacortada"] = 4,
					["water"] = 2,
				}
			},
			["FoodMilkshake"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["Foodsorvete"] = 2,
					["leitecondensado"] = 1,
					["caldadechocolate"] = 1,
				}
			},
			["delivery"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars"] = 50
				}
			}
		}
	},
	
	["VanillaCrafting"] = {
	["perm"] = "Vanilla",
	["list"] = {
			["Foodsucobifasico"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["water"] = 2,
					["strawberry"] = 3,
					["orange"] = 2
				}
			},
			["Foodsex"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["water"] = 1,
					["Foodabsolut"] = 2,
					["strawberry"] = 3
				}
			},
			["Foodboanoite"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["water"] = 2,
					["Foodabsolut"] = 2,
					["orange"] =3
				}
			}
		}
	},

	["BahamasCrafting"] = {
	["perm"] = "Bahamas",
	["list"] = {
			["Foodsucodemorango"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["water"] = 1,
					["strawberry"] = 3
				}
			},
			["Foodsunrise"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["Foodabsolut"] = 1,
					["orange"] = 3
				}
			},
			["Fooddrinkbahamas"] = {
				["amount"] = 3,
				["destroy"] = true,
				["require"] = {
					["Foodabsolut"] = 1,
					["orange"] = 2,
					["strawberry"] = 1
				}
			}
		}
	},

	["Arma01Crafting"] = {
		["perm"] = "Arma01",
		["list"] = {
			["WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 30,
					["copper"] = 15,
					["aluminum"] = 15,
					["plastic"] = 10,
					["glass"] = 5,
					["dollars"] = 18000
				}
			},
			["WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 30,
					["copper"] = 15,
					["aluminum"] = 15,
					["plastic"] = 10,
					["glass"] = 5,
					["dollars"] = 18000
				}
			},
			["WEAPON_ASSAULTSMG"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_MACHINEPISTOL"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_MICROSMG"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 17,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 6000
				}
			}
		}
	},
	["Arma02Crafting"] = {
		["perm"] = "Arma02",
		["list"] = {
			["WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 30,
					["copper"] = 15,
					["aluminum"] = 15,
					["plastic"] = 10,
					["glass"] = 5,
					["dollars"] = 18000
				}
			},
			["WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 30,
					["copper"] = 15,
					["aluminum"] = 15,
					["plastic"] = 10,
					["glass"] = 5,
					["dollars"] = 18000
				}
			},
			["WEAPON_ASSAULTSMG"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_MACHINEPISTOL"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_MICROSMG"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 17,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 6000
				}
			}
		}
	},
	["Arma03Crafting"] = {
		["perm"] = "Arma03",
		["list"] = {
			["WEAPON_ASSAULTRIFLE_MK2"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 30,
					["copper"] = 15,
					["aluminum"] = 15,
					["plastic"] = 10,
					["glass"] = 5,
					["dollars"] = 18000
				}
			},
			["WEAPON_SPECIALCARBINE_MK2"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 30,
					["copper"] = 15,
					["aluminum"] = 15,
					["plastic"] = 10,
					["glass"] = 5,
					["dollars"] = 18000
				}
			},
			["WEAPON_ASSAULTSMG"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_MACHINEPISTOL"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_MICROSMG"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 20,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 10000
				}
			},
			["WEAPON_PISTOL_MK2"] = {
				["amount"] = 2,
				["destroy"] = true,
				["require"] = {
					["bpwait"] = 17,
					["copper"] = 10,
					["aluminum"] = 10,
					["plastic"] = 5,
					["dollars"] = 6000
				}
			}
		}
	},

	["ilegalCrafting"] = {
		["list"] = {
			["handcuff"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["plastic"] = 3,
					["aluminum"] = 3,
					["copper"] = 4
				}
			},
			["pendrive"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["eletronics"] = 20,
					["rubber"] = 8,
					["plastic"] = 20,
					["aluminum"] = 15
				}
			},
			["raceticket"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 100
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["aluminum"] = 20,
					["rubber"] = 20,
					["copper"] = 5
				}
			}
		}
	},

	["CassinoCoins"] = {
		["list"] = {
			["coins"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars"] = 2
				}
			}
		}
	},
	["CassinoDollars"] = {
		["list"] = {
			["dollars"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["coins"] = 1,
				}
			}
		}
	},

	["Lavagem01"] = {
		["list"] = {
			["dollars"] = {
				["amount"] = 42500,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 50000,
					["keylogs"] = 5,
				}
			}
		}
	},
	["Lavagem02"] = {
		["list"] = {
			["dollars"] = {
				["amount"] = 42500,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 50000,
					["keylogs"] = 5,
				}
			}
		}
	},

	["Barragem"] = {
		["perm"] = "Barragem",
		["list"] = {
			["meth"] = {
				["amount"] = 25,
				["destroy"] = true,
				["require"] = {
					["methliquid"] = 1,
					["ephedrine"] = 10,
				}
			},
			["masterpick"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["chave"] = 15,
					["lima"] = 10,
					["aluminum"] = 30,
					["copper"] = 2,
					["plastic"] = 25
				}
			},
			["pendrive"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["eletronics"] = 20,
					["rubber"] = 8,
					["plastic"] = 20,
					["aluminum"] = 15
				}
			},
			["chavedeacesso"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["chave"] = 25,
					["rubber"] = 15,
					["copper"] = 10,
					["lima"] = 25
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["aluminum"] = 10,
					["rubber"] = 10,
					["copper"] = 1
				}
			}
		}
	},
	["Cupim"] = {
		["perm"] = "Cupim",
		["list"] = {
			["cocaine"] = {
				["amount"] = 25,
				["destroy"] = true,
				["require"] = {
					["cokepast"] = 1,
					["mdma"] = 10,
				}
			},
			["masterpick"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["chave"] = 15,
					["lima"] = 10,
					["aluminum"] = 30,
					["copper"] = 2,
					["plastic"] = 25
				}
			},
			["pendrive"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["eletronics"] = 20,
					["rubber"] = 8,
					["plastic"] = 20,
					["aluminum"] = 15
				}
			},
			["chavedeacesso"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["chave"] = 25,
					["rubber"] = 15,
					["copper"] = 10,
					["lima"] = 25
				}
			},
			["lockpick"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["aluminum"] = 10,
					["rubber"] = 10,
					["copper"] = 1
				}
			}
		}
	},
	["Helipa"] = {
		["perm"] = "Helipa",
		["list"] = {
			["joint"] = {
				["amount"] = 25,
				["destroy"] = true,
				["require"] = {
					["weedpack"] = 1,
					["silk"] = 10,
				}
			},
			["masterpick"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["chave"] = 15,
					["lima"] = 10,
					["aluminum"] = 30,
					["copper"] = 2,
					["plastic"] = 25
				}
			},
			["pendrive"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["eletronics"] = 20,
					["rubber"] = 8,
					["plastic"] = 20,
					["aluminum"] = 15
				}
			},
			["chavedeacesso"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["chave"] = 25,
					["rubber"] = 15,
					["copper"] = 10,
					["lima"] = 25
				}
			},
			["c4"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["plastic"] = 20,
					["rubber"] = 20,
					["glass"] = 10,
					["eletronics"] = 10
				}
			},
		}
	},

	["Municao01Crafting"] = {
		["perm"] = "Municao01",
		["list"] = {
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommp"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 700
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommm"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 1000
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommg"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 1200
				}
			},
			["bluecard"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 1500,
				}
			},
			["blackcard"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 3500,
				}
			},
			["vest"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 3000,
				}
			},
		}
	},
	["Municao02Crafting"] = {
		["perm"] = "Municao02",
		["list"] = {
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommp"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 700
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommm"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 1000
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommg"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 1200
				}
			},
			["bluecard"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 1500,
				}
			},
			["blackcard"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 3500,
				}
			},
			["vest"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 3000,
				}
			},
		}
	},
	["Municao03Crafting"] = {
		["perm"] = "Municao03",
		["list"] = {
			["WEAPON_PISTOL_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommp"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 700
				}
			},
			["WEAPON_SMG_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommm"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 1000
				}
			},
			["WEAPON_RIFLE_AMMO"] = {
				["amount"] = 500,
				["destroy"] = true,
				["require"] = {
					["ammommg"] = 150,
					["gunpowder"] = 50,
					["capsule"] = 500,
					["dollars"] = 1200
				}
			},
			["bluecard"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 1500,
				}
			},
			["blackcard"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 3500,
				}
			},
			["vest"] = {
				["amount"] = 1,
				["destroy"] = true,
				["require"] = {
					["dollars2"] = 3000,
				}
			},
		}
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTPERM
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestPerm(craftType)
	local source = source
	local user_id = vRP.getUserId(source)

	if user_id then
		if vRP.wantedReturn(user_id) then
			return false
		end

		if craftList[craftType]["perm"] ~= nil then
			if not vRP.hasPermission(user_id,craftList[craftType]["perm"]) then
				return false
			end
		end

		return true
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.requestCrafting(craftType)
	local source = source
	local user_id = vRP.getUserId(source)
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		local inventoryShop = {}
		for k,v in pairs(craftList[craftType]["list"]) do
			local craftList = {}
			for k,v in pairs(v.require) do
				table.insert(craftList,{ name = vRP.itemNameList(k), amount = v })
			end

			table.insert(inventoryShop,{ name = vRP.itemNameList(k), index = vRP.itemIndexList(k), key = k, weight = vRP.itemWeightList(k), list = craftList, amount = parseInt(v["amount"]) })
		end

		local inventoryUser = {}
		local inv = vRP.getInventory(user_id)
		if inv then
			for k,v in pairs(inv) do

				v.amount = parseInt(v.amount)
				v.name = vRP.itemNameList(v.item)
				v.peso = vRP.itemWeightList(v.item)
				v.index = vRP.itemIndexList(v.item)
				v.key = v.item
				v.slot = k

				inventoryUser[k] = v
			end
		end

		return inventoryShop,inventoryUser,vRP.computeInvWeight(user_id),vRP.getBackpack(user_id),{ identity.name.." "..identity.name2,parseInt(user_id),parseInt(identity.bank),parseInt(vRP.getUserGems(user_id)),identity.phone,identity.registration }
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONCRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionCrafting(shopItem,shopType,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end

		if craftList[shopType]["list"][shopItem] then
			for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
				if itemAmount(user_id,k) < parseInt(v*shopAmount) then
					return
				end
				Citizen.Wait(1)
			end

			for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
				if vRP.tryGetInventoryItem(user_id,k,parseInt(v*shopAmount)) then end
				Citizen.Wait(1)
			end

			vRP.giveInventoryItem(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"]*shopAmount,false,slot)
		end

		vCLIENT.updateCrafting(source,"requestCrafting")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTIONDESTROY
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.functionDestroy(shopItem,shopType,shopAmount,slot)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if shopAmount == nil then shopAmount = 1 end
		if shopAmount <= 0 then shopAmount = 1 end

		if craftList[shopType]["list"][shopItem] then
			if craftList[shopType]["list"][shopItem]["destroy"] then
				if vRP.tryGetInventoryItem(user_id,shopItem,craftList[shopType]["list"][shopItem]["amount"]) then
					for k,v in pairs(craftList[shopType]["list"][shopItem]["require"]) do
						if parseInt(v) <= 1 then
							vRP.giveInventoryItem(user_id,k,1)
						else
							vRP.giveInventoryItem(user_id,k,v/2)
						end
						Citizen.Wait(1)
					end
				end
			end
		end

		vCLIENT.updateCrafting(source,"requestCrafting")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_crafting:populateSlot")
AddEventHandler("vrp_crafting:populateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
			vRP.giveInventoryItem(user_id,itemName,amount,false,target)
			vCLIENT.updateCrafting(source,"requestCrafting")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- POPULATESLOT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("vrp_crafting:updateSlot")
AddEventHandler("vrp_crafting:updateSlot",function(itemName,slot,target,amount)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if amount == nil then amount = 1 end
		if amount <= 0 then amount = 1 end

		local inv = vRP.getInventory(user_id)
		if inv then
			if inv[tostring(slot)] and inv[tostring(target)] and inv[tostring(slot)].item == inv[tostring(target)].item then
				if vRP.tryGetInventoryItem(user_id,itemName,amount,false,slot) then
					vRP.giveInventoryItem(user_id,itemName,amount,false,target)
				end
			else
				vRP.swapSlot(user_id,slot,target)
			end
		end

		vCLIENT.updateCrafting(source,"requestCrafting")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEM AMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemAmount(user_id,idname)
	local data = vRP.getInventory(user_id)
	if data then
		for k,v in pairs(data) do
			if v.item == idname then
				return parseInt(v.amount)
			end
		end
	end
	return 0
end