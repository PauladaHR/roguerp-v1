local Tunnel = module("vrp","lib/Tunnel")
vGARAGE = Tunnel.getInterface("vrp_garages")

cfg = {}

cfg.DismantleList = {
	"guardian","sandking","bullet","mesa","surfer","regina","bjxl","sandking2","picador","radi",
	"blista","blista2","bobcatxl","mixer","sentinel","zentorno","ellie","boxville","sentinel2",
	"dominator","adder","pounder","windsor","sultan","alpha","baller2","comet2","baller","monroe",
	"dubsta","serrano","rebel2","jester","tornado","tornado2","tornado3","sadler","granger","surfer2",
	"warrener","carbonizzare","sabregt","exemplar","issi2","gauntlet","utillitruck","feltzer2","dune",
	"kuruma","dukes","chino","voltic","scrap","rhapsody","zion","zion2","superd","rebel","jackal","carbonrs",
	"flatbed","faction","contender","casco","surano","patriot","buffalo","cavalcade","asterope","phoenix",
	"buccaneer","seminole","nemesis","felon","felon2","emperor","rancherxl","benson","tiptruck2","panto","cog55",
	"peyote","banshee","massacro","stanier","packer","gresley","furoregt","rapidgt2","firetruk","penumbra",
	"vigero","manana","glendale","mule","pigalle","landstalker","bagger","huntley","ingot","youga","rocoto",
	"faggio2","stalion","stockade","taxi","taco","infernus","futo","daemon","oracle",
	"cavalcade2","speedo","washington","intruder","minivan","bus","schafter2","fusilade"
}

cfg.locs = { x = 2130.71, y = 4785.51, z = 40.98 }

cfg.itensList = {
	[1] = "plastic",
	[2] = "glass",
	[3] = "rubber",
	[4] = "aluminum",
	[5] = "copper"
}

cfg.vehicleParts = {
    [1] = "engine",
	[2] = "transmission",
	[3] = "turbo",
	[4] = "suspension",
	[5] = "brakes"
}

cfg.reputationGive = 20

function cfg.DeleteVehicle(source,Vehicle)
	vGARAGE.deleteVehicle(source,Vehicle)
end

cfg.permList = { "Desmanche01","Desmanche02" }

function cfg.paymentDismantle()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		local reputation = vRP.checkReputation(user_id,"Dismantle")
		vRP.generateItem(user_id,cfg.itensList[math.random(#cfg.itensList)],math.random(30,55),true)
		vRP.upgradeStress(user_id,10)

		if reputation >= 101 and reputation <= 199 then
			vRP.generateItem(user_id,"dollars2",math.random(1250,1650),true)
            vRP.generateItem(user_id,cfg.vehicleParts[math.random(#cfg.vehicleParts)],1,true)
		elseif reputation >= 201 and reputation <= 299 then
			vRP.generateItem(user_id,"dollars2",math.random(1500,2000),true)
            vRP.generateItem(user_id,cfg.vehicleParts[math.random(#cfg.vehicleParts)],2,true)
		elseif reputation >= 301 and reputation <= 399 then
			vRP.generateItem(user_id,"dollars2",math.random(2200,2500),true)
            vRP.generateItem(user_id,cfg.vehicleParts[math.random(#cfg.vehicleParts)],math.random(2,3),true)
		elseif reputation > 400 then
			vRP.generateItem(user_id,"dollars2",math.random(2600,2900),true)
            vRP.generateItem(user_id,cfg.vehicleParts[math.random(#cfg.vehicleParts)],math.random(3,4),true)
		end
	end
end

function cfg.paymentDismantlePlayer(VehPlateID,VehicleName)
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		vRP.generateItem(user_id,"dollars2",math.random(35000,50000),true)
		exports["oxmysql"]:executeSync("UPDATE vrp_users_vehicles SET arrest = ? WHERE user_id = ? AND vehicle = ? ", { 1,VehPlateID,VehicleName } )
	end
end