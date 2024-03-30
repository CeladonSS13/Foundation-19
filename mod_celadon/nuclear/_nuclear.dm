/datum/modpack/nuclear
	/// A string name for the modpack. Used for looking up other modpacks in init.
	name = "nuclear"
	/// A string desc for the modpack. Can be used for modpack verb list as description.
	desc = "Добавляет музыку для ядерной боеголовки, исправляет взрыв"
	/// A string with authors of this modpack.
	author = "Вэн Дарк"

/datum/modpack/nuclear/pre_initialize()
	. = ..()

/datum/modpack/nuclear/initialize()
	. = ..()

/datum/modpack/nuclear/post_initialize()
	. = ..()

#define WARHEAD_SOUND 'mod_celadon/nuclear/sound/warhead.ogg'
