-- N8Gamez LICENSE/AGREEMENT:
-- BY USING THIS MOD OR VIEWING ITS CONTENTS YOU HEREBY ABSOLUTELY AGREE TO ALL OF THE FOLLOWING:
--
-- All GTA V Mods are direct violation of ROCKSTARGAMES License Agreements. 
-- Mosquito bites make you itch. Trees are good for the environment!
-- You will feel free to use any of N8Gamez scripts that he shares which are written in lua format.
-- If any N8Gamez scripts helps you learn how to write some lua scripts, you will strive to do it better...
-- By reading this N8Gamez License/Agreement YOU CONSENT to something, not sure what but really who knows.
-- End of N8Gamez LICENSE/AGREEMENT.
-- Ok so: Feel free to do what you want with this mod/script.
--
Toddler_Carry = {}

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------- 								THIS SCRIPT WAS MADE FOR INSANOGAMES BABY/TODDLER MODS
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
---
---
-------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------|        CUSTOMIZE YOUR HOT KEYS         |--------------------------------------------------------------
-----------------------------------------------v----------------------------------------v--------------------------------------------------------------
--- 
---
---------
---                            		<   STANDARD KEYBOARDS  >
---  
--- To change key number: See the keys.lua file in your GTA V/scripts folder location.
---------
---------
---------- TO SPAWN CHILD(REN) USES TWO KEYS 
local CHILDSPWN = Keys.Add ---------------- USED WITH KEY BELOW
------- SECOND KEY ASSIGN BELOW FOR CHILD ONE AND CHILD TWO.
local One_Tyke = Keys.NumPad1
local Two_Tyke = Keys.NumPad2
---------
---------
---------- TO PICKUP CHILD USES TWO KEYS 
local FIRst_KEy = Keys.Decimal; --<-------------->- USED WITH ONE OF THE KEYS BELOW
------- SECOND KEY ASSIGN BELOW TO HOLD CHILD ON ARM OR ON SHOULDERS.
local Pull_up = Keys.NumPad1;--- ON ARM
local Hop_on = Keys.NumPad2--- ON SHOULDERS
---
---------
---------
---------- TO SETDOWN CHILD USES TWO KEYS 
local Removkd_KEy = Keys.Decimal;
local Set_DWN = Keys.NumPad0
---
---------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------   END OF CONFIGURABLE KEYS  -------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
----
-------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------|        CUSTOMIZE BABY MODEL NAMES      |--------------------------------------------------------------
-----------------------------------------------v----------------------------------------v--------------------------------------------------------------
------------ ASSIGN BABY NAMES BELOW eg: CHANGE  "Baby_1"  FOR THE MODEL NAME YOU USED. LEAVE QUOTATIONS JUST CHANGE NAME SO IF MODEL NAME IS PRECILLA THEN CHANGE "BabySitter" to "Precilla"
---------
local Kido_1 = GAMEPLAY.GET_HASH_KEY("Baby_1");
local Kido_2 = GAMEPLAY.GET_HASH_KEY("Baby_2");
local Kido_3 = GAMEPLAY.GET_HASH_KEY("Baby_3");
local Kido_4 = GAMEPLAY.GET_HASH_KEY("Baby_4");
local Kido_5 = GAMEPLAY.GET_HASH_KEY("Baby_5");
local Kido_6 = GAMEPLAY.GET_HASH_KEY("Baby_6");
local Kido_7 = GAMEPLAY.GET_HASH_KEY("Baby_7");
local Kido_8 = GAMEPLAY.GET_HASH_KEY("Baby_8");
local Kido_9 = GAMEPLAY.GET_HASH_KEY("Baby_9");
local Kido_10 = GAMEPLAY.GET_HASH_KEY("Baby_10");
local Kido_11 = GAMEPLAY.GET_HASH_KEY("Baby_11");
local Kido_12 = GAMEPLAY.GET_HASH_KEY("Baby_12");

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------   END OF CONFIGURABLE MODEL NAMES  -------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--
--- This script will recognize up to 12 babies/toddlers it will pick up the one you are facing, or the baby/toddler that is anxious with hands to be picked up. Face child to pick it up.
---
function Toddler_Carry.unload()
end

function Toddler_Carry.init()
	BabySitter = PLAYER.PLAYER_PED_ID();
	AdultLoc = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), nil);
	Commentary = ENTITY.GET_ENTITY_MODEL(BabySitter);
	Famunit_A = PLAYER.GET_PLAYER_GROUP(BabySitter);
	Adult_facen = 0.0;
	count = 0;
	lastPlayer = 0;
	model = 0;
	Converse = 0;
	Arm_rider = false;
	followNow = false;
	Hold_me = false;
	Hold_me_2 = false;
	Hold_please = false;
	isOnPed = false;
	keyPressed = false;
	keyPushed = false;
	Let_go_baby = false;
	PkupPause = false;
	PU_CHK = false;
	Talk_Chk = false;
	Unite_1 = false;
	Unite_2 = false;
	PkupPaus1 = false;
	PkupPaus2 = false;
	Shoulder_rider = false;
end

function Reach_out()
	local SpotKid = {};
	local SpotKidCount = {};
	local SpotKid,SpotKidCount = PED.GET_PED_NEARBY_PEDS(BabySitter, 12, 28);
	
	for k,v in ipairs(SpotKid)do
		Child = SpotKid[1];
	end
	if(PED.IS_PED_MODEL(Child, Kido_1)) then
		model = 1;
	elseif(PED.IS_PED_MODEL(Child, Kido_2)) then                                
		model = 2;
	elseif(PED.IS_PED_MODEL(Child, Kido_3)) then
		model = 3;
	elseif(PED.IS_PED_MODEL(Child, Kido_4)) then
		model = 4;
	elseif(PED.IS_PED_MODEL(Child, Kido_5)) then                                
		model = 5;
	elseif(PED.IS_PED_MODEL(Child, Kido_6)) then
		model = 6;
	elseif(PED.IS_PED_MODEL(Child, Kido_7)) then
		model = 7;
	elseif(PED.IS_PED_MODEL(Child, Kido_8)) then                                
		model = 8;
	elseif(PED.IS_PED_MODEL(Child, Kido_9)) then
		model = 9;
	elseif(PED.IS_PED_MODEL(Child, Kido_10)) then
		model = 10;
	elseif(PED.IS_PED_MODEL(Child, Kido_11)) then                                
		model = 11;
	elseif(PED.IS_PED_MODEL(Child, Kido_12)) then
		model = 12;
	end
	if(ENTITY.IS_ENTITY_ON_SCREEN(Child)) and((model == 1) or(model == 2) or(model == 3) or(model == 4) or(model == 5) or(model == 6) or(model == 7) or(model == 8) or(model == 9) or(model == 10) or(model == 11) or(model == 12)) then
		AI.TASK_TURN_PED_TO_FACE_ENTITY(Child, BabySitter, -1);
		PkupPause = true;
		SYSTEM.SETTIMERA(-1);
	elseif(not ENTITY.IS_ENTITY_ON_SCREEN(Child)) or(model == 0) then
		keyPressed = false;
		local SpotKid = {}; 
		local SpotKidCount = {};
		local SpotKid,SpotKidCount = PED.GET_PED_NEARBY_PEDS(BabySitter, 1, 28);
		for k,v in ipairs(SpotKid)do
			Child = SpotKid[1];
		end
		AI.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "rcmnigel1c", "hailing_whistle_waive_a", 8, -8, 800, 48, 0, false, false, false);
	end
end

function runAnimz(loop) 
	local a = -1;
	local b = 1;

	if not loop then
		a = 1;
		b = 0;
	end
	STREAMING.REQUEST_ANIM_DICT("ladders@female");
	AI.TASK_PLAY_ANIM(Child, "ladders@female", "get_on_bottom_left_run", -6, 4, -1, b, 0.000, false,false,false);
end

function CarrinKid(BabySitter)
	local flag = true;
	if(not ENTITY.IS_ENTITY_ATTACHED_TO_ANY_PED(BabySitter)) then
		flag = false;
	end
	return flag;
end

function Kidruns(BabySitter)
	STREAMING.REQUEST_ANIM_DICT("anim@move_m@trash");
	AI.TASK_PLAY_ANIM(BabySitter, "anim@move_m@trash","pickup", -8, 4, 420, 0, 0.605, false,false,false);
	ENTITY.ATTACH_ENTITY_TO_ENTITY(Child, BabySitter, PED.GET_PED_BONE_INDEX(BabySitter, 28252), 0.150, 0.010, 0.150, 185, 100, 90,true, true, true, true, 1,true);
	Let_go_baby = true;
	SYSTEM.SETTIMERA(-1);
end

function dimountcmplt()
	AI.CLEAR_PED_TASKS(Child);
	ENTITY.DETACH_ENTITY(Child, true, true);
	ENTITY.DETACH_ENTITY(BabySitter, true, true);
	PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(BabySitter, false);
	isOnPed = false;
	followNow = true;
	model = 0;
end

function Random_siter()
	Siton = GAMEPLAY.GET_RANDOM_INT_IN_RANGE(1, 4);
	if(Siton == 1) then
		STREAMING.REQUEST_ANIM_DICT("mp_safehouseseated@male@generic@idle_b");
		AI.TASK_PLAY_ANIM(Child,"mp_safehouseseated@male@generic@idle_b", "idle_e", 4, -4, -1, 48, 0, true, true, true);
	end
	if(Siton == 2) then
		STREAMING.REQUEST_ANIM_DICT("mp_safehouseseated@male@generic@idle_a");
		AI.TASK_PLAY_ANIM(Child,"mp_safehouseseated@male@generic@idle_a", "idle_c", 4, -4, -1, 48, 0, true, true, true);
	end
	if(Siton == 3) then
		STREAMING.REQUEST_ANIM_DICT("mp_safehouseseated@male@generic@idle_a");
		AI.TASK_PLAY_ANIM(Child,"mp_safehouseseated@male@generic@idle_a", "idle_b", 4, -4, -1, 48, 0, true, true, true);
	end
	if(Siton == 4) then
		STREAMING.REQUEST_ANIM_DICT("mp_safehouseseated@male@generic@idle_a");
		AI.TASK_PLAY_ANIM(Child,"mp_safehouseseated@male@generic@idle_a", "idle_a", 4, -4, -1, 48, 0, true, true, true);
	end
end

function Shoulder_guy()
	AI.TASK_LOOK_AT_ENTITY(Child, BabySitter, 1850, 2048, 3);
	runAnimz(true);
	STREAMING.REQUEST_ANIM_DICT("anim@sports@ballgame@handball@");
	AI.TASK_PLAY_ANIM(BabySitter, "anim@sports@ballgame@handball@", "ball_idle", -6, 3, 800, 48, 0.0, false,false,false);
	wait(150);
	ENTITY.ATTACH_ENTITY_TO_ENTITY(Child, BabySitter, PED.GET_PED_BONE_INDEX(BabySitter, 60309), 0.0, 0.0, -0.30, 110.0, 0.0, 0.0,true, true, true, true, 1,true);
	wait(550);
	runAnimz(false);
	ENTITY.ATTACH_ENTITY_TO_ENTITY(Child, BabySitter, PED.GET_PED_BONE_INDEX(BabySitter, 31086), 0.45, -0.35, 0.0, -10, 90, 0,true, true, true, true, 1,true);
	STREAMING.REQUEST_ANIM_DICT("veh@boat@speed@fps@base");
	AI.TASK_PLAY_ANIM(Child, "veh@boat@speed@fps@base", "sit_idle", 8, 8, -1, 1, 0.445, false,false,false);
	isOnPed = true;
	AI.TASK_LOOK_AT_ENTITY(BabySitter, Child, -1, 2048, 3);
	AI.TASK_LOOK_AT_ENTITY(Child, BabySitter, -1, 2048, 3);
	STREAMING.REQUEST_MODEL(Commentary);
	while(not STREAMING.HAS_MODEL_LOADED(Commentary)) do
		wait(50);
	end
	AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
	if(STREAMING.HAS_MODEL_LOADED(Commentary)) then
		Converse = PED.CREATE_PED(12, Commentary, AdultLoc.x, AdultLoc.y+5, AdultLoc.z, Adult_facen, false, true);
		ENTITY.SET_ENTITY_ALPHA(Converse, 0, false);
	end
	Talk_Chk = true;
	Shoulder_rider = true;
	AUDIO._PLAY_AMBIENT_SPEECH1(Converse, "HOWS_IT_GOING_FEMALE", "SPEECH_PARAMS_FORCE_SHOUTED");
	SYSTEM.SETTIMERA(-1);
end

function Arm_chair()
	STREAMING.REQUEST_ANIM_DICT("move_duck_for_cover");
	AI.TASK_PLAY_ANIM(BabySitter, "move_duck_for_cover", "exit", -4, 8, 460, 0, 0.0, false,false,false);
	STREAMING.REQUEST_ANIM_DICT("ladders@female");
	AI.TASK_PLAY_ANIM(Child, "ladders@female", "get_on_bottom_left_run", -6, 4, 180, 48, 0.300, false,false,false);
	Unite_1 = true;
	AI.TASK_LOOK_AT_ENTITY(BabySitter, Child, -1, 2048, 3);
	AI.TASK_LOOK_AT_ENTITY(Child, BabySitter, -1, 2048, 3);
	STREAMING.REQUEST_MODEL(Commentary);
	while(not STREAMING.HAS_MODEL_LOADED(Commentary)) do
		wait(50);
	end
	AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
	if(STREAMING.HAS_MODEL_LOADED(Commentary)) then
		Converse = PED.CREATE_PED(12, Commentary, AdultLoc.x, AdultLoc.y+5, AdultLoc.z, Adult_facen, false, true);
		ENTITY.SET_ENTITY_ALPHA(Converse, 0, false);
	end
	Talk_Chk = true;
	Arm_rider = true;
	AUDIO._PLAY_AMBIENT_SPEECH1(Converse, "HOWS_IT_GOING_FEMALE", "SPEECH_PARAMS_FORCE_SHOUTED");
	SYSTEM.SETTIMERA(-1);
end

function FollowMe()	-- Setting Child as group member and following behind player at nominal distance
	PED.SET_PED_RELATIONSHIP_GROUP_HASH(Child, Famunit_A);
	PED.SET_PED_AS_GROUP_MEMBER(PLAYER.PLAYER_PED_ID(), Famunit_A);
	PED.SET_PED_AS_GROUP_MEMBER(BabySitter, Famunit_A);	
	AI.TASK_FOLLOW_TO_OFFSET_OF_ENTITY(Child, BabySitter, 0, -0.2, 0, -1, -1, .8, true);
	PED.SET_PED_KEEP_TASK(Child, true);
end

function Toddler_Carry.tick()
	if(get_key_pressed(CHILDSPWN) and get_key_pressed(One_Tyke)) then
		model = GAMEPLAY.GET_HASH_KEY("Baby_1");
		local Adult_facen = ENTITY.GET_ENTITY_HEADING(BabySitter);
		local Makebaby = 0;
		AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
		STREAMING.REQUEST_MODEL(model);
		while(not STREAMING.HAS_MODEL_LOADED(model)) do
			wait(50);
		end
		AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
		if(STREAMING.HAS_MODEL_LOADED(model)) then
			Makebaby = PED.CREATE_PED(12, model, AdultLoc.x+0.7, AdultLoc.y, AdultLoc.z, Adult_facen, false, true);
			wait(350);
		end
		PED.CLEAR_PED_PROP(BabySitter, 0);
	end
	if(get_key_pressed(CHILDSPWN) and get_key_pressed(Two_Tyke)) then
		local Adult_facen = ENTITY.GET_ENTITY_HEADING(BabySitter);
		local Makebaby = 0;
		AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
		STREAMING.REQUEST_MODEL(Kido_1);
		while(not STREAMING.HAS_MODEL_LOADED(Kido_1)) do
			wait(50);
		end
		AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
		if(STREAMING.HAS_MODEL_LOADED(Kido_1)) then
			Makebaby = PED.CREATE_PED(12, Kido_1, AdultLoc.x, AdultLoc.y+0.7, AdultLoc.z, Adult_facen, false, true);
		end
		STREAMING.REQUEST_MODEL(Kido_2);
		while(not STREAMING.HAS_MODEL_LOADED(Kido_2)) do
			wait(50);
		end
		AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
		if(STREAMING.HAS_MODEL_LOADED(Kido_2)) then
			Makebaby = PED.CREATE_PED(12, Kido_2, AdultLoc.x+0.7, AdultLoc.y, AdultLoc.z, Adult_facen, false, true);
			wait(350);
		end
		PED.CLEAR_PED_PROP(BabySitter, 0);
	end
	if(PkupPause) and(PkupPaus1) and(not PkupPaus2) then
		PkupPause = false;
		keyPressed = true;
		PkupPaus1 = true;
	end
	if(PkupPause) and(PkupPaus2) and(not PkupPaus1) then
		PkupPause = false;
		keyPushed = true;
		PkupPaus2 = true;
	end
	if(PkupPaus1) and(SYSTEM.TIMERA() > 500) then
		keyPressed = true;
		PkupPaus1 = false;
		keyPushed = false;
	end
	if(PkupPaus2) and(SYSTEM.TIMERA() > 500) then
		keyPushed = true;
		PkupPaus2 = false;
		keyPressed = false;
	end
	if(PkupPaus_2) and(SYSTEM.TIMERA() > 500) then
		keyPressed = true;
		PkupPaus_2 = false;
		keyPushed = false;
	end
	if(PkupPaus_3) and(SYSTEM.TIMERA() > 500) then
		keyPushed = true;
		PkupPaus_3 = false;
		keyPressed = false;
	end
	if(get_key_pressed(Removkd_KEy) and get_key_pressed(Set_DWN)) and(isOnPed) then-- send with switch to run anims for putting down kid
		PU_CHK = false;
		Arm_rider = false;
		Shoulder_rider = false;
		isOnPed = false;
		Hold_me = false;
		Hold_me_2 = false;
		Hold_please = false;
		AI.CLEAR_PED_TASKS(BabySitter);
		STREAMING.REQUEST_ANIM_DICT("melee@holster");
		AI.TASK_PLAY_ANIM(BabySitter, "melee@holster", "unholster", -8, 4, 420, 0, 0.605, false,false,false);
		wait(400);
		STREAMING.REQUEST_MODEL(GAMEPLAY.GET_HASH_KEY("Baby_1"));
		while(not STREAMING.HAS_MODEL_LOADED(GAMEPLAY.GET_HASH_KEY("Baby_1"))) do
			wait(50);
		end
		AdultLoc = ENTITY.GET_ENTITY_COORDS(BabySitter, nil);
		if(STREAMING.HAS_MODEL_LOADED(Commentary)) then
			Converse = PED.CREATE_PED(12, Commentary, AdultLoc.x, AdultLoc.y+2, AdultLoc.z, Adult_facen, false, true);
			ENTITY.SET_ENTITY_ALPHA(Converse, 0, false);
		end
		Talk_Chk = true;
		if(PED.IS_PED_MODEL(BabySitter, GAMEPLAY.GET_HASH_KEY("Player_zero"))) then
			AUDIO._PLAY_AMBIENT_SPEECH1(Converse, "ACTIVITY_LEAVING", "SPEECH_PARAMS_FORCE_SHOUTED");
		elseif(PED.IS_PED_MODEL(BabySitter, GAMEPLAY.GET_HASH_KEY("Player_one"))) then
			AUDIO._PLAY_AMBIENT_SPEECH1(Converse, "ACTIVITY_LEAVING", "SPEECH_PARAMS_FORCE_SHOUTED");
		elseif(PED.IS_PED_MODEL(BabySitter, GAMEPLAY.GET_HASH_KEY("Player_two"))) then
			AUDIO._PLAY_AMBIENT_SPEECH1(Converse, "GETTING_OLD", "SPEECH_PARAMS_FORCE_SHOUTED");
		end
		SYSTEM.SETTIMERA(-1);
		Kidruns(BabySitter);
	end
	if(count <= 0) then
		if(get_key_pressed(FIRst_KEy) and get_key_pressed(Pull_up)) and not(isOnPed) then --- Ride in arm
			count = 50;
			Reach_out();
			wait(400);
			PkupPaus1 = true;
		end
		if(get_key_pressed(FIRst_KEy) and get_key_pressed(Hop_on)) and not(isOnPed) then --- Ride 0n shoulders
			count = 50;
			Reach_out();
			wait(400);
			PkupPaus2 = true;
		end
	end
	count = count - 1;
	if(keyPressed) then
		keyPressed = false;
		if(not isOnPed) then
			AI.TASK_GO_TO_ENTITY(Child, BabySitter, -1, 2, 10, 1073741824, 0);
			STREAMING.REQUEST_ANIM_DICT("misscarsteal4@vendor");
			AI.TASK_PLAY_ANIM(Child, "misscarsteal4@vendor", "base_vendor", -4, -4, -1, 48, 0.0, false, false, false);
			PU_CHK = true;
		end
	end
	if(keyPushed) then
		keyPushed = false;
		if(not isOnPed) then
			AI.TASK_GO_TO_ENTITY(Child, BabySitter, -1, 2, 10, 1073741824, 0);
			STREAMING.REQUEST_ANIM_DICT("misscarsteal4@vendor");
			AI.TASK_PLAY_ANIM(Child, "misscarsteal4@vendor", "base_vendor", -4, -4, -1, 48, 0.0, false, false, false);
			PU_CHK_2 = true;
		end
	end
	if(PU_CHK) and(PED.IS_PED_FACING_PED(BabySitter, Child, 15)) and(not Shoulder_rider) then
		local BbSitLoc = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), nil);
		local BabyLoc = ENTITY.GET_ENTITY_COORDS(Child, nil);
		local Totdist = GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(BbSitLoc.x, BbSitLoc.y, BbSitLoc.z, BabyLoc.x, BabyLoc.y, BabyLoc.z, false);
		if(Totdist < 1.0) then
			PU_CHK = false;
			AI.TASK_TURN_PED_TO_FACE_ENTITY(Child, BabySitter, -1);
			AI.CLEAR_PED_TASKS(BabySitter);
			Arm_chair();
		end
	end
	if(PU_CHK_2) and(PED.IS_PED_FACING_PED(BabySitter, Child, 15)) then
		local BbSitLoc = ENTITY.GET_ENTITY_COORDS(PLAYER.PLAYER_PED_ID(), nil);
		local BabyLoc = ENTITY.GET_ENTITY_COORDS(Child, nil);
		local Totdist = GAMEPLAY.GET_DISTANCE_BETWEEN_COORDS(BbSitLoc.x, BbSitLoc.y, BbSitLoc.z, BabyLoc.x, BabyLoc.y, BabyLoc.z, false);
		if(Totdist < 1.0) then
			PU_CHK_2 = false;
			AI.TASK_TURN_PED_TO_FACE_ENTITY(Child, BabySitter, -1);
			AI.CLEAR_PED_TASKS(BabySitter);
			Shoulder_guy();
		end
	end
	if(Talk_Chk) and(SYSTEM.TIMERA() > 2810) and(not AUDIO.IS_AMBIENT_SPEECH_PLAYING(BabySitter))then
		Talk_Chk = false;
		ENTITY.DELETE_ENTITY(Converse);
	end
	if(Let_go_baby) and(SYSTEM.TIMERA() > 210) then
		Let_go_baby = false;
		dimountcmplt();
	end
	if(Unite_1) and(SYSTEM.TIMERA() > 200) then
		Unite_2 = true;
		Unite_1 = false;
		STREAMING.REQUEST_ANIM_DICT("anim@sports@ballgame@handball@");
		AI.TASK_PLAY_ANIM(BabySitter, "anim@sports@ballgame@handball@", "ball_idle", 8, 8, -1, 48, 0.0, false,false,false);
		GAMEPLAY.SET_TIME_SCALE(10);
		STREAMING.REQUEST_ANIM_DICT("amb@prop_human_seat_chair@male@elbows_on_knees@idle_a");
		SYSTEM.SETTIMERA(-1);
		Unite_2 = true;
	end
	if(Unite_2) and(SYSTEM.TIMERA() > 190) then
		Unite_2 = false;
		ENTITY.ATTACH_ENTITY_TO_ENTITY(Child, BabySitter, PED.GET_PED_BONE_INDEX(BabySitter, 60309), -0.10, -0.49, -0.496, 134.0, 10.0, 0.0,true, true, true, true, 1,true);
		AI.TASK_PLAY_ANIM(Child, "amb@prop_human_seat_chair@male@elbows_on_knees@idle_a", "idle_a", 8, 8, -1, 1, 0.445, false,false,false);
		PED.SET_BLOCKING_OF_NON_TEMPORARY_EVENTS(BabySitter, true);
		STREAMING.REQUEST_ANIM_DICT("anim@sports@ballgame@handball@");
		Hold_me = true;
		isOnPed = true;
		GAMEPLAY.SET_TIME_SCALE(100);
		return isOnPed;
	end
	if(Hold_me) then
		Hold_me = false;
		AI.TASK_PLAY_ANIM(BabySitter, "anim@sports@ballgame@handball@", "ball_idle", -5, -1, -1, 48, 0.05, false,false,false);
		Hold_me_2 = true;
		SYSTEM.SETTIMERA(-1);
	end
	if(Hold_me_2) and(SYSTEM.TIMERA() > 5555) then
		Hold_me_2 = false;
		AI.TASK_PLAY_ANIM(BabySitter, "anim@sports@ballgame@handball@", "ball_idle", -1, -1, -1, 48, 0.0, false,false,false);
		Hold_please = true;
		SYSTEM.SETTIMERA(-1);
	end
	if(Hold_please) and(SYSTEM.TIMERA() > 5555) then
		Hold_please = false;
		Hold_me_2 = false;
		Hold_me = true;
	end
	if(followNow) and not(Let_go_baby) then
		followNow = false
		FollowMe()
	end
	if(PLAYER.IS_PLAYER_DEAD(PLAYER.GET_PLAYER_INDEX())) and(CarrinKid(BabySitter)) then
		Kidruns(BabySitter);
	end
	if(PLAYER.IS_PLAYER_BEING_ARRESTED(PLAYER.GET_PLAYER_INDEX(), true)) and(CarrinKid(BabySitter)) then
		Kidruns(BabySitter);
	end
end


return Toddler_Carry;