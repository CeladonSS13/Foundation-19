//SSticker.forced_end = TRUE

// VARS
/obj/machinery/nuclearbomb/station
	self_destruct_cutoff = 30 //Seconds 60
	timeleft = 100 // 300
	minTime = 100 // 300
	maxTime = 100 // 900

// OVERRIDES
/obj/machinery/nuclearbomb/station/start_bomb()
	for(var/inserter in inserters)
		var/obj/machinery/self_destruct/sd = inserter
		if(!istype(sd) || !sd.armed)
			to_chat(usr, SPAN_WARNING("An inserter has not been armed or is damaged."))
			return
	visible_message(SPAN_WARNING("Warning. The self-destruct sequence override will be disabled [self_destruct_cutoff] seconds before detonation."))
	var/list/listeners = GLOB.player_list
	for(var/P in listeners)
		sound_to(P, WARHEAD_SOUND)
	timing = 1
	log_and_message_staff("activated the detonation countdown of \the [src]")
	bomb_set++ // There can still be issues with this resetting when there are multiple bombs. Not a big deal though for Nuke/N
	var/decl/security_state/security_state = decls_repository.get_decl(GLOB.using_map.security_state)
	if(security_state.set_security_level(security_state.destruction_security_level, TRUE)) //This would only be FALSE if the security level was already at destruction
		security_state.stored_security_level = security_state.current_security_level
	update_icon()

/obj/machinery/nuclearbomb/station/Process()
	..()
	if(timeleft > 0 && GAME_STATE < RUNLEVEL_POSTGAME)
		if(timeleft <= self_destruct_cutoff)
			if(!announced)
				priority_announcement.Announce("The self-destruct sequence has reached terminal countdown, abort systems have been disabled.", "Self-Destruct Control Computer")
				announced = 1
			if(world.time >= time_to_explosion)
				// Cinematic
				GLOB.cinematic.station_explosion_cinematic(0, gamemode_cache["extended"])
				// End Round
				SSticker.forced_end = TRUE
