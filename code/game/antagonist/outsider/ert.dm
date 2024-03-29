GLOBAL_DATUM_INIT(ert, /datum/antagonist/ert, new)


/datum/antagonist/ert
	id = MODE_ERT
	role_text = "MTF Nine-Tailed Fox - Epsilon-11 Agent"
	role_text_plural = "MTF Nine-Tailed Fox - Epsilon-11 Agents"
	welcome_text = "As Agent of the Nine-Tailed Fox - Epsilon-11 taskforce, you only answer to your leader, nobody else."
	antag_text = "You are an <b>anti</b> antagonist! Within the rules, \
		try to save the site and its inhabitants from the ongoing crisis. \
		Try to make sure other players have <i>fun</i>! If you are confused or at a loss, always adminhelp, \
		and before taking extreme actions, please try to also contact the administration! \
		Think through your actions and make the roleplay immersive! <b>Please remember all \
		rules aside from those without explicit exceptions apply to the MTF.</b>"
	leader_welcome_text = "You shouldn't see this"
	landmark_id = "Response Team"
	id_type = /obj/item/card/id/mtf

	flags = ANTAG_OVERRIDE_JOB | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME | ANTAG_RANDOM_EXCEPTED
	antaghud_indicator = "hudloyalist"

	hard_cap = 5
	hard_cap_round = 7
	initial_spawn_req = 5
	initial_spawn_target = 7
	show_objectives_on_creation = 0 //we are not antagonists, we do not need the antagonist shpiel/objectives
	var/reason = ""

/datum/antagonist/ert/create_default(mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,45)

/datum/antagonist/ert/New()
	..()
	//	ert = src

/datum/antagonist/ert/greet(datum/mind/player)
	var/datum/response_team_info/team_info = GLOB.ert_info
	if (team_info.short_name == "Omega-1")
		leader_welcome_text = "As leader of Mobile Task Force [team_info.full_name], you answer only to the Ethics Committee, and have authority to override the Site staff where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the site staff where possible, however."
	else
		leader_welcome_text = "As leader of Mobile Task Force [team_info.full_name], you answer only to the O5 Council, and have authority to override the Site staff where it is necessary to achieve your mission goals. It is recommended that you attempt to cooperate with the site staff where possible, however."
	role_text = "MTF [team_info.full_name] Agent"
	role_text_plural = "MTF [team_info.short_name] Agents"
	welcome_text = "As Agent of the [team_info.full_name] taskforce, you only answer to your leader, nobody else."
	if(!..())
		return

	if (team_info.short_name == "Omega-1")
		to_chat(player.current, "The Mobile Task Force works for the Ethics Committee; your job is to contain loose SCPs and eliminate infiltrators. There is a code red alert at [station_name()], you are tasked to go and fix the problem.")
	else
		to_chat(player.current, "The Mobile Task Force works for the O5 Council; your job is to contain loose SCPs and eliminate infiltrators. There is a code red alert at [station_name()], you are tasked to go and fix the problem.")
	to_chat(player.current, "You should first gear up and discuss a plan with your team. More members may be joining, don't move out before you're ready.")

/datum/antagonist/ert/equip(mob/living/carbon/human/player)
	var/datum/response_team_info/team_info = GLOB.ert_info
	//Special radio setup
	player.add_language(LANGUAGE_ENGLISH)
	if (team_info.short_name == "Epsilon-11")
		player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert(src), slot_w_uniform)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/swat(src), slot_shoes)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/gloves/thick/swat(src), slot_gloves)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/head/helmet/mtftactical(player), slot_head)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/suit/armor/mtftactical(player), slot_wear_suit)
	else if (team_info.short_name == "Beta-7")
		player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert/beta7(src), slot_w_uniform)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/gloves/tactical/scp(src), slot_gloves)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/head/helmet/scp/beta(player), slot_head)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/suit/armor/vest/scp/medarmor/beta(player), slot_wear_suit)
	else if (team_info.short_name == "Nu-7")
		player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert/nu7(src), slot_w_uniform)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/combat(src), slot_shoes)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/gloves/thick/combat(src), slot_gloves)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/head/helmet/mtfheavy(player), slot_head)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/suit/armor/mtfheavy(player), slot_wear_suit)
	else if (team_info.short_name == "Alpha-1")
		player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert/alpha1(src), slot_w_uniform)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/combat(src), slot_shoes)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/gloves/tactical/alpha(src), slot_gloves)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/head/beret/mtf/alpha(player), slot_head)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/suit/armor/vest/scp/medarmor/alpha(player), slot_wear_suit)
	else if (team_info.short_name == "Omega-1")
		player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert/omega1(src), slot_w_uniform)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/combat(src), slot_shoes)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/gloves/thick/swat/lcz(src), slot_gloves)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/head/beret/mtf/omega(player), slot_head)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/suit/armor/vest/scp/medarmor/alpha(player), slot_wear_suit)
	else if (team_info.short_name == "Eta-10")
		player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert/eta10(src), slot_w_uniform)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/gloves/tactical/scp(src), slot_gloves)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/head/helmet/scp/eta(player), slot_head)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/suit/armor/vest/scp/medarmor/eta(player), slot_wear_suit)
	else if (team_info.short_name == "Epsilon-9")
		player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert/(src), slot_w_uniform)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)
		player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/gloves/tactical/scp(src), slot_gloves)

	create_id(role_text, player)
	return 1

