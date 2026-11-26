/obj/item/seeds/cannabis/og_kush
	name = "og kush seed pack"
	reagents_add = list(/datum/reagent/drug/cannabis/og_kush = 0.15)

/obj/item/seeds/cannabis/sour_diesel
	name = "sour diesel seed pack"
	reagents_add = list(/datum/reagent/drug/cannabis/sour_diesel = 0.15)

/obj/item/seeds/cannabis/granddaddy_purple
	name = "grandaddy purple seed pack"
	reagents_add = list(/datum/reagent/drug/cannabis/granddaddy_purple = 0.15)

/obj/item/seeds/cannabis/girl_scout_cookies
	name = "girl scout cookies seed pack"
	reagents_add = list(/datum/reagent/drug/cannabis/girl_scout_cookies = 0.15)

/obj/item/seeds/cannabis/Initialize(mapload, nogenes)
	var/strain_amount = reagents_add[/datum/reagent/drug/cannabis]
	if(strain_amount)
		reagents_add = list()
		reagents_add[pick(subtypesof(/datum/reagent/drug/cannabis))] = strain_amount
	return ..()

/obj/item/cigarette/rollie/cannabis/Initialize(mapload)
	list_reagents = list()
	list_reagents[pick(subtypesof(/datum/reagent/drug/cannabis))] = 15
	return ..()

/obj/item/food/grown/cannabis
	name = "cannabis bud"

/obj/item/food/grown/cannabis/Initialize(mapload, obj/item/seeds/new_seed)
	. = ..()
	update_appearance()

/obj/item/food/grown/cannabis/examine(mob/user)
	. = ..()
	for(var/datum/reagent/drug/cannabis/strain in reagents?.reagent_list)
		if(strain.strain_desc)
			. += span_notice(strain.strain_desc)

/obj/item/food/grown/cannabis/proc/get_strain()
	for(var/datum/reagent/drug/cannabis/strain in reagents?.reagent_list)
		if(strain.strain_icon_state)
			return strain
	return null

/obj/item/food/grown/cannabis/update_name(updates)
	. = ..()

	var/datum/reagent/drug/cannabis/strain = get_strain()
	if(strain)
		name = "[strain.name] bud"

/obj/item/food/grown/cannabis/update_icon_state()
	. = ..()

	var/datum/reagent/drug/cannabis/strain = get_strain()
	if(!strain)
		return
	icon = 'modular_darkpack/modules/jesse_we_need_to_cook/icons/cannabis_strains.dmi'
	onflooricon = icon
	icon_state = strain.strain_icon_state

/datum/reagent/drug/cannabis
	var/strain_desc
	var/strain_icon_state
	var/list/smoke_messages = list(
		"You feel relaxed.",
		"You feel calmed.",
		"Your mouth feels dry.",
		"You could use some water.",
		"Your heart beats quickly.",
		"You feel clumsy.",
		"You crave junk food.",
		"You notice you've been moving more slowly."
	)

/datum/reagent/drug/cannabis/proc/is_primary_cannabis()
	for(var/datum/reagent/drug/cannabis/other in holder.reagent_list)
		return other == src

/datum/reagent/drug/cannabis/og_kush
	name = "OG Kush"
	strain_icon_state = "og_kush"
	smoke_messages = list(
		"You feel happy.",
		"Your body tingles.",
		"You feel your body relax.",
		"You feel your worries melt away.",
		"You feel talkative.",
		"You need a snack."
	)
	strain_desc = "Forest green with long orange hairs and a golden crystal dusting. Smells earthy, sour and piney."
	taste_description = "earthy pine and lemon peel"
	chemical_flags = NONE
	randomized_spawns = REAGENT_SPAWN_NO_RANDOM

/datum/reagent/drug/cannabis/sour_diesel
	name = "Sour Diesel"
	strain_icon_state = "sour_diesel"
	smoke_messages = list(
		"You feel excited and energized.",
		"You feel creative.",
		"You have three new ideas going on at once.",
		"You feel like you can do all your chores.",
		"You feel the music."
	)
	strain_desc = "Dense light green with orange hairs. Sticky. Smells like fuel and lemon."
	taste_description = "sour diesel fumes"
	chemical_flags = NONE
	randomized_spawns = REAGENT_SPAWN_NO_RANDOM

/datum/reagent/drug/cannabis/granddaddy_purple
	name = "Granddaddy Purple"
	strain_icon_state = "granddaddy_purple"
	smoke_messages = list(
		"You feel euphoric.",
		"Your body tingles.",
		"You are becoming furniture.",
		"Your hands are very far away.",
		"You have not blinked in a while.",
		"Time? What is time? It's not passing.",
		"Your mind swirls."
	)
	strain_desc = "Deep purple with fiery orange hairs. Sticky. Smells like sweet grape."
	taste_description = "grape candy"
	chemical_flags = NONE
	randomized_spawns = REAGENT_SPAWN_NO_RANDOM

/datum/reagent/drug/cannabis/girl_scout_cookies
	name = "Girl Scout Cookies"
	strain_icon_state = "girl_scout_cookies"
	smoke_messages = list(
		"You feel relaxed.",
		"You keep giggling at nothing.",
		"Your mouth is dry.",
		"You have no urge to move.",
		"You would join the Dark Side for a cookie."
	)
	strain_desc = "Small dense green nugs under a heavy silvery coat of kief. Smells like sweet earth and... mint?"
	taste_description = "sweet earth and mint"
	chemical_flags = NONE
	randomized_spawns = REAGENT_SPAWN_NO_RANDOM
