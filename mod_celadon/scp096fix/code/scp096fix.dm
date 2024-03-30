#define RADAR_OFF (1 << 0)
#define RADAR_ON (1 << 1)

#define STATE_096_IDLE		(1<<0)
#define STATE_096_SCREAMING	(1<<1)
#define STATE_096_CHASING	(1<<2)
#define STATE_096_SLAUGHTER	(1<<3)
#define STATE_096_STAGGERED	(1<<4)

// NEW VARS

/mob/living/scp096
	// Block pull
	mob_size = MOB_LARGE
	// Night Vision
	see_in_dark = 8
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	var/target_radar = RADAR_OFF

// OVERRIDE PROCS

/mob/living/scp096/UnarmedAttack(atom/A as obj|mob|turf)
	if(A in GLOB.SCP_list)
		return

	if(A == src || current_state != STATE_096_CHASING)
		return
	else if(isobj(A) || istype(A, /turf/simulated/wall))
		if(istype(A, /obj/machinery/door))
			OpenDoor(A)
			return
		else if (istype(A, /turf/simulated/wall))
			if(!do_after(src, 1.5, A)) // Wait time
				return
			visible_message(SPAN_DANGER("[src] destroy [A] trying to get at [target]!"))
			playsound(src, SFX_EXPLOSION, 45)
			A.melt()
		else if (ismachinery(A))
			if(!do_after(src, 0.5, A))
				return
			visible_message(SPAN_DANGER("[src] destroy [A] trying to get at [target]!"))
			playsound(src, SFX_EXPLOSION, 45)
			A.Destroy()
		else if (isstructure(A))
			if(!do_after(src, 1.0, A))
				return
			visible_message(SPAN_DANGER("[src] destroy [A] trying to get at [target]!"))
			playsound(src, SFX_EXPLOSION, 45)
			A.Destroy()
		else
			A.attack_generic(src, rand(120,350), "smashes")
	else if(ismob(A) && (A != target))
		visible_message(SPAN_DANGER("[src] rips [A] apart trying to get at [target]!"))
		var/mob/obstacle = A
		obstacle.gib()
	else if(A == target)
		current_state = STATE_096_SLAUGHTER

		target.loc = loc
		target.anchored = TRUE //Only humans can use grab so we have to do this ugly shit
		target.stun_effect_act(30, 5, 2)
		visible_message(SPAN_DANGER("[src] grabs [target] and starts trying to pull [target.p_them()] apart!"))

		playsound(src, 'sounds/scp/096/096-kill.ogg', 100)
		target.emote("scream")

		if(!do_after(src, 2 SECONDS, target))
			target.anchored = FALSE
			return

		visible_message(SPAN_DANGER("[src] tears [target] apart!"))
		target.anchored = FALSE
		target.gib()

		log_admin("[target] ([target.ckey]) has been torn apart by an active SCP-[SCP.designation].")
		message_staff("ALERT: [target.real_name] [ADMIN_JMP(target)] has been torn apart by an active SCP-[SCP.designation].")
		targets -= target
		target = null
		current_path = null
		current_state = STATE_096_CHASING



/mob/living/scp096/movement_delay()
	if(current_state == STATE_096_CHASING)
		return -2
	else
		return 10

/mob/living/scp096/handle_AI()
	if(src.client) // Cancel if there is a player
		return
	switch(current_state)
		if(STATE_096_IDLE)
			if(prob(45) && ((world.time - emote_cooldown_track) > emote_cooldown))
				audible_message(pick("[src] cries.", "[src] sobs.", "[src] wails."))
				playsound(src, 'sounds/scp/096/096-idle.ogg', 80, ignore_walls = TRUE)
				emote_cooldown_track = world.time
		if(STATE_096_CHASING)
			//Find path to target
			for(var/mob/living/carbon/human/Ptarget in targets)
				if(LAZYLEN(current_path))
					break
				target = Ptarget
				lastTargetTurf = get_turf(target)
				current_path = get_path_to(src, target, maxJPSdistance)
			//If we have no more targets, we go back to idle
			if(!LAZYLEN(targets))
				current_state = STATE_096_IDLE
				icon_state = "scp"
				target = null
				current_path = null
				//This resets the screaming noise for everyone.
				for(var/mob/living/carbon/human/hearer in hearers(world.view, src))
					sound_to(hearer, sound(null))
				update_icon()
				return
			//If we havent found a path for any of our targets, we notify admins and switch ourselves to the first target in our list. Path code will also use byond's inherent pathfinding for this life call.
			if(!LAZYLEN(current_path))
				log_and_message_staff("Instance of SCP-[SCP.designation] failed to find paths for targets. Switching to byond pathfinding for current life iteration.", src, loc)
				target = targets[1]
				lastTargetTurf = get_turf(target)
			//If the target moved, we must regenerate the path list
			if(get_turf(target) != lastTargetTurf)
				current_path = get_path_to(src, target, maxJPSdistance)
				//if we cant path to target we reset the target
				if(!LAZYLEN(current_path))
					target = null
					return
				lastTargetTurf = get_turf(target)
			//Gets our next step
			LAZYINITLIST(current_path)
			var/turf/next_step = LAZYLEN(current_path) ? current_path[1] : get_step_towards(src, target)
			//Get rid of obstacles
			if(next_step.contains_dense_objects())
				for(var/atom/obstacle in next_step)
					if(!obstacle.density)
						continue
					if(isturf(obstacle) && !istype(obstacle, /turf/simulated/wall))
						continue
					UnarmedAttack(obstacle)
				if(!(src in next_step))
					return
			//Murder!
			if(get_dist(src, target) <= 1)
				UnarmedAttack(target)
				return
			else if((get_dist(src, target) <= scp096_leap_range) && leapHandler.can_be_used_by(src, target, TRUE))
				leapHandler.perform(src, target, 5)
				return
			step_towards(src, next_step, scp096_speed)
			if(get_turf(src) != next_step)
				target = null
				current_path = null
				return
			current_path -= next_step
		if(STATE_096_STAGGERED)
			if(world.time > stagger_counter)
				current_state = STATE_096_CHASING


/mob/living/scp096/Life()
	//Sets the probability of someone seeing 096's face based on its current state
	var/probability_to_view
	switch(current_state)
		if(STATE_096_IDLE, STATE_096_SCREAMING)
			probability_to_view = idle_view_prob
		if(STATE_096_CHASING, STATE_096_SLAUGHTER, STATE_096_STAGGERED)
			probability_to_view = chasing_view_prob
	//Applies probability to each new viewer
	for(var/mob/living/carbon/human/viewer in viewers(world.view, src))
		if(viewer in oldViewers)
			continue
		if(!viewer.can_see(src, TRUE))
			continue
		var/message = "[SPAN_NOTICE("You notice [src], and instinctively look away ")]"
		if(prob(probability_to_view))
			message += "[SPAN_NOTICE("but you catch a glimpse of")] [SPAN_DANGER("its [SPAN_BOLD("face")]!")]"
			trigger(viewer)
		else
			message += "[SPAN_NOTICE("managing to avoid seeing its face.")]"

		to_chat(viewer, message)
		oldViewers += viewer

	//Now we remove any oldViewers that are no longer looking at 096
	for(var/mob/living/carbon/human/oldViewer in oldViewers)
		if(!oldViewer.can_see(src, TRUE))
			oldViewers -= oldViewer

	adjustBruteLoss(-10)
	handle_AI()
	handle_Player()


// NEW PROCS-VERBS

/mob/living/scp096/verb/cry()
	set name = "CRY"
	set category = "SCP"
	set desc = "Just crying."
	if((world.time - emote_cooldown_track) > emote_cooldown)
		audible_message(pick("[src] cries.", "[src] sobs.", "[src] wails."))
		playsound(src, 'sounds/scp/096/096-idle.ogg', 80, ignore_walls = TRUE)
		emote_cooldown_track = world.time

/mob/living/scp096/verb/flair()
	set name = "Set Flair"
	set category = "SCP"
	set desc = "Use your flair."
	target_radar = ~target_radar

/mob/living/scp096/verb/calmdown()
	set name = "Calm Down"
	set category = "SCP"
	set desc = "Don't worry."
	current_state = STATE_096_IDLE
	src.update_icon()
	targets = list()
	target = null
	icon_state = "scp"
	visible_message(SPAN_DANGER("[src] calms down!"))

/mob/living/scp096/proc/handle_Player()
	if(!src.client)
		return
	switch(current_state)
		if(STATE_096_CHASING)
			var/target_dist = get_dist(src, targets[1])
			for(var/mob/living/carbon/human/Ptarget in targets)
				if (get_dist(src, Ptarget) <= target_dist)
					target = Ptarget
			if(!LAZYLEN(targets))
				current_state = STATE_096_IDLE
				icon_state = "scp"
				target = null
				update_icon()
				return
		if(STATE_096_STAGGERED)
			if(world.time > stagger_counter)
				current_state = STATE_096_CHASING

#undef STATE_096_IDLE
#undef STATE_096_SCREAMING

#undef RADAR_OFF
#undef RADAR_ON
