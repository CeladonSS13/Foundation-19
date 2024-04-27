/datum/antagonist/ert/equip(mob/living/carbon/human/player)

	//Special radio setup
	player.add_language(LANGUAGE_ENGLISH)
	player.equip_to_slot_or_store_or_drop(new /obj/item/device/radio/headset/ert(src), slot_l_ear)
	player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/under/ert(src), slot_w_uniform)
	player.equip_to_slot_or_store_or_drop(new /obj/item/clothing/shoes/jackboots(src), slot_shoes)


	create_id(role_text, player)
	return 1
