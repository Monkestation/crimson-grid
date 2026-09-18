GLOBAL_LIST_INIT(night_spirits, world.file2list("modular_darkpack/modules/occult_artifacts/strings/night_spirits.txt"))
GLOBAL_LIST_INIT(darkness_spirits, world.file2list("modular_darkpack/modules/occult_artifacts/strings/darkness_spirits.txt"))
GLOBAL_LIST_INIT(vengeance_spirits, world.file2list("modular_darkpack/modules/occult_artifacts/strings/vengeance_spirits.txt"))
GLOBAL_LIST_INIT(animal_spirits, world.file2list("modular_darkpack/modules/occult_artifacts/strings/animal_spirits.txt"))

/obj/item/occult_artifact/werewolf
	icon = 'modular_darkpack/modules/occult_artifacts/icons/fetishes.dmi'
	worn_icon = 'modular_darkpack/modules/occult_artifacts/icons/fetishes_worn.dmi'
	lefthand_file = 'modular_darkpack/modules/occult_artifacts/icons/fetishes_lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/occult_artifacts/icons/fetishes_righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/occult_artifacts/icons/fetishes_onfloor.dmi')
	icon_state = "dagger"
	abstract_type = /obj/item/occult_artifact/werewolf
	var/spirit_name = "Glitchimus"
	var/spirit_type = "ahelp"

/obj/item/occult_artifact/werewolf/can_be_used_by(mob/living/user)
	return !!get_werewolf_splat(user)

/proc/generate_spirit_name(spirit_type) // TODO: make this better. there are 50+ spirits in WoD, and that's not condusive to this format.
	var/spirit_name
	var/spirit_table
	var/spirit_desc

	switch(spirit_type)
		if(SPIRIT_NIGHT)
			spirit_table = GLOB.night_spirits
		if(SPIRIT_DARKNESS)
			spirit_table = GLOB.darkness_spirits
		if(SPIRIT_VENGEANCE)
			spirit_table = GLOB.vengeance_spirits
		if(SPIRIT_ANIMAL)
			spirit_table = GLOB.animal_spirits

	if(length(spirit_table))
		spirit_name = pick(spirit_table)
		spirit_desc = "[spirit_name], a spirit of [spirit_type]"

	return spirit_desc
