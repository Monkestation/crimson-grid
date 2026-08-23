#define DOAFTER_SOURCE_MATRIX "doafter_matrix"

/turf/closed/indestructible/the_matrix
	name = "matrix"
	desc = "Suicide is no exit..."
	icon = 'modular_darkpack/modules/matrix/icons/matrix.dmi'
	icon_state = "matrix"

/turf/closed/indestructible/the_matrix/attack_hand(mob/user)
	if(!user.client)
		return FALSE
	if(!do_after(user, 10 SECONDS, src, interaction_key = DOAFTER_SOURCE_MATRIX))
		return FALSE
	matrix_mob(user, src)
	return TRUE

/obj/the_matrix
	name = "matrix (depricated)"
	desc = "Suicide is no exit... This is an old evil version, please contact a mapper to replace this with a turf one if you are reading this"
	icon = 'modular_darkpack/modules/matrix/icons/matrix.dmi'
	icon_state = "matrix"
	layer = ABOVE_NORMAL_TURF_LAYER
	anchored = TRUE
	opacity = TRUE
	density = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF | FREEZE_PROOF

/obj/the_matrix/attack_hand(mob/user)
	if(!user.client)
		return FALSE
	if(!do_after(user, 10 SECONDS, src, interaction_key = DOAFTER_SOURCE_MATRIX))
		return FALSE
	matrix_mob(user, src)
	return TRUE

ADMIN_VERB_AND_CONTEXT_MENU(matrix_mob_verb, R_ADMIN, "Matrix Mob", "Matrix (despawn) a mob.", ADMIN_CATEGORY_SECOND_CITY, /mob/living)
	VERB_ARG_TYPED(target, VERB_ARG_TYPE_MOB, VERB_ARG_SOURCE_WORLD, /mob/living)

	var/confirm = tgui_alert(user, "Are you sure you want to matrix this mob?", "Confirm", list("Yes", "No"))
	if(confirm != "Yes")
		return

	var/turf/target_turf = get_turf(target)
	var/message = "[key_name(user)] has matrixed [target] ([target.type]) at [AREACOORD(target_turf)]"
	message_admins(message)
	log_admin(message)

	matrix_mob(target)
	BLACKBOX_LOG_ADMIN_VERB("Matrix Mob")

/proc/matrix_mob(mob/living/despawning_mob)
	message_admins("[ADMIN_LOOKUP(despawning_mob)] has exited through the matrix.")
	log_game("[despawning_mob] has exited through the matrix.")

	GLOB.manifest.remove(despawning_mob.real_name)

	SSjob.FreeRole(despawning_mob)

	GLOB.joined_player_list -= despawning_mob.ckey

	//handle_objectives()
	SSmasquerade.matrix_masquerade_breacher(despawning_mob, TRUE)
	despawning_mob.ghostize(FALSE)
	QDEL_NULL(despawning_mob)

#undef DOAFTER_SOURCE_MATRIX
