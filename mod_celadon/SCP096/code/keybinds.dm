/mob/living/scp096
	var/seedarkness = 1

/mob/living/scp096/verb/toggle_darkness()
	set name = "Toggle Darkness"
	set category = "IC"
	seedarkness = !(seedarkness)
	set_see_invisible(SEE_INVISIBLE_NOLIGHTING)
	to_chat(src, "You [(seedarkness?"now":"no longer")] see darkness.")

/mob/living/scp096/verb/stop_screaming()
	set name = "Stop scream"
	set category = "IC"

	target = null
	LAZYCLEARLIST(targets)
	current_state = STATE_096_IDLE
	icon_state = "scp"
	update_icon()
