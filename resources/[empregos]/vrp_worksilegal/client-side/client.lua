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
Tunnel.bindInterface("vrp_worksilegal",cRP)
vSERVER = Tunnel.getInterface("vrp_worksilegal")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local works = {}
local inService = false
local timeSelling = 0
local inTimers = 10
local inPed = nil
local inCollect = 0
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

local callName = { "James","John","Robert","Michael","William","David","Richard","Charles","Joseph","Thomas","Christopher","Daniel","Paul","Mark","Donald","George","Kenneth","Steven","Edward","Brian","Ronald","Anthony","Kevin","Jason","Matthew","Gary","Timothy","Jose","Larry","Jeffrey","Frank","Scott","Eric","Stephen","Andrew","Raymond","Gregory","Joshua","Jerry","Dennis","Walter","Patrick","Peter","Harold","Douglas","Henry","Carl","Arthur","Ryan","Roger","Joe","Juan","Jack","Albert","Jonathan","Justin","Terry","Gerald","Keith","Samuel","Willie","Ralph","Lawrence","Nicholas","Roy","Benjamin","Bruce","Brandon","Adam","Harry","Fred","Wayne","Billy","Steve","Louis","Jeremy","Aaron","Randy","Howard","Eugene","Carlos","Russell","Bobby","Victor","Martin","Ernest","Phillip","Todd","Jesse","Craig","Alan","Shawn","Clarence","Sean","Philip","Chris","Johnny","Earl","Jimmy","Antonio","Mary","Patricia","Linda","Barbara","Elizabeth","Jennifer","Maria","Susan","Margaret","Dorothy","Lisa","Nancy","Karen","Betty","Helen","Sandra","Donna","Carol","Ruth","Sharon","Michelle","Laura","Sarah","Kimberly","Deborah","Jessica","Shirley","Cynthia","Angela","Melissa","Brenda","Amy","Anna","Rebecca","Virginia","Kathleen","Pamela","Martha","Debra","Amanda","Stephanie","Carolyn","Christine","Marie","Janet","Catherine","Frances","Ann","Joyce","Diane","Alice","Julie","Heather","Teresa","Doris","Gloria","Evelyn","Jean","Cheryl","Mildred","Katherine","Joan","Ashley","Judith","Rose","Janice","Kelly","Nicole","Judy","Christina","Kathy","Theresa","Beverly","Denise","Tammy","Irene","Jane","Lori","Rachel","Marilyn","Andrea","Kathryn","Louise","Sara","Anne","Jacqueline","Wanda","Bonnie","Julia","Ruby","Lois","Tina","Phyllis","Norma","Paula","Diana","Annie","Lillian","Emily","Robin" }
local callName2 = { "Smith","Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark","Rodriguez","Lewis","Lee","Walker","Hall","Allen","Young","Hernandez","King","Wright","Lopez","Hill","Scott","Green","Adams","Baker","Gonzalez","Nelson","Carter","Mitchell","Perez","Roberts","Turner","Phillips","Campbell","Parker","Evans","Edwards","Collins","Stewart","Sanchez","Morris","Rogers","Reed","Cook","Morgan","Bell","Murphy","Bailey","Rivera","Cooper","Richardson","Cox","Howard","Ward","Torres","Peterson","Gray","Ramirez","James","Watson","Brooks","Kelly","Sanders","Price","Bennett","Wood","Barnes","Ross","Henderson","Coleman","Jenkins","Perry","Powell","Long","Patterson","Hughes","Flores","Washington","Butler","Simmons","Foster","Gonzales","Bryant","Alexander","Russell","Griffin","Diaz","Hayes" }
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTSERVICE COLLECT
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local coords = GetEntityCoords(ped)
			
			for k,v in pairs(works) do
				local distance = #(coords - vector3(v["coords"][1],v["coords"][2],v["coords"][3]))
				if distance <= 2 then
					timeDistance = 4

					if not inService then
						DrawText3D(v["coords"][1],v["coords"][2],v["coords"][3],"~g~E~w~   INICIAR") 
					else
						DrawText3D(v["coords"][1],v["coords"][2],v["coords"][3],"~g~E~w~   FINALIZAR")
					end


					if IsControlJustPressed(1,38) and vSERVER.checkPermission(k) then
						if not inService then
							inService = k
							inCollect = 1
							inTimers = 5
							TriggerEvent("Notify","verde", "Serviço de <b>"..k.."</b> foi iniciado.", 5000)
						else 
							if inService == k then 
								inService = false
								if inPed ~= nil then
									DeleteEntity(inPed)
									inTimers = 10
								end
								TriggerEvent("Notify","verde", "Serviço de <b>"..k.."</b> foi finalizado.", 5000)
							else
								TriggerEvent("Notify","verde", "Dirija-se até o emprego de <b>"..inService.."</b> e finalize o mesmo.", 5000)
							end
						end
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
Citizen.CreateThread(function()
	while true do
		local timeDistance = 500

		if inService then
			if inPed ~= nil and inTimers <= 0 then
				local ped = PlayerPedId()
				local coords = GetEntityCoords(ped)
				local coordsPed = GetEntityCoords(inPed)
				local distance = #(coords - coordsPed)

				if distance <= 30 then
					timeDistance = 4

					if timeSelling > 0 then
						DisableControlAction(1,23,true)
						DrawText3D(coordsPed.x,coordsPed.y,coordsPed.z,"~w~AGUARDE  ~g~"..timeSelling.."~w~  SEGUNDOS")
					else
						DrawText3D(coordsPed.x,coordsPed.y,coordsPed.z,"~g~E~w~   RECEBER ENCOMENDA")
						if distance <= 2 then
							if IsControlJustPressed(1,38) and not IsPedInAnyVehicle(ped) then
								timeSelling = 5
							end
						end
					end
				end
			end
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADINTIMERS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if inService and inTimers > 0 then
			inTimers = inTimers - 1

			if inTimers == 60 and inPed ~= nil then
				DeleteEntity(inPed)
				inPed = nil
			end

			if inTimers <= 0 then
				local mHash = GetHashKey(pedHashs[math.random(#pedHashs)])

				RequestModel(mHash)
				while not HasModelLoaded(mHash) do
					RequestModel(mHash)
					Citizen.Wait(10)
				end


                if inCollect >= #works[inService]["collectCoords"] then
                    inCollect = 1
                else
                    inCollect = inCollect + 1
                end


				inPed = CreatePed(4,mHash,works[inService]["collectCoords"][inCollect][1],works[inService]["collectCoords"][inCollect][2],works[inService]["collectCoords"][inCollect][3]-1,works[inService]["collectCoords"][inCollect][4],false,false)
				SetEntityInvincible(inPed,true)
				FreezeEntityPosition(inPed,true)
				SetPedSuffersCriticalHits(inPed,false)
				SetBlockingOfNonTemporaryEvents(inPed,true)
				SetModelAsNoLongerNeeded(mHash)

				TriggerEvent("NotifyPush",{ code = 20, title = "Entrega de Encomenda", x = works[inService]["collectCoords"][inCollect][1], y = works[inService]["collectCoords"][inCollect][2], z = works[inService]["collectCoords"][inCollect][3], name = callName[math.random(#callName)].." "..callName2[math.random(#callName2)], rgba = {69,115,41} })
			end
		end

		Citizen.Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TIMESELLING
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		if timeSelling > 0 then
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
				inTimers = 5

				vSERVER.paymentMethod(inService)
			end

			if distance >= 3 then
				FreezeEntityPosition(inPed,false)
				TaskWanderStandard(inPed,10.0,10)
				timeSelling = 0
				inTimers = 5
			end
		end

		Citizen.Wait(1000)
	end 
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSECONDS
-----------------------------------------------------------------------------------------------------------------------------------------
function cRP.updateWorks(status)
	works = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
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