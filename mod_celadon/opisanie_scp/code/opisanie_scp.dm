/mob/observer/ghost/verb/become_scp()
	set category = "Ghost"
	set name = "Become an SCP"
	set desc = "Take control of a clientless SCP."

	if(!MayRespawn(TRUE, SCP_SPAWN_DELAY))
		return

	var/list/scp_type_ref_list = list()

	for(var/atom/PossibleSCP in GLOB.SCP_list)
		if(!canBecomeSCP(PossibleSCP))
			continue
		var/datum/scp/PSCP = PossibleSCP.SCP
		var/select_string = "SCP-[PSCP.designation] | [PSCP.classification][(PSCP.metaFlags & SCP_ROLEPLAY) ? " | Roleplay" : ""]"

		var/new_select_string = select_string
		var/count = 1
		while(scp_type_ref_list[new_select_string])
			new_select_string = "[select_string] ([count])"
			count++

		scp_type_ref_list[new_select_string] = PossibleSCP

	if(LAZYLEN(scp_type_ref_list))
		var/selected_scp_string = tgui_input_list(src, "Which SCP do you want to take control of?", "SCP Select", scp_type_ref_list)
		if(!LAZYLEN(selected_scp_string))
			return

		var/mob/living/selected_scp = scp_type_ref_list[selected_scp_string]
		var/agreement = tgui_alert(src, (selected_scp.opisanie ? selected_scp.opisanie : ""), "Are you sure?", list("Yes","No"))
		if(!LAZYLEN(agreement) || (agreement == "No"))
			return
		if(!canBecomeSCP(selected_scp)) //This is incase something changes while we are waiting for a response from the ghost
			to_chat(src, SPAN_WARNING("SCP-[selected_scp.SCP.designation] is no longer avalible!"))
			return
		selected_scp.do_possession(src)
	else
		to_chat(src, SPAN_WARNING("There are no SCPs avalible yet! Keep in mind that not all SCPs are avalible round start and more may become avalible as the round goes on!"))


/// создание описания для всех сцп
/mob/living
	var/opisanie = ""

// дальше идет описание для всех сцп, добавлять или изменять по возможности
/mob/living/scp173
	opisanie = "ОПИСАНИЕ: Статуя, построенная из бетона и арматуры со следами аэрозольной краски марки КРИЛОН. ВАША ЦЕЛЬ: Уничтожить весь персонал, свернуть им шеи. ОСОБЕННОСТИ: Избегайте зрительного контакта, иначе вы будете лишены возможности передвижения. СТАНДАРТНЫЕ ДЕЙСТВИЯ: Раз в определённое время вы создаёте отходы под собой. Если ваша камера будет очень сильно загрязнена и не очищена вовремя - будет сломана система дверей, что даст вам возможность к побегу."

/mob/living/simple_animal/hostile/scp457
	opisanie = "ОПИСАНИЕ: Горящий столб огня в форме взрослого человека. ВАША ЦЕЛЬ: Найти как можно больше топлива и употреблять его. ОСОБЕННОСТИ: Вы неуязвимы от физического урона и крайне уязвимы к воде, огнетушителям, а так-же к низким температурам. Вы можете сжигать гуманоидов в качестве топлива это повышает ваше здоровье. СТАНДАРТНЫЕ ДЕЙСТВИЯ: Ищите как можно больше топлива, потребляйте его. Сжигайте персонал! БОЙТЕСЬ ВОДЫ."

/mob/living/carbon/human/scp106
	opisanie = "ОПИСАНИЕ: Пожилой мужчина что весь покрыт чёрной липкой жидкостью неизвестного происхождения, на его лице видна безумна широкая улыбка. ВАША ЦЕЛЬ: Ловить персонал  в своё измерение. ОСОБЕННОСТИ: Вы можете проходить сквозь стены и другие твёрдые объекты. Ваше касание не даст вашей жертве убежать. Вас могут поймать приманив с помощью приманки. СТАНДАРТНЫЕ ДЕЙСТВИЯ: Искать своих будущих жертв."

