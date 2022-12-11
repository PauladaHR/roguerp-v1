-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local fov_min = 5.0
local fov_max = 70.0
local cameras = false
local binoculos = false
local fov = (fov_max+fov_min)*0.5
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLEDANCES
-----------------------------------------------------------------------------------------------------------------------------------------
local poleDances = {
	{ 108.98,-1289.45,29.25,252.29 },
	{ 102.40,-1290.06,29.25,320.32 },
	{ 104.95,-1294.35,29.25,323.15 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAIRS
-----------------------------------------------------------------------------------------------------------------------------------------
local chairs = {
    { "v_serv_ct_chair02",0.0 },
    { "v_corp_offchair",0.5 },
    { "prop_bench_01a",0.5 },
    { "prop_bench_09",0.3 },
    { "prop_wheelchair_01",0.0 },
    { "v_ret_gc_chair02",0.0 },
    { "prop_off_chair_05",0.4 },
    { "v_club_officechair",0.4 },
    { "prop_table_01_chr_a",0.0 },
    { "prop_table_03_chr",0.4 },
    { "hei_prop_yah_seat_03",0.5 },
    { "hei_prop_yah_seat_02",0.5 },
    { "prop_bench_02",0.5 },
    { "prop_bench_06",0.5 },
    { "v_ret_chair_white",0.5 },
    { "v_res_jarmchair",0.5 },
    { "v_ret_chair",0.5 },
    { "prop_chair_02",0.5 },
    { "prop_chair_01b",0.5 },
    { "prop_chair_04a",0.5 },
    { "prop_off_chair_01",0.5 },
    { "v_corp_bk_chair3",0.5 },
    { "prop_table_03b_chr",0.5 },
    { "prop_table_05_chr",0.5 },
    { "prop_skid_chair_02",0.0 },
    { "prop_old_deck_chair",-0.05 },
    { "prop_chair_06",0.5 },
    { "prop_bar_stool_01",0.8 },
	{ "bkr_prop_weed_chair_01a",0.5 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ANIMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
local animacoes = {
	{ nome = "radio2" , prop = "prop_boombox_01" , flag = 50 , hand = 57005 , pos1 = 0.30 , pos2 = 0 , pos3 = 0 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "radio3" , prop = "prop_portable_hifi_01" , flag = 50 , hand = 28422 , pos1 = 0.26 , pos2 = 0.1 , pos3 = 0.08 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "bolsa" , prop = "prop_ld_case_01" , flag = 50 , hand = 57005 , pos1 = 0.16 , pos2 = 0 , pos3 = 0 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "bolsa2" , prop = "prop_ld_case_01_s" , flag = 50 , hand = 57005 , pos1 = 0.16 , pos2 = 0 , pos3 = 0 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "bolsa3" , prop = "prop_security_case_01" , flag = 50 , hand = 57005 , pos1 = 0.16 , pos2 = 0 , pos3 = -0.01 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "bolsa4" , prop = "w_am_case" , flag = 50 , hand = 57005 , pos1 = 0.08 , pos2 = 0 , pos3 = 0 , pos4 = 0 , pos5 = 266.0 , pos6 = 60.0 },
	{ nome = "bolsa5" , prop = "prop_ld_suitcase_01" , flag = 50 , hand = 57005 , pos1 = 0.39 , pos2 = 0 , pos3 = 0 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "bolsa6" , prop = "xm_prop_x17_bag_med_01a" , flag = 50 , hand = 57005 , pos1 = 0.43 , pos2 = 0 , pos3 = 0.04 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "lixo" , prop = "prop_cs_rub_binbag_01" , flag = 50 , hand = 57005 , pos1 = 0.11 , pos2 = 0 , pos3 = 0.0 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "mic" , prop = "prop_microphone_02" , flag = 50 , hand = 60309 , pos1 = 0.08 , pos2 = 0.03 , pos3 = 0.0 , pos4 = 240.0 , pos5 = 0.0 , pos6 = 0.0 },
	{ nome = "mic2" , prop = "p_ing_microphonel_01" , flag = 50 , hand = 60309 , pos1 = 0.08 , pos2 = 0.03 , pos3 = 0.0 , pos4 = 240.0 , pos5 = 0.0 , pos6 = 0.0 },
	{ nome = "mic3" , dict = "missfra1" , anim = "mcs2_crew_idle_m_boom" , prop = "prop_v_bmike_01" , flag = 50 , hand = 28422 },
	{ nome = "mic4" , dict = "missmic4premiere" , anim = "interview_short_lazlow" , prop = "p_ing_microphonel_01" , flag = 50 , hand = 28422 },
	{ nome = "mic5" , dict = "anim@random@shop_clothes@watches" , anim = "base" , prop = "p_ing_microphonel_01" , andar = true , loop = true , flag = 49 , hand = 60309 , pos1 = 0.10 , pos2 = 0.04 , pos3 = 0.012 , pos4 = -60.0 , pos5 = 60.0 , pos6 = -30.0 , propAnim = true },
	{ nome = "buque" , prop = "prop_snow_flower_02" , flag = 50 , hand = 60309 , pos1 = 0.0 , pos2 = 0.0 , pos3 = 0.0 , pos4 = 300.0 , pos5 = 0.0 , pos6 = 0.0 },
	{ nome = "rosa" , prop = "prop_single_rose" , flag = 50 , hand = 60309 , pos1 = 0.055 , pos2 = 0.05 , pos3 = 0.0 , pos4 = 240.0 , pos5 = 0.0 , pos6 = 0.0 },
	{ nome = "cigarro" , prop = "prop_cigar_02" , flag = 49 , hand = 47419 , pos1 = 0.010 , pos2 = 0 , pos3 = 0 , pos4 = 50.0 , pos5 = 0.0 , pos6 = -80.0 },
	{ nome = "prebeber" , dict = "amb@code_human_wander_drinking@beer@male@base" , anim = "static" , prop = "prop_fib_coffee" , flag = 49 , hand = 28422 },
	{ nome = "prebeber2" , dict = "amb@code_human_wander_drinking@beer@male@base" , anim = "static" , prop = "prop_ld_flow_bottle" , flag = 49 , hand = 28422 },
	{ nome = "prebeber3" , dict = "amb@code_human_wander_drinking@beer@male@base" , anim = "static" , prop = "prop_cs_bs_cup" , flag = 49 , hand = 28422 },
	{ nome = "verificar" , dict = "amb@medic@standing@tendtodead@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "mexer" , dict = "amb@prop_human_parking_meter@female@idle_a" , anim = "idle_a_female" , andar = true , loop = true },
	{ nome = "cuidar" , dict = "mini@cpr@char_a@cpr_str" , anim = "cpr_pumpchest" , andar = true , loop = true },
	{ nome = "cuidar2" , dict = "mini@cpr@char_a@cpr_str" , anim = "cpr_kol" , andar = true , loop = true },
	{ nome = "cuidar3" , dict = "mini@cpr@char_a@cpr_str" , anim = "cpr_kol_idle" , andar = true , loop = true },
	{ nome = "cansado" , dict = "rcmbarry" , anim = "idle_d" , andar = false , loop = true },
	{ nome = "spiderman" , dict = "missexile3" , anim = "ex03_train_roof_idle" , andar = false , loop = true },
	{ nome = "meleca" , dict = "anim@mp_player_intuppernose_pick" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "meleca2" , dict = "anim@mp_player_intcelebrationfemale@nose_pick" , anim = "nose_pick" , andar = false , loop = false },
	{ nome = "meleca3" , dict = "move_p_m_two_idles@generic" , anim = "fidget_sniff_fingers" , andar = true , loop = false },
	{ nome = "bora" , dict = "missfam4" , anim = "say_hurry_up_a_trevor" , andar = true , loop = false },
	{ nome = "selimpar" , dict = "missfbi3_camcrew" , anim = "final_loop_guy" , andar = true , loop = false },
	{ nome = "galinha" , dict = "random@peyote@chicken" , anim = "wakeup" , andar = true , loop = true },
	{ nome = "amem" , dict = "rcmepsilonism8" , anim = "worship_base" , andar = true , loop = true },
	{ nome = "nervoso" , dict = "rcmme_tracey1" , anim = "nervous_loop" , andar = true , loop = true },
	{ nome = "morrer" , dict = "misslamar1dead_body" , anim = "dead_idle" , andar = false , loop = true },
	{ nome = "ajoelhar" , dict = "amb@medic@standing@kneel@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "naruto" , dict = "missfbi1" , anim = "ledge_loop" , andar = true , loop = true },
	{ nome = "naruto2" , dict = "missfam5_yoga" , anim = "a2_pose" , andar = true , loop = true },
	{ nome = "naruto3" , dict = "missfbi1", anim = "ledge_loop" , andar = true , loop = true },
	{ nome = "naruto4" , dict = "timetable@amanda@ig_4", anim = "ig_4_base" , andar = false , loop = true },
	{ nome = "rebolar" , dict = "switch@trevor@mocks_lapdance" , anim = "001443_01_trvs_28_idle_stripper" , andar = false , loop = true },
	{ nome = "celebrar" , dict = "rcmfanatic1celebrate" , anim = "celebrate" , andar = false , loop = false },
	{ nome = "morto" , dict = "anim@mp_player_intcelebrationmale@cut_throat" , anim = "cut_throat" , andar = true , loop = false },
	{ nome = "morto2" , dict = "anim@mp_player_intcelebrationfemale@cut_throat" , anim = "cut_throat" , andar = true , loop = false },
	{ nome = "sinalizar" , dict = "amb@world_human_car_park_attendant@male@base" , anim = "base" , prop = "prop_parking_wand_01" , flag = 49 , hand = 28422 },
	{ nome = "placa" , dict = "amb@world_human_bum_freeway@male@base" , anim = "base" , prop = "prop_beggers_sign_01" , flag = 49 , hand = 28422 },
	{ nome = "placa2" , dict = "amb@world_human_bum_freeway@male@base" , anim = "base" , prop = "prop_beggers_sign_03" , flag = 49 , hand = 28422 },
	{ nome = "placa3" , dict = "amb@world_human_bum_freeway@male@base" , anim = "base" , prop = "prop_beggers_sign_04" , flag = 49 , hand = 28422 },
	{ nome = "tablet" , dict = "amb@code_human_in_bus_passenger_idles@female@tablet@idle_a" , anim = "idle_b" , prop = "prop_cs_tablet" , flag = 49 , hand = 60309 },
	{ nome = "abanar" , dict = "timetable@amanda@facemask@base" , anim = "base" , andar = true , loop = true },
	{ nome = "cocada" , dict = "mp_player_int_upperarse_pick" , anim = "mp_player_int_arse_pick" , andar = true , loop = true },
	{ nome = "cocada2" , dict = "mp_player_int_uppergrab_crotch" , anim = "mp_player_int_grab_crotch" , andar = true , loop = true },
	{ nome = "lero" , dict = "anim@mp_player_intselfiejazz_hands" , anim = "idle_a" , andar = true , loop = false },
	{ nome = "lero2" , dict = "anim@mp_player_intcelebrationfemale@thumb_on_ears" , anim = "thumb_on_ears" , andar = false , loop = false },
	{ nome = "lero3" , dict = "anim@mp_player_intcelebrationfemale@cry_baby" , anim = "cry_baby" , andar = false , loop = false },
	{ nome = "beijo" , dict = "anim@mp_player_intselfieblow_kiss" , anim = "exit" , andar = true , loop = false },
	{ nome = "beijo2" , dict = "anim@mp_player_intcelebrationfemale@blow_kiss" , anim = "blow_kiss" , andar = true , loop = false },
	{ nome = "malicia" , dict = "anim@mp_player_intupperdock" , anim = "idle_a" , andar = true , loop = false },
	{ nome = "ligar" , dict = "cellphone@" , anim = "cellphone_call_in" , prop = "prop_amb_phone" , flag = 50 , hand = 28422 },
	{ nome = "radio" , dict = "cellphone@" , anim = "cellphone_call_in" , prop = "prop_cs_hand_radio" , flag = 50 , hand = 28422 },
	{ nome = "cafe" , dict = "amb@world_human_aa_coffee@base" , anim = "base" , prop = "prop_fib_coffee" , flag = 50 , hand = 28422 },
	{ nome = "cafe2" , dict = "amb@world_human_aa_coffee@idle_a" , anim = "idle_a" , prop = "prop_fib_coffee" , flag = 49 , hand = 28422 },
	{ nome = "caixa" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "hei_prop_heist_box" , flag = 50 , hand = 28422 },
	{ nome = "caixa2" , prop = "prop_tool_box_04" , flag = 50 , hand = 57005 , pos1 = 0.45 , pos2 = 0 , pos3 = 0.05 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "caixa3" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "xm_prop_smug_crate_s_medical" , flag = 50 , hand = 28422 },
	{ nome = "caixa4" , prop = "gr_prop_gr_tool_box_01a" , flag = 50 , hand = 57005 , pos1 = 0.45 , pos2 = 0 , pos3 = 0.05 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "caixa5" , prop = "gr_prop_gr_tool_box_02a" , flag = 50 , hand = 57005 , pos1 = 0.45 , pos2 = 0 , pos3 = 0.05 , pos4 = 0 , pos5 = 260.0 , pos6 = 60.0 },
	{ nome = "bateria" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "prop_car_battery_01" , flag = 50 , hand = 28422 },
	{ nome = "pneu" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "prop_wheel_tyre" , flag = 50 , hand = 28422 },
	{ nome = "chuva" , dict = "amb@world_human_drinking@coffee@male@base" , anim = "base" , prop = "p_amb_brolly_01" , flag = 50 , hand = 28422 },
	{ nome = "chuva2" , dict = "amb@world_human_drinking@coffee@male@base" , anim = "base" , prop = "p_amb_brolly_01_s" , flag = 50 , hand = 28422 },
	{ nome = "comer" , dict = "amb@code_human_wander_eating_donut@male@idle_a" , anim = "idle_c" , prop = "prop_cs_burger_01" , flag = 49 , hand = 28422 },
	{ nome = "comer2" , dict = "amb@code_human_wander_eating_donut@male@idle_a" , anim = "idle_c" , prop = "prop_cs_hotdog_01" , flag = 49 , hand = 28422 },
	{ nome = "comer3" , dict = "amb@code_human_wander_eating_donut@male@idle_a" , anim = "idle_c" , prop = "prop_amb_donut" , flag = 49 , hand = 28422 },
	{ nome = "comer4" , dict = "mp_player_inteat@burger" , anim = "mp_player_int_eat_burger" , prop = "prop_sandwich_01" , flag = 49 , hand = 60309 },
	{ nome = "comer5" , dict = "mp_player_inteat@burger" , anim = "mp_player_int_eat_burger" , prop = "prop_choc_ego" , flag = 49 , hand = 60309 },
	{ nome = "beber" , dict = "amb@world_human_drinking@beer@male@idle_a" , anim = "idle_a" , prop = "p_cs_bottle_01" , flag = 49 , hand = 28422 },
	{ nome = "beber2" , dict = "amb@world_human_drinking@beer@male@idle_a" , anim = "idle_a" , prop = "prop_energy_drink" , flag = 49 , hand = 28422 },
	{ nome = "beber3" , dict = "amb@world_human_drinking@beer@male@idle_a" , anim = "idle_a" , prop = "prop_amb_beer_bottle" , flag = 49 , hand = 28422 },
	{ nome = "beber4" , dict = "amb@world_human_drinking@beer@male@idle_a" , anim = "idle_a" , prop = "p_whiskey_notop" , flag = 49 , hand = 28422 },
	{ nome = "beber5" , dict = "amb@world_human_drinking@beer@male@idle_a" , anim = "idle_a" , prop = "prop_beer_logopen" , flag = 49 , hand = 28422 },
	{ nome = "beber6" , dict = "amb@world_human_drinking@beer@male@idle_a" , anim = "idle_a" , prop = "prop_beer_blr" , flag = 49 , hand = 28422 },
	{ nome = "beber7" , dict = "amb@world_human_drinking@beer@male@idle_a" , anim = "idle_a" , prop = "prop_ld_flow_bottle" , flag = 49 , hand = 28422 },
	{ nome = "beber8" , dict = "amb@world_human_drinking@coffee@male@idle_a" , anim = "idle_c" , prop = "prop_drink_whisky" , flag = 49 , hand = 28422 },
	{ nome = "champanhe" , dict = "anim@mp_player_intupperspray_champagne" , anim = "idle_a" , prop = "ba_prop_battle_champ_open" , flag = 49 , hand = 28422 },
	{ nome = "digitar" , dict = "anim@heists@prison_heistig1_p1_guard_checks_bus" , anim = "loop" , andar = false , loop = true },
	{ nome = "digitar2" , dict = "mp_fbi_heist" , anim = "loop" , andar = false , loop = true },
	{ nome = "continencia" , dict = "mp_player_int_uppersalute" , anim = "mp_player_int_salute" , andar = true , loop = true },
	{ nome = "atm" , dict = "amb@prop_human_atm@male@idle_a" , anim = "idle_a" , andar = false , loop = false },
	{ nome = "no" , dict = "mp_player_int_upper_nod" , anim = "mp_player_int_nod_no" , andar = true , loop = true },
	{ nome = "palmas" , dict = "anim@mp_player_intcelebrationfemale@slow_clap" , anim = "slow_clap" , andar = true , loop = false },
	{ nome = "palmas2" , dict = "amb@world_human_cheering@male_b" , anim = "base" , andar = true , loop = true },
	{ nome = "palmas3" , dict = "amb@world_human_cheering@male_d" , anim = "base" , andar = true , loop = true },
	{ nome = "palmas4" , dict = "amb@world_human_cheering@male_e" , anim = "base" , andar = true , loop = true },
	{ nome = "palmas5" , dict = "anim@arena@celeb@flat@solo@no_props@" , anim = "angry_clap_a_player_a" , andar = true , loop = false },
	{ nome = "palmas6" , dict = "anim@mp_player_intupperslow_clap" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "postura" , dict = "anim@heists@prison_heiststation@cop_reactions" , anim = "cop_a_idle" , andar = true , loop = true },
	{ nome = "postura2" , dict = "amb@world_human_cop_idles@female@base" , anim = "base" , andar = true , loop = true },
	{ nome = "postura3" , dict = "missbigscore2aleadinout@bs_2a_mcs_3" , anim = "bankman_leadout_action" , andar = true , loop = true },
	{ nome = "varrer" , dict = "amb@world_human_janitor@male@idle_a" , anim = "idle_a" , prop = "prop_tool_broom" , flag = 49 , hand = 28422 },
	{ nome = "musica" , dict = "amb@world_human_musician@guitar@male@base" , anim = "base" , prop = "prop_el_guitar_01" , flag = 49 , hand = 60309 },
	{ nome = "musica2" , dict = "amb@world_human_musician@guitar@male@base" , anim = "base" , prop = "prop_el_guitar_02" , flag = 49 , hand = 60309 },
	{ nome = "musica3" , dict = "amb@world_human_musician@guitar@male@base" , anim = "base" , prop = "prop_el_guitar_03" , flag = 49 , hand = 60309 },
	{ nome = "musica4" , dict = "amb@world_human_musician@guitar@male@base" , anim = "base" , prop = "prop_acc_guitar_01" , flag = 49 , hand = 60309 },
	{ nome = "prancheta" , dict = "amb@world_human_clipboard@male@base" , anim = "base" , prop = "p_amb_clipboard_01" , flag = 50 , hand = 60309 },
	{ nome = "mapa" , dict = "amb@world_human_clipboard@male@base" , anim = "base" , prop = "prop_tourist_map_01" , flag = 50 , hand = 60309 },
	{ nome = "anotar" , dict = "amb@medic@standing@timeofdeath@base" , anim = "base" , prop = "prop_notepad_01" , flag = 49 , hand = 60309 },
	{ nome = "peace" , dict = "mp_player_int_upperpeace_sign" , anim = "mp_player_int_peace_sign" , andar = true , loop = true },
	{ nome = "peace2" , dict = "anim@mp_player_intupperpeace" , anim = "idle_a" , andar = true , loop = true },

	{ nome = "foto" , dict = "amb@lo_res_idles@" , anim ="world_human_lean_male_hands_together_lo_res_base" , andar = false , loop = true },
	{ nome = "foto1" , dict = "amb@code_human_cross_road@female@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto2" , dict = "amb@code_human_in_car_mp_actions@tit_squeeze@bodhi@rps@base" , anim ="idle_a" , andar = false , loop = true },
	{ nome = "foto3" , dict = "amb@world_human_hang_out_street@female_arm_side@enter" , anim ="enter" , andar = false , loop = true },
	{ nome = "foto4" , dict = "amb@world_human_hang_out_street@female_arm_side@idle_a" , anim ="idle_b" , andar = false , loop = true },
	{ nome = "foto5" , dict = "amb@world_human_hang_out_street@female_arms_crossed@idle_a" , anim ="idle_b" , andar = false , loop = true },
	{ nome = "foto6" , dict = "friends@" , anim ="pickupwait" , andar = false , loop = true },
	{ nome = "foto7" , dict = "mini@hookers_sp" , anim ="idle_reject_loop_a" , andar = false , loop = true },
	{ nome = "foto8" , dict = "misscarsteal2" , anim ="sweep_high" , andar = false , loop = true },
	{ nome = "foto9" , dict = "missheist_agency3aig_23" , anim ="urinal_base" , andar = false , loop = true },
	{ nome = "foto10" , dict = "misstrevor2ron_basic_moves" , anim ="idle" , andar = false , loop = true },
	{ nome = "foto11" , dict = "oddjobs@basejump@" , anim ="ped_a_loop" , andar = false , loop = true },
	{ nome = "foto12" , dict = "rcmjosh1" , anim ="idle" , andar = false , loop = true },
	{ nome = "foto13" , dict = "switch@franklin@plays_w_dog" , anim ="001916_01_fras_v2_9_plays_w_dog_idle" , andar = false , loop = true },
	{ nome = "foto14" , dict = "timetable@amanda@ig_9" , anim ="ig_9_base_amanda" , andar = false , loop = true },
	{ nome = "foto15" , dict = "misscommon@response" , anim ="bring_it_on" , andar = false , loop = true },
	{ nome = "foto16" , dict = "cover@first_person@move@base@core" , anim ="low_idle_l_facecover" , andar = false , loop = true },
	{ nome = "foto17" , dict = "cover@weapon@core" , anim ="idle_turn_stop" , andar = false , loop = true },
	{ nome = "foto18" , dict = "anim@amb@casino@hangout@ped_female@stand@02b@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto19" , dict = "anim@amb@casino@hangout@ped_male@stand@01a@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto20" , dict = "anim@amb@casino@out_of_money@ped_male@01b@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto21" , dict = "anim@amb@casino@shop@ped_female@01a@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto22" , dict = "anim@mp_corona_idles@female_c@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto23" , dict = "anim@random@shop_clothes@watches" , anim ="base" , andar = false , loop = true },
	{ nome = "foto24" , dict = "iaa_int-11" , anim ="csb_avon_dual-11" , andar = false , loop = true },
	{ nome = "foto25" , dict = "mini@strip_club@lap_dance@ld_girl_a_approach" , anim ="ld_girl_a_approach_f" , andar = false , loop = true },
    { nome = "foto26" , dict = "amb@code_human_in_car_mp_actions@rock@bodhi@rps@base" , anim ="idle_a" , andar = false , loop = true },
	{ nome = "foto27" , dict = "mini@hookers_spcrackhead" , anim ="idle_reject_loop_c" , andar = false , loop = true },
	{ nome = "foto28" , dict = "anim@mp_player_intupperfinger" , anim ="idle_a" , andar = false , loop = true },
	{ nome = "foto29" , dict = "switch@franklin@lamar_tagging_wall" , anim ="lamar_tagging_wall_loop_franklin" , andar = false , loop = true },
	{ nome = "foto30" , dict = "mp_move@prostitute@m@cokehead" , anim ="idle" , andar = false , loop = true },
	{ nome = "foto31" , dict = "anim@amb@casino@valet_scenario@pose_c@" , anim ="base_a_m_y_vinewood_01" , andar = false , loop = true },
	{ nome = "foto32" , dict = "anim@amb@casino@valet_scenario@pose_d@" , anim ="look_ahead_l_a_m_y_vinewood_01" , andar = false , loop = true },
	{ nome = "foto33" , dict = "anim@special_peds@casino@beth@wheel@" , anim ="action10_beth" , andar = false , loop = true },
	{ nome = "foto34" , dict = "anim@special_peds@casino@beth@wheel@" , anim ="action2_beth" , andar = false , loop = true },
	{ nome = "foto35" , dict = "anim@mp_player_intcelebrationfemale@v_sign" , anim ="v_sign" , andar = false , loop = true },
	{ nome = "foto36" , dict = "mini@strip_club@idles@stripper" , anim ="stripper_idle_03" , andar = false , loop = true },
	{ nome = "foto37" , dict = "mini@strip_club@idles@stripper" , anim ="stripper_idle_04" , andar = false , loop = true },
	{ nome = "foto38" , dict = "anim_heist@arcade@fortune@female@" , anim ="reaction_pondering" , andar = false , loop = true },
	{ nome = "foto39" , dict = "anim@mp_player_intcelebrationfemale@peace" , anim ="peace" , andar = false , loop = true },
	{ nome = "foto40" , dict = "missfbi3_party_d" , anim ="stand_talk_loop_b_female" , andar = false , loop = true },
	{ nome = "foto41" , dict = "armenian_1_int-44" , anim ="a_m_y_musclbeac_01^1_dual-44" , andar = false , loop = true },
	{ nome = "foto42" , dict = "mp_clothing@female@trousers" , anim ="try_trousers_positive_a" , andar = false , loop = true },
	{ nome = "foto43" , dict = "silj_ext-19" , anim ="mp_m_freemode_01^3_dual-19" , andar = false , loop = true },
	{ nome = "foto44" , dict = "sdrm_mcs_2-0" , anim ="ig_bestmen^1-0" , andar = false , loop = true },
	{ nome = "foto45" , dict = "anim_heist@arcade_combined@" , anim ="ped_female@_stand@_02a@_idles_convo_idle_c" , andar = false , loop = true },
	{ nome = "foto46" , dict = "anim@arena@celeb@flat@solo@no_props@" , anim ="thumbs_down_a_player_a" , andar = false , loop = true },
	{ nome = "foto47" , dict = "guard_reactions" , anim ="1hand_aiming_cycle" , andar = false , loop = true },
	{ nome = "foto48" , dict = "anim@move_f@waitress" , anim ="idle" , andar = false , loop = true },
	{ nome = "foto49" , dict = "anim_heist@arcade_combined@" , anim ="ped_female@_stand_withdrink@_01b@_base_base" , andar = false , loop = true },
	{ nome = "foto50" , dict = "amb@lo_res_idles@" , anim ="world_human_security_shine_torch_lo_res_base" , andar = false , loop = true },
	{ nome = "foto51" , dict = "rcmjosh2" , anim ="stand_lean_back_beckon_a" , andar = false , loop = true },
    { nome = "foto52" , dict = "rcmjosh2" , anim ="stand_lean_back_beckon_b" , andar = false , loop = true },
	{ nome = "foto53" , dict = "pro_mcs_7_concat-1" , anim ="cs_priest_dual-1" , andar = false , loop = true },
	{ nome = "foto54" , dict = "clothingshirt" , anim ="try_shirt_base" , andar = false , loop = true },
	{ nome = "foto55" , dict = "special_ped@pamela@trevor_1@trevor_1a" , anim ="pamela_convo_trevor_im_trying_to_get_noticed_0" , andar = false , loop = true },
    { nome = "foto56" , dict = "special_ped@impotent_rage@intro" , anim ="idle_intro" , andar = false , loop = true },
	{ nome = "foto57" , dict = "random@escape_paparazzi@standing@" , anim ="idle" , andar = false , loop = true },
	{ nome = "foto58" , dict = "pro_mcs_7_concat-8" , anim ="player_two_dual-8" , andar = false , loop = true },
	{ nome = "foto59" , dict = "anim@heists@ornate_bank@thermal_charge" , anim ="cover_eyes_loop" , andar = false , loop = true },
	{ nome = "foto60" , dict = "low_fun_int-7" , anim ="cs_lamardavis_dual-7" , andar = false , loop = true },
    { nome = "foto61" , dict = "tale_intro-12" , anim ="a_f_y_genhot_01^2_dual-12" , andar = false , loop = true },
	{ nome = "foto62" , dict = "amb@code_human_police_investigate@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto63" , dict = "anim@mp_player_intincarpeacebodhi@ds@" , anim ="enter" , andar = false , loop = true },
	{ nome = "foto64" , dict = "anim@mp_corona_idles@female_c@idle_a" , anim ="idle_a" , andar = false , loop = true },
	{ nome = "foto65" , dict = "anim@miss@low@fin@vagos@" , anim ="idle_ped07" , andar = false , loop = true },
	{ nome = "foto66" , dict = "oddjobs@assassinate@multi@" , anim ="idle_a_pros" , andar = false , loop = true },
	{ nome = "foto67" , dict = "timetable@jimmy@ig_5@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto68" , dict = "rcmnigel1bnmt_1b" , anim ="base_tyler" , andar = false , loop = true },
	{ nome = "foto69" , dict = "mp_fm_intro_cut" , anim ="world_human_standing_male_01_idle_03" , andar = false , loop = true },
	{ nome = "foto70" , dict = "mic_4_int-0" , anim ="a_f_y_bevhills_04-0" , andar = false , loop = true },
	{ nome = "foto71" , dict = "mic_4_int-0" , anim ="cs_milton_dual-0" , andar = false , loop = true },
	{ nome = "foto72" , dict = "cellphone@self@franklin@" , anim ="west_coast" , andar = false , loop = true },
	{ nome = "foto73" , dict = "anim@random@shop_clothes@watches" , anim ="idle_d" , andar = false , loop = true },
	{ nome = "foto74" , dict = "amb@world_human_muscle_flex@arms_in_front@idle_a" , anim ="idle_b" , andar = false , loop = true },
	{ nome = "foto75" , dict = "amb@world_human_prostitute@crackhooker@idle_a" , anim ="idle_c" , andar = false , loop = true },
	{ nome = "foto76" , dict = "amb@world_human_prostitute@hooker@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto77" , dict = "anim@mp_player_intupperfinger" , anim ="idle_a" , andar = false , loop = true },
	{ nome = "foto78" , dict = "anim@mp_player_intcelebrationmale@blow_kiss" , anim ="blow_kiss" , andar = false , loop = true },
	{ nome = "foto79" , dict = "anim@mp_player_intcelebrationmale@knuckle_crunch" , anim ="knuckle_crunch" , andar = false , loop = true },
	{ nome = "foto80" , dict = "anim@mp_player_intupperthumbs_up" , anim ="idle_a_fp" , andar = false , loop = true },
	{ nome = "foto81" , dict = "switch@michael@prostitute" , anim ="exit_hooker" , andar = false , loop = true },
	{ nome = "foto82" , dict = "mp_player_int_upperbro_love" , anim ="mp_player_int_bro_love_fp" , andar = false , loop = true },
	{ nome = "foto83" , dict = "hs3_arc_int-9" , anim ="csb_georginacheng_dual-9" , andar = false , loop = true },
	{ nome = "foto84" , dict = "armenian_1_int-0" , anim ="a_f_y_beach_01_dual-0" , andar = false , loop = true },
	{ nome = "foto85" , dict = "armenian_1_int-0" , anim ="a_f_y_hipster_02^2-0" , andar = false , loop = true },
	{ nome = "foto86" , dict = "armenian_1_int-0" , anim ="a_f_y_tourist_01^2-0" , andar = false , loop = true },
	{ nome = "foto87" , dict = "armenian_1_int-0" , anim ="a_m_y_beach_03-0" , andar = false , loop = true },
	{ nome = "foto88" , dict = "special_ped@pamela@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto89" , dict = "mp_fm_intro_cut" , anim ="world_human_standing_male_01_idle_01" , andar = false , loop = true },
	{ nome = "foto90" , dict = "amb@world_human_leaning@female@smoke@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto91" , dict = "amb@world_human_leaning@female@wall@back@hand_up@base" , anim ="base" , andar = false , loop = true },
	{ nome = "foto92" , dict = "amb@code_human_cross_road@female@base" , anim = "base" , andar = false , loop = true },
	{ nome = "foto93" , dict = "anim@heists@heist_corona@single_team" , anim = "single_team_intro_boss" , andar = false , loop = true },
	{ nome = "foto94" , dict = "amb@incar@male@smoking@idle_a" , anim = "idle_b" , andar = false , loop = true },
	{ nome = "foto95" , anim = "idle_a" , dict  = "anim@amb@casino@hangout@ped_male@stand@02b@idles" , andar = false , loop = true },
	{ nome = "foto96" , anim = "rub_neck_a_m_y_vinewood_01" , dict  = "anim@amb@casino@valet_scenario@pose_c@" , andar = false , loop = true },
	{ nome = "foto97" , dict = "anim@mp_player_intuppershush" , anim = "idle_a_fp" , andar = false , loop = true },
	{ nome = "foto98" , anim = "_car_a_flirt_girl" , dict  = "random@street_race" , andar = false , loop = true },
	{ nome = "foto99" , dict = "misshair_shop@barbers" , anim = "keeper_base" , andar = false , loop = true },
	{ nome = "foto100" , dict = "cellphone@self@franklin@" , anim = "chest_bump" , andar = false , loop = true },
    { nome = "foto101" , dict = "amb@world_human_leaning@male@wall@back@foot_up@aggro_react" , anim = "aggro_react_forward_enter", andar = false , loop = true },
    { nome = "foto102" , dict = "martin_1_int-0" , anim = "cs_patricia_dual-0" , andar = false , loop = true },
    { nome = "foto103" , dict = "mini@strip_club@lap_dance_2g@ld_2g_decline" , anim = "ld_2g_decline_h_s2" , andar = false , loop = true },
    { nome = "foto104" , anim = "stripper_idle_03" , dict  = "mini@strip_club@idles@stripper" , andar = false , loop = true },
    { nome = "foto105" , dict = "amb@world_human_binoculars@male@base" , anim ="base" , andar = false , loop = true },
    { nome = "foto106" , dict = "amb@world_human_tourist_mobile@male@base" , anim ="base" , andar = false , loop = true },
    { nome = "foto107" , dict = "anim@amb@board_room@whiteboard@" , anim ="read_03_amy_skater_01" , andar = false , loop = true },
    { nome = "foto108" , dict = "anim@heists@team_respawn@variations@variation_b_rot" , anim ="respawn_b_ped_c" , andar = false , loop = true },
	{ nome = "foto109" , anim = "idle_d" , dict  = "anim@amb@casino@hangout@ped_female@stand@01a@idles" , andar = false , loop = true },
	{ nome = "foto110" , dict = "amb@world_human_stand_guard@male@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "foto111" , dict = "amb@world_human_tourist_mobile@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "foto112" , dict = "switch@michael@pharmacy" , anim = "mics1_ig_11_loop" , andar = false , loop = true },
	{ nome = "foto113" , dict = "weapons@first_person@aim_idle@p_m_one@unarmed@fidgets@c" , anim = "fidget_low_loop" , andar = false , loop = true },
	{ nome = "foto114" , dict = "armenian_1_int-0" , anim = "player_one_dual-0" , andar = false , loop = true },
	{ nome = "foto115" , dict = "amb@world_human_bum_wash@male@low@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "foto116" , dict = "anim@amb@casino@hangout@ped_male@stand_withdrink@01b@base" , anim = "base" , andar = false , loop = true },
	{ nome = "foto117" , dict = "anim@move_m@trash_rc" , anim = "aim_high_loop" , andar = false , loop = true },
	{ nome = "foto118" , dict = "martin_1_int-10" , anim = "cs_patricia_dual-10" , andar = false , loop = true },
	{ nome = "foto119" , dict = "club_open-30" , anim = "ig_djsolmanager_dual-30" , andar = false , loop = true },
	{ nome = "foto120" , dict= "anim_heist@arcade_combined@" , anim = "ped_female@_stand@_02a@_idles_convo_idle_d" , andar = false , loop = true },
	{ nome = "foto121" , dict= "amb@code_human_police_investigate@base" , anim = "base" , andar = false , loop = true },
	{ nome = "foto122" , dict= "amb@world_human_golf_player@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "foto123" , dict= "rcmnigel1a" , anim = "base" , andar = false , loop = true },
	{ nome = "foto124" , dict= "timetable@ron@ig_1" , anim = "ig_1_base" , andar = false , loop = true },
	{ nome = "foto125" , dict= "anim@amb@code_human_in_car_idles@arm@generic@ds@idle_j" , anim = "idle_lowdoor" , andar = false , loop = true },
	{ nome = "foto126" , dict= "club_open-0" , anim = "cs_lazlow_2_dual-0" , andar = false , loop = true },
	{ nome = "foto127" , dict= "armenian_1_int-33" , anim = "a_m_y_runner_01-33" , andar = false , loop = true },
	{ nome = "foto128" , dict= "armenian_1_int-33" , anim = "ig_lamardavis_dual-33" , andar = false , loop = true },
	{ nome = "foto129" , dict= "armenian_1_int-3" , anim = "a_f_y_fitness_02^5-3" , andar = false , loop = true },

	{ nome = "tiktok" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_left_up" , andar = false , loop = true },    
    { nome = "tiktok2" , dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_f@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    { nome = "tiktok3" , dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_f@" , anim = "ped_b_dance_idle" , andar = false , loop = true },    
    { nome = "tiktok4" , dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_h@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    { nome = "tiktok5" , dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_h@" , anim = "ped_b_dance_idle" , andar = false , loop = true },    
    { nome = "tiktok6" , dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_j@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    { nome = "tiktok7" , dict = "anim@amb@nightclub@mini@dance@dance_paired@dance_m@" , anim = "ped_a_dance_idle" , andar = false , loop = true },    
    { nome = "tiktok8" , dict = "anim@amb@nightclub_island@dancers@club@" , anim = "hi_idle_a_f02" , andar = false , loop = true },    
    { nome = "tiktok9" , dict = "anim@amb@nightclub_island@dancers@club@" , anim = "mi_idle_b_f02" , andar = false , loop = true },    
    { nome = "tiktok10" , dict = "anim@mp_player_intcelebrationfemale@crowd_invitation" , anim = "crowd_invitation" , andar = false , loop = true },    
    { nome = "tiktok11" , dict = "anim@mp_player_intcelebrationfemale@driver" , anim = "driver" , andar = false , loop = true },    
    { nome = "tiktok12" , dict = "anim@mp_player_intcelebrationfemale@shooting" , anim = "shooting" , andar = false , loop = true },    
    { nome = "tiktok13" , dict = "anim@mp_player_intcelebrationmale@shooting" , anim = "shooting" , andar = false , loop = true },    
    { nome = "tiktok14" , dict = "anim@mp_player_intcelebrationmale@suck_it" , anim = "suck_it" , andar = false , loop = true },    
    { nome = "tiktok15" , dict = "anim@mp_player_intuppercrowd_invitation" , anim = "idle_a" , andar = false , loop = true },    
    { nome = "tiktok16" , dict = "anim@mp_player_intuppershooting" , anim = "idle_a" , andar = false , loop = true },    
    { nome = "tiktok17" , dict = "anim@mp_player_intuppersuck_it" , anim = "idle_a" , andar = false , loop = true },

	{ nome = "deitar" , dict = "anim@gangops@morgue@table@" , anim = "ko_front" , andar = false , loop = true },
	{ nome = "deitar2" , dict = "amb@world_human_sunbathe@female@back@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "deitar3" , dict = "amb@world_human_sunbathe@female@front@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "deitar4" , dict = "amb@world_human_sunbathe@male@back@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "deitar5" , dict = "amb@world_human_sunbathe@male@front@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "deitar6" , dict = "mini@cpr@char_b@cpr_str" , anim = "cpr_kol_idle" , andar = false , loop = true },
	{ nome = "deitar7" , dict = "switch@trevor@scares_tramp" , anim = "trev_scares_tramp_idle_tramp" , andar = false , loop = true },
	{ nome = "deitar8" , dict = "switch@trevor@annoys_sunbathers" , anim = "trev_annoys_sunbathers_loop_girl" , andar = false , loop = true },		
	{ nome = "deitar9" , dict = "switch@trevor@annoys_sunbathers" , anim = "trev_annoys_sunbathers_loop_guy" , andar = false , loop = true },
	{ nome = "debrucar" , dict = "amb@prop_human_bum_shopping_cart@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "debrucar2" , dict = "anim@amb@casino@valet_scenario@pose_b@" , anim = "base_a_m_y_vinewood_01" , andar = false , loop = true },
	{ nome = "debrucar3" , dict = "anim@amb@casino@valet_scenario@pose_a@" , anim = "base_a_m_y_vinewood_01" , andar = false , loop = true },
	{ nome = "debrucar4" , dict = "anim@amb@casino@out_of_money@ped_female@02a@base" , anim = "base" , andar = false , loop = true },
	{ nome = "debrucar5" , dict = "anim@mini@yacht@bar@drink@four" , anim = "four_bartender" , andar = false , loop = true },
	{ nome = "debrucar6" , dict = "anim@amb@warehouse@toolbox@" , anim = "idle" , andar = false , loop = true },
	{ nome = "debrucar7" , dict = "anim@amb@casino@valet_scenario@pose_b@" , anim = "toe_wiggle_stretch_a_m_y_vinewood_01" , andar = false , loop = true },
	{ nome = "dancar" , dict = "rcmnigel1bnmt_1b" , anim = "dance_loop_tyler" , andar = false , loop = true },
	{ nome = "dancar2" , dict = "mp_safehouse" , anim = "lap_dance_girl" , andar = false , loop = true },
	{ nome = "dancar3" , dict = "misschinese2_crystalmazemcs1_cs" , anim = "dance_loop_tao" , andar = false , loop = true },
	{ nome = "dancar4" , dict = "mini@strip_club@private_dance@part1" , anim = "priv_dance_p1" , andar = false , loop = true },
	{ nome = "dancar5" , dict = "mini@strip_club@private_dance@part2" , anim = "priv_dance_p2" , andar = false , loop = true },
	{ nome = "dancar6" , dict = "mini@strip_club@private_dance@part3" , anim = "priv_dance_p3" , andar = false , loop = true },
	{ nome = "dancar7" , dict = "special_ped@mountain_dancer@monologue_2@monologue_2a" , anim = "mnt_dnc_angel" , andar = false , loop = true },
	{ nome = "dancar8" , dict = "special_ped@mountain_dancer@monologue_3@monologue_3a" , anim = "mnt_dnc_buttwag" , andar = false , loop = true },
	{ nome = "dancar9" , dict = "missfbi3_sniping" , anim = "dance_m_default" , andar = false , loop = true },
	{ nome = "dancar10" , dict = "anim@amb@nightclub@dancers@black_madonna_entourage@" , anim = "hi_dance_facedj_09_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar11" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar12" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar13" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar14" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar15" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar16" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar17" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar18" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar19" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar20" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar21" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar22" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar23" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar24" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar25" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar26" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar27" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar28" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar29" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar30" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar31" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar32" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar33" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar34" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar35" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar36" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar37" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar38" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar39" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar40" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar41" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar42" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar43" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar44" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar45" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar46" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar47" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar48" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar49" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar50" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar51" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar52" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar53" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar54" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar55" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar56" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar57" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar58" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_11_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar59" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar60" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar61" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar62" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar63" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar64" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar65" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar66" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar67" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar68" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar69" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar70" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar71" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar72" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar73" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar74" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar75" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar76" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar77" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar78" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar79" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar80" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar81" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar82" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_13_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar83" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar84" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar85" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar86" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar87" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar88" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar89" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar90" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar91" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar92" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar93" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar94" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar95" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar96" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar97" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar98" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar99" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar100" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar101" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar102" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar103" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar104" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar105" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar106" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_15_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar107" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar108" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar109" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar110" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar111" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar112" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar113" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar114" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar115" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar116" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar117" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar118" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar119" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar120" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar121" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar122" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar123" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar124" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar125" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar126" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar127" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar128" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar129" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar130" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_17_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar131" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar132" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar133" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar134" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar135" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar136" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar137" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar138" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar139" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar140" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar141" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar142" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar143" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar144" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar145" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar146" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar147" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar148" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar149" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar150" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar151" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar152" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar153" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar154" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_09_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar155" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar156" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar157" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar158" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar159" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar160" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar161" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar162" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar163" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar164" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar165" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar166" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_11_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar167" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar168" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar169" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar170" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar171" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar172" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar173" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar174" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar175" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar176" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar177" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar178" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_13_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar179" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar180" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar181" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar182" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar183" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar184" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar185" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar186" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar187" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar188" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar189" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar190" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar191" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar192" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar193" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar194" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar195" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar196" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar197" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar198" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar199" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar200" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar201" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar202" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_15_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar203" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar204" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^2" , andar = false , loop = true },
	{ nome = "dancar205" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^3" , andar = false , loop = true },
	{ nome = "dancar206" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^4" , andar = false , loop = true },
	{ nome = "dancar207" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^5" , andar = false , loop = true },
	{ nome = "dancar208" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_female^6" , andar = false , loop = true },
	{ nome = "dancar209" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^1" , andar = false , loop = true },
	{ nome = "dancar210" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^2" , andar = false , loop = true },
	{ nome = "dancar211" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^3" , andar = false , loop = true },
	{ nome = "dancar212" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^4" , andar = false , loop = true },
	{ nome = "dancar213" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^5" , andar = false , loop = true },
	{ nome = "dancar214" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v1_male^6" , andar = false , loop = true },
	{ nome = "dancar215" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar216" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^2" , andar = false , loop = true },
	{ nome = "dancar217" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar218" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^4" , andar = false , loop = true },
	{ nome = "dancar219" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^5" , andar = false , loop = true },
	{ nome = "dancar220" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_female^6" , andar = false , loop = true },
	{ nome = "dancar221" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^1" , andar = false , loop = true },
	{ nome = "dancar222" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^2" , andar = false , loop = true },
	{ nome = "dancar223" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^3" , andar = false , loop = true },
	{ nome = "dancar224" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^4" , andar = false , loop = true },
	{ nome = "dancar225" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar226" , dict = "anim@amb@nightclub@dancers@crowddance_groups@hi_intensity" , anim = "hi_dance_crowd_17_v2_male^6" , andar = false , loop = true },
	{ nome = "dancar227" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_center_up" , andar = false , loop = true },	
	{ nome = "dancar228" , dict = "timetable@tracy@ig_8@idle_b" , anim = "idle_d" , andar = false , loop = true },
	{ nome = "dancar229" , dict = "timetable@tracy@ig_5@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "dancar230" , dict = "anim@amb@nightclub@lazlow@hi_podium@" , anim = "danceidle_hi_11_buttwiggle_b_laz" , andar = false , loop = true },
	{ nome = "dancar231" , dict = "move_clown@p_m_two_idles@" , anim = "fidget_short_dance" , andar = false , loop = true },
	{ nome = "dancar232" , dict = "move_clown@p_m_zero_idles@" , anim = "fidget_short_dance" , andar = false , loop = true },
	{ nome = "dancar233" , dict = "misschinese2_crystalmazemcs1_ig" , anim = "dance_loop_tao" , andar = false , loop = true },
	{ nome = "dancar234" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar235" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_center_down" , andar = false , loop = true },
	{ nome = "dancar236" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar237" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar238" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_center" , andar = true , loop = true },
	{ nome = "dancar239" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar240" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center" , andar = false , loop = true },
	{ nome = "dancar241" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_down" , andar = false , loop = true },
	{ nome = "dancar242" , dict = "anim@amb@nightclub@dancers@podium_dancers@" , anim = "hi_dance_facedj_17_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar243" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar244" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_center_down" , andar = false , loop = true },
	{ nome = "dancar245" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar246" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar247" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center" , andar = false , loop = true },
	{ nome = "dancar248" , dict = "anim@amb@nightclub@dancers@solomun_entourage@" , anim = "mi_dance_facedj_17_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar249" , dict = "anim@mp_player_intcelebrationfemale@the_woogie" , anim = "the_woogie" , andar = false , loop = true },	
	{ nome = "dancar250" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "med_center_up" , andar = false , loop = true },	
	{ nome = "dancar251" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center" , andar = false , loop = true },	
	{ nome = "dancar252" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_center" , andar = false , loop = true },
	{ nome = "dancar253" , dict = "mini@strip_club@private_dance@idle" , anim = "priv_dance_idle" , andar = false , loop = true },
	{ nome = "dancar254" , dict = "mini@strip_club@lap_dance@ld_girl_a_song_a_p2" , anim = "ld_girl_a_song_a_p2_f" , andar = false , loop = true },
	{ nome = "dancar255" , dict = "mini@strip_club@lap_dance_2g@ld_2g_p1" , anim = "ld_2g_p1_s2" , andar = false , loop = true },
	{ nome = "dancar256" , dict = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1" , anim = "ld_girl_a_song_a_p1_f" , andar = false , loop = true },
	{ nome = "dancar260" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center_down" , andar = false , loop = true },
	{ nome = "dancar261" , dict = "anim@arena@celeb@podium@no_prop@" , anim = "dance_a_1st" , andar = false , loop = false },
	{ nome = "dancar262" , dict = "anim@amb@nightclub@lazlow@hi_podium@" , anim = "danceidle_mi_13_enticing_laz" , andar = false , loop = true },
	{ nome = "dancar263" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_right" , andar = false , loop = true },
	{ nome = "dancar264" , dict = "special_ped@mountain_dancer@monologue_3@monologue_3a" , anim = "mnt_dnc_buttwag" , andar = false , loop = true },
	{ nome = "dancar265" , dict = "anim@amb@nightclub@dancers@solomun_entourage@" , anim = "mi_dance_facedj_17_v1_female^1" , andar = false , loop = true },
	{ nome = "dancar266" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center" , andar = false , loop = true },
	{ nome = "dancar267" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar268" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^1" , andar = false , loop = true },
	{ nome = "dancar269" , dict = "anim@amb@nightclub@dancers@crowddance_facedj@hi_intensity" , anim = "hi_dance_facedj_09_v2_female^3" , andar = false , loop = true },
	{ nome = "dancar270" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar271" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar272" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_a@" , anim = "low_center_down" , andar = false , loop = true },
	{ nome = "dancar273" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar274" , dict = "anim@amb@nightclub@dancers@podium_dancers@" , anim = "hi_dance_facedj_17_v2_male^5" , andar = false , loop = true },
	{ nome = "dancar275" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_down" , andar = false , loop = true },
	{ nome = "dancar276" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center" , andar = false , loop = true },
	{ nome = "dancar277" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar278" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "high_center" , andar = true , loop = true },
	{ nome = "dancar279" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar280" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b" , anim = "low_center_down" , andar = false , loop = true },
	{ nome = "dancar281" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar282" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_left_up" , andar = false , loop = true },
	{ nome = "dancar283" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_right" , andar = false , loop = true },
	{ nome = "dancar284" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_right_down" , andar = false , loop = true },
	{ nome = "dancar285" , dict = "anim@amb@nightclub@mini@dance@dance_solo@female@var_b@" , anim = "med_right_up" , andar = false , loop = true },
	{ nome = "dancar286" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center" , andar = false , loop = true },
	{ nome = "dancar287" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center_down" , andar = false , loop = true },
	{ nome = "dancar288" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar289" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_left" , andar = false , loop = true },
	{ nome = "dancar290" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_left_down" , andar = false , loop = true },
	{ nome = "dancar291" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_left_up" , andar = false , loop = true },
	{ nome = "dancar292" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_right" , andar = false , loop = true },
	{ nome = "dancar293" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_right_down" , andar = false , loop = true },
	{ nome = "dancar294" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "high_right_up" , andar = false , loop = true },
	{ nome = "dancar295" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar296" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center_down" , andar = false , loop = true },
	{ nome = "dancar297" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_center_up" , andar = false , loop = true },
	{ nome = "dancar298" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_left" , andar = false , loop = true },
	{ nome = "dancar299" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_left_down" , andar = false , loop = true },
	{ nome = "dancar300" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_left_up" , andar = false , loop = true },
	{ nome = "dancar301" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_right" , andar = false , loop = true },
	{ nome = "dancar302" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_right_down" , andar = false , loop = true },
	{ nome = "dancar303" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "low_right_up" , andar = false , loop = true },
	{ nome = "dancar304" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_center" , andar = false , loop = true },
	{ nome = "dancar305" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_center_down" , andar = false , loop = true },
	{ nome = "dancar306" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_center_up" , andar = false , loop = true },
	{ nome = "dancar307" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_left" , andar = false , loop = true },
	{ nome = "dancar308" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_left_down" , andar = false , loop = true },
	{ nome = "dancar309" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_left_up" , andar = false , loop = true },
	{ nome = "dancar310" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_right" , andar = false , loop = true },
	{ nome = "dancar311" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_right_down" , andar = false , loop = true },
	{ nome = "dancar312" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_a@" , anim = "med_right_up" , andar = false , loop = true },
	{ nome = "dancar313" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center" , andar = false , loop = true },
	{ nome = "dancar314" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_down" , andar = false , loop = true },
	{ nome = "dancar315" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar316" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_left" , andar = false , loop = true },
	{ nome = "dancar317" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_left_down" , andar = false , loop = true },
	{ nome = "dancar318" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_left_up" , andar = false , loop = true },
	{ nome = "dancar319" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_right" , andar = false , loop = true },
	{ nome = "dancar320" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_right_down" , andar = false , loop = true },
	{ nome = "dancar321" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "high_right_up" , andar = false , loop = true },
	{ nome = "dancar322" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar323" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center_down" , andar = false , loop = true },
	{ nome = "dancar324" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_center_up" , andar = false , loop = true },
	{ nome = "dancar325" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_left" , andar = false , loop = true },
	{ nome = "dancar326" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_left_down" , andar = false , loop = true },
	{ nome = "dancar327" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_left_up" , andar = false , loop = true },
	{ nome = "dancar328" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_right" , andar = false , loop = true },
	{ nome = "dancar329" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_right_down" , andar = false , loop = true },
	{ nome = "dancar330" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "low_right_up" , andar = false , loop = true },
	{ nome = "dancar331" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_center" , andar = false , loop = true },
	{ nome = "dancar332" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_center_down" , andar = false , loop = true },
	{ nome = "dancar333" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_center_up" , andar = false , loop = true },
	{ nome = "dancar334" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_left" , andar = false , loop = true },
	{ nome = "dancar335" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_left_down" , andar = false , loop = true },
	{ nome = "dancar336" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_left_up" , andar = false , loop = true },
	{ nome = "dancar337" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_right" , andar = false , loop = true },
	{ nome = "dancar338" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_right_down" , andar = false , loop = true },
	{ nome = "dancar339" , dict = "anim@amb@nightclub@mini@dance@dance_solo@male@var_b@" , anim = "med_right_up" , andar = false , loop = true },
	{ nome = "dancar340" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_center" , andar = false , loop = true },
	{ nome = "dancar341" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_center_down" , andar = false , loop = true },
	{ nome = "dancar342" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_center_up" , andar = false , loop = true },
	{ nome = "dancar343" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_left" , andar = false , loop = true },
	{ nome = "dancar344" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_left_down" , andar = false , loop = true },
	{ nome = "dancar345" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_left_up" , andar = false , loop = true },
	{ nome = "dancar346" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_right" , andar = false , loop = true },
	{ nome = "dancar347" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_right_down" , andar = false , loop = true },
	{ nome = "dancar348" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "high_right_up" , andar = false , loop = true },
	{ nome = "dancar349" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_center" , andar = false , loop = true },
	{ nome = "dancar350" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_center_down" , andar = false , loop = true },
	{ nome = "dancar351" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_center_up" , andar = false , loop = true },
	{ nome = "dancar352" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_left" , andar = false , loop = true },
	{ nome = "dancar353" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_left_down" , andar = false , loop = true },
	{ nome = "dancar354" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_left_up" , andar = false , loop = true },
	{ nome = "dancar355" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_right" , andar = false , loop = true },
	{ nome = "dancar356" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_right_down" , andar = false , loop = true },
	{ nome = "dancar357" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "low_right_up" , andar = false , loop = true },
	{ nome = "dancar358" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_center" , andar = false , loop = true },
	{ nome = "dancar359" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_center_down" , andar = false , loop = true },
	{ nome = "dancar360" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_center_up" , andar = false , loop = true },
	{ nome = "dancar361" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_left" , andar = false , loop = true },
	{ nome = "dancar362" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_left_down" , andar = false , loop = true },
	{ nome = "dancar363" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_left_up" , andar = false , loop = true },
	{ nome = "dancar364" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_right" , andar = false , loop = true },
	{ nome = "dancar365" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_right_down" , andar = false , loop = true },
	{ nome = "dancar366" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@" , anim = "med_right_up" , andar = false , loop = true },
	{ nome = "dancar367" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center" , andar = false , loop = true },	
	{ nome = "dancar368" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center_down" , andar = false , loop = true },	
	{ nome = "dancar369" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_center_up" , andar = false , loop = true },	
	{ nome = "dancar370" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_left" , andar = false , loop = true },	
	{ nome = "dancar371" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_left_down" , andar = false , loop = true },	
	{ nome = "dancar372" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_left_up" , andar = false , loop = true },	
	{ nome = "dancar373" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_right" , andar = false , loop = true },	
	{ nome = "dancar374" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_right_down" , andar = false , loop = true },	
	{ nome = "dancar375" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "high_right_up" , andar = false , loop = true },	
	{ nome = "dancar376" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_center" , andar = false , loop = true },	
	{ nome = "dancar377" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_center_down" , andar = false , loop = true },	
	{ nome = "dancar378" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_center_up" , andar = false , loop = true },	
	{ nome = "dancar379" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_left" , andar = false , loop = true },	
	{ nome = "dancar380" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_left_down" , andar = false , loop = true },	
	{ nome = "dancar381" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_left_up" , andar = false , loop = true },	
	{ nome = "dancar382" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_right" , andar = false , loop = true },	
	{ nome = "dancar383" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_right_down" , andar = false , loop = true },	
	{ nome = "dancar384" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "low_right_up" , andar = false , loop = true },	
	{ nome = "dancar385" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_center" , andar = false , loop = true },	
	{ nome = "dancar386" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_center_down" , andar = false , loop = true },	
	{ nome = "dancar387" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_center_up" , andar = false , loop = true },	
	{ nome = "dancar388" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_left" , andar = false , loop = true },	
	{ nome = "dancar389" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_left_down" , andar = false , loop = true },	
	{ nome = "dancar390" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_left_up" , andar = false , loop = true },	
	{ nome = "dancar391" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_right" , andar = false , loop = true },	
	{ nome = "dancar392" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_right_down" , andar = false , loop = true },	
	{ nome = "dancar393" , dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@" , anim = "med_right_up" , andar = false , loop = true },
	{ nome = "poledance" , dict = "mini@strip_club@pole_dance@pole_dance1", anim = "pd_dance_01", andar = false, loop = true, extra = function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(poleDances) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 1 then
				SetEntityHeading(ped,v[4])
				SetEntityCoords(ped,v[1],v[2],v[3] - 1,1,0,0,0)
				break
			end
		end
	end },
	{ nome = "poledance2" , dict = "mini@strip_club@pole_dance@pole_dance2", anim = "pd_dance_02", andar = false, loop = true, extra = function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(poleDances) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 1 then
				SetEntityHeading(ped,v[4])
				SetEntityCoords(ped,v[1],v[2],v[3] - 1,1,0,0,0)
				break
			end
		end
	end },
	{ nome = "poledance3" , dict = "mini@strip_club@pole_dance@pole_dance3", anim = "pd_dance_03", andar = false, loop = true, extra = function()
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)
		for k,v in pairs(poleDances) do
			local distance = #(coords - vector3(v[1],v[2],v[3]))
			if distance <= 1 then
				SetEntityHeading(ped,v[4])
				SetEntityCoords(ped,v[1],v[2],v[3] - 1,1,0,0,0)
				break
			end
		end
	end },
	{ nome = "sexo" , dict = "rcmpaparazzo_2" , anim = "shag_loop_poppy" , andar = false , loop = true },
	{ nome = "sexo2" , dict = "rcmpaparazzo_2" , anim = "shag_loop_a" , andar = false , loop = true },
	{ nome = "sexo3" , dict = "anim@mp_player_intcelebrationfemale@air_shagging" , anim = "air_shagging" , andar = false , loop = true },
	{ nome = "sexo4" , dict = "oddjobs@towing" , anim = "m_blow_job_loop" , andar = false , loop = true , carros = true },
	{ nome = "sexo5" , dict = "oddjobs@towing" , anim = "f_blow_job_loop" , andar = false , loop = true , carros = true },
	{ nome = "sexo6" , dict = "mini@prostitutes@sexlow_veh" , anim = "low_car_sex_loop_female" , andar = false , loop = true , carros = true },
	{ nome = "sexo7" , dict = "timetable@trevor@skull_loving_bear" , anim = "skull_loving_bear" , andar = false , loop = true },
	{ nome = "sentar" , dict = "amb@world_human_picnic@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "sentar2" , dict = "anim@heists@fleeca_bank@ig_7_jetski_owner" , anim = "owner_idle" , andar = false , loop = true },
	{ nome = "sentar3" , dict = "amb@world_human_stupor@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "sentar4" , dict = "amb@world_human_picnic@female@base" , anim = "base" , andar = false , loop = true },
	{ nome = "sentar5" , dict = "anim@amb@nightclub@lazlow@lo_alone@" , anim = "lowalone_base_laz" , andar = false , loop = true },
	{ nome = "sentar6" , dict = "anim@amb@business@bgen@bgen_no_work@" , anim = "sit_phone_phoneputdown_idle_nowork" , andar = false , loop = true },
	{ nome = "sentar7" , dict = "rcm_barry3" , anim = "barry_3_sit_loop" , andar = false , loop = true },
	{ nome = "sentar8" , dict = "amb@world_human_picnic@male@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "sentar9" , dict = "amb@world_human_picnic@female@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "sentar10" , dict = "timetable@jimmy@mics3_ig_15@" , anim = "idle_a_jimmy" , andar = false , loop = true },
	{ nome = "sentar11" , dict = "timetable@jimmy@mics3_ig_15@" , anim = "mics3_15_base_jimmy" , andar = false , loop = true },
	{ nome = "sentar12" , dict = "amb@world_human_stupor@male@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "sentar13" , dict = "timetable@tracy@ig_14@" , anim = "ig_14_base_tracy" , andar = false , loop = true },
	{ nome = "sentar14" , dict = "anim@heists@ornate_bank@hostages@hit" , anim = "hit_loop_ped_b" , andar = false , loop = true },
	{ nome = "sentar15" , dict = "timetable@ron@ig_5_p3" , anim = "ig_5_p3_base" , andar = false , loop = true },
	{ nome = "sentar16" , dict = "timetable@reunited@ig_10" , anim = "base_amanda" , andar = false , loop = true },
	{ nome = "sentar17" , dict = "timetable@ron@ig_3_couch" , anim = "base" , andar = false , loop = true },
	{ nome = "sentar18" , dict = "timetable@jimmy@mics3_ig_15@" , anim = "mics3_15_base_tracy" , andar = false , loop = true },
	{ nome = "sentar19" , dict = "timetable@maid@couch@" , anim = "base" , andar = false , loop = true },
	{ nome = "sentar20" , dict = "timetable@ron@ron_ig_2_alt1" , anim = "ig_2_alt1_base" , andar = false , loop = true },
	{ nome = "sentar21" , dict = "mp_am_stripper" , anim = "lap_dance_player" , andar = false , loop = true },
	{ nome = "sentar22" , dict = "anim@amb@casino@out_of_money@ped_male@02b@idles" , anim = "idle_a" , andar = false , loop = true },

	{ nome = "striper" , dict = "mini@strip_club@idles@stripper" , anim = "stripper_idle_02" , andar = false , loop = true },
	{ nome = "escutar" , dict = "mini@safe_cracking" , anim = "idle_base" , andar = false , loop = true },
	{ nome = "alongar" , dict = "anim@deathmatch_intros@unarmed" , anim = "intro_male_unarmed_e" , andar = false , loop = true },
	{ nome = "alongar2" , dict = "mini@triathlon" , anim = "idle_e" , andar = false , loop = true },
	{ nome = "alongar3" , dict = "anim@deathmatch_intros@unarmed" , anim = "intro_male_unarmed_c" , andar = false , loop = false },
	{ nome = "alongar4" , dict = "mini@triathlon" , anim = "idle_f" , andar = false , loop = true },
	{ nome = "alongar5" , dict = "mini@triathlon" , anim = "idle_d" , andar = false , loop = true },
	{ nome = "alongar6" , dict = "rcmfanatic1maryann_stretchidle_b" , anim = "idle_e" , andar = false , loop = true },
	{ nome = "alongar7" , dict = "timetable@reunited@ig_2" , anim = "jimmy_getknocked" , andar = false , loop = true },
	{ nome = "dj" , dict = "anim@mp_player_intupperdj" , anim = "idle_a", andar = true , loop = true },
	{ nome = "dj2" , dict = "anim@mp_player_intupperair_synth" , anim = "idle_a_fp" , andar = false , loop = true },
	{ nome = "dj3" , dict = "anim@mp_player_intcelebrationfemale@air_synth" , anim = "air_synth" , andar = false , loop = false },
	{ nome = "rock" , dict = "anim@mp_player_intcelebrationmale@air_guitar" , anim = "air_guitar" , andar = false , loop = false },
	{ nome = "rock2" , dict = "mp_player_introck" , anim = "mp_player_int_rock" , andar = false , loop = false },
	{ nome = "peitos" , dict = "mini@strip_club@backroom@" , anim = "stripper_b_backroom_idle_b" , andar = false , loop = false },
	{ nome = "espernear" , dict = "missfam4leadinoutmcs2" , anim = "tracy_loop" , andar = false , loop = true },
	{ nome = "arrumar" , dict = "anim@amb@business@coc@coc_packing_hi@" , anim = "full_cycle_v1_pressoperator" , andar = false , loop = true },
	{ nome = "bebado" , dict = "missfam5_blackout" , anim = "pass_out" , andar = false , loop = false },
	{ nome = "bebado2" , dict = "missheist_agency3astumble_getup" , anim = "stumble_getup" , andar = false , loop = false },
	{ nome = "bebado3" , dict = "missfam5_blackout" , anim = "vomit" , andar = false , loop = false },
	{ nome = "bebado4" , dict = "random@drunk_driver_1" , anim = "drunk_fall_over" , andar = false , loop = false },
	{ nome = "bebado5" , dict = "misscarsteal4@actor" , anim = "stumble" , andar = false , loop = false },
	{ nome = "bebado6" , dict = "anim@amb@nightclub@mini@drinking@drinking_shots@ped_c@drunk" , anim = "outro_fallover" , andar = false , loop = false },
	{ nome = "bebado7" , dict = "switch@trevor@puking_into_fountain" , anim = "trev_fountain_puke_loop" , andar = false , loop = true },
	{ nome = "bebado8" , dict = "switch@trevor@head_in_sink" , anim = "trev_sink_idle" , andar = false , loop = true },
	{ nome = "yoga" , dict = "missfam5_yoga" , anim = "f_yogapose_a" , andar = false , loop = true },
	{ nome = "yoga2" , dict = "amb@world_human_yoga@male@base" , anim = "base_a" , andar = false , loop = true },
	{ nome = "abdominal" , dict = "amb@world_human_sit_ups@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "bixa" , anim = "WORLD_HUMAN_PROSTITUTE_LOW_CLASS" },
	{ nome = "britadeira" , dict = "amb@world_human_const_drill@male@drill@base" , anim = "base" , prop = "prop_tool_jackham" , flag = 15 , hand = 28422 },
	{ nome = "cerveja" , anim = "WORLD_HUMAN_PARTYING" },
	{ nome = "churrasco" , anim = "PROP_HUMAN_BBQ" },
	{ nome = "consertar" , anim = "WORLD_HUMAN_WELDING" },
	{ nome = "dormir" , dict = "anim@heists@ornate_bank@hostages@hit" , anim = "hit_react_die_loop_ped_a" , andar = false , loop = true },
	{ nome = "dormir2" , dict = "anim@heists@ornate_bank@hostages@hit" , anim = "hit_react_die_loop_ped_e" , andar = false , loop = true },
	{ nome = "dormir3" , dict = "anim@heists@ornate_bank@hostages@hit" , anim = "hit_react_die_loop_ped_h" , andar = false , loop = true },
	{ nome = "dormir4" , dict = "mp_sleep" , anim = "sleep_loop" , andar = true , loop = true },
	{ nome = "dormir5" , dict = "missarmenian2" , anim = "drunk_loop" , andar = false , loop = true },
	{ nome = "encostar" , dict = "amb@lo_res_idles@" , anim = "world_human_lean_male_foot_up_lo_res_base" , andar = false , loop = true },
	{ nome = "encostar2" , dict = "bs_2a_mcs_10-0" , anim = "hc_gunman_dual-0" , andar = false , loop = true },
	{ nome = "encostar3" , dict = "misscarstealfinalecar_5_ig_1" , anim = "waitloop_lamar" , andar = false , loop = true },
	{ nome = "encostar4" , dict = "anim@amb@casino@out_of_money@ped_female@02b@base" , anim = "base" , andar = false , loop = true },
	{ nome = "encostar5" , dict = "anim@amb@casino@hangout@ped_male@stand@03b@base" , anim = "base" , andar = true , loop = true },
	{ nome = "encostar6" , dict = "anim@amb@casino@hangout@ped_female@stand@02b@base" , anim = "base" , andar = false , loop = true },
	{ nome = "encostar7" , dict = "anim@amb@casino@hangout@ped_female@stand@02a@base" , anim = "base" , andar = false , loop = true },
	{ nome = "encostar8" , dict = "anim@amb@casino@hangout@ped_female@stand@01b@base" , anim = "base" , andar = false , loop = true },
	{ nome = "encostar9" , dict = "anim@amb@clubhouse@bar@bartender@" , anim = "base_bartender" , andar = false , loop = true },
	{ nome = "encostar10" , dict = "missclothing" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "encostar11" , dict = "misscarstealfinale" , anim = "packer_idle_1_trevor" , andar = false , loop = true },
	{ nome = "encostar12" , dict = "missarmenian1leadinoutarm_1_ig_14_leadinout" , anim = "leadin_loop" , andar = false , loop = true },
	{ nome = "estatua" , dict = "amb@world_human_statue@base" , anim = "base" , andar = false , loop = true },
	{ nome = "estatua2" , dict = "club_intro2-0" , anim = "csb_englishdave_dual-0" , andar = false , loop = true },
	{ nome = "flexao" , dict = "amb@world_human_push_ups@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "flexao2" , anim = "WORLD_HUMAN_MUSCLE_FLEX" },
	{ nome = "fumar" , anim = "WORLD_HUMAN_SMOKING" },
	{ nome = "fumar2" , anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS" },
	{ nome = "fumar3" , anim = "WORLD_HUMAN_AA_SMOKE" },
	{ nome = "fumar4" , anim = "WORLD_HUMAN_SMOKING_POT" },
	{ nome = "fumar5" , dict = "amb@world_human_aa_smoke@male@idle_a" , anim = "idle_c" , prop = "prop_cs_ciggy_01" , flag = 49 , hand = 28422 },
	{ nome = "fumar6" , dict = "amb@world_human_smoking@female@idle_a" , anim = "idle_b" , prop = "prop_cs_ciggy_01" , flag = 49 , hand = 28422 },
	{ nome = "malhar" , dict = "amb@world_human_muscle_free_weights@male@barbell@base" , anim = "base" , prop = "prop_curl_bar_01" , flag = 49 , hand = 28422 },
	{ nome = "malhar2" , dict = "amb@prop_human_muscle_chin_ups@male@base" , anim = "base" , andar = false , loop = true },
	{ nome = "martelo" , dict = "amb@world_human_hammering@male@base" , anim = "base" , prop = "prop_tool_hammer" , flag = 49 , hand = 28422 },
	{ nome = "pescar" , dict = "amb@world_human_stand_fishing@base" , anim = "base" , prop = "prop_fishing_rod_01" , flag = 49 , hand = 60309 },
	{ nome = "pescar2" , dict = "amb@world_human_stand_fishing@idle_a" , anim = "idle_c" , prop = "prop_fishing_rod_01" , flag = 49 , hand = 60309 },
	{ nome = "plantar" , dict = "amb@world_human_gardener_plant@female@base" , anim = "base_female" , andar = false , loop = true },
	{ nome = "plantar2" , dict = "amb@world_human_gardener_plant@female@idle_a" , anim = "idle_a_female" , andar = false , loop = true },
	{ nome = "procurar" , dict = "amb@world_human_bum_wash@male@high@base" , anim = "base" , andar = false , loop = true },
	{ nome = "soprador" , dict = "amb@code_human_wander_gardener_leaf_blower@base" , anim = "static" , prop = "prop_leaf_blower_01" , flag = 49 , hand = 28422 },
	{ nome = "soprador2" , dict = "amb@code_human_wander_gardener_leaf_blower@idle_a" , anim = "idle_a" , prop = "prop_leaf_blower_01" , flag = 49 , hand = 28422 },
	{ nome = "soprador3" , dict = "amb@code_human_wander_gardener_leaf_blower@idle_a" , anim = "idle_b" , prop = "prop_leaf_blower_01" , flag = 49 , hand = 28422 },
	{ nome = "trotar" , dict = "amb@world_human_jog_standing@male@fitidle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "esquentar" , anim = "WORLD_HUMAN_STAND_FIRE" },
	{ nome = "selfie" , dict = "cellphone@self" , anim = "selfie_in_from_text" , prop = "prop_amb_phone" , flag = 50 , hand = 28422 },
	{ nome = "selfie2" , dict = "cellphone@" , anim = "cellphone_text_read_base_cover_low" , prop = "prop_amb_phone" , flag = 50 , hand = 28422 },
	{ nome = "mecanico" , dict = "amb@world_human_vehicle_mechanic@male@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "mecanico2" , dict = "mini@repair" , anim = "fixing_a_player" , andar = false , loop = true },
	{ nome = "mecanico3" , dict = "mini@repair" , anim = "fixing_a_ped" , andar = false , loop = true },
	{ nome = "mecanico4" , dict = "anim@amb@garage@chassis_repair@" , anim = "look_tool_01_amy_skater_01" , andar = false , loop = true },
	{ nome = "furadeira" , dict = "anim@heists@fleeca_bank@drilling" , anim = "drill_left" , prop = "ch_prop_ch_heist_drill" , flag = 49 , hand = 60309 },
	{ nome = "puto" , dict = "misscarsteal4@actor" , anim = "actor_berating_loop" , andar = true , loop = false },
	{ nome = "puto2" , dict = "oddjobs@assassinate@vice@hooker" , anim = "argue_a" , andar = true , loop = false },
	{ nome = "puto3" , dict = "mini@triathlon" , anim = "want_some_of_this" , andar = true , loop = false },
	{ nome = "bale" , dict = "anim@mp_player_intcelebrationpaired@f_f_sarcastic" , anim = "sarcastic_left" , andar = false , loop = true },
	{ nome = "bonzao" , dict = "misscommon@response" , anim = "bring_it_on" , andar = true , loop = false },
	{ nome = "wtf" , dict = "anim@mp_player_intcelebrationfemale@face_palm" , anim = "face_palm" , andar = true , loop = false },
	{ nome = "wtf2" , dict = "random@car_thief@agitated@idle_a" , anim = "agitated_idle_a" , andar = true , loop = false },
	{ nome = "wtf3" , dict = "missminuteman_1ig_2" , anim = "tasered_2" , andar = true , loop = false },
	{ nome = "wtf4" , dict = "anim@mp_player_intupperface_palm" , anim = "idle_a" , andar = true , loop = false },
	--{ nome = "meditar" , dict = "rcmcollect_paperleadinout@" , anim = "meditiate_idle" , andar = false , loop = true },
	{ nome = "meditar2" , dict = "timetable@amanda@ig_4" , anim = "ig_4_base" , andar = false , loop = true },
	{ nome = "meditar3" , dict = "mp_fm_intro_cut" , anim = "base_loop" , andar = false , loop = true },
	{ nome = "joia" , dict = "anim@mp_player_intincarthumbs_uplow@ds@" , anim = "enter" , andar = true , loop = false },
	{ nome = "joia2" , dict = "anim@mp_player_intselfiethumbs_up" , anim = "idle_a" , andar = true , loop = false },
	{ nome = "carona" , dict = "random@hitch_lift" , anim = "idle_f" , andar = true , loop = false },
	{ nome = "rastejar" , dict = "move_crawl" , anim = "onfront_fwd" , andar = false , loop = true },
	{ nome = "rastejar2" , dict = "move_injured_ground" , anim = "front_loop" , andar = false , loop = true },
	{ nome = "rastejar3" , dict = "missfbi3_sniping" , anim = "prone_dave" , andar = false , loop = true },
	{ nome = "pirueta" , dict = "anim@arena@celeb@flat@solo@no_props@" , anim = "cap_a_player_a" , andar = false , loop = false },
	{ nome = "pirueta2" , dict = "anim@arena@celeb@flat@solo@no_props@" , anim = "flip_a_player_a" , andar = false , loop = false },
	{ nome = "onda" , dict = "anim@mp_player_intupperfind_the_fish" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "heroi" , dict = "rcmbarry" , anim = "base" , andar = true , loop = true },
	{ nome = "boboalegre" , dict = "rcm_barry2" , anim = "clown_idle_0" , andar = false , loop = false },
	{ nome = "boboalegre2" , dict = "rcm_barry2" , anim = "clown_idle_1" , andar = false , loop = false },
	{ nome = "boboalegre3" , dict = "rcm_barry2" , anim = "clown_idle_2" , andar = false , loop = false },
	{ nome = "boboalegre4" , dict = "rcm_barry2" , anim = "clown_idle_3" , andar = false , loop = false },
	{ nome = "boboalegre5" , dict = "rcm_barry2" , anim = "clown_idle_6" , andar = false , loop = false },
	{ nome = "passaro" , dict = "random@peyote@bird" , anim = "wakeup" , andar = false , loop = false },
	{ nome = "cachorro" , dict = "random@peyote@dog" , anim = "wakeup" , andar = false , loop = false },
	{ nome = "tiltado" , dict = "anim@mp_player_intcelebrationfemale@freakout" , anim = "freakout" , andar = false , loop = false },
	{ nome = "dedo" , dict = "anim@mp_player_intcelebrationfemale@finger" , anim = "finger" , andar = true , loop = false },
	{ nome = "dedo2" , dict = "anim@arena@celeb@podium@no_prop@" , anim = "flip_off_a_1st" , andar = false , loop = false },
	{ nome = "dedo3" , dict = "anim@arena@celeb@podium@no_prop@" , anim = "flip_off_c_1st" , andar = true , loop = false },
	{ nome = "dedo4" , dict = "random@shop_robbery_reactions@" , anim = "screw_you" , andar = true , loop = false },
	{ nome = "mamamia" , dict = "anim@mp_player_intcelebrationmale@finger_kiss" , anim = "finger_kiss" , andar = true , loop = false },
	{ nome = "louco" , dict = "anim@mp_player_intincaryou_locobodhi@ds@" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "xiu" , dict = "anim@mp_player_intincarshushbodhi@ds@" , anim = "idle_a_fp" , andar = true , loop = true },
	{ nome = "ok" , dict = "anim@mp_player_intselfiedock" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "escorregar" , dict = "anim@arena@celeb@flat@solo@no_props@" , anim = "slide_a_player_a" , andar = false , loop = false },
	{ nome = "escorregar2" , dict = "anim@arena@celeb@flat@solo@no_props@" , anim = "slide_c_player_a" , andar = false , loop = false },
	{ nome = "gang" , dict = "mp_player_int_uppergang_sign_a" , anim = "mp_player_int_gang_sign_a" , andar = true , loop = true },
	{ nome = "gang2" , dict = "mp_player_int_uppergang_sign_b" , anim = "mp_player_int_gang_sign_b" , andar = true , loop = true },
	{ nome = "cruzar" , dict = "amb@world_human_cop_idles@female@idle_b" , anim = "idle_e" , andar = true , loop = true },
	{ nome = "cruzar2" , dict = "anim@amb@casino@hangout@ped_male@stand@02b@idles" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "cruzar3" , dict = "amb@world_human_hang_out_street@male_c@idle_a" , anim = "idle_b" , andar = true , loop = true },
	{ nome = "cruzar4" , dict = "random@street_race" , anim = "_car_b_lookout" , andar = true , loop = true },
	{ nome = "cruzar5" , dict = "random@shop_gunstore" , anim = "_idle" , andar = true , loop = true },
	{ nome = "cruzar6" , dict = "move_m@hiking" , anim = "idle" , andar = true , loop = true },
	{ nome = "cruzar7" , dict = "anim@amb@casino@valet_scenario@pose_d@" , anim = "base_a_m_y_vinewood_01" , andar = true , loop = true },
	{ nome = "cruzar8" , dict = "anim@amb@casino@shop@ped_female@01a@base" , anim = "base" , andar = true , loop = true },
	{ nome = "cruzar9" , dict = "anim@amb@casino@valet_scenario@pose_c@" , anim = "shuffle_feet_a_m_y_vinewood_01" , andar = true , loop = true },
	{ nome = "cruzar10" , dict = "anim@amb@casino@hangout@ped_male@stand@03a@idles_convo" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "fera" , dict = "anim@mp_fm_event@intro" , anim = "beast_transform" , andar = true , loop = false },
	{ nome = "karate" , dict = "anim@mp_player_intcelebrationfemale@karate_chops" , anim = "karate_chops" , andar = false , loop = false },
	{ nome = "karate2" , dict = "anim@mp_player_intcelebrationmale@karate_chops" , anim = "karate_chops" , andar = false , loop = false },
	{ nome = "boxe" , dict = "anim@mp_player_intcelebrationmale@shadow_boxing" , anim = "shadow_boxing" , andar = false , loop = false },
	{ nome = "boxe2" , dict = "anim@mp_player_intcelebrationfemale@shadow_boxing" , anim = "shadow_boxing" , andar = false , loop = false },
	{ nome = "explodir" , dict = "anim@mp_player_intcelebrationmale@mind_blown" , anim = "mind_blown" , andar = false , loop = false },
	{ nome = "fedo" , dict = "anim@mp_player_intcelebrationfemale@stinker" , anim = "stinker" , andar = false , loop = false },
	{ nome = "pensar" , dict = "anim@amb@casino@out_of_money@ped_male@01b@base" , anim = "base" , andar = true , loop = true },
	{ nome = "pensar2" , dict = "misscarsteal4@aliens" , anim = "rehearsal_base_idle_director" , andar = true , loop = true },
	{ nome = "pensar3" , dict = "timetable@tracy@ig_8@base", anim = "base" , andar = true , loop = true },
	{ nome = "ferido" , dict = "anim@amb@casino@hangout@ped_female@stand_withdrink@01b@base" , anim = "base" , andar = true , loop = true },
	{ nome = "ferido2" , dict = "combat@damage@injured_pistol@to_writhe" , anim = "variation_d" , andar = false , loop = false },
	{ nome = "olhar" , dict = "oddjobs@basejump@" , anim = "ped_d_loop" , andar = true , loop = true },
	{ nome = "olhar2" , dict = "friends@fra@ig_1" , anim = "base_idle" , andar = true , loop = true },
	{ nome = "suicidio" , dict = "mp_suicide" , anim = "pistol" , andar = false , loop = false },
	{ nome = "suicidio2" , dict = "mp_suicide" , anim = "pill" , andar = false , loop = false },
	{ nome = "senha" , dict = "mp_heists@keypad@" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "lavar" , dict = "missheist_agency3aig_23" , anim = "urinal_sink_loop" , andar = true , loop = true },
	{ nome = "triste" , dict = "misscarsteal2car_stolen" , anim = "chad_car_stolen_reaction" , andar = false , loop = false },
	{ nome = "aqc" , dict = "anim@deathmatch_intros@unarmed" , anim = "intro_male_unarmed_a" , andar = false , loop = false },
	{ nome = "aqc2" , dict = "anim@deathmatch_intros@unarmed" , anim = "intro_male_unarmed_d" , andar = false , loop = false },
	{ nome = "inspec" , dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_b" , andar = false , loop = true },
	{ nome = "inspec2" , dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_c" , andar = false , loop = false },
	{ nome = "inspec3" , dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_d" , andar = false , loop = false },
	{ nome = "inspec4" , dict = "anim@deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_e" , andar = false , loop = false },
	{ nome = "inspec5" , dict = "mp_deathmatch_intros@1hmale" , anim = "intro_male_1h_a_michael" , andar = false , loop = false },
	{ nome = "inspec6" , dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_a" , andar = false , loop = false },
	{ nome = "inspec7" , dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_b" , andar = false , loop = false },
	{ nome = "inspec8" , dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_c" , andar = false , loop = false },
	{ nome = "inspec9" , dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_d" , andar = false , loop = false },
	{ nome = "inspec10" , dict = "mp_deathmatch_intros@melee@1h" , anim = "intro_male_melee_1h_e" , andar = false , loop = false },
	{ nome = "inspec11" , dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_a" , andar = false , loop = false },
	{ nome = "inspec12" , dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_b" , andar = false , loop = false },
	{ nome = "inspec13" , dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_c" , andar = false , loop = false },
	{ nome = "inspec14" , dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_d" , andar = false , loop = false },
	{ nome = "inspec15" , dict = "mp_deathmatch_intros@melee@2h" , anim = "intro_male_melee_2h_e" , andar = false , loop = false },
	{ nome = "inspec16" , dict = "anim@deathmatch_intros@1hmale" , anim = "intro_male_1h_d_michael" , andar = true , loop = false },
	{ nome = "sentardog" , dict = "creatures@rottweiler@amb@world_dog_sitting@base" , anim = "base" , andar = false , loop = true },
	{ nome = "sentardog2" , dict = "creatures@carlin@amb@world_dog_sitting@idle_a" , anim = "idle_b" , andar = false , loop = true },
	{ nome = "sentardog3" , dict = "creatures@retriever@amb@world_dog_sitting@idle_a" , anim = "idle_c" , andar = false , loop = true },
	{ nome = "deitardog" , dict = "creatures@rottweiler@amb@sleep_in_kennel@" , anim = "sleep_in_kennel" , andar = false , loop = true },
	{ nome = "deitardog2" , dict = "creatures@cat@amb@world_cat_sleeping_ground@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "deitardog3" , dict = "creatures@coyote@amb@world_coyote_rest@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "swat" , dict = "swat" , anim = "come" , andar = true , loop = false },
	{ nome = "swat2" , dict = "swat" , anim = "freeze" , andar = true , loop = false },
	{ nome = "swat3" , dict = "swat" , anim = "go_fwd" , andar = true , loop = false },
	{ nome = "swat4" , dict = "swat" , anim = "rally_point" , andar = true , loop = false },
	{ nome = "swat5" , dict = "swat" , anim = "understood" , andar = true , loop = false },
	{ nome = "swat6" , dict = "swat" , anim = "you_back" , andar = true , loop = false },
	{ nome = "swat7" , dict = "swat" , anim = "you_fwd" , andar = true , loop = false },
	{ nome = "swat8" , dict = "swat" , anim = "you_left" , andar = true , loop = false },
	{ nome = "swat9" , dict = "swat" , anim = "you_right" , andar = true , loop = false },
	{ nome = "aqui" , dict = "gestures@f@standing@casual" , anim = "gesture_hand_down" , andar = true , loop = false },
	{ nome = "inspecionar" , dict = "random@train_tracks" , anim = "idle_e" , andar = false , loop = true },
	{ nome = "buuu" , dict = "anim@mp_player_intcelebrationfemale@jazz_hands" , anim = "jazz_hands" , andar = true , loop = false },
	{ nome = "olharespelho" , dict = "mp_clothing@female@trousers" , anim = "try_trousers_neutral_a" , andar = false , loop = true },
	{ nome = "olharespelho2" , dict = "mp_clothing@female@shirt" , anim = "try_shirt_positive_a" , andar = false , loop = true },
	{ nome = "olharespelho3" , dict = "mp_clothing@female@shoes" , anim = "try_shoes_positive_a" , andar = false , loop = true },
	{ nome = "coelho" , dict = "random@peyote@rabbit" , anim = "wakeup" , andar = false , loop = false },
	--[[{ nome = "binoculos" , dict = "amb@world_human_binoculars@male@enter" , anim = "enter" , prop = "prop_binoc_01" , flag = 50 , hand = 28422 , extra = function()
		binoculos = true
	end },]]
	{ nome = "camera2" , dict = "missfinale_c2mcs_1" , anim = "fin_c2_mcs_1_camman" , prop = "prop_v_cam_01" , flag = 49 , hand = 28422 , extra = function() 
		camerajornal = true
	end },
	{ nome = "camera3" , dict = "missmic4premiere" , anim = "interview_short_camman" , prop = "prop_v_cam_01" , flag = 49 , hand = 28422 , extra = function() 
		camerajornal = true
	end },
	{ nome = "limpar" , dict = "timetable@maid@cleaning_window@base" , anim = "base" , prop = "prop_rag_01" , flag = 49 , hand = 28422 , extra = function()
		local vehicle = vRP.getNearVehicle(5)
		if IsEntityAVehicle(vehicle) then
			LocalPlayer["state"]["Cancel"] = true
			TriggerEvent("Progress",15000)
			SetTimeout(15000,function()
				LocalPlayer["state"]["Cancel"] = false
				TriggerServerEvent("tryCleanEntity",VehToNet(vehicle))
				vRP.removeObjects("one")
			end)
		end
	end },
	{ nome = "limpar2" , dict = "timetable@maid@cleaning_surface@base" , anim = "base" , prop = "prop_rag_01" , flag = 49 , hand = 28422 , extra = function()
		local vehicle = vRP.getNearVehicle(5)
		if IsEntityAVehicle(vehicle) then
			LocalPlayer["state"]["Cancel"] = true
			TriggerEvent("Progress",15000)
			SetTimeout(15000,function()
				LocalPlayer["state"]["Cancel"] = false
				TriggerServerEvent("tryCleanEntity",VehToNet(vehicle))
				vRP.removeObjects("one")
			end)
		end
	end },
	{ nome = "limpar3" , dict = "timetable@floyd@clean_kitchen@base" , anim = "base" , prop = "prop_sponge_01" , andar = true , loop = true , flag = 49 , hand = 28422 , pos1 = 0.0 , pos2 = 0.0 , pos3 = -0.01 , pos4 = 90.0 , pos5 = 0.0 , pos6 = 0.0 , propAnim = true , extra = function()
		local vehicle = vRP.getNearVehicle(5)
		if IsEntityAVehicle(vehicle) then
			LocalPlayer["state"]["Cancel"] = true
			TriggerEvent("Progress",15000)
			SetTimeout(15000,function()
				LocalPlayer["state"]["Cancel"] = false
				TriggerServerEvent("tryCleanEntity",VehToNet(vehicle))
				vRP.removeObjects("one")
			end)
		end
	end },
	{ nome = "limpar4" , dict = "amb@world_human_maid_clean@" , anim = "base" , prop = "prop_sponge_01" , andar = true , loop = true , flag = 49 , hand = 28422 , pos1 = 0.0 , pos2 = 0.0 , pos3 = -0.01 , pos4 = 90.0 , pos5 = 0.0 , pos6 = 0.0 , propAnim = true , extra = function()
		local vehicle = vRP.getNearVehicle(5)
		if IsEntityAVehicle(vehicle) then
			LocalPlayer["state"]["Cancel"] = true
			TriggerEvent("Progress",15000)
			SetTimeout(15000,function()
				LocalPlayer["state"]["Cancel"] = false
				TriggerServerEvent("tryCleanEntity",VehToNet(vehicle))
				vRP.removeObjects("one")
			end)
		end
	end },
	{ nome = "mijar" , dict = "misscarsteal2peeing" , anim = "peeing_intro" , andar = false , loop = false , extra = function()
		local ped = PlayerPedId()
		SetTimeout(4000,function()
			TriggerServerEvent("trySyncParticle","peeing",PedToNet(ped))
			Citizen.Wait(4500)
			TriggerServerEvent("tryStopParticle",PedToNet(ped))
		end)
	end },
	{ nome = "cagar" , dict = "missfbi3ig_0" , anim = "shit_loop_trev" , andar = false , loop = false , extra = function()
		local ped = PlayerPedId()
		TriggerServerEvent("trySyncParticle","poo",PedToNet(ped))
		SetTimeout(15000,function()
			TriggerServerEvent("tryStopParticle",PedToNet(ped))
		end)
	end	},
	{ nome = "livro" , dict = "cellphone@" , anim = "cellphone_text_read_base" , prop = "prop_novel_01" , andar = true , loop = true , flag = 49 , hand = 6286 , pos1 = 0.15 , pos2 = 0.03 , pos3 = -0.065 , pos4 = 0.0 , pos5 = 180.0 , pos6 = 90.0 , propAnim = true },
	{ nome = "urso" , dict = "impexp_int-0" , anim = "mp_m_waremech_01_dual-0" , prop = "v_ilev_mr_rasberryclean" , andar = true , loop = true , flag = 49 , hand = 24817 , pos1 = -0.20 , pos2 = 0.46 , pos3 = -0.016 , pos4 = -180.0 , pos5 = -90.0 , pos6 = 0.0 , propAnim = true },
	{ nome = "dinheiro" , dict = "anim@mp_player_intupperraining_cash" , anim = "idle_a" , prop = "prop_anim_cash_pile_01" , andar = true , loop = true , flag = 49 , hand = 60309 , pos1 = 0.0 , pos2 = 0.0 , pos3 = 0.0 , pos4 = 180.0 , pos5 = 0.0 , pos6 = 70.0 , propAnim = true },
	{ nome = "capo" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "imp_prop_impexp_bonnet_03a" , andar = true , loop = true , flag = 49 , hand = 28422 , pos1 = 0.2 , pos2 = 0.2 , pos3 = -0.1 , pos4 = 0.0 , pos5 = 0.0 , pos6 = 180.0 , propAnim = true },
	{ nome = "porta" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "imp_prop_impexp_car_door_04a" , andar = true , loop = true , flag = 49 , hand = 28422 , pos1 = -0.5 , pos2 = -0.15 , pos3 = -0.1 , pos4 = 0.0 , pos5 = 0.0 , pos6 = 90.0 , propAnim = true },
	{ nome = "parachoque" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "imp_prop_impexp_front_bumper_02a" , andar = true , loop = true , flag = 49 , hand = 28422 , pos1 = 0.0 , pos2 = 0.1 , pos3 = 0.05 , pos4 = 0.0 , pos5 = 0.0 , pos6 = 0.0 , propAnim = true },
	{ nome = "megaphone" , dict = "anim@random@shop_clothes@watches" , anim = "base" , prop = "prop_megaphone_01" , andar = true , loop = true , flag = 49 , hand = 60309 , pos1 = 0.10 , pos2 = 0.04 , pos3 = 0.012 , pos4 = -60.0 , pos5 = 100.0 , pos6 = -30.0 , propAnim = true },
	{ nome = "casalm2" , dict = "timetable@trevor@ig_1" , anim = "ig_1_thedontknowwhy_trevor" , andar = false , loop = true },
    { nome = "casalf2" , dict = "timetable@trevor@ig_1" , anim = "ig_1_thedontknowwhy_patricia" , andar = false , loop = true },
    { nome = "casalm3" , dict = "timetable@trevor@ig_1" , anim = "ig_1_thedesertissobeautiful_trevor" , andar = false , loop = true },
	{ nome = "casalf3" , dict = "timetable@trevor@ig_1" , anim = "ig_1_thedesertissobeautiful_patricia" , andar = false , loop = true },
	{ nome = "wait" , dict = "random@shop_tattoo" , anim = "_idle_a" , andar = true , loop = true },
	{ nome = "wait2" , dict = "rcmnigel1cnmt_1c" , anim = "base" , andar = true , loop = true },
	{ nome = "wait3" , dict = "rcmjosh1", anim = "idle" , andar = true , loop = true },
	{ nome = "wait4" , dict = "timetable@amanda@ig_3" , anim = "ig_3_base_tracy" , andar = true , loop = true },
	{ nome = "wait5" , dict = "misshair_shop@hair_dressers" , anim = "keeper_base" , andar = true , loop = true },
	{ nome = "blowkiss", dict = "anim@mp_player_intcelebrationfemale@blow_kiss" , anim = "blow_kiss" , andar = true , loop = true },


	{ nome = "crossarms" , dict = "random@street_race", anim = "_car_b_lookout" , andar = true , loop = true },
	{ nome = "crossarms2" , dict = "anim@amb@nightclub@peds@", anim = "rcmme_amanda1_stand_loop_cop" , andar = true , loop = true },
	{ nome = "knucklecrunch" , dict = "anim@mp_player_intcelebrationfemale@knuckle_crunch", anim = "knuckle_crunch" , andar = true , loop = false },
	{ nome = "leanside" , dict = "misscarstealfinalecar_5_ig_1", anim = "waitloop_lamar" , andar = true , loop = true },
	{ nome = "no2" , dict = "anim@heists@ornate_bank@chat_manager", anim = "fail" , andar = true , loop = false },
	{ nome = "screwyou" , dict = "misscommon@response", anim = "screw_you" , andar = true , loop = false },
	{ nome = "wave" , dict = "random@mugging5", anim = "001445_01_gangintimidation_1_female_idle_b" , andar = true , loop = true },
	{ nome = "wave2" , dict = "friends@fra@ig_1", anim = "over_here_idle_a" , andar = true , loop = true },
	{ nome = "wave3" , dict = "friends@frj@ig_1", anim = "wave_e" , andar = true , loop = true },
	{ nome = "gangsign" , dict = "mp_player_int_uppergang_sign_a", anim = "mp_player_int_gang_sign_a" , andar = true , loop = true },
	{ nome = "gangsign2" , dict = "mp_player_int_uppergang_sign_b", anim = "mp_player_int_gang_sign_b" , andar = true , loop = true },
	{ nome = "flipoff" , dict = "anim@arena@celeb@podium@no_prop@", anim = "flip_off_c_1st" , andar = true , loop = true },
	{ nome = "bow" , dict = "anim@arena@celeb@podium@no_prop@", anim = "regal_c_1st" , andar = true , loop = false },
	{ nome = "headbutt" , dict = "melee@unarmed@streamed_variations", anim = "plyr_takedown_front_headbutt" , andar = true , loop = false },
	{ nome = "cough" , dict = "timetable@gardener@smoking_joint", anim = "idle_cough" , andar = true , loop = true },
	{ nome = "stretch" , dict = "mini@triathlon", anim = "idle_f" , andar = true , loop = true },
	{ nome = "punching" , dict = "rcmextreme2", anim = "loop_punching" , andar = true , loop = true },
	{ nome = "mindcontrol" , dict = "rcmbarry", anim = "bar_1_attack_idle_aln" , andar = true , loop = true },
	{ nome = "ajoelhar2" , dict = "amb@medic@standing@kneel@idle_a" , anim = "idle_c" , andar = false , loop = true },
	{ nome = "arrumar2" , dict = "misstrevor3" , anim = "brokendown_wrongwithyou" , andar = false , loop = true },
	{ nome = "bandeja" , dict = "anim@heists@box_carry@" , anim = "idle" , prop = "prop_food_tray_01" , flag = 50 , hand = 60309 },
	{ nome = "cruzarbraco" , dict = "anim@amb@casino@peds@" , anim = "amb_world_human_hang_out_street_male_c_base" , andar = false , loop = true },
	{ nome = "deitar9" , dict = "amb@world_human_sunbathe@female@front@idle_a" , anim = "idle_c" , andar = false , loop = true },
	{ nome = "digitar2" , dict = "anim@heists@fleeca_bank@scope_out@cashier_loop" , anim = "cashier_loop" , andar = false , loop = true },
	{ nome = "dj3" , dict = "anim@mp_player_intcelebrationmale@dj" , anim = "dj" , andar = false , loop = false },
	{ nome = "dj4" , dict = "anim@mp_player_intcelebrationfemale@dj" , anim = "dj" , andar = false , loop = false },
	{ nome = "discutir" , dict = "oddjobs@assassinate@vice@hooker" , anim = "argue_a" , andar = true , loop = true },
	{ nome = "dor" , dict = "combat@damage@injured_pistol@to_writhe" , anim = "variation_b" , andar = false , loop = false },
	{ nome = "dor2" , dict = "combat@damage@writheidle_a" , anim = "writhe_idle_a" , andar = false , loop = true },
	{ nome = "encostar13" , dict = "amb@world_human_leaning@male@wall@back@foot_up@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "escorar" , dict = "anim@heists@prison_heist" , anim = "ped_b_react" , andar = false , loop = true },
	{ nome = "escorar2" , dict = "anim@mp_ferris_wheel" , anim = "idle_a_playet_two" , andar = false , loop = true },
	{ nome = "escorar3" , dict = "rcmnigel1aig_1" , anim = "base_02_willie" , andar = false , loop = true },
	{ nome = "escorar4" , dict = "anim@amb@business@bgen@bgen_no_work@" , anim = "stand_phone_lookaround_nowork" , andar = false , loop = true },
	{ nome = "esperar" , dict = "amb@world_human_hang_out_street@female_arms_crossed@base" , anim = "base" , andar = false , loop = true },
	{ nome = "esperar2" , dict = "amb@world_human_hang_out_street@female_arm_side@base" , anim = "base" , andar = false , loop = true },
	{ nome = "esperar3" , dict = "switch@michael@parkbench_smoke_ranger" , anim = "ranger_nervous_loop" , andar = false , loop = true },
	{ nome = "esperar4" , dict = "oddjobs@assassinate@guard" , anim = "unarmed_fold_arms" , andar = false , loop = true },
	{ nome = "esperar5" , dict = "anim@amb@casino@hangout@ped_female@stand@01a@idles" , anim = "idle_d" , andar = false , loop = true },
	{ nome = "espreguicar" , dict = "amb@world_human_muscle_flex@arms_at_side@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "gravata" , dict = "clothingtie" , anim = "outro" , andar = false , loop = false },
	{ nome = "gravatab" , dict = "clothingtie" , anim = "try_tie_positive_b" , andar = false , loop = false },
	{ nome = "joia3" , dict = "anim@mp_player_intcelebrationmale@thumbs_up" , anim = "thumbs_up" , andar = false , loop = false },
	{ nome = "mapa2" , dict = "amb@world_human_tourist_map@male@base" , anim = "base" , prop = "prop_tourist_map_01" , flag = 50 , hand = 28422 },
	{ nome = "massagem" , dict = "missheistdocks2aleadinoutlsdh_2a_int" , anim = "massage_loop_2_floyd" , andar = false , loop = true },
	{ nome = "massagem2" , dict = "missheistdocks2aleadinoutlsdh_2a_int" , anim = "massage_loop_2_trevor" , andar = false , loop = true },
	{ nome = "massagemperna" , dict = "missheistdocks2bleadinoutlsdh_2b_int" , anim = "leg_massage_b_floyd" , andar = false , loop = true },
	{ nome = "massagemperna2" , dict = "missheistdocks2bleadinoutlsdh_2b_int" , anim = "leg_massage_b_trevor" , andar = false , loop = true },
	{ nome = "obito" , dict = "mini@cpr@char_a@cpr_str" , anim = "cpr_fail" , andar = false , loop = true },
	{ nome = "palmas7" , dict = "anim@mp_player_intincarslow_clapbodhi@ds@" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "peace3" , dict = "anim@mp_player_intcelebrationfemale@peace" , anim = "peace" , andar = true , loop = false },
	{ nome = "peace4" , dict = "anim@mp_player_intincarpeacebodhi@ds@" , anim = "idle_a" , andar = true , loop = true },
	{ nome = "pisar" , dict = "missfbi4leadinoutfbi_4_int" , anim = "agents_idle_b_andreas" , andar = false , loop = true },
	{ nome = "podevir" , dict = "timetable@lamar@ig_4" , anim = "nothing_to_see_here_stretch" , andar = false , loop = true },
	{ nome = "postura3" , dict = "rcmpaparazzo_3big_1" , anim = "_action_guard_a" , andar = false , loop = true },
	{ nome = "procurar2" , dict = "anim@miss@low@fin@lamar@" , anim = "idle" , andar = false , loop = true },
	{ nome = "sms" , dict = "amb@world_human_leaning@female@wall@back@texting@base" , anim = "base" , prop = "prop_amb_phone", flag = 50 , hand = 28422 },
	{ nome = "sexy" , dict = "amb@world_human_prostitute@cokehead@base" , anim = "base" , andar = false , loop = true },
	{ nome = "sexy2" , dict = "amb@world_human_prostitute@cokehead@idle_a" , anim = "idle_b" , andar = false , loop = true },
	{ nome = "sexy3" , dict = "amb@world_human_prostitute@french@base" , anim = "base" , andar = false , loop = true },  
	{ nome = "sexy4" , dict = "amb@world_human_prostitute@hooker@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "tocaai" , dict = "mp_ped_interaction" , anim = "handshake_guy_b" , andar = false , loop = true },
	{ nome = "tossir" , dict = "timetable@gardener@smoking_joint" , anim = "idle_cough" , andar = true , loop = false },
	{ nome = "trotar" , dict = "amb@world_human_jog_standing@male@fitidle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "trotar2" , dict = "amb@world_human_jog_standing@female@idle_a" , anim = "idle_a" , andar = false , loop = true },
	{ nome = "verificar2" , dict = "amb@code_human_police_investigate@idle_b" , anim = "idle_f" , andar = false , loop = true },
	{ nome = "verificar3" , dict = "amb@code_human_police_investigate@idle_b" , anim = "idle_e" , andar = false , loop = true },
	{ nome = "verificar4" , dict = "amb@world_human_guard_patrol@male@idle_b" , anim = "idle_e" , andar = false , loop = true },
	{ nome = "yoga3" , dict = "amb@world_human_yoga@female@base" , anim = "base_b" , andar = false , loop = true },
	{ nome = "yoga4" , dict = "amb@world_human_yoga@female@base" , anim = "base_c" , andar = false , loop = true },

	{ nome = "roguepose" , dict = "holdhip@animation" , anim = "holdhip_clip" , andar = false , loop = true },
	{ nome = "roguepose2" , dict = "holdhipb@animation" , anim = "holdhipb_clip" , andar = false , loop = true },
	{ nome = "roguepose3" , dict = "holdass@animation" , anim = "holdass_clip" , andar = false , loop = true },
	{ nome = "roguepose4" , dict = "holdassb@animation" , anim = "holdassb_clip" , andar = false , loop = true },
	{ nome = "roguepose5" , dict = "coupleseat1@animation" , anim = "coupleseat1_clip" , andar = false , loop = true },
	{ nome = "roguepose6" , dict = "coupleseat1b@animation" , anim = "coupleseat1b_clip" , andar = false , loop = true },
	{ nome = "roguepose7" , dict = "mx@couplemale" , anim = "clipcouple_male" , andar = false , loop = true },
	{ nome = "roguepose8" , dict = "mx@couplefemale" , anim = "clipcouple_female" , andar = false , loop = true },
	{ nome = "roguepose9" , dict = "karxem@couple_f" , anim = "karxem_couple_f_clip" , andar = false , loop = true },
	{ nome = "roguepose10" , dict = "karxem@couple_m" , anim = "karxem_couple_m_clip" , andar = false , loop = true },
	{ nome = "roguepose11" , dict = "karxem@couple2_f" , anim = "karxem_coupel2_f_clip" , andar = false , loop = true },
	{ nome = "roguepose12" , dict = "karxem@couple2_m" , anim = "karxem_couple2_m_clip" , andar = false , loop = true },
	{ nome = "roguepose13" , dict = "karxem@karxem@couple3_f" , anim = "karxem_couple3_f_clip" , andar = false , loop = true },
	{ nome = "roguepose14" , dict = "karxem@couple3_m" , anim = "karxem_couple3_m_clip" , andar = false , loop = true },
	{ nome = "roguepose15" , dict = "mx@piggypack_a" , anim = "mxclip_a" , andar = false , loop = true },
	{ nome = "roguepose16" , dict = "mx@piggypack_b" , anim = "mxanim_b" , andar = false , loop = true },
	{ nome = "roguepose17" , dict = "mx@couple1_a" , anim = "mx@couple1_a_clip" , andar = false , loop = true },
	{ nome = "roguepose18" , dict = "mx@couple1_b" , anim = "mx@couple1_b_clip" , andar = false , loop = true },
	{ nome = "roguepose19" , dict = "mx@couple2_a" , anim = "mx@couple2_clip" , andar = false , loop = true },
	{ nome = "roguepose20" , dict = "mx@couple2_b" , anim = "mx@couple2b_clip" , andar = false , loop = true },
	{ nome = "roguepose21" , dict = "mx@couple3_a" , anim = "mx@couple3_a_clip" , andar = false , loop = true },
	{ nome = "roguepose22" , dict = "mx@couple3_b" , anim = "mx@couple3_b_clip" , andar = false , loop = true },
	{ nome = "roguepose23" , dict = "mx@couplephone_m" , anim = "mx@couplephone_m_clip" , andar = false , loop = true },
	{ nome = "roguepose24" , dict = "mx@couplephone_f" , anim = "mx@couplephone_f_clip" , andar = false , loop = true },
	{ nome = "roguepose25" , dict = "instagrampose@seimen" , anim = "instagrampose_clip" , andar = false , loop = true },
	{ nome = "roguepose26" , dict = "instagrampose2@seimen" , anim = "instagrampose2_clip" , andar = false , loop = true },
	{ nome = "roguepose27" , dict = "instagrampose3@seimen" , anim = "instagrampose3_clip" , andar = false , loop = true },
	{ nome = "roguepose28" , dict = "instagrampose4@seimen" , anim = "instagrampose4_clip" , andar = false , loop = true },
	{ nome = "roguepose29" , dict = "instagrampose5@seimen" , anim = "instagrampose5_clip" , andar = false , loop = true },
	{ nome = "roguepose30" , dict = "instagrampose6@seimen" , anim = "instagrampose6_clip" , andar = false , loop = true },
	{ nome = "roguepose31" , dict = "instagrampose7@seimen" , anim = "instagrampose7_clip" , andar = false , loop = true },
	{ nome = "roguepose32" , dict = "instagrampose8@seimen" , anim = "instagrampose8_clip" , andar = false , loop = true },
	{ nome = "roguepose33" , dict = "instagrampose9@seimen" , anim = "instagrampose9_clip" , andar = false , loop = true },
	{ nome = "roguepose34" , dict = "anim@model_car_fancy" , anim = "car_fancy_clip" , andar = false , loop = true },
	{ nome = "roguepose35" , dict = "anim@model_stretched_leg" , anim = "stretched_leg_clip" , andar = false , loop = true },
	{ nome = "roguepose36" , dict = "anim@car_sitting_fuckyou" , anim = "sitting_fuckyou_clip" , andar = false , loop = true },
	{ nome = "roguepose37" , dict = "anim@car_sitting_cute" , anim = "sitting_cute_clip" , andar = false , loop = true },
	{ nome = "roguepose38" , dict = "anim@model_bike" , anim = "bike_clip" , andar = false , loop = true },
	{ nome = "roguepose39" , dict = "anim@model_bike_two" , anim = "bike_two_clip" , andar = false , loop = true },
	{ nome = "roguepose40" , dict = "anim@peace_selfie" , anim = "peace_clip" , andar = false , loop = true },
	{ nome = "roguepose41" , dict = "anim@stance_folded_arms" , anim = "folded_arms_clip" , andar = false , loop = true },
	{ nome = "roguepose42" , dict = "anim@stance_kneeling_cute" , anim = "kneeling_cute_clip" , andar = false , loop = true },
	{ nome = "roguepose43" , dict = "anim@sit_cute_window" , anim = "cute_window_clip" , andar = false , loop = true },
	{ nome = "roguepose44" , dict = "anim@car_cute_sit" , anim = "cute_sit_clip" , andar = false , loop = true },
	{ nome = "roguepose45" , dict = "anim@selfie_peacesign_cute" , anim = "peacesign_cute_clip" , andar = false , loop = true },
	{ nome = "roguepose46" , dict = "anim@hoodrat_pistol_selfie" , anim = "selfie_clip" , andar = false , loop = true },
	{ nome = "roguepose47" , dict = "anim@kneeling_stare" , anim = "kneeling_stare_clip" , andar = false , loop = true },
	{ nome = "roguepose48" , dict = "anim@model_cute" , anim = "model_cute_clip" , andar = false , loop = true },
	{ nome = "roguepose49" , dict = "anim@model_wall_cute" , anim = "wall_cute_clip" , andar = false , loop = true },
	{ nome = "roguepose50" , dict = "anim@selfie_floor_cute" , anim = "floor_cute_clip" , andar = false , loop = true },
	{ nome = "roguepose51" , dict = "anim@sitting_thot" , anim = "sitting_thot_clip" , andar = false , loop = true },
	{ nome = "roguepose52" , dict = "mirrorselfie1@animation" , anim = "mirrorselfie1_clip" , andar = false , loop = true },
	{ nome = "roguepose53" , dict = "mirrorselfie2@animation" , anim = "mirrorselfie2_clip" , andar = false , loop = true },
	{ nome = "roguepose54" , dict = "mirrorselfie3@animation" , anim = "mirrorselfie3_clip" , andar = false , loop = true },
	{ nome = "roguepose55" , dict = "mirrorselfie4@animation" , anim = "mirrorselfie4_clip" , andar = false , loop = true },
	{ nome = "roguepose56" , dict = "mirrorselfie5@animation" , anim = "mirrorselfie5_clip" , andar = false , loop = true },
	{ nome = "roguepose57" , dict = "lunyx@random@v3@pose001", anim = "random@v3@pose001" , andar = true , loop = true },
	{ nome = "roguepose58" , dict = "lunyx@random@v3@pose002", anim = "random@v3@pose002" , andar = true , loop = true },
	{ nome = "roguepose59" , dict = "lunyx@random@v3@pose003", anim = "random@v3@pose003" , andar = false , loop = true },
	{ nome = "roguepose60" , dict = "lunyx@random@v3@pose004", anim = "random@v3@pose004" , andar = false , loop = true },
	{ nome = "roguepose61" , dict = "lunyx@random@v3@pose005", anim = "random@v3@pose005" , andar = false , loop = true },
	{ nome = "roguepose62" , dict = "lunyx@random@v3@pose006", anim = "random@v3@pose006" , andar = true , loop = true },
	{ nome = "roguepose63" , dict = "lunyx@random@v3@pose007", anim = "random@v3@pose007" , andar = true , loop = true },
	{ nome = "roguepose64" , dict = "lunyx@random@v3@pose008", anim = "random@v3@pose008" , andar = true , loop = true },
	{ nome = "roguepose65" , dict = "lunyx@random@v3@pose009", anim = "random@v3@pose009" , andar = true , loop = true },
	{ nome = "roguepose66" , dict = "lunyx@random@v3@pose010", anim = "random@v3@pose010" , andar = true , loop = true },
	{ nome = "roguepose67" , dict = "lunyx@random@v3@pose011", anim = "random@v3@pose011" , andar = true , loop = true },
	{ nome = "roguepose68" , dict = "lunyx@random@v3@pose012", anim = "random@v3@pose012" , andar = true , loop = true },
	{ nome = "roguepose69" , dict = "lunyx@random@v3@pose013", anim = "random@v3@pose013" , andar = true , loop = true },
	{ nome = "roguepose70" , dict = "lunyx@random@v3@pose014", anim = "random@v3@pose014" , andar = true , loop = true },
	{ nome = "roguepose71" , dict = "lunyx@random@v3@pose015", anim = "random@v3@pose015" , andar = true , loop = true },
	{ nome = "roguepose72" , dict = "lunyx@random@v3@pose016", anim = "random@v3@pose016" , andar = false , loop = true },
	{ nome = "roguepose73" , dict = "lunyx@random@v3@pose017", anim = "random@v3@pose017" , andar = true , loop = true },
	{ nome = "roguepose74" , dict = "lunyx@random@v3@pose018", anim = "random@v3@pose018" , andar = true , loop = true },
	{ nome = "roguepose75" , dict = "lunyx@random@v3@pose019", anim = "random@v3@pose019" , andar = true , loop = true },
	{ nome = "roguepose76" , dict = "lunyx@random@v3@pose020", anim = "random@v3@pose020" , andar = false , loop = true },


	{ nome = "tryclothes", dict = "mp_clothing@female@trousers", anim = "try_trousers_neutral_a", andar = false, loop = false },
	{ nome = "tryclothes2", dict = "mp_clothing@female@shirt", anim = "try_shirt_positive_a", andar = false, loop = false },
	{ nome = "tryclothes3", dict = "mp_clothing@female@shoes", anim = "try_shoes_positive_a", andar = false, loop = false },
	{ nome = "tryclothes4", dict = "clothingtie", anim = "try_tie_neutral_c", andar = false, loop = false },
	{ nome = "tryclothes5", dict = "clothingtie", anim = "try_tie_neutral_d", andar = false, loop = false },

	{ nome = "esperar", dict = "random@shop_tattoo", anim = "_idle_a", andar = true, loop = true },
	{ nome = "esperar2", dict = "rcmnigel1cnmt_1c", anim = "base", andar = true, loop = true },
	{ nome = "esperar3", dict = "rcmjosh1", anim = "idle", andar = true, loop = true },
	{ nome = "esperar4", dict = "timetable@amanda@ig_3", anim = "ig_3_base_tracy", andar = true, loop = true },
	{ nome = "esperar5", dict = "misshair_shop@hair_dressers", anim = "keeper_base", andar = true, loop = true },
	{ nome = "esperar6", dict = "jh_1_ig_3-2", anim = "cs_jewelass_dual-2", andar = true, loop = true },






	{ nome = "cowgirl" , dict = "cuddlepartner1@pawuk" , anim = "cuddlepartner1_clip" , andar = false , loop = true },
	{ nome = "cowgirl2" , dict = "cuddlepartner2@pawuk" , anim = "cuddlepartner2_clip" , andar = false , loop = true },
}

RegisterNetEvent('emotes')
AddEventHandler('emotes',function(nome)
	local ped = PlayerPedId()
	if GetEntityHealth(ped) > 101 then
		if not vRP.getHandcuff() then
			vRP.removeObjects("one")
			for _,emote in pairs(animacoes) do
				if not IsPedInAnyVehicle(ped) and not emote.carros then
					if nome == emote.nome then
						if emote.extra then emote.extra() end
						if emote.propAnim then 
							vRP.createObjects(emote.dict,emote.anim,emote.prop,emote.flag,emote.hand,emote.pos1,emote.pos2,emote.pos3,emote.pos4,emote.pos5,emote.pos6)
						elseif emote.pos1 then
							vRP.createObjects("","",emote.prop,emote.flag,emote.hand,emote.pos1,emote.pos2,emote.pos3,emote.pos4,emote.pos5,emote.pos6)
						elseif emote.prop then
							vRP.createObjects(emote.dict,emote.anim,emote.prop,emote.flag,emote.hand)
						elseif emote.dict then
							vRP._playAnim(emote.andar,{emote.dict,emote.anim},emote.loop)
						else
							vRP._playAnim(false,{task=emote.anim},false)
						end
					end
				else
					if IsPedInAnyVehicle(ped) and emote.carros then
						local vehicle = GetVehiclePedIsIn(ped,false)
						if nome == emote.nome then
							if (GetPedInVehicleSeat(vehicle,-1) == ped or GetPedInVehicleSeat(vehicle,1) == ped) and emote.nome == "sexo4" then
								vRP._playAnim(emote.andar,{emote.dict,emote.anim},emote.loop)
							elseif (GetPedInVehicleSeat(vehicle,0) == ped or GetPedInVehicleSeat(vehicle,2) == ped) and (emote.nome == "sexo5" or emote.nome == "sexo6") then
								vRP._playAnim(emote.andar,{emote.dict,emote.anim},emote.loop)
							end
						end
					end
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCED ANIMATIONS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent('syncAnim')
AddEventHandler('syncAnim',function(pos)
	local ped = PlayerPedId()
 	local pedInFront = GetPlayerPed(GetClosestPlayer())
    local heading = GetEntityHeading(pedInFront)
    local coords = GetOffsetFromEntityInWorldCoords(pedInFront,0.0,pos,0.0)
    SetEntityHeading(ped,heading-180.1)
    SetEntityCoordsNoOffset(ped,coords.x,coords.y,coords.z,0)
end)

RegisterNetEvent('syncAnim2')
AddEventHandler('syncAnim2',function(pos1,pos2,pos3)
	local ped = PlayerPedId()
 	local pedInFront = GetPlayerPed(GetClosestPlayer())
    local heading = GetEntityHeading(pedInFront)
    local coords = GetOffsetFromEntityInWorldCoords(pedInFront,pos1,pos2,pos3)
    SetEntityHeading(ped,heading-360.1)
    SetEntityCoordsNoOffset(ped,coords.x,coords.y,coords.z,0)
end)

RegisterNetEvent('syncAnimAll')
AddEventHandler('syncAnimAll',function(status,person)
	vRP.removeObjects()
	if status == "beijar" then
		vRP._playAnim(false,{"mp_ped_interaction","kisses_guy_a"},false)
	elseif status == "abracar" then
		vRP._playAnim(false,{"mp_ped_interaction","hugs_guy_a"},false)
	elseif status == "abracar2" then
		vRP._playAnim(false,{"mp_ped_interaction","kisses_guy_b"},false)
	elseif status == "abracar3" then
		vRP._playAnim(false,{"mp_ped_interaction","handshake_guy_a"},false)
	elseif status == "abracar4" then
		vRP._playAnim(false,{"mp_ped_interaction","handshake_guy_b"},false)
	elseif status == "dancar257" then
		vRP._playAnim(false,{"anim@amb@nightclub@lazlow@hi_railing@","ambclub_13_mi_hi_sexualgriding_laz"},false)
		vRP.createObjects("","","ba_prop_battle_glowstick_01",49,28422,0.0700,0.1400,0.0,-80.0,20.0)
		vRP.createObjects2("","","ba_prop_battle_glowstick_01",49,60309,0.0700,0.0900,0.0,-120.0,-20.0)
	elseif status == "dancar258" then
		vRP._playAnim(false,{"anim@amb@nightclub@lazlow@hi_railing@","ambclub_12_mi_hi_bootyshake_laz"},false)
		vRP.createObjects("","","ba_prop_battle_glowstick_01",49,28422,0.0700,0.1400,0.0,-80.0,20.0)
		vRP.createObjects2("","","ba_prop_battle_glowstick_01",49,60309,0.0700,0.0900,0.0,-120.0,-20.0)
	elseif status == "dancar259" then
		vRP._playAnim(false,{"anim@amb@nightclub@lazlow@hi_dancefloor@","crowddance_hi_11_handup_laz"},false)
		vRP.createObjects("","","ba_prop_battle_hobby_horse",49,28422,0.0,0.0,0.0,0.0,0.0,0.0)
	elseif status == "casal" then
		if person == 1 then
			vRP._playAnim(false,{"misscarsteal2chad_goodbye","chad_armsaround_girl"},true)
		elseif person == 2 then
			vRP._playAnim(false,{"misscarsteal2chad_goodbye","chad_armsaround_chad"},true)
		end
	elseif status == "casal2" then
		if person == 1 then
			vRP._playAnim(false,{"timetable@trevor@ig_1","ig_1_thedontknowwhy_patricia"},true)
		elseif person == 2 then
			vRP._playAnim(false,{"timetable@trevor@ig_1","ig_1_thedontknowwhy_trevor"},true)
		end
	elseif status == "casal3" then
		if person == 1 then
			vRP._playAnim(false,{"timetable@trevor@ig_1","ig_1_thedesertissobeautiful_patricia"},true)
		elseif person == 2 then
			vRP._playAnim(false,{"timetable@trevor@ig_1","ig_1_thedesertissobeautiful_trevor"},true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SYNCED PARTICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("startSyncParticle")
AddEventHandler("startSyncParticle",function(asset,index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToPed(index)
		if DoesEntityExist(v) then
			if asset == "champagne" then
				vRP.PtfxThis("scr_ba_club")
				StartParticleFxLoopedOnPedBone("scr_ba_club_champagne_spray",v,0.0,0.4,0.2,-50.0,0.0,0.0,GetPedBoneIndex(v,11816),2.0,false,false,false)
			elseif asset == "money" then
				vRP.PtfxThis("scr_xs_celebration")
				StartParticleFxLoopedOnPedBone("scr_xs_money_rain",v,0.0,0.4,0.6,-50.0,0.0,0.0,GetPedBoneIndex(v,11816),1.0,false,false,false)
			elseif asset == "peeing" then
				vRP.PtfxThis("core")
				StartParticleFxLoopedOnPedBone("ent_amb_peeing",v,0.0,0.35,-0.15,-140.0,0.0,0.0,GetPedBoneIndex(v,11816),2.5,false,false,false)
			elseif asset == "poo" then
				vRP.PtfxThis("scr_amb_chop")
				StartParticleFxLoopedOnPedBone("ent_anim_dog_poo",v,0.0,0.0,-0.6,0.0,0.0,20.0,GetPedBoneIndex(v,11816),2.0,false,false,false)
				StartParticleFxLoopedOnPedBone("ent_anim_dog_poo",v,0.0,0.0,-0.6,0.0,0.0,20.0,GetPedBoneIndex(v,11816),2.0,false,false,false)
			elseif asset == "noclip" then
				vRP.PtfxThis("scr_rcbarry2")
				StartParticleFxLoopedOnPedBone("scr_clown_death",v,0.0,0.0,-0.6,0.0,0.0,20.0,GetPedBoneIndex(v,11816),2.0,false,false,false)
			end
		end
	end
end)

RegisterNetEvent("stopSyncParticle")
AddEventHandler("stopSyncParticle",function(index)
	if NetworkDoesNetworkIdExist(index) then
		local v = NetToPed(index)
		if DoesEntityExist(v) then
			RemoveParticleFxFromEntity(v)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADBINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while true do
		local timeDistance = 999
		if (binoculos or cameras) then
			timeDistance = 1

			local ped = PlayerPedId()
			local scaleform = RequestScaleformMovie("BINOCULARS")
			while not HasScaleformMovieLoaded(scaleform) do
				Citizen.Wait(1)
			end

			local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA",true)
			AttachCamToEntity(cam,ped,0.0,0.0,1.0,true)
			SetCamRot(cam,0.0,0.0,GetEntityHeading(ped))
			SetCamFov(cam,fov)
			RenderScriptCams(true,false,0,1,0)

			while (binoculos or cameras) and true do
				Citizen.Wait(1)

				local zoomvalue = (1.0 / (fov_max - fov_min)) * (fov - fov_min)
				CheckInputRotation(cam,zoomvalue)
				HandleZoom(cam)

				if binoculos then
					DrawScaleformMovieFullscreen(scaleform,255,255,255,255)
				end

				if IsPedArmed(PlayerPedId(),6) then
					TriggerServerEvent("inventory:Cancel")
					binoculos = false
					cameras = false
				end
			end

			fov = (fov_max + fov_min) * 0.5
			RenderScriptCams(false,false,0,1,0)
			SetScaleformMovieAsNoLongerNeeded(scaleform)
			DestroyCam(cam,false)
			SetNightvision(false)
			SetSeethrough(false)
		end

		Citizen.Wait(timeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEBINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("useBinoculos")
AddEventHandler("useBinoculos",function()
	binoculos = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- USEBINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("useCamera")
AddEventHandler("useCamera",function()
	cameras = true
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("binoculos")
AddEventHandler("binoculos",function()
	if IsEntityPlayingAnim(PlayerPedId(),"amb@world_human_binoculars@male@enter","enter",3) then
		binoculos = true
	else
		binoculos = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BINOCULOS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("camera")
AddEventHandler("camera",function()
	if IsEntityPlayingAnim(PlayerPedId(),"amb@world_human_paparazzi@male@base","base",3) then
		cameras = true
	else
		cameras = false
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKINPUTROTATION
-----------------------------------------------------------------------------------------------------------------------------------------
function CheckInputRotation(cam,zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0,220)
	local rightAxisY = GetDisabledControlNormal(0,221)
	local rotation = GetCamRot(cam,2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z+rightAxisX*-1.0*(8.0)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0,rotation.x+rightAxisY*-1.0*(8.0)*(zoomvalue+0.1)),-89.5)
		SetCamRot(cam,new_x,0.0,new_z,2)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- HANDLEZOOM
-----------------------------------------------------------------------------------------------------------------------------------------
function HandleZoom(cam)
	if IsControlJustPressed(1,241) then
		fov = math.max(fov-10.0,fov_min)
	end

	if IsControlJustPressed(1,242) then
		fov = math.min(fov+10.0,fov_max)
	end

	local current_fov = GetCamFov(cam)
	if math.abs(fov-current_fov) < 0.1 then
		fov = current_fov
	end
	SetCamFov(cam,current_fov+(fov-current_fov)*0.05)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETCLOSESTPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function GetClosestPlayer()
    local players = GetPlayers()
    local closestDistance = -1
    local closestPlayer = -1
    local ply = PlayerPedId()
    local plyCoords = GetEntityCoords(ply,0)
    for index,value in ipairs(players) do
        local target = GetPlayerPed(value)
        if (target ~= ply) then
            local targetCoords = GetEntityCoords(GetPlayerPed(value),0)
            local distance = GetDistanceBetweenCoords(targetCoords["x"],targetCoords["y"],targetCoords["z"],plyCoords["x"],plyCoords["y"],plyCoords["z"],true)
            if (closestDistance == -1 or closestDistance > distance) then
                closestPlayer = value
                closestDistance = distance
            end
        end
    end
    return closestPlayer,closestDistance
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETPLAYER
-----------------------------------------------------------------------------------------------------------------------------------------
function GetPlayers()
    local players = {}
    for i = 0, 256 do
        if NetworkIsPlayerActive(i) then
            table.insert(players,i)
        end
    end
    return players
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BREAKING
-----------------------------------------------------------------------------------------------------------------------------------------
function Breaking(text)
	SetTextColour(255,255,255,255)
	SetTextFont(8)
	SetTextScale(1.2,1.2)
	SetTextWrap(0.0,1.0)
	SetTextCentre(false)
	SetTextDropshadow(0,0,0,0,255)
	SetTextEdge(1,0,0,0,205)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(0.2,0.85)
end