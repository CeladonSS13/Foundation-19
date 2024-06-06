// Дополнительная переменная
/mob/living/carbon/human/scp343
	var/move_delay = 3.0


// Перегрузка метода. Добавлено ограничение по времени.
/mob/living/carbon/human/scp343/Initialize(mapload, new_species = "SCP-343")
	. = ..()
	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"strange elderly man", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_SAFE, //Obj Class
		"343", //Numerical Designation
		SCP_PLAYABLE|SCP_ROLEPLAY
	)

	add_language(LANGUAGE_ENGLISH)
	add_language(LANGUAGE_HUMAN_FRENCH)
	add_language(LANGUAGE_HUMAN_GERMAN)
	add_language(LANGUAGE_HUMAN_SPANISH)
	if(!(MUTATION_XRAY in mutations))
		mutations.Add(MUTATION_XRAY)
		update_mutations()
		update_sight()

	add_verb(src, /mob/living/carbon/human/scp343/verb/object_phase)

	SCP.min_time = 15 MINUTES
	SCP.min_playercount = 20



// Новый verb для 343
/mob/living/carbon/human/scp343/verb/change_shell()
	set name = "Change shell"
	set category = "SCP"
	set desc = "Become unreal"

	// Invisible
	if (alpha < 255)
		alpha = 255
		move_delay = 3.0 // Default speed
	else if (alpha == 255)
		alpha = 0
		move_delay = 1.0 // Max speed


	to_chat(src, SPAN_WARNING("You change your visibility."))

// Перегрузка базового Verb
/mob/living/carbon/human/scp343/object_phase()
	// Перегрузка переменной
	phase_time = 1 SECOND

	var/obj/target_object = null
	for(var/obj/O in get_step(src, dir))
		// Things that we will ignore
		if(!isstructure(O) && !ismachinery(O))
			continue

		if(!O.density)
			continue

		// Things that will block our phasing
		if(istype(O, /obj/machinery/shieldwall) || istype(O, /obj/machinery/shieldwallgen))
			to_chat(src, SPAN_WARNING("You cannot phase through [O]."))
			return

		// There can be more than one available dense object, but that doesn't matter
		target_object = O

	if(!istype(target_object))
		to_chat(src, SPAN_WARNING("There's nothing to phase through in that direction."))
		return

	var/turf/target_turf = get_step(target_object, dir)
	if(target_turf.density)
		to_chat(src, SPAN_WARNING("\The [target_turf] is preventing us from phasing in that direction."))
		return

	phase_cooldown_track = world.time

	// Mob effects
	var/old_layer = layer
	var/anim_x = 0
	var/anim_y = 0
	layer = OBSERVER_LAYER

	if(dir in list(NORTH, NORTHEAST, NORTHWEST))
		anim_y = 32
	if(dir in list(SOUTH, SOUTHEAST, SOUTHWEST))
		anim_y = -32
	if(dir in list(EAST, NORTHEAST, SOUTHEAST))
		anim_x = 32
	if(dir in list(WEST, NORTHWEST, SOUTHWEST))
		anim_x = -32
	animate(src, pixel_x = anim_x, pixel_y = anim_y, time = phase_time)

	//if(do_after(src, phase_time, target_object))
	forceMove(get_step(src, dir))
	visible_message(SPAN_NOTICE("[src] silently phases through [target_object]"))

	layer = old_layer
	pixel_x = 0
	pixel_y = 0

// Перегрузка
/mob/living/carbon/human/scp343/movement_delay()
	return move_delay
