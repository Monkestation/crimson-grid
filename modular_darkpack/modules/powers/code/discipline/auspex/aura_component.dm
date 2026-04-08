/datum/atom_hud/data/auspex_aura
	hud_icons = list(AUSPEX_AURA_HUD)

/obj/effect/aura_overlay
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

/particles/smoke/aura
	count = 1024
	spawning = 6
	lifespan = 3 SECONDS
	fade = 2.5 SECONDS
	fadein = 0.5 SECONDS
	gravity = list(0, 0, 0)
	friction = 0.01
	velocity = generator(GEN_SPHERE, 0, 0.5, UNIFORM_RAND)
	drift = list(0, 0, 0)
	position = generator(GEN_BOX, list(-8, -8, 0), list(10, 10, 0), UNIFORM_RAND)
	scale = list(0.75, 0.75)
	grow = 0.015
	color = "#ffffff28"

/datum/component/aura
	// A list of currently selected emotions by the player
	var/current_aura = AURA_INNOCENT
	var/current_emotion_name = "Innocent"
	var/obj/effect/abstract/shared_particle_holder/aura_smoke
	var/examine_message = ""
	var/obj/effect/aura_overlay/aura_glow_image
	var/obj/effect/aura_overlay/aura_base_image
	var/obj/effect/aura_overlay/aura_smoke_image

	var/obj/effect/aura_overlay/aura_classic_image

/datum/component/aura/RegisterWithParent()
	. = ..()
	var/mob/parent_mob = parent
	var/datum/atom_hud/data/auspex_aura/target_hud = GLOB.huds[DATA_HUD_AUSPEX_AURAS]
	target_hud.add_atom_to_hud(parent_mob)

	RegisterSignal(parent_mob, COMSIG_MOB_EMOTION_CHANGED, PROC_REF(update_emotions))
	RegisterSignal(parent_mob, COMSIG_MOB_UPDATE_AURA, PROC_REF(update_aura))
	RegisterSignal(parent_mob, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	if(isnpc(parent_mob))
		RegisterSignal(parent_mob, COMSIG_COMBAT_MODE_TOGGLED, PROC_REF(on_combat_mode_toggled))

	update_aura()

/datum/component/aura/UnregisterFromParent()
	var/mob/parent_mob = parent
	var/datum/atom_hud/data/auspex_aura/target_hud = GLOB.huds[DATA_HUD_AUSPEX_AURAS]
	target_hud.remove_atom_from_hud(parent_mob)
	examine_message = ""
	UnregisterSignal(parent_mob, list(COMSIG_MOB_EMOTION_CHANGED, COMSIG_MOB_UPDATE_AURA, COMSIG_ATOM_EXAMINE))
	if(isnpc(parent_mob))
		UnregisterSignal(parent_mob, list(COMSIG_COMBAT_MODE_TOGGLED))
	QDEL_NULL(aura_smoke)
	QDEL_NULL(aura_glow_image)
	QDEL_NULL(aura_base_image)
	QDEL_NULL(aura_smoke_image)

	QDEL_NULL(aura_classic_image)
	return ..()

/datum/component/aura/proc/update_emotions(mob/changed_mob, new_emotion)
	SIGNAL_HANDLER

	if(current_aura == new_emotion)
		return

	current_emotion_name = new_emotion
	current_aura = GLOB.aura_list[new_emotion]
	update_aura()

/datum/component/aura/proc/on_combat_mode_toggled(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/npc/parent_mob = parent
	if(parent_mob.combat_mode)
		SEND_SIGNAL(parent_mob, COMSIG_MOB_EMOTION_CHANGED, "Angry")
	if(current_aura == AURA_ANGRY && !parent_mob.combat_mode)
		SEND_SIGNAL(parent_mob, COMSIG_MOB_EMOTION_CHANGED, "Innocent")


/datum/component/aura/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!examine_message)
		return
	var/datum/atom_hud/data/auspex_aura/auspex_hud = GLOB.huds[DATA_HUD_AUSPEX_AURAS]
	if(!(user in auspex_hud.hud_users_all_z_levels))
		return
	examine_list += examine_message

/datum/component/aura/proc/update_examine_message(mutable_appearance/aura_appearance)
	var/mob/parent_mob = parent

	switch(current_aura)
		if(AURA_AFRAID)
			examine_message = "[parent_mob.p_Their()] aura burns a bright orange, tense and flickering at the edges."
		if(AURA_AGGRESSIVE)
			examine_message = "[parent_mob.p_Their()] aura radiates a deep purple, pulsing like an engine."
		if(AURA_ANGRY)
			examine_message = "[parent_mob.p_Their()] aura blazes a fierce red, hot and agitated."
		if(AURA_BITTER)
			examine_message = "[parent_mob.p_Their()] aura settles in a muddy brown, murky and stagnant."
		if(AURA_CALM)
			examine_message = "[parent_mob.p_Their()] aura glows a soft blue, steady and unhurried."
		if(AURA_COMPASSIONATE)
			examine_message = "[parent_mob.p_Their()] aura shines a warm pink, open and gentle."
		if(AURA_CONSERVATIVE)
			examine_message = "[parent_mob.p_Their()] aura holds a muted lavender, contained and composed."
		if(AURA_DEPRESSED)
			examine_message = "[parent_mob.p_Their()] aura fades to a dull gray, thin and sluggish."
		if(AURA_DESIROUS)
			examine_message = "[parent_mob.p_Their()] aura smolders a deep red, heavy and pulling."
		if(AURA_DISTRUSTFUL)
			examine_message = "[parent_mob.p_Their()] aura flickers a pale green, guarded and watchful."
		if(AURA_ENVIOUS)
			examine_message = "[parent_mob.p_Their()] aura coils a dark green, tight and covetous."
		if(AURA_EXCITED)
			examine_message = "[parent_mob.p_Their()] aura crackles with violet, quick and restless."
		if(AURA_GENEROUS)
			examine_message = "[parent_mob.p_Their()] aura blooms a soft rose, warm and outward-reaching."
		if(AURA_HAPPY)
			examine_message = "[parent_mob.p_Their()] aura shines a vivid vermillion, bright and expansive."
		if(AURA_HATEFUL)
			examine_message = "[parent_mob.p_Their()] aura darkens to black, heavy and oppressive."
		if(AURA_IDEALISTIC)
			examine_message = "[parent_mob.p_Their()] aura gleams a bright yellow, clear and radiant."
		if(AURA_INNOCENT)
			examine_message = "[parent_mob.p_Their()] aura glows a clean white, simple and unguarded."
		if(AURA_LOVESTRUCK)
			examine_message = "[parent_mob.p_Their()] aura pulses a warm blue, soft and yearning."
		if(AURA_OBSESSED)
			examine_message = "[parent_mob.p_Their()] aura burns a steady green, fixed and unyielding."
		if(AURA_SAD)
			examine_message = "[parent_mob.p_Their()] aura dims to a pale silver, quiet and withdrawn."
		if(AURA_SPIRITUAL)
			examine_message = "[parent_mob.p_Their()] aura shimmers gold, with a ghostly hue."
		if(AURA_SUSPICIOUS)
			examine_message = "[parent_mob.p_Their()] aura shifts a dark blue, restless and searching."
		if(AURA_ANXIOUS)
			examine_message = "[parent_mob.p_Their()] aura appears scrambled, like static or white noise."
		if(AURA_CONFUSED)
			examine_message = "[parent_mob.p_Their()] aura shifts between mottled, flickering colors."
		if(AURA_DAYDREAMING)
			examine_message = "[parent_mob.p_Their()] aura flickers with sharp, slow colors."
		if(AURA_PSYCHOTIC)
			examine_message = "[parent_mob.p_Their()] aura swirls with hypnotic, fast colors."
		else
			examine_message = ""
	var/quality = GLOB.emotion_to_quality[current_emotion_name]
	if(examine_message && quality)
		examine_message += " You sense [quality]."
	examine_message += "\n \n" // makes the below stand out more
	if(HAS_TRAIT(parent_mob, TRAIT_DIABLERIE))
		examine_message += "Black veins pulse through [parent_mob.p_their()] aura."
	if(HAS_TRAIT(parent_mob, TRAIT_FRENETIC_AURA))
		examine_message += "[parent_mob.p_Their()] aura appears especially energetic."
	if(get_ghoul_splat(parent_mob))
		examine_message += "Pale blotches mark [parent_mob.p_their()] aura."
	if(get_kindred_splat(parent_mob))
		var/mob/living/carbon/human/lick = parent_mob
		var/datum/st_stat/morality_path/morality/stat_morality = lick.storyteller_stats[STAT_MORALITY]
		if(!stat_morality.morality_path.alignment == MORALITY_HUMANITY) // non-humanity licks have standard kindred auras that give them away
			examine_message += "[parent_mob.p_Their()] aura colors appear pale."
	if(isavatar(parent_mob) || isobserver(parent_mob))
		examine_message += "[parent_mob.p_Their()] aura is weak and intermittent, fading in and out."

/datum/component/aura/proc/update_aura()
	SIGNAL_HANDLER

	var/mob/parent_mob = parent
	var/image/holder = parent_mob.hud_list[AUSPEX_AURA_HUD]
	if(!holder)
		holder = new
	holder.plane = ABOVE_LIGHTING_PLANE
	if(!aura_smoke)
		aura_smoke = new /obj/effect/abstract/shared_particle_holder(null, /particles/smoke/aura)
		aura_smoke.blend_mode = 2
		aura_smoke.add_filter("particle_blur", 1, gauss_blur_filter(8))
	var/mutable_appearance/aura_appearance = mutable_appearance('modular_darkpack/modules/powers/icons/auras.dmi', "aura", ABOVE_MOB_LAYER, parent_mob, ABOVE_GAME_PLANE)
	update_aura_colors(aura_appearance, holder)
	update_aura_overlays(aura_appearance, holder)
	update_aura_filters(aura_appearance, holder)
	update_examine_message(aura_appearance)

/datum/component/aura/proc/is_color(input_text)
	if(findtext(input_text, GLOB.is_color))
		return TRUE
	return FALSE

/datum/component/aura/proc/update_aura_colors(mutable_appearance/aura_appearance, image/holder)
	var/output_color
	if(is_color(current_aura))
		output_color = current_aura
	else
		output_color = null

	aura_appearance.color = output_color

	if(aura_smoke)
		aura_smoke.particles.color = output_color ? (output_color + pick("20","30")) : "#ffffff09"

	holder.icon = null
	holder.icon_state = null
	holder.color = null

	var/mob/parent_mob = parent
	if(HAS_TRAIT(parent, TRAIT_PALE_AURA) && !HAS_TRAIT(parent, TRAIT_DECEPTIVE_AURA) && output_color)
		var/mob/living/carbon/human/lick = parent_mob
		var/datum/st_stat/morality_path/morality/stat_morality = lick.storyteller_stats[STAT_MORALITY]
		if(!stat_morality?.morality_path.alignment == MORALITY_HUMANITY) // non-humanity licks have standard kindred auras that give them away
			var/list/hsv_color_value = rgb2hsv(output_color)
			hsv_color_value[2] = hsv_color_value[2] * 0.7 // Reduce saturation for kindred
			aura_appearance.color = hsv2rgb(hsv_color_value)

	if(HAS_TRAIT(parent_mob, TRAIT_FRENETIC_AURA))
		var/list/hsv_color_value = rgb2hsv(aura_appearance.color || "#ffffff")
		hsv_color_value[2] = hsv_color_value[2] * 1.5 // Way brighter for shapeshifters
		aura_appearance.color = hsv2rgb(hsv_color_value)
		aura_appearance.icon_state = "old_aura_bright"


/datum/component/aura/proc/update_aura_overlays(mutable_appearance/aura_appearance, image/holder)
	holder.vis_contents = aura_smoke ? list(aura_smoke) : list()
	var/mob/parent_mob = parent
	if(!aura_glow_image)
		aura_glow_image = new(null)
		aura_glow_image.icon = 'modular_darkpack/modules/powers/icons/auras.dmi'
		aura_glow_image.icon_state = "aura"
		aura_glow_image.layer = ABOVE_MOB_LAYER - 0.01
		aura_glow_image.plane = ABOVE_LIGHTING_PLANE
		aura_glow_image.add_filter("ambient_blur", 1, gauss_blur_filter(12))
	aura_glow_image.color = aura_appearance.color
	aura_glow_image.alpha = 20
	holder.vis_contents += aura_glow_image

	if(!aura_base_image)
		aura_base_image = new(null)
		aura_base_image.icon = 'modular_darkpack/modules/powers/icons/auras.dmi'
		aura_base_image.icon_state = "aura"
		aura_base_image.layer = ABOVE_MOB_LAYER
		aura_base_image.plane = ABOVE_LIGHTING_PLANE
	aura_base_image.color = aura_appearance.color
	aura_base_image.icon_state = aura_appearance.icon_state || "aura"
	aura_base_image.transform = matrix(0.8, MATRIX_SCALE)
	aura_base_image.alpha = 175
	holder.vis_contents += aura_base_image


	if(!aura_classic_image)
		aura_classic_image = new(null)
		aura_classic_image.icon = 'modular_darkpack/modules/powers/icons/auras.dmi'
		aura_classic_image.icon_state = "old_aura"
		aura_classic_image.layer = ABOVE_MOB_LAYER + 4.03
		aura_classic_image.plane = ABOVE_LIGHTING_PLANE
	aura_classic_image.color = aura_appearance.color
	aura_classic_image.icon_state = "old_aura"
	aura_classic_image.alpha = 255

	if(!aura_smoke_image)
		aura_smoke_image = new(null)
		aura_smoke_image.icon = 'modular_darkpack/modules/powers/icons/auras.dmi'
		aura_smoke_image.icon_state = "smoke"
		aura_smoke_image.layer = ABOVE_MOB_LAYER + 4.01
		aura_smoke_image.plane = ABOVE_LIGHTING_PLANE
	aura_smoke_image.color = aura_appearance.color
	aura_smoke_image.alpha = 50

	if(HAS_TRAIT(parent_mob, TRAIT_DIABLERIE))
		var/mutable_appearance/diablerie_image = mutable_appearance('modular_darkpack/modules/powers/icons/auras.dmi', "diab", ABOVE_MOB_LAYER + 1, parent_mob, ABOVE_GAME_PLANE)
		holder.add_overlay(diablerie_image)
		aura_classic_image.color = "#1717178b"

	if(current_aura == AURA_ANXIOUS)
		var/icon/temporary_icon_holder = icon('modular_darkpack/modules/powers/icons/auras.dmi', "old_aura")
		var/icon/static_icon = getStaticIcon(temporary_icon_holder)
		var/obj/effect/aura_overlay/static_image = new(null)
		static_image.icon = static_icon
		static_image.icon_state = "old_aura"
		static_image.layer = ABOVE_MOB_LAYER + 2
		static_image.plane = ABOVE_LIGHTING_PLANE
		static_image.appearance_flags |= RESET_COLOR
		static_image.alpha = 150
		holder.vis_contents += static_image

	if(!HAS_TRAIT(parent, TRAIT_PALE_AURA) && get_ghoul_splat(parent_mob))
		var/list/hsv_color_value = rgb2hsv(aura_appearance.color)
		hsv_color_value[2] = hsv_color_value[2] * 0.7 // Reduce saturation for ghouls
		aura_smoke_image.color = hsv2rgb(hsv_color_value)
		aura_classic_image.icon_state = "old_aura_ghoul"

	if(isavatar(parent_mob) || isobserver(parent_mob))
		holder.opacity = holder.opacity * 0.5

	var/matrix/smoke_transform = matrix()
	smoke_transform.Scale(1, pick(1.25, 1.5))
	aura_smoke_image.transform = smoke_transform

	var/matrix/classic_aura_transform = matrix()
	classic_aura_transform.Scale(pick(0.65, 0.75), 1)
	aura_classic_image.transform = classic_aura_transform

	holder.vis_contents += aura_classic_image
	holder.vis_contents += aura_smoke_image


/datum/component/aura/proc/update_aura_filters(mutable_appearance/aura_appearance, image/holder)
	remove_wibbly_filters(holder)
	apply_wibbly_filters(holder)
	holder.add_filter("aura_glow", 1, gauss_blur_filter(2))
