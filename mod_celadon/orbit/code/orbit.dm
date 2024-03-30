/obj/screen/ghost/orbit/Click()
	var/mob/observer/ghost/G = usr
	var/list/A

	for(var/mob/living/carbon/human/O in GLOB.living_mob_list_|GLOB.dead_mob_list_)
		A += list(O)

	for(var/mob/O in GLOB.SCP_list)
		A += list(O)

	A += GLOB.player_list

	var/mob/fh = tgui_input_list(G, "Choose a player to orbit", "Orbit", A)
	if(istype(fh))
		G.follow(fh)
