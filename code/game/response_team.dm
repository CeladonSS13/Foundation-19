//STRIKE TEAMS
//Thanks to Kilakk for the admin-button portion of this code.

var/global/send_emergency_team = 0 // Used for automagic response teams
								   // 'admin_emergency_team' for admin-spawned response teams

GLOBAL_VAR(ert_info)


/datum/response_team_info
	var/full_name = "Default" // Full MTF name with prefix
	var/short_name = "Default" // Short MTF name
	var/id_tag = "default" // BlastDoor tag

// Temporary location of response team information
/datum/response_team_info/epsilon11
	full_name = "Nine-Tailed Fox - Epsilon-11"
	short_name = "Epsilon-11"
	id_tag = "epislon11"
/datum/response_team_info/beta7
	full_name = "Maz Hatters - Beta-7"
	short_name = "Beta-7"
	id_tag = "beta7"
/datum/response_team_info/eta10
	full_name = "See No Evil - Eta-10"
	short_name = "Eta-10"
	id_tag = "eta10"
/datum/response_team_info/omega1
	full_name = "Law's Left Hand - Omega-1"
	short_name = "Omega-1"
	id_tag = "omega1"
/datum/response_team_info/alpha1
	full_name = "Red Right Hand - Alpha-1"
	short_name = "Alpha-1"
	id_tag = "alpha1"
/datum/response_team_info/epsilon9
	full_name = "Fire eaters - Epsilon-9"
	short_name = "Epsilon-9"
	id_tag = "epislon9"
/datum/response_team_info/nu7
	full_name = "Hammer Down - Nu-7"
	short_name = "Nu-7"
	id_tag = "Nu-7"


/client/proc/response_team()
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
	trigger_armed_response_team(reason)

/client/verb/JoinResponseTeam()

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

/proc/trigger_armed_response_team(reason = "")
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
