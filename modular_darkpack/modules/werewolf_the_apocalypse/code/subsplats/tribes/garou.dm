/datum/subsplat/werewolf/tribe/garou
	abstract_type = /datum/subsplat/werewolf/tribe/garou
	fera_restriction = SPLAT_GAROU

/datum/subsplat/werewolf/tribe/garou/galestalkers
	name = TRIBE_GALESTALKERS
	desc = "Tireless trackers and peerless hunters, the galestalkers carry the namesake of the wind that crosses the tundra."
	gifts_provided = list()
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/ghostcouncil
	name = TRIBE_UKTENA
	desc = "Seekers of mystery and highly secretive, the Uktena is one of the most misunderstood tribes. Their ranks include guides, academics and the religious."
	gifts_provided = list(
		// /datum/action/cooldown/power/gift/spirit_speech, // DARKPACK TODO - (Selectable Gifts)
	)
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/hartwardens
	name = TRIBE_FIANNA
	desc = "Growing, creating, cultivating and maintaining the most natural of Gaia's creations, the Wardens are some of the closest to nature. Wherever they are, they coax Gaia's blessing out of whatever they can."
	gifts_provided = list(
		/datum/action/cooldown/power/gift/faerie_light,
	)
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/glasswalkers
	name = TRIBE_GLASS_WALKERS
	desc = "The closest to the Weaver, they find themselves deeply entrenched in modern human society, religion, technology and cities. Every new invention and every new discovery is one that aids the Glass Walkers, instead of impeding them."
	gifts_provided = list(
		/datum/action/cooldown/power/gift/control_machine/simple,
	)
	subsplat_keys = /obj/item/vamp/keys/techstore

/datum/subsplat/werewolf/tribe/garou/bonegnawers
	name = TRIBE_BONE_GNAWERS
	desc = "Survivors and scavengers, often destitute and homeless. The Gnawers are seen as mongrels who live off scraps, but they know better. They're the true survivors, patiently waiting for their moment to strike against overconfident foes."
	gifts_provided = list(
		/datum/action/cooldown/power/gift/desperate_strength,
	)
	subsplat_keys = /obj/item/vamp/keys/children_of_gaia

/datum/subsplat/werewolf/tribe/garou/childrenofgaia
	name = TRIBE_CHILDREN_OF_GAIA
	desc = "Peacekeepers, negotiators, treaty-makers and philosophers. The Children of Gaia strive as hard as they can create an understanding and unity between the disparate tribes that will allow them to form a united front against their foes."
	gifts_provided = list(
		/datum/action/cooldown/power/gift/jam_weapon
		// /datum/action/cooldown/power/gift/mothers_touch, // DARKPACK TODO - (Selectable Gifts)
		// /datum/action/cooldown/power/gift/resist_pain, // DARKPACK TODO - (Selectable Gifts)
	)
	subsplat_keys = /obj/item/vamp/keys/children_of_gaia

/datum/subsplat/werewolf/tribe/garou/getoffenris
	name = TRIBE_GET_OF_FENRIS
	desc = "Warriors, compassionate and fierce. They view themselves are Gaia's strongest heroes, but the rest of the tribes view them with caution, their violence more famous than their courage."
	gifts_provided = list(
		// /datum/action/cooldown/power/gift/razor_claws, // DARKPACK TODO - (Selectable Gifts)
		// /datum/action/cooldown/power/gift/resist_pain, // DARKPACK TODO - (Selectable Gifts)
		/datum/action/cooldown/power/gift/visage_of_fenris,
	)
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/blackfuries
	name = TRIBE_BLACK_FURIES
	desc = "An all-female tribe, and the matriarchs of the Garou. The Black Furies are known fondly for their honor, wisdom, pride and impressive prowess in battle."
	gifts_provided = list(
		/datum/action/cooldown/power/gift/breath_of_the_wyld,
	)
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/silentstriders
	name = TRIBE_SILENT_STRIDERS
	desc = "Highly spiritual nomads, the Silent Striders have headed deeper and longer into the depths of the Umbra than any other tribe."
	gifts_provided = list(
		// /datum/action/cooldown/power/gift/sense_wyrm, // DARKPACK TODO - (Selectable Gifts)
		/datum/action/cooldown/power/gift/speed_of_thought,
	)
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/shadowlords
	name = TRIBE_SHADOW_LORDS
	desc = "The closest one could consider a Garou to being a 'politician'. They manipulate the tribes, and their enemies, and rely on cunning and wits more than physical strength. Not to say there aren't adept warriors in their ranks, but the tribe tends towards brains than brawn."
	gifts_provided = list(
		/datum/action/cooldown/power/gift/aura_of_confidence,
		/datum/action/cooldown/power/gift/fatal_flaw,
	)
	subsplat_keys = /obj/item/vamp/keys/techstore

/datum/subsplat/werewolf/tribe/garou/redtalons
	name = TRIBE_RED_TALONS
	desc = "Exclusively consisting of lupus, the Red Talons shun humanity and think of them as a blight on Gaia."
	gifts_provided = list(
		// /datum/action/cooldown/power/gift/beast_speech, // DARKPACK TODO - (Selectable Gifts)
		/datum/action/cooldown/power/gift/hidden_killer,
	)

/datum/subsplat/werewolf/tribe/garou/silverfangs
	name = TRIBE_SILVER_FANGS
	desc = "Commonly known as the 'Alphas' of the Garou Nation, their ranks consist of traditional rulers and wartime leaders. Known for being honorable and having courage, odd mental quirks have begun plaguing their young members, and the tribe is beginning to suffer from diseases of the spirit and mind."
	gifts_provided = list(
		// /datum/action/cooldown/power/gift/inspiration, // DARKPACK TODO - (Selectable Gifts)
	)
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/stargazers
	name = TRIBE_STARGAZERS
	desc = "The calmest of the Garou, they are well known for their introversion. They are the smallest of the remaining tribes, many of their kind wiped out by the Wyrm."
	gifts_provided = list()
	subsplat_keys = /obj/item/vamp/keys/nps

/datum/subsplat/werewolf/tribe/garou/blackspiraldancers
	name = TRIBE_BLACK_SPIRAL_DANCERS
	desc = "The lost tribe. The dreadwolves. Those who dance lockstep with the Wyrm. They who have entered the labyrinth and come back, changed.\n<b>{THIS IS AN ADVANCED TRIBE AND NOT RECOMMENDED FOR BEGINNERS. LORE KNOWLEDGE IS REQUIRED TO PLAY THIS TRIBE}</B>"
	gifts_provided = list(
		/datum/action/cooldown/power/gift/bane_protector,
		// /datum/action/cooldown/power/gift/resist_pain, // DARKPACK TODO - (Selectable Gifts)
		// /datum/action/cooldown/power/gift/sense_wyrm, // DARKPACK TODO - (Selectable Gifts)
	)
	// tribe_trait = TRAIT_WYRMTAINTED_SPRITE

/datum/subsplat/werewolf/tribe/garou/blackspiraldancers/psychomania_effect(mob/living/target, mob/living/owner)
	target.playsound_local(target, "modular_darkpack/modules/powers/sounds/daimonion_laughs/demonlaugh3.ogg", 50, FALSE)
	target.visible_message(span_warning("[target] whines in animalistic fear"), span_cult("VISIONS OF BRIMSTONE AND FLAME FLASH BEFORE MY EYES"))
	target.Paralyze(5 SECONDS)

/datum/subsplat/werewolf/tribe/garou/ronin
	name = TRIBE_RONIN
	desc = "Garou who, for one reason or another, find themselves as outcasts of the Nation."
	gifts_provided = list()
