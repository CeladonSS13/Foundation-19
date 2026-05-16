/*
CONTAINS:
SAFES
FLOOR SAFES
*/

GLOBAL_LIST_EMPTY(safes)

//SAFES
/obj/structure/safe
	name = "safe"
	desc = "A huge chunk of metal with a dial embedded in it. Up until first lock,down until second lock. Fine print on the dial reads \"Scarborough Arms - 2 tumbler safe, guaranteed thermite resistant, explosion resistant, and Class D resistant.\"."
	icon = 'icons/obj/structures.dmi'
	icon_state = "safe"
	anchored = TRUE
	density = TRUE
	var/open = 0		//is the safe open?
	var/tumbler_1_pos	//the tumbler position TRUE/FALSE
	var/tumbler_1_open	//the tumbler position to open at- 0 to 99
	var/tumbler_2_pos
	var/tumbler_2_open
	var/dial = 0		//where is the dial pointing?
	var/space = 0		//the combined w_class of everything in the safe
	var/maxspace = 24	//the maximum combined w_class of stuff in the safe
	var/known_by = list()

/obj/structure/safe/Initialize()
	. = ..()
	GLOB.safes += src
	tumbler_1_open = rand(0, 99)

	tumbler_2_open = rand(0, 99)
	return INITIALIZE_HINT_LATELOAD

/obj/structure/safe/LateInitialize()
	for(var/obj/item/I in loc)
		if(istype(I, /obj/item/paper/safe_codes))
			continue
		if(space >= maxspace)
			return
		if(I.w_class + space <= maxspace) //todo replace with internal storage or something
			space += I.w_class
			I.forceMove(src)
	. = ..()

/obj/structure/safe/Destroy()
	. = ..()
	GLOB.safes -= src

/obj/structure/safe/examine(mob/user)
	. = ..()
	if(open)
		. += "<span class='notice'>The inside of the the door has numbers written on it:  <b>[tumbler_1_open]</b> and <b>[tumbler_2_open]</b></span>"

/obj/structure/safe/proc/check_unlocked(mob/user as mob, canhear)
	if(user && canhear)
		if(tumbler_1_pos == tumbler_1_open)
			to_chat(user, SPAN_NOTICE("You hear a [pick("tonk", "krunk", "plunk")] from [src]."))
		if(tumbler_2_pos == tumbler_2_open)
			to_chat(user, SPAN_NOTICE("You hear a [pick("tink", "krink", "plink")] from [src]."))
	if(tumbler_1_pos == tumbler_1_open && tumbler_2_pos == tumbler_2_open)
		if(user) visible_message("<b>[pick("Spring", "Sprang", "Sproing", "Clunk", "Krunk")]!</b>")
		return 1
	return 0


/obj/structure/safe/proc/decrement(num)
	num -= 1
	if(num < 0)
		num = 99
	return num

/obj/structure/safe/proc/decrement_ten(num)
	num -= 10
	if(num < 0)
		num = 98 + num
	return num


/obj/structure/safe/proc/increment(num)
	num += 1
	if(num > 99)
		num = 0
	return num

/obj/structure/safe/proc/increment_ten(num)
	num += 10
	if(num > 99)
		num = num - 100
	return num



/obj/structure/safe/on_update_icon()
	if(open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)


/obj/structure/safe/attack_hand(mob/user as mob)
	if(ishuman(usr))
		var/mob/living/carbon/human/Human = usr
		if(istype(Human.l_hand, /obj/item/clothing/accessory/stethoscope) || istype(Human.r_hand, /obj/item/clothing/accessory/stethoscope))
			to_chat(user, SPAN_NOTICE("You start listening safe's internal mechanism"))
	var/dat = "<center>"
	dat += "<a href='byond://?src=\ref[src];open=1'>[open ? "Close" : "Open"] [src]</a> | <a href='byond://?src=\ref[src];decrement_ten=1'>--</a> <a href='byond://?src=\ref[src];decrement=1'>-</a> [dial] <a href='byond://?src=\ref[src];increment=1'>+</a><a href='byond://?src=\ref[src];increment_ten=1'>++</a>"
	if(open)
		dat += "<table>"
		for(var/i = contents.len, i>=1, i--)
			var/obj/item/P = contents[i]
			dat += "<tr><td><a href='byond://?src=\ref[src];retrieve=\ref[P]'>[P.name]</a></td></tr>"
		dat += "</table></center>"
	var/datum/browser/popup = new(user, "safe", "Safe", 350, 300)
	popup.set_content(dat)
	popup.open()

/obj/structure/safe/Topic(href, href_list)
	if(!ishuman(usr))	return
	var/mob/living/carbon/human/user = usr

	var/canhear = 0
	if(istype(user.l_hand, /obj/item/clothing/accessory/stethoscope) || istype(user.r_hand, /obj/item/clothing/accessory/stethoscope))
		canhear = 1

	if(href_list["open"])
		if(check_unlocked())
			to_chat(user, SPAN_NOTICE("You [open ? "close" : "open"] [src]."))
			open = !open
			update_icon()
			attack_hand(user)
			return
		else
			to_chat(user, SPAN_NOTICE("You can't [open ? "close" : "open"] [src], the lock is engaged!"))
			return

	if(href_list["decrement"])
		dial = decrement(dial)
		if(!tumbler_1_pos == tumbler_1_open)
			tumbler_1_pos = -1 //no way to lucky trigger
			tumbler_2_pos = dial
		if(tumbler_1_pos == tumbler_1_open)
			tumbler_2_pos = dial
			if((tumbler_2_pos != tumbler_2_open) && canhear)
				to_chat(user, SPAN_NOTICE("You hear a [pick("click", "chink", "clink")] from [src]."))
			check_unlocked(user, canhear)
		attack_hand(user)
		return

	if(href_list["decrement_ten"])
		dial = decrement_ten(dial)
		if(!tumbler_1_pos == tumbler_1_open)
			tumbler_1_pos = -1 //no way to lucky trigger
			tumbler_2_pos = dial
		if(tumbler_1_pos == tumbler_1_open)
			tumbler_2_pos = dial
			if((tumbler_2_pos != tumbler_2_open) && canhear)
				to_chat(user, SPAN_NOTICE("You hear a [pick("click", "chink", "clink")] from [src]."))
			check_unlocked(user, canhear)
		attack_hand(user)
		return

	if(href_list["increment"])
		dial = increment(dial) //если не в 1 позиции-сброс второй
		tumbler_1_pos = dial
		tumbler_2_pos = -1 //no way to activate
		if((tumbler_1_pos != tumbler_1_open) && canhear)
			to_chat(user, SPAN_NOTICE("You hear a [pick("clack", "scrape", "clank")] from [src]."))
		check_unlocked(user, canhear)
		attack_hand(user)
		return

	if(href_list["increment_ten"])
		dial = increment_ten(dial)
		tumbler_1_pos = dial
		tumbler_2_pos = -1 //no way to trigger
		if((tumbler_1_pos != tumbler_1_open) &&canhear)
			to_chat(user, SPAN_NOTICE("You hear a [pick("clack", "scrape", "clank")] from [src]."))
		check_unlocked(user, canhear)
		attack_hand(user)
		return

	if(href_list["retrieve"])
		var/obj/item/P = locate(href_list["retrieve"]) in src
		if(open)
			if(P && in_range(src, user))
				user.put_in_hands(P)
				attack_hand(user)


/obj/structure/safe/attackby(obj/item/I as obj, mob/user as mob)
	if(open)
		if(I.w_class + space <= maxspace)
			if(!user.unEquip(I, src))
				return
			space += I.w_class
			to_chat(user, SPAN_NOTICE("You put [I] in [src]."))
			attack_hand(user)
			return
		else
			to_chat(user, SPAN_NOTICE("[I] won't fit in [src]."))
			return
	else
		if(istype(I, /obj/item/clothing/accessory/stethoscope))
			to_chat(user, "Hold [I] in one of your hands while you manipulate the dial.")
			return


/obj/structure/safe/ex_act(severity)
	return

/obj/structure/safe/lcz
	maxspace = 80

/obj/structure/safe/lcz/Initialize()
	for (var/subtype in subtypesof(/obj/item/card/id/lcz))
		new subtype(src.loc)
	. = ..()

/obj/structure/safe/hcz
	maxspace = 80

/obj/structure/safe/hcz/Initialize()
	for (var/subtype in subtypesof(/obj/item/card/id/hcz))
		new subtype(src.loc)
	. = ..()

//FLOOR SAFES
/obj/structure/safe/floor
	name = "floor safe"
	icon_state = "floorsafe"
	density = FALSE
	level = 1	//underfloor
	layer = BELOW_OBJ_LAYER

/obj/structure/safe/floor/Initialize()
	. = ..()
	var/turf/T = loc
	if(istype(T) && !T.is_plating())
		hide(1)
	update_icon()

/obj/structure/safe/floor/hide(intact)
	set_invisibility(intact ? 101 : 0)

/obj/structure/safe/floor/hides_under_flooring()
	return 1

/obj/item/paper/safe_codes
	name = "safe codes"
	var/owner
	info = "<div style='text-align:center;'><img src = scplogo.png><center><h3>Safe Codes</h3></center>"

/obj/item/paper/safe_codes/Initialize(mapload)
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/paper/safe_codes/LateInitialize()
	. = ..()
	for(var/safe in GLOB.safes)
		var/obj/structure/safe/S = safe
		if(owner in S.known_by)
			info += "<br> The combination for the safe located in the [get_area(S)] is: turn right until dial is [S.tumbler_1_open] and turn left until dial is [S.tumbler_2_open]]<br>"
			info_links = info
