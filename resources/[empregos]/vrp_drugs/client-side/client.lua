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
Tunnel.bindInterface("vrp_drugs",cRP)
vSERVER = Tunnel.getInterface("vrp_drugs")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local startLocations = {
	{ 144.81,-2204.23,4.69 },
}

local inService = false
local timeSelling = 0
local inTimers = 15
local inPed = nil
local inSeconds = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDHASHS
-----------------------------------------------------------------------------------------------------------------------------------------
local pedHashs = {
	"ig_abigail",
	"u_m_y_abner",
	"a_m_o_acult_02",
	"a_m_m_afriamer_01",
	"csb_mp_agent14",
	"csb_agent",
	"u_m_m_aldinapoli",
	"ig_amandatownley",
	"ig_andreas",
	"u_m_y_antonb",
	"csb_anita",
	"cs_andreas",
	"ig_ashley",
	"s_m_m_autoshop_01",
	"ig_money",
	"g_m_y_ballaeast_01",
	"g_m_y_ballaorig_01",
	"g_f_y_ballas_01",
	"u_m_y_babyd",
	"ig_barry",
	"s_m_y_barman_01",
	"u_m_y_baygor",
	"a_f_y_beach_01",
	"a_f_y_bevhills_02",
	"a_f_y_bevhills_01",
	"u_m_y_burgerdrug_01",
	"a_m_m_business_01",
	"a_f_m_business_02",
	"a_m_y_business_02",
	"ig_car3guy1",
	"ig_chef2",
	"g_m_m_chigoon_02",
	"g_m_m_chigoon_01",
	"ig_claypain",
	"ig_clay",
	"a_f_m_eastsa_01"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PEDLOCATE
-----------------------------------------------------------------------------------------------------------------------------------------
local pedLocate = {
	{ -1679.0,-401.68,47.53,57.61 }, 
	{ -1779.09,-427.92,41.45,199.86 }, 
	{ -1545.99,-531.0,36.15,33.38 },
	{ 373.0,427.59,145.69,22.95 },
	{ -1473.54,-645.89,29.59,222.08 },
	{ -1493.62,-668.11,29.03,319.33 },
	{ 331.37,465.31,151.25,19.5 }, 
	{ -1457.91,-645.51,33.39,126.91 },
	{ 318.0,562.63,154.54,10.98 },
	{ -1462.91,-662.14,33.39,40.8 }, 
	{ -1202.93,-944.81,8.12,118.74 },
	{ 231.96,672.15,189.95,17.43 },
	{ -1156.04,-931.87,2.66,179.23 },
	{ 216.03,619.92,187.64,78.88 },
	{ -1090.05,-954.01,2.43,121.04 },
	{ 128.34,566.25,183.96,5.87 },
	{ -1092.03,-1040.02,2.16,207.29 },
	{ -1158.99,-1101.06,6.54,26.69 },
	{ 84.75,562.69,182.58,0.55 },
	{ -1225.31,-1207.95,8.27,285.26 },
	{ -66.78,490.28,144.89,343.43 },
	{ -970.01,-1431.95,7.68,106.99 },
	{ -7.87,468.16,145.86,327.8 },
	{ 58.06,450.04,147.04,326.82 },
	{ -1001.87,-1219.01,5.75,207.12 },
	{ 42.05,467.97,148.1,256.84 },
	{ 118.98,493.82,147.35,141.33 },
	{ -813.04,-980.68,14.16,145.73 },
	{ 223.68,513.94,140.77,50.7 },
	{ -1751.37,-698.57,10.21,132.31 },
	{ -1800.46,-667.04,10.56,50.28 },
	{ -202.13,405.19,110.92,12.64 }, 
	{ -1828.32,-653.27,10.8,139.27 },
	{ -311.96,475.07,111.83,119.19 },
	{ -1960.15,-546.45,11.84,132.75 },
	{ -355.57,469.66,112.49,286.45 },
	{ -1961.24,-513.44,11.84,350.93 },
	{ -349.18,514.84,120.65,142.33 },
	{ -386.72,504.3,120.42,326.29 },
	{ 410.31,-1910.77,25.46,85.7 },
	{ 428.54,-1964.74,23.34,301.97 },
	{ 706.75,-2136.07,29.05,352.16 },
	{ 702.95,-2195.62,29.18,246.8 },
	{ 1086.52,-2399.93,30.58,273.01 },
	{ 1407.91,-2218.04,61.38,307.51 },
	{ 1442.14,-2221.82,60.87,19.0 },
	{ 1490.77,-1910.41,71.52,216.17 },
	{ 1576.85,-1686.03,88.15,110.48 },
	{ 1565.62,-1691.64,88.26,301.83 },
	{ 1723.41,-1469.18,112.88,58.55 },
	{ 1269.28,-1571.68,54.56,35.63 },
	{ 1231.49,-1083.05,38.53,126.26 },
	{ 510.91,-1074.92,28.82,91.13 },
	{ 488.57,-898.66,25.82,263.64 },
	{ 316.49,-685.04,29.49,243.94 },
	{ 76.77,-871.44,31.51,71.47 },
	{ -49.98,-1058.83,27.81,68.53 },
	{ -200.55,-1378.98,31.26,216.31 },
	{ 12.26,-1299.96,29.24,196.07 },
	{ 305.99,-1348.98,31.97,233.7 },
	{ 375.83,-347.06,46.67,241.58 },
	{ 445.82,83.88,98.94,339.52 },
	{ 305.7,27.04,85.22,241.87 },
	{ 242.16,-96.81,70.11,344.35 },
	{ -5.42,-74.37,61.4,270.88 },
	{ -443.68,146.13,64.7,183.01 },
	{ -780.07,-204.95,37.29,309.43 },
	{ -700.11,-305.78,36.64,337.45 },
	{ -1169.58,-534.32,30.15,289.84 },
	{ -1148.3,-913.71,2.7,297.72 },
	{ -1223.65,-1207.74,7.74,287.29 },
	{ -1171.07,-1380.9,4.97,40.1 },
	{ -1982.07,-241.97,34.92,147.29 },
	{ -406.7,566.99,124.61,155.02 }, 
	{ -500.23,553.64,120.0,343.91 },
	{ -1569.57,-295.12,48.28,315.69 },
	{ -1583.16,-265.9,48.28,267.99 },
	{ -1555.28,-279.32,48.28,332.12 },
	{ -520.47,594.22,120.84,278.55 },
	{ -475.29,585.85,128.69,1.72 },
	{ -1592.99,-277.93,52.69,97.74  },
	{ -515.28,628.5,133.55,222.63 },
	{ -1463.93,-33.45,54.69,308.05 }, 
	{ -533.38,709.21,153.11,194.19 },
	{ -494.49,739.33,163.04,292.65 },
	{ -1649.51,150.26,62.17,208.61 }, 
	{ -496.06,797.5,184.37,350.43 }, 
	{ -597.27,851.58,211.45,37.02 },
	{ -2187.93,-408.78,13.16,230.82 }, 
	{ -746.0,808.52,214.6,11.52 },
	{ -655.13,803.65,199.0,359.24 },
	{ -599.97,807.02,191.18,198.15 },
	{ -3089.09,221.51,14.07,319.73 },
	{ -568.04,-781.54,30.67,6.24 },
	{ -595.59,780.82,189.12,302.94 },
	{ -3106.18,312.17,8.39,336.27 },
	{ -565.9,761.06,185.43,44.1 },
	{ -3091.4,379.26,7.12,253.77 },
	{ -718.66,-855.01,23.03,354.86 },
	{ -579.72,733.19,184.22,8.31 },
	{ -3071.49,442.11,6.36,61.3 },
	{ -663.98,742.23,174.29,261.46 },
	{ -3077.96,658.83,11.67,308.98 },
	{ -708.85,712.69,162.21,284.14 },
	{ -3109.29,751.71,24.71,170.49 },
	{ -606.03,672.21,151.6,356.48 },
	{ -2994.84,682.51,25.05,109.25 },
	{ -1113.33,-1193.37,2.37,27.27 },
	{ -1190.99,-1054.93,2.16,113.15 },
	{ -2972.2,598.82,24.45,62.02 },
	{ -1097.89,-1673.33,8.4,121.62 },
	{ -3013.61,75.93,11.61,336.05 },
	{ -1098.24,-1679.03,4.37,134.88 },
	{ -551.82,686.61,146.08,168.79 },
	{ -559.28,664.19,145.46,298.42 },
	{ -1667.4,-441.41,40.36,229.97 }, 
	{ -476.7,647.97,144.39,23.04 },
	{ -1284.61,-567.51,31.72,316.38 },
	{ -336.55,31.0,47.86,76.54 },
	{ -400.0,665.13,163.84,6.71 },
	{ -336.62,31.06,47.86,77.86 },
	{ -339.16,21.63,47.86,76.31 },
	{ -353.41,668.31,169.08,168.96 },
	{ -345.16,17.99,47.86,352.25 },
	{ -1287.34,-429.43,34.77,310.49 }, 
	{ -371.2,23.29,47.86,355.07 },
	{ -307.59,643.49,176.14,131.61 },
	{ -362.43,57.23,54.43,173.55 },
	{ -1471.97,-330.41,44.82,313.83 }, 
	{ -344.71,57.15,54.44,177.01 },
	{ -293.45,600.92,181.58,355.84 },
	{ -430.1,-56.82,43.01,226.53 },
	{ -1464.87,-34.19,55.06,312.27 }, 
	{ -437.87,-66.85,43.01,227.07 },
	{ -232.5,588.4,190.54,358.58 },
	{ -431.02,-54.89,47.39,133.85 },
	{ -189.46,618.06,199.67,181.17 }, 
	{ -1564.96,-407.07,42.39,224.99 },
	{ -185.34,591.47,197.83,0.5 },
	{ -126.31,589.04,204.52,1.17 },
	{ -1383.57,267.53,61.24,196.53 },
	{ 228.39,766.03,204.79,52.29 },
	{ -1808.41,333.68,89.38,27.88 },
	{ -1839.08,315.02,90.92,99.56 },
	{ -2008.77,367.57,94.82,274.63 },
	{ -400.87,427.29,112.35,254.81 },
	{ -1943.15,449.57,102.93,102.5 },
	{ -452.0,395.63,104.78,359.73 },
	{ -1998.72,541.14,109.55,231.7 },  
	{ 938.9,-2127.41,30.51,87.34 },
	{ -1974.3,630.82,122.54,242.14 },
	{ -516.87,433.29,97.81,142.75 },
	{ -595.45,530.18,107.76,205.1 },
	{ 467.28,-1590.0,32.8,324.07 },
	{ -622.95,489.26,108.85,14.64 },
	{ 455.17,-1579.86,32.8,321.63 },
	{ 461.11,-1573.9,32.8,231.73 },
	{ -1219.34,-357.99,37.29,298.47 },   
	{ -640.93,519.9,109.69,197.09 },
	{ -1178.15,-372.08,36.63,98.84 }, 
	{ -1027.63,-498.8,36.77,7.69 }, 
	{ -1032.65,-544.43,35.29,27.78 },
	{ 559.19,-1777.12,33.45,336.29 },
	{ -1029.73,-538.32,35.54,226.48 },
	{ -667.13,471.63,114.14,16.34 },
	{ -1013.38,-534.84,36.22,37.35 },
	{ 550.17,-1772.95,33.45,336.39 },
	{ 552.54,-1765.33,33.45,250.4 },
	{ 559.54,-1750.98,33.45,239.8 },
	{ -679.0,511.84,113.53,200.14 },
	{ -1285.42,-651.8,26.59,34.21 }, 
	{ 561.58,-1747.57,33.45,160.94 },
	{ 558.04,-1759.9,29.32,251.63 },
	{ 562.02,-1751.87,29.29,242.12 },
	{ -741.97,484.46,109.47,124.86 },
	{ 550.63,-1775.87,29.32,244.48 },
	{ -1310.53,-931.68,13.36,21.25 }, 
	{ -1331.21,-939.1,15.36,21.72 },
	{ -1339.15,-941.41,12.36,299.98 }, 
	{ -784.12,458.79,100.18,215.3 },
	{ 1301.21,-573.99,71.74,344.71 },
	{ 1323.72,-582.76,73.25,333.14 },
	{ 1341.72,-597.67,74.71,323.11 },
	{ 1367.32,-606.1,74.72,2.66 },
	{ 1385.83,-593.06,74.49,57.13 },
	{ 1388.56,-569.65,74.5,113.0 },
	{ 1372.36,-555.55,74.69,152.69 },
	{ 1348.15,-547.18,73.9,163.5 },
	{ 1327.67,-535.72,72.45,160.53 },
	{ 1302.68,-528.59,71.47,162.45 },
	{ 1251.19,-515.59,69.35,256.11 },
	{ 1253.01,-494.51,69.51,263.51 },
	{ 1260.01,-479.84,70.19,295.2 },
	{ 1265.93,-457.9,70.52,281.78 },
	{ 1262.68,-429.93,70.02,296.0 },
	{ 1241.33,-366.93,69.09,162.65 },
	{ 1241.64,-565.8,69.66,301.63 },
	{ 1236.8,-588.75,69.43,3.71 },
	{ 1251.3,-621.54,69.42,231.65 },
	{ 1265.4,-647.99,67.93,304.44 },
	{ 1270.92,-682.73,66.04,274.41 },
	{ 1265.37,-703.25,64.57,243.91 },
	{ 1228.96,-725.5,60.8,114.83 },
	{ 1222.56,-696.87,60.81,107.04 },
	{ 1221.59,-668.46,63.5,105.65 },
	{ 1206.93,-620.34,66.44,96.86 },
	{ 1203.56,-598.4,68.07,188.59 },
	{ 1200.77,-575.69,69.14,135.99 },
	{ 1204.75,-557.54,69.62,89.75 },
	{ 1090.29,-484.37,65.67,80.45 },
	{ 1098.61,-464.6,67.32,164.73 },
	{ 1099.93,-450.73,67.79,86.59 },
	{ 1100.42,-411.34,67.56,97.01 },
	{ 1060.49,-378.3,68.24,222.9 },
	{ 1029.54,-409.26,65.95,218.45 },
	{ 1011.21,-422.82,64.96,308.95 },
	{ 988.13,-433.62,63.9,231.86 },
	{ 1014.51,-469.21,64.51,45.55 },
	{ 970.31,-502.34,62.15,76.26 },
	{ 921.94,-478.19,61.09,209.25 },
	{ 906.41,-489.82,59.44,205.09 },
	{ 878.56,-498.1,58.1,235.05 },
	{ 886.85,-608.27,58.45,314.89 },
	{ 903.7,-615.93,58.46,322.38 },
	{ 1094.07,-795.03,58.27,1.19 },
	{ 895.52,-896.27,27.8,87.3 },
	{ 739.99,-970.16,24.46,272.82 },
	{ 185.55,-584.03,43.87,251.66 },
	{ 213.61,-568.88,43.87,329.83 },
	{ 78.17,289.44,110.22,64.67 },
	{ -122.94,229.49,94.92,69.29 },
	{ -372.35,193.54,83.66,188.7 },
	{ -491.37,-70.0,40.4,57.8 },
	{ -291.49,-429.89,30.24,338.89 },
	{ -242.21,-335.05,29.98,186.27 },
	{ -480.48,-401.78,34.55,354.73 },
}

local callName = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio","Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local callName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		for k, v in pairs(startLocations) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 5 then
				timeDistance = 4
	
				if not inService then
					DrawText3D(v[1],v[2],v[3],"~g~E~w~   INICIAR")
				else
					DrawText3D(v[1],v[2],v[3],"~g~E~w~   FINALIZAR")
				end
	
				if distance <= 1 and IsControlJustPressed(1,38) then
					if inService then
						inService = false
						TriggerEvent("Notify","amarelo", "Vendas finalizada.", 5000)
	
						if inPed then
							DeleteEntity(inPed)
							inTimers = 30
						end
					else
						inService = true
						TriggerEvent("Notify","amarelo", "Vendas iniciadas. Aguarde que os clientes irão entrar em contato.", 5000)

						randomizeNewCustomer()
						startCustomerThread()
					end
				end
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADDELIVERY
-----------------------------------------------------------------------------------------------------------------------------------------
function startCustomerThread()
	Citizen.CreateThread(function()
		while inService do
			local timeDistance = 500

			if inPed and inTimers <= 0 then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local coordsPed = GetEntityCoords(inPed)
				local distance = #(coords - coordsPed)

				if distance <= 25 then
					timeDistance = 4

					if timeSelling > 0 then
						DisableControlAction(1,23,true)
						DrawText3D(coordsPed.x,coordsPed.y,coordsPed.z,"~w~AGUARDE  ~g~"..timeSelling.."~w~  SEGUNDOS")
					else
						DrawText3D(coordsPed.x,coordsPed.y,coordsPed.z,"~g~G~w~   VENDER")
						if distance <= 2 then
							if IsControlJustPressed(1,47) and vSERVER.checkAmount() and not IsPedInAnyVehicle(ped) then
								timeSelling = 12
								sellDrugs()

								if math.random(100) < 65 then
									TriggerServerEvent("drugs:markOccurrence")
								end
							end
						end
					end
				end
			end

			Citizen.Wait(timeDistance)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
function randomizeNewCustomer()
	Citizen.CreateThread(function()
		while inService and inTimers > 0 do
			inTimers = inTimers - 1

			if inTimers <= 0 then
				if inPed then
					DeleteEntity(inPed)
					inPed = nil
				end

				local mHash = GetHashKey(pedHashs[math.random(#pedHashs)])

				RequestModel(mHash)
				while not HasModelLoaded(mHash) do
					RequestModel(mHash)
					Citizen.Wait(10)
				end

				local rand = math.random(#pedLocate)
				inPed = CreatePed(4,mHash,pedLocate[rand][1],pedLocate[rand][2],pedLocate[rand][3]-1,pedLocate[rand][4],false,false)
				SetEntityInvincible(inPed,true)
				FreezeEntityPosition(inPed,true)
				SetPedSuffersCriticalHits(inPed,false)
				SetBlockingOfNonTemporaryEvents(inPed,true)
				SetModelAsNoLongerNeeded(mHash)
				TriggerEvent("NotifyPush",{ code = 31, title = "Quero comprar um produto", x = pedLocate[rand][1], y = pedLocate[rand][2], z = pedLocate[rand][3], name = callName[math.random(#callName)].." "..callName2[math.random(#callName2)], rgba = {69,115,41} })
			end
			Citizen.Wait(10)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESELLING
-----------------------------------------------------------------------------------------------------------------------------------------
function sellDrugs()
	Citizen.CreateThread(function()
		while timeSelling > 0 do
			timeSelling = timeSelling - 1

			local ped = PlayerPedId()
			local coords = GetEntityCoords(ped)
			local coordsPed = GetEntityCoords(inPed)
			local distance = #(coords - coordsPed)

			if timeSelling <= 0 then
				RequestAnimDict("pickup_object")
				while not HasAnimDictLoaded("pickup_object") do
					RequestAnimDict("pickup_object")
					Citizen.Wait(10)
				end

				TaskPlayAnim(inPed,"pickup_object","putdown_low",3.0,3.0,-1,48,10,0,0,0)
				SetEntityInvincible(inPed,false)
				FreezeEntityPosition(inPed,false)
				TaskWanderStandard(inPed,10.0,10)
				inTimers = 30

				randomizeNewCustomer()

				vSERVER.paymentMethod()

				-- Citizen.Wait(math.random(2000,5000))

				-- if math.random(100) >= 95 then
				-- 	GiveWeaponToPed(inPed,GetHashKey("WEAPON_PISTOL"),200,true,true)
				-- 	TaskShootAtEntity(inPed,ped,1000,GetHashKey("FIRING_PATTERN_FULL_AUTO"))
				-- end
			end

			if distance >= 3 then
				FreezeEntityPosition(inPed,false)
				TaskWanderStandard(inPed,10.0,10)
				timeSelling = 0
				inTimers = 30

				randomizeNewCustomer()
			end

			Citizen.Wait(1000)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOWME3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(x,y,z,text)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)
		SetTextColour(255,255,255,150)
		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 160 * 0.45
		DrawRect(_x,_y + 0.0125,width,0.03,38,42,56,200)
	end
end

