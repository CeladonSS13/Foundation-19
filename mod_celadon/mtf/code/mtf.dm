// VARS

GLOBAL_VAR(ert_info)

// OVERRIDES

/client/proc/mtf_team()
	set name = "Dispatch MTF"
	set category = "Fun"
	set desc = "Send an MTF squad"

	if(!holder)
		to_chat(usr, SPAN_DANGER("Only administrators may use this command."))
		return
	if(GAME_STATE < RUNLEVEL_GAME)
		to_chat(usr, SPAN_DANGER("The game hasn't started yet!"))
		return
	if(send_emergency_team)
		to_chat(usr, SPAN_DANGER("[GLOB.using_map.boss_name] is already currently dispatching an MTF!"))
		return
	if(alert("Do you want to dispatch an MTF?",,"Yes","No") != "Yes")
		return

	var/datum/response_team_info/team_type = input("What type of MTF?", "MTF list") as null|anything in subtypesof(/datum/response_team_info)
	if(!team_type)
		return
	var/ert_count = input("How many people are in the squad?", "MTF count") as null|num
	if(!ert_count && ert_count > 0)
		return

	GLOB.ert.hard_cap = ert_count
	GLOB.ert_info = team_type

	// Opens the doors to the mtf armory
	for (var/obj/machinery/door/blast/shutters/B in SSmachines.machinery)
		if(team_type.id_tag == B.id_tag)
			B.open()

	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if(security_state.current_security_level_is_lower_than(security_state.severe_security_level)) // Allow admins to reconsider if the alert level is below High
		switch(alert("Current security level lower than [security_state.severe_security_level.name]. Do you still want to dispatch a response team?",,"Yes","No"))
			if("No")
				return

	var/reason = input("What is the reason for dispatching this MTF?", "Dispatching MTF")

	if(!reason && alert("You did not input a reason. Continue anyway?",,"Yes", "No") != "Yes")
		return

	if(send_emergency_team)
		to_chat(usr, SPAN_DANGER("Looks like someone beat you to it!"))
		return

	if(reason)
		message_staff("[key_name_admin(usr)] is dispatching an MTF [team_type.full_name] squad with [ert_count] members for the reason: [reason]", 1)
	else
		message_staff("[key_name_admin(usr)] is dispatching an MTF [team_type.full_name] squad with [ert_count] members.", 1)

	log_admin("[key_name(usr)] used Dispatch MTF.")
	trigger_armed_response_team_fix(reason)

// Pull dependence
/client/JoinResponseTeam()

	set name = "Join MTF Squad"
	set category = "OOC"

	if(!MayRespawn(1))
		to_chat(usr, SPAN_WARNING("You cannot join the response team at this time."))
		return

	if(isghost(usr) || isnewplayer(usr))
		if(!send_emergency_team)
			to_chat(usr, "No MTF is currently being sent.")
			return
		if(jobban_isbanned(usr, MODE_ERT) || jobban_isbanned(usr, "Security Officer"))
			to_chat(usr, SPAN_DANGER("You are jobbanned from the MTF!"))
			return
		if(GLOB.ert.current_antagonists.len >= GLOB.ert.hard_cap)
			to_chat(usr, "The MTF is already full!")
			return
		GLOB.ert.create_default(usr)
	else
		to_chat(usr, "You need to be an observer or new player to use this.")

// Ghost fix
/proc/trigger_armed_response_team_fix(reason = "")
	if(send_emergency_team)
		return

	command_announcement.Announce("It would appear that an MTF was requested for [station_name()]. We will prepare and send one as soon as possible.", "[GLOB.using_map.boss_name]")

	GLOB.ert.reason = reason //Set it even if it's blank to clear a reason from a previous ERT

	send_emergency_team = 1

	for (var/mob/observer/ghost/M in SSmobs.mob_list)
		if(alert(M, "Join MTF squad?",,"Yes","No") != "Yes")
			continue
		M.client.JoinResponseTeam()

	sleep(600 * 5)
	send_emergency_team = 0 // Can no longer join the ERT.

// Fix text
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

// Equip fix
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
