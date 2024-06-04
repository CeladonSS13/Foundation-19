// Добавляем условие pull'a для отработки спуска по лестнице
// Перегружаем базовый proc
/atom/movable/handle_fall(turf/landing)
	forceMove(landing)
	if(locate(/obj/structure/stairs) in landing)
		if(isliving(src))
			var/mob/living/L = src
			if(L.pulling)
				L.pulling.forceMove(landing)
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			if(H.has_footsteps())
				playsound(landing, 'sounds/effects/stairs_step.ogg', 50)
				playsound(landing, 'sounds/effects/stairs_step.ogg', 50)
		return 1
	else if(landing.get_fluid_depth() >= FLUID_DEEP)
		visible_message(SPAN_NOTICE("\The [src] falls into the water!"), SPAN_NOTICE("What a splash!"))
		playsound(src,  'sounds/effects/watersplash.ogg', 30, TRUE)
		return 1
	else
		handle_fall_effect(landing)

// Перегрузка для can_pull()
/mob/living/can_pull()
	//if(!moving)
		//return FALSE
	if(pulling.anchored)
		return FALSE
	if(!isturf(pulling.loc))
		return FALSE
	if(restrained())
		return FALSE

	if(get_dist(src, pulling) > 2)
		return FALSE

	if(pulling.z != z)
		if(pulling.z < z)
			return FALSE
		var/turf/T = GetAbove(src)
		if(!isopenspace(T))
			return FALSE
	return TRUE
