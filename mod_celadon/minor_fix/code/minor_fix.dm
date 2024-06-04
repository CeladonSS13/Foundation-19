// Исправляем шторки.
/obj/structure/curtain
	plane = MOB_PLANE // Магия шторки снова работает

// Исправляем описание.
/decl/flooring/linoleum
	desc = "It's like the 1990's all over again."

// Исправляем описание.
/obj/item/reagent_containers/food/snacks/enchiladas
	desc = "Viva La Mexico!"

// Стекло становится нормальным ведром.
/obj/item/reagent_containers/glass/bucket/throw_impact(atom/hit_atom)
	if (reagents.reagent_list.len > 0)
		visible_message(
			SPAN_DANGER("\The [src] bounces and spills all its contents!")
		)
		reagents.splash(hit_atom, reagents.total_volume)
	else
		visible_message(
			SPAN_WARNING("\The [src] bounces dangerously. Luckily it didn't break.")
		)
	playsound(src.loc, "sounds/effects/Glasshit.ogg", 50)

// Фиксим берет?
/datum/gear/head/beret
	whitelist_department_flags = 65535 // ALL IN, все отделы
