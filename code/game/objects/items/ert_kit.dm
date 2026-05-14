/obj/item/ert_kit
	name = "Kit device."
	desc = "Strange device, used by some aggresive strangers. Could be activated only at starting position."
	icon = 'icons/obj/radio.dmi'
	icon_state = "walkietalkie"
	item_state = "walkietalkie"

/obj/item/ert_kit/attack_self(mob/user as mob)
	if(!istype(user.loc.loc, /area/centcom)) //if not at base
		return
	if(!ishuman(user)) //you cant be outfitted
		to_chat(user, SPAN_INFO("It serves no purpose for you"))
		return
	if(!user.mind)
		return
	var/mob/living/carbon/human/H = user
	if(user.mind.special_role == "MTF Nine-Tailed Fox - Epsilon-11 Agent") //only for MTF
		var/list/ert_kits_options = list("Pointman", "Breacher", "Medic")
		var/ert_kit = tgui_input_list(H, "Please select a class kit!", "Skills not included", "Pointman", ert_kits_options, 0)
		if(!ert_kit)
			return
		if(!istype(user.loc.loc, /area/centcom)) //if not at base
			return
		switch(ert_kit)
			if("Pointman")
				dressup_human(H, outfits_decls_by_type_[/decl/hierarchy/outfit/mtf/epsilon_11/pointman], TRUE)
			if("Breacher")
				dressup_human(H, outfits_decls_by_type_[/decl/hierarchy/outfit/mtf/epsilon_11/breacher], TRUE)
			if("Medic")
				dressup_human(H, outfits_decls_by_type_[/decl/hierarchy/outfit/mtf/epsilon_11/medic], TRUE)
		qdel(src) //once used,no more
