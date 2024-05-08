/client/verb/fix_layout()
	set name = "Исправить раскладку"
	set category = "OOC"

	set_macros()
	to_chat(src, SPAN_WARNING("Перерегистрация макросов выполнена. Если не сработало, убедитесь что раскладка переключена на английский язык."))

// XAH, фоловиться за сцп ->
/mob/observer/ghost/verb/followSCP(mob/fs in GLOB.SCP_list,)
	set category = "Ghost"
	set name = "Follow on SCP"
	set desc = "Follow a SCP"

	if(!fs)
		to_chat(src, SPAN_WARNING("SCP not found."))
		return
	start_following(fs)

/obj/screen/ghost/followSCP/Click()
	var/mob/observer/ghost/G = usr
	var/mob/fs = tgui_input_list(G, "Choose a SCP to orbit", "Orbit", GLOB.SCP_list)
	if(istype(fs))
		G.follow(fs)
// <- XAH
