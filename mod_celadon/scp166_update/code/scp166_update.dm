// Форма для 166-V
/decl/hierarchy/outfit/scp166
	name = "SCP-166-V"
	uniform = /obj/item/clothing/under/kimono
	l_pocket = /obj/item/device/radio
	flags = OUTFIT_HAS_BACKPACK | OUTFIT_RESET_EQUIPMENT


// Реагент
/datum/reagent/nutriment/scp166_food
	name = "166_food"
	description = "Looks edible."
	color = "#dfdfdf"

	taste_description = "terrible taste"
	hydration_factor = 10
	nutriment_factor = 10


// Стаканчик с реагентом
/obj/item/reagent_containers/food/drinks/scp166_pack
	name = "cup of scp166 food"
	gender = PLURAL
	desc = "This cup is cursed, give up the contents 166."
	icon_state = "ramen"
	center_of_mass = "x=16;y=11"


// Добавляем реагент в стаканчик
/obj/item/reagent_containers/food/drinks/scp166_pack/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/scp166_food, 30)


// Добавляем еду для 166 в список покупок карго
/decl/hierarchy/supply_pack/galley/scp166_food
	name = "SCP166 - SPECIAL FOOD"
	contains = list(
			/obj/item/reagent_containers/food/drinks/scp166_pack
			)
	cost = 20
	containername = "scp166 food crate"


// Основной класс
/mob/living/carbon/human/scp166
	name = "Young lady"
	desc = "Young lady, 16-19 years old."
	gender = "female"

	// Фразы для меметического эффекта
	var/list/phrases = list("Здравствуйте, вашей маме зять не нужен?",
							"Ты случайно не фотоаппарат? Потому что каждый раз, когда я смотрю на тебя, у меня появляется улыбка.",
							"Твои глаза голубые, как Атлантический океан, но я не против в них утонуть.",
							"Как хорошо, что я купил страховку, потому что когда я увидел тебя, моё сердце остановилось.",
							"Если бы мне пришлось оценить тебя от 1 до 10, я дал бы тебе 9, потому что я тот единственный, которого тебе не хватает.",
							"Что-то случилось с моими глазами. Я не могу оторвать от тебя взгляд.",
							"Помнишь меня? Забыл, мы же встречались только во снах.",
							"Если бы ты и я носили носки, мы были бы прекрасной парой.",
							"Твои родители случайно не пекари? Тогда откуда у них такой пирожок?",
							"Наверное, я волшебник, потому что каждый раз, когда я смотрю на тебя, всё остальное исчезает.",
							"Ты наверное устала, потому что ты весь день крутишься у меня в голове.",
							"Привет, как там на небесах, когда ты спустилась с них?")

	// Переменные объекта
	var/hungry_message_cooldown = 15 SECONDS
	var/hungry_message_track = 0 SECONDS


// Инициализация 166-V
/mob/living/carbon/human/scp166/Initialize(mapload, new_species = null)
	. = ..()
	SCP = new /datum/scp(
		src, // Ref to actual SCP atom
		"Young lady", //Name (Should not be the scp desg, more like what it can be described as to viewers)
		SCP_EUCLID, //Obj Class
		"166", //Numerical Designation
		SCP_PLAYABLE|SCP_ROLEPLAY|SCP_MEMETIC
	)

	SCP.min_time = 10 MINUTES
	SCP.min_playercount = 20
	add_language(LANGUAGE_ENGLISH)
	add_language(LANGUAGE_HUMAN_FRENCH)
	add_language(LANGUAGE_HUMAN_GERMAN)
	add_language(LANGUAGE_HUMAN_SPANISH)

	// Меметика объекта
	SCP.memeticFlags = MVISUAL|MCAMERA|MSYNCED
	SCP.memetic_proc = TYPE_PROC_REF(/mob/living/carbon/human/scp166, memetic_effect)
	SCP.compInit()

	// Добавляем волосы и меняем телосложение
	var/datum/sprite_accessory/hair/newhair = /datum/sprite_accessory/hair/longest
	src.change_hair(initial(newhair.name))
	descriptors["build"] = 1 // Rail Thin build

	// Добавляем снаряжение
	var/decl/hierarchy/outfit/scp166/outfit = outfit_by_type(/decl/hierarchy/outfit/scp166)
	outfit.equip(src)



/mob/living/carbon/human/scp166/proc/memetic_effect(mob/living/carbon/human/H)
	var/mob/living/carbon/human/scp166/A = locate(/mob/living/carbon/human/scp166/) in GLOB.SCP_list // Находим объект
	if (!A) // Уходим, если объекта нет O.O
		return
	if(!H || H.stat == UNCONSCIOUS || H.blinded || !H.can_see(A) || H.gender == "female")
		return // Проверка на состояние, женщины не подвержены меметическому эффекту

	if(get_dist(H, src) > 1) // Начинаем идти к объекту
		step_to(H, src)
		to_chat(H, SPAN_DANGER("Come to her. Come on, come to her."))
	else if(get_dist(H, src) <= 1) // Мы близко.
		H.visible_message(SPAN_NOTICE("[H] looks at the \"[name]\"."))
		H.say(pick(phrases))



// Перегрузка методов для еды...
/datum/reagent/nutriment/adjust_nutrition(mob/living/carbon/M, alien, removed)
	var/nut_removed = removed
	var/hyd_removed = removed
	if(istype(M, /mob/living/carbon/human/scp166))
		if(istype(src, /datum/reagent/nutriment/scp166_food))
			M.adjust_nutrition(nutriment_factor * nut_removed) // Питаемся
		else
			removed *= 0.1 // Обычная еда нам не подходит
	if(alien == IS_UNATHI)
		removed *= 0.1 // Unathi get most of their nutrition from meat.
	if(nutriment_factor)
		M.adjust_nutrition(nutriment_factor * nut_removed) // For hunger and fatness
	if(hydration_factor)
		M.adjust_hydration(hydration_factor * hyd_removed) // For thirst

/datum/reagent/nutriment/protein/adjust_nutrition(mob/living/carbon/M, alien, removed)
	if(istype(M, /mob/living/carbon/human/scp166))
		return // Протеины не усвоены
	switch(alien)
		if(IS_UNATHI) removed *= 2.25
		if(IS_SKRELL) return
	M.adjust_nutrition(nutriment_factor * removed)


// Перегрузка метода.
/mob/living/carbon/human/scp166/Life()
	. = ..()
	if(src.nutrition < 100) // Сильный голод.
		if(world.time > hungry_message_track)
			hungry_message_track = world.time + hungry_message_cooldown
			to_chat(src, SPAN_DANGER("You relly need to eat something!"))

	// Обработка меметики
	SCP.meme_comp.check_viewers()
	SCP.meme_comp.activate_memetic_effects()


