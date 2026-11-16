/// Inits GLOB.glyph_list
/proc/init_glyphs()
	var/glyph_list = list()
	for(var/path in valid_subtypesof(/obj/effect/decal/garou_glyph))
		var/obj/effect/decal/garou_glyph/S = path
		glyph_list[S.garou_name] = S
	sort_list(glyph_list, GLOBAL_PROC_REF(cmp_typepaths_asc))
	return glyph_list

/obj/item/pen/charcoal/interact_with_atom(atom/target, mob/user, list/modifiers, list/attack_modifiers)
	if(!isopenturf(target) || isgroundlessturf(target))
		return NONE

	if(!user.has_language(/datum/language/garou_tongue, UNDERSTOOD_LANGUAGE))
		return NONE

	if(!GLOB.glyph_list.len)
		to_chat(user, span_notice("There are no glyphs available."))
		return NONE

	var/list/glyph_names = list()

	for(var/glyph in GLOB.glyph_list)
		glyph_names += glyph

	var/choice = tgui_input_list(user, "Select a glyph to draw.", "Glyph Selection", glyph_names)
	if(!choice)
		return ITEM_INTERACT_BLOCKING

	var/obj/effect/decal/garou_glyph/drawn_glyph = GLOB.glyph_list[choice]
	if(drawn_glyph)
		user.visible_message(span_notice("[user] starts to scrape a glyph into the ground..."), \
		span_notice("You begin to etch the spirals and lines of your chosen glyph..."))

		if(do_after(user, 5 SECONDS, target))
			new drawn_glyph.type(target)
			user.visible_message(span_notice("[user] finishes up their rune."), \
			span_notice("You put the finishing touches on your rune, as it marks the ground before you."))
			return ITEM_INTERACT_SUCCESS
		else
			user.visible_message(span_notice("[user] slips, smduges and ruins their glyph."), \
			span_notice("You mess it up, the glyph turning into nothing more than a smear upon the ground."))
			return ITEM_INTERACT_FAILURE

/obj/effect/decal/garou_glyph
	abstract_type = /obj/effect/decal/garou_glyph
	name = "odd glyph"
	desc = "An odd collection of symbols drawn in what seems to be charcoal."
	anchored = TRUE
	icon = 'modular_darkpack/modules/werewolf_the_apocalypse/icons/glyphs.dmi'
	icon_state = "garou"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	// Very likely not needed
	// layer = SIGIL_LAYER
	var/garou_name = "basic glyph"
	var/garou_desc = "a basic glyph with no meaning." // This is shown to werewolves who examine the glyph in order to determine its true meaning.

/obj/effect/decal/garou_glyph/examine(mob/user)
	. = ..()
	if(user.has_language(/datum/language/garou_tongue, UNDERSTOOD_LANGUAGE))
		. += "<b>Name:</b> [garou_name]\n"
		. += "<b>Description:</b> [garou_desc]\n"

/obj/effect/decal/garou_glyph/wyrm
	name = "creepy glyph"
	garou_name = "wyrm glyph"
	garou_desc = "A glyph that represents the Wyrm, a force of corruption and destruction."
	icon_state = "wyrm"

/obj/effect/decal/garou_glyph/vampire
	name = "weird glyph"
	garou_name = "vampire glyph"
	garou_desc = "A glyph that represents the Kindred, leeches of the Weaver and Wyrm."
	icon_state = "vampire"

/obj/effect/decal/garou_glyph/kinfolk
	name = "uncanny glyph"
	garou_name = "kinfolk glyph"
	garou_desc = "A glyph that represents the Kinfolk, the human relatives of the Garou."
	icon_state = "kinfolk"

/obj/effect/decal/garou_glyph/dance
	name = "funky glyph"
	garou_name = "dancing glyph"
	garou_desc = "A glyph that represents the spiritual dancing of the Garou."
	icon_state = "dance"

/obj/effect/decal/garou_glyph/caern
	name = "eerie glyph"
	garou_name = "caern glyph"
	garou_desc = "A glyph that represents the Caern, a sacred location that naturally flows with spiritual energy."
	icon_state = "caern"

/obj/effect/decal/garou_glyph/danger
	name = "peculiar glyph"
	garou_name = "danger glyph"
	garou_desc = "A glyph that represents danger! Proceed with caution."
	icon_state = "danger"

/obj/effect/decal/garou_glyph/garou
	name = "freakish glyph"
	garou_name = "garou glyph"
	garou_desc = "A glyph that represents the Garou, the warriors of Gaia."
	icon_state = "garou"

/obj/effect/decal/garou_glyph/conceal
	name = "mysterious glyph"
	garou_name = "conceal glyph"
	garou_desc = "A glyph that represents the obfuscation of something. What may be hidden from you?"
	icon_state = "conceal"

/obj/effect/decal/garou_glyph/hive
	name = "outlandish glyph"
	garou_name = "hive glyph"
	garou_desc = "A glyph that represents a Hive, the foul home of a Black Spiral Dancer pack."
	icon_state = "hive"

/obj/effect/decal/garou_glyph/howl
	name = "unusual glyph"
	garou_name = "howling glyph"
	garou_desc = "A glyph that represents the natural song of the Garou, the howl."
	icon_state = "howl"

/obj/effect/decal/garou_glyph/remembrance
	name = "morose glyph"
	garou_name = "remembrance glyph"
	garou_desc = "A glyph that represents the mourning and remembrance of the fallen."
	icon_state = "remembrance"

/obj/effect/decal/garou_glyph/watch
	name = "odd glyph"
	garou_name = "watch glyph"
	garou_desc = "A glyph that marks something as in need of monitoring"
	icon_state = "watch"

/obj/effect/decal/garou_glyph/toxic
	name = "foul glyph"
	garou_name = "toxic glyph"
	garou_desc = "A glyph that represents toxicity, the material corruption of the Wyrm on the Earth."
	icon_state = "toxic"

/obj/effect/decal/garou_glyph/dancers
	name = "alien glyph"
	garou_name = "\improper Black Spiral Dancer glyph"
	garou_desc = "A glyph that represents the tribe of the Black Spiral Dancers."
	icon_state = "black_spiral_dancers"

/obj/effect/decal/garou_glyph/glasswalkers
	name = "quirky glyph"
	garou_name = "\improper Glasswalkers glyph"
	garou_desc = "A glyph that represents the Glasswalkers tribe."
	icon_state = "glasswalkers"

/obj/effect/decal/garou_glyph/galestalkers
	name = "abnormal glyph"
	garou_name = "\improper Younger Brother glyph"
	garou_desc = "A glyph that represents the Galestalkers tribe."
	icon_state = "younger_brother"

/obj/effect/decal/garou_glyph/war_against_wyrm
	name = "terrifying glyph"
	garou_name = "war against wyrm glyph"
	garou_desc = "A glyph that represents the apocalyptic war of the Garou against the Wyrm."
	icon_state = "war_against_wyrm"

/obj/effect/decal/garou_glyph/black_furies
	name = "rooted glyph"
	garou_name = "black furies glyph"
	garou_desc = "A glyph that represents the Black Furies, one of the Garou Tribes."
	icon_state = "black_furies"

/obj/effect/decal/garou_glyph/bonegnawers
	name = "smudged glyph"
	garou_name = "bonegnawer glyph"
	garou_desc = "A glyph that represents the Bonegnawers, one of the Garou Tribes."
	icon_state = "bonegnawers"

/obj/effect/decal/garou_glyph/children_of_gaia
	name = "relaxing glyph"
	garou_name = "children of gaia glyph"
	garou_desc = "A glyph that represents the Children of Gaia, one of the Garou Tribes."
	icon_state = "children_of_gaia"

/obj/effect/decal/garou_glyph/fianna
	name = "musical glyph"
	garou_name = "fianna glyph"
	garou_desc = "A glyph that represents the Fianna, one of the Garou Tribes."
	icon_state = "fianna"

/obj/effect/decal/garou_glyph/get_of_fenris
	name = "jagged glyph"
	garou_name = "get of fenris glyph"
	garou_desc = "A glyph that represents the Get of Fenris, one of the Garou Tribes."
	icon_state = "get_of_fenris"

/obj/effect/decal/garou_glyph/red_talons
	name = "clawed glyph"
	garou_name = "red talon glyph"
	garou_desc = "A glyph that represents the Red Talons, one of the Garou Tribes."
	icon_state = "red_talons"

/obj/effect/decal/garou_glyph/shadow_lords
	name = "veiled glyph"
	garou_name = "shadow lord glyph"
	garou_desc = "A glyph that represents the Shadow Lords, one of the Garou Tribes."
	icon_state = "shadow_lords"

/obj/effect/decal/garou_glyph/silent_striders
	name = "wavy glyph"
	garou_name = "silent striders glyph"
	garou_desc = "A glyph that represents the Silent Striders, one of the Garou Tribes."
	icon_state = "silent_striders"

/obj/effect/decal/garou_glyph/silver_fangs
	name = "illustrious glyph"
	garou_name = "silver fang glyph"
	garou_desc = "A glyph that represents the Silver Fangs, one of the Garou Tribes."
	icon_state = "silver_fangs"

/obj/effect/decal/garou_glyph/stargazers
	name = "auspicious glyph"
	garou_name = "stargazers glyph"
	garou_desc = "A glyph that represents the Stargazers, a Garou tribe which has since left the nation."
	icon_state = "stargazers"

/obj/effect/decal/garou_glyph/ghost_council
	name = "watchful glyph"
	garou_name = "ghost council glyph"
	garou_desc = "A glyph that represents the Ghost Council, one of the Garou Tribes."
	icon_state = "ghost_council"

/obj/effect/decal/garou_glyph/ronin
	name = "messy glyph"
	garou_name = "ronin glyph"
	garou_desc = "A glyph that represents the Ronin, loners who exist out of a tribe and can rarely be trusted."
	icon_state = "ronin"

/obj/effect/decal/garou_glyph/ratkin
	name = "ominous glyph"
	garou_name = "ratkin glyph"
	garou_desc = "A glyph that represents the Ratkin, the Fera with the power to shift between man and rat."
	icon_state = "ratkin"

/obj/effect/decal/garou_glyph/corax
	name = "flashy glyph"
	garou_name = "corax glyph"
	garou_desc = "A glyph that represents the Corax, the Fera with the power to shift between man and raven."
	icon_state = "corax"

/obj/effect/decal/garou_glyph/sept_of_western_eye
	name = "elaborate glyph"
	garou_name = "sept of western eye glyph"
	garou_desc = "A glyph that represents the Sept of Western Eye, who watch over Gaia's sacred places hidden around San Francisco and its outskirts."
	icon_state = "sept_of_western_eye"

/obj/effect/decal/garou_glyph/bastet
	name = "fanged glyph"
	garou_name = "bastet glyph"
	garou_desc = "A glyph that represents the Bastet, the Fera with the power to shift between man and feline."
	icon_state = "bastet"

/obj/effect/decal/garou_glyph/gurahl
	name = "large glyph"
	garou_name = "gurahl glyph"
	garou_desc = "A glyph that represents the Gurahl, the Fera with the power to shift between man and bear."
	icon_state = "gurahl"

/obj/effect/decal/garou_glyph/rokea
	name = "watery glyph"
	garou_name = "rokea glyph"
	garou_desc = "A glyph that represents the Rokea, the Fera with the power to shift between man and shark."
	icon_state = "rokea"

/obj/effect/decal/garou_glyph/corax_safe
	name = "crude marking"
	garou_name = "corax safety glyph"
	garou_desc = "A Corax glyph that marks a space as safe."
	icon_state = "corax_safe"

/obj/effect/decal/garou_glyph/corax_danger
	name = "strange lines"
	garou_name = "corax danger glyph"
	garou_desc = "A Corax glyph that marks a space as dangerous."
	icon_state = "corax_danger"

/obj/effect/decal/garou_glyph/corax_wyrm_spirits
	name = "crude symbols"
	garou_name = "corax wyrm spirit glyph"
	garou_desc = "A Corax glyph that warns of the presence of Wyrm spirits."
	icon_state = "corax_wyrm_spirits"

/obj/effect/decal/garou_glyph/corax_weaver_spirits
	name = "scratch marks"
	garou_name = "corax weaver spirit glyph"
	garou_desc = "A Corax glyph that warns of the presence of Weaver spirits."
	icon_state = "corax_weaver_spirits"

/obj/effect/decal/garou_glyph/corax_food
	name = "oddly arranged dots"
	garou_name = "corax food glyph"
	garou_desc = "A Corax glyph that highlights the presence of food or a slaughter."
	icon_state = "corax_food"

/obj/effect/decal/garou_glyph/corax_party
	name = "crude etching"
	garou_name = "corax party glyph"
	garou_desc = "A Corax glyph showcasing the locale of a party or celebration of sorts."
	icon_state = "corax_party"

/obj/effect/decal/garou_glyph/lodge_of_the_moon
	name = "roof glyph"
	garou_name = "moon lodge glyph"
	garou_desc = "A glyph that represents the Moon Lodge, one of the two lodges of the Silver Fang, focused on spiritual matters."
	icon_state = "lodge_of_the_moon"

/obj/effect/decal/garou_glyph/lodge_of_the_sun
	name = "shiny glyph"
	garou_name = "sun lodge glyph"
	garou_desc = "A glyph that represents the Sun Lodge, one of the two lodges of the Silver Fang, focused on worldly matters."
	icon_state = "lodge_of_the_sun"

/obj/effect/decal/garou_glyph/house_austere_howl
	name = "smoke glyph"
	garou_name = "house austere glyph"
	garou_desc = "A glyph that represents House Austere, one of the seven houses of the Silver Fang tribe."
	icon_state = "house_austere_howl"

/obj/effect/decal/garou_glyph/house_blood_red_crest
	name = "crying glyph"
	garou_name = "house blood-red crest glyph"
	garou_desc = "A glyph that represents House Blood-Red Crest, one of the seven houses of the Silver Fang tribe."
	icon_state = "house_blood_red_crest"

/obj/effect/decal/garou_glyph/house_crescent_moon
	name = "curved glyph"
	garou_name = "house crescent moon glyph"
	garou_desc = "A glyph that represents House Crescent Moon, one of the seven houses of the Silver Fang tribe."
	icon_state = "house_crescent_moon"

/obj/effect/decal/garou_glyph/house_gleaming_eye
	name = "gazing glyph"
	garou_name = "house gleaming eye glyph"
	garou_desc = "A glyph that represents House Gleaming Eye, one of the seven houses of the Silver Fang tribe."
	icon_state = "house_gleaming_eye"

/obj/effect/decal/garou_glyph/house_unbreakable_hearth
	name = "sturdy glyph"
	garou_name = "house unbreakable hearth glyph"
	garou_desc = "A glyph that represents House Unbreakable Hearth, one of the seven houses of the Silver Fang tribe."
	icon_state = "house_unbreakable_hearth"

/obj/effect/decal/garou_glyph/house_wise_heart
	name = "knowing glyph"
	garou_name = "house wise heart glyph"
	garou_desc = "A glyph that represents House Wise Heart, one of the seven houses of the Silver Fang tribe."
	icon_state = "house_wise_heart"

/obj/effect/decal/garou_glyph/house_wyrmfoe
	name = "shredded glyph"
	garou_name = "house wyrmfoe glyph"
	garou_desc = "A glyph that represents House Wyrmfoe, one of the seven houses of the Silver Fang tribe."
	icon_state = "house_wyrmfoe"

/obj/effect/decal/garou_glyph/siberakh
	name = "unusual glyph"
	garou_name = "siberakh glyph"
	garou_desc = "A glyph that represents the Siberakh, a secretive tribe known only to the Silver Fangs and Galestalkers."
	icon_state = "siberakh"

/obj/effect/decal/garou_glyph/impergium
	name = "fear-inducing glyph"
	garou_name = "impergium glyph"
	garou_desc = "A glyph that represents the Impergium, the time when Garou hunted man also known as the First War."
	icon_state = "impergium"

/obj/effect/decal/garou_glyph/litany
	name = "pointed glyph"
	garou_name = "litany glyph"
	garou_desc = "A glyph that represents the Litany, the sacred laws of which all of the Garou Nation are bound to follow."
	icon_state = "litany"

/obj/effect/decal/garou_glyph/pack
	name = "square glyph"
	garou_name = "pack glyph"
	garou_desc = "A glyph that represents the pack, the closest-knit unit of the Garou."
	icon_state = "pack"

/obj/effect/decal/garou_glyph/moot
	name = "bowl glyph"
	garou_name = "moot glyph"
	garou_desc = "A glyph that represents a moot, a great gathering of Garou."
	icon_state = "moot"

/obj/effect/decal/garou_glyph/weaver
	name = "grid glyph"
	garou_name = "weaver glyph"
	garou_desc = "A glyph that represents the Weaver, primal spirit of stasis and immutability."
	icon_state = "weaver"

/obj/effect/decal/garou_glyph/defiler_wyrm
	name = "tempting glyph"
	garou_name = "defiler wyrm glyph"
	garou_desc = "A glyph that represents the Defiler Wyrm, the corrupting aspect of the Triatic Wyrm."
	icon_state = "defiler_wyrm"

/obj/effect/decal/garou_glyph/beast_of_war
	name = "dangerous glyph"
	garou_name = "beast of war glyph"
	garou_desc = "A glyph that represents the Beast of War, the violent aspect of the Triatic Wyrm."
	icon_state = "beast_of_war"

/obj/effect/decal/garou_glyph/eater_of_souls
	name = "empty glyph"
	garou_name = "eater of souls glyph"
	garou_desc = "A glyph that represents the Eater of Souls, the creation-hungry aspect of the Triatic Wyrm."
	icon_state = "eater_of_souls"

/obj/effect/decal/garou_glyph/wyld
	name = "chaotic glyph"
	garou_name = "wyld glyph"
	garou_desc = "A glyph that represents the Wyld, the primal spirit of life and creation."
	icon_state = "wyld"

/obj/effect/decal/garou_glyph/umbra
	name = "inconspicuous glyph"
	garou_name = "umbra glyph"
	garou_desc = "A glyph that represents the Umbra, the realm of spirits that exists sideways of the physical plane."
	icon_state = "umbra"

/obj/effect/decal/garou_glyph/luna
	name = "circle glyph"
	garou_name = "luna glyph"
	garou_desc = "A glyph that represents Luna, the moon spirit which granted the Garou their rage."
	icon_state = "luna"

/obj/effect/decal/garou_glyph/helios
	name = "compass glyph"
	garou_name = "helios glyph"
	garou_desc = "A glyph that represents Helios, the sun spirit which granted the Corax their light."
	icon_state = "helios"

/obj/effect/decal/garou_glyph/fish
	name = "fishy glyph"
	garou_name = "fish glyph"
	garou_desc = "A glyph that represents fish."
	icon_state = "fish"

/obj/effect/decal/garou_glyph/forest
	name = "small glyph"
	garou_name = "forest glyph"
	garou_desc = "A glyph that represents the forest."
	icon_state = "forest"

/obj/effect/decal/garou_glyph/ally
	name = "reassuring glyph"
	garou_name = "ally glyph"
	garou_desc = "A glyph that represents an alliance."
	icon_state = "ally"

/obj/effect/decal/garou_glyph/rite
	name = "subtle glyph"
	garou_name = "rite glyph"
	garou_desc = "A glyph that represents a rite, the sacred rituals of the Fera."
	icon_state = "rite"

/obj/effect/decal/garou_glyph/moon_bridge
	name = "crossed glyph"
	garou_name = "moon bridge glyph"
	garou_desc = "A glyph that represents a moon bridge, that which allows for travel between the physical plane and the Umbra."
	icon_state = "moon_bridge"

/obj/effect/decal/garou_glyph/chimera
	name = "imposing glyph"
	garou_name = "chimera glyph"
	garou_desc = "A glyph that represents Chimera, the totem spirit of the Stargazers."
	icon_state = "chimera"

/obj/effect/decal/garou_glyph/cockroach
	name = "gross glyph"
	garou_name = "cockroach glyph"
	garou_desc = "A glyph that represents Cockroach, the totem spirit of the Glasswalkers."
	icon_state = "cockroach"

/obj/effect/decal/garou_glyph/falcon
	name = "gazing glyph"
	garou_name = "falcon glyph"
	garou_desc = "A glyph that represents Falcon, the totem spirit of the Silver Fangs."
	icon_state = "falcon"

/obj/effect/decal/garou_glyph/fenris
	name = "carved glyph"
	garou_name = "fenris glyph"
	garou_desc = "A glyph that represents Fenris, the totem spirit of the Get of Fenris."
	icon_state = "fenris"

/obj/effect/decal/garou_glyph/griffin
	name = "unsettling glyph"
	garou_name = "griffin glyph"
	garou_desc = "A glyph that represents Griffin, the totem spirit of the Red Talons."
	icon_state = "griffin"

/obj/effect/decal/garou_glyph/owl
	name = "perched glyph"
	garou_name = "owl glyph"
	garou_desc = "A glyph that represents Owl, the totem spirit of the Silent Striders."
	icon_state = "owl"

/obj/effect/decal/garou_glyph/grandfather_thunder
	name = "weathered glyph"
	garou_name = "grandfather thunder glyph"
	garou_desc = "A glyph that represents Grandfather Thunder, the totem spirit of the Shadow Lords."
	icon_state = "grandfather_thunder"

/obj/effect/decal/garou_glyph/pegasus
	name = "swift glyph"
	garou_name = "pegasus glyph"
	garou_desc = "A glyph that represents Pegasus, the totem spirit of the Black Furies."
	icon_state = "pegasus"

/obj/effect/decal/garou_glyph/rat
	name = "nasty glyph"
	garou_name = "rat glyph"
	garou_desc = "A glyph that represents Rat, the totem spirit of the Bonegnawers."
	icon_state = "rat"

/obj/effect/decal/garou_glyph/stag
	name = "horned glyph"
	garou_name = "stag glyph"
	garou_desc = "A glyph that represents Stag, the totem spirit of the Fianna."
	icon_state = "stag"

/obj/effect/decal/garou_glyph/horned_serpent
	name = "slithery glyph"
	garou_name = "horned serpent glyph"
	garou_desc = "A glyph that represents Horned Serpent, the totem spirit of the Uktena, also known as the Ghost Council."
	icon_state = "horned_serpent"

/obj/effect/decal/garou_glyph/unicorn
	name = "noble glyph"
	garou_name = "unicorn glyph"
	garou_desc = "A glyph that represents Unicorn, the totem spirit of the Children of Gaia."
	icon_state = "unicorn"

/obj/effect/decal/garou_glyph/north_wind
	name = "simple glyph"
	garou_name = "north wind glyph"
	garou_desc = "A glyph that represents North Wind, the totem spirit of the " + TRIBE_GALESTALKERS + "."
	icon_state = "north_wind"

/obj/effect/decal/garou_glyph/gun
	name = "smoking glyph"
	garou_name = "gun glyph"
	garou_desc = "A glyph that represents a gun."
	icon_state = "gun"

/obj/effect/decal/garou_glyph/path
	name = "meandering glyph"
	garou_name = "path glyph"
	garou_desc = "A glyph that represents a pathway."
	icon_state = "path"

/obj/effect/decal/garou_glyph/urge_wyrm
	name = "alluring glyph"
	garou_name = "urge wyrm glyph"
	garou_desc = "A glyph that represents the Urge Wyrms, spiritual entities that can corrupt the mind."
	icon_state = "urge_wyrm"

/obj/effect/decal/garou_glyph/radiation
	name = "glowing glyph"
	garou_name = "radiation glyph"
	garou_desc = "A glyph that represents radiation, that which can defile life like little else can."
	icon_state = "radiation"

/obj/effect/decal/garou_glyph/spirit
	name = "abstract glyph"
	garou_name = "spirit glyph"
	garou_desc = "A glyph that represents a spiritual presence."
	icon_state = "spirit"

/obj/effect/decal/garou_glyph/mend
	name = "cross glyph"
	garou_name = "mend glyph"
	garou_desc = "A glyph that represents a call to mend or repair a place, thing, or person."
	icon_state = "mend"

/obj/effect/decal/garou_glyph/safety
	name = "reassuring glyph"
	garou_name = "safety glyph"
	garou_desc = "A glyph that represents a place of safety."
	icon_state = "safety"

/obj/effect/decal/garou_glyph/suffering
	name = "upsetting glyph"
	garou_name = "suffering glyph"
	garou_desc = "A glyph that represents a state or place of suffering."
	icon_state = "suffering"

/obj/effect/decal/garou_glyph/regeneration
	name = "calming glyph"
	garou_name = "regeneration glyph"
	garou_desc = "A glyph that represents a state or place of regeneration and healing."
	icon_state = "regeneration"

/obj/effect/decal/garou_glyph/storm
	name = "lightning glyph"
	garou_name = "storm glyph"
	garou_desc = "A glyph that represents a storm, in all its might."
	icon_state = "storm"

/obj/effect/decal/garou_glyph/story
	name = "weird glyph"
	garou_name = "story glyph"
	garou_desc = "A glyph that represents a place of storytelling, or is used to tell a story in glyphs."
	icon_state = "story"

/obj/effect/decal/garou_glyph/totem
	name = "involved glyph"
	garou_name = "totem glyph"
	garou_desc = "A glyph that represents a totem, a spirit which watches over a tribe of Garou."
	icon_state = "totem"

/obj/effect/decal/garou_glyph/cyberrealm
	name = "messy glyph"
	garou_name = "cyberrealm glyph"
	garou_desc = "A glyph that represents CyberRealm, the spiritual realm of the internet."
	icon_state = "cyberspace"

/obj/effect/decal/garou_glyph/wolfhome
	name = "feral glyph"
	garou_name = "wolfhome glyph"
	garou_desc = "A glyph that represents Wolfhome, a a primeval spirit realm of endless forest in which dwell the spirits of wolf packs and their prey."
	icon_state = "wolfhome"

/obj/effect/decal/garou_glyph/malfeas
	name = "bone-chilling glyph"
	garou_name = "malfeas glyph"
	garou_desc = "A glyph that represents Malfeas, a dark realm of the Umbra that lies within the Maw of the Wyrm."
	icon_state = "malfeas"

/obj/effect/decal/garou_glyph/aetherial
	name = "dazzling glyph"
	garou_name = "aetherial glyph"
	garou_desc = "A glyph that represents the Aetherial, an umbral realm housing the Spirit Wilds."
	icon_state = "aetherial"

/obj/effect/decal/garou_glyph/arcadia_gateway
	name = "loopy glyph"
	garou_name = "arcadia gateway glyph"
	garou_desc = "A glyph that represents the Arcadia Gateway, a land resembling the mythical home of the Fae deep in the Middle Umbra."
	icon_state = "arcadia_gateway"

/obj/effect/decal/garou_glyph/atrocity_realm
	name = "fetid glyph"
	garou_name = "atrocity realm glyph"
	garou_desc = "A glyph that represents the Atrocity Realm, the breeding ground of Banes."
	icon_state = "atrocity_realm"

/obj/effect/decal/garou_glyph/battleground
	name = "tattered glyph"
	garou_name = "battleground glyph"
	garou_desc = "A glyph that represents Battleground, the Near Realm which contains all battles and conflict ever fought."
	icon_state = "battleground"

/obj/effect/decal/garou_glyph/erebus
	name = "pointed glyph"
	garou_name = "erebus glyph"
	garou_desc = "A glyph that represents Erebus, a realm of spiritual cleansing often compared to hell."
	icon_state = "erebus"

/obj/effect/decal/garou_glyph/flux
	name = "wild glyph"
	garou_name = "flux glyph"
	garou_desc = "A glyph that represents the Flux, a Near Realm of pure, undiluted Wyld energy untouched by the Weaver."
	icon_state = "flux"

/obj/effect/decal/garou_glyph/legendary_realm
	name = "powerful glyph"
	garou_name = "legendary realm glyph"
	garou_desc = "A glyph that represents the Legendary Realm, the place Garou can walk to live the lives of their ancestors."
	icon_state = "legendary_realm"

/obj/effect/decal/garou_glyph/pangaea
	name = "primal glyph"
	garou_name = "pangaea glyph"
	garou_desc = "A glyph that represents Pangaea, a Middle Realm reflecting the Earth as it was before civilization, history, and the end of the Impergium."
	icon_state = "pangaea"

/obj/effect/decal/garou_glyph/the_scar
	name = "ugly glyph"
	garou_name = "scar glyph"
	garou_desc = "A glyph that represents the Scar, the Near Realm which reflects the industrial revolution, its oppression and pollution."
	icon_state = "the_scar"

/obj/effect/decal/garou_glyph/summer_country
	name = "impressive glyph"
	garou_name = "summer country glyph"
	garou_desc = "A glyph that represents the Summer Country, a quickly fading Middle Realm that is said to embody Gaia's pure love for her children."
	icon_state = "summer_country"

/obj/effect/decal/garou_glyph/pollution
	name = "arched glyph"
	garou_name = "pollution glyph"
	garou_desc = "A glyph that represents pollution, the industrial spread of the Wyrm's taint."
	icon_state = "pollution"

/obj/effect/decal/garou_glyph/ananasi
	name = "spindly glyph"
	garou_name = "ananasi glyph"
	garou_desc = "A glyph that represents the Ananasi, the Fera blessed with the power to shift between man and spider."
	icon_state = "ananasi"

/obj/effect/decal/garou_glyph/nagah
	name = "fanged glyph"
	garou_name = "nagah glyph"
	garou_desc = "A glyph that represents the Nagah, the Fera blessed with the power to shift between man and snake."
	icon_state = "nagah"

/obj/effect/decal/garou_glyph/fire
	name = "smokey glyph"
	garou_name = "fire glyph"
	garou_desc = "A glyph that represents fire, a primeval force of destruction."
	icon_state = "fire"

/obj/effect/decal/garou_glyph/bane
	name = "concerning glyph"
	garou_name = "bane glyph"
	garou_desc = "A glyph that represents the presence of Banes, spirits corrupted by the Wyrm."
	icon_state = "bane"

/obj/effect/decal/garou_glyph/fomori
	name = "boxed glyph"
	garou_name = "fomori glyph"
	garou_desc = "A glyph that represents the Fomori, a diverse group of bane-possessed mortals mutated by the Wyrm's servants."
	icon_state = "fomori"

/obj/effect/decal/garou_glyph/therapy
	name = "relaxing glyph"
	garou_name = "therapy glyph"
	garou_desc = "A glyph that represents a state or place of therapy."
	icon_state = "therapy"

/obj/effect/decal/garou_glyph/ragabash
	name = "oval glyph"
	garou_name = "ragabash glyph"
	garou_desc = "A glyph that represents the Ragabash, the trickster and contrarian auspice."
	icon_state = "ragabash"

/obj/effect/decal/garou_glyph/theurge
	name = "crested glyph"
	garou_name = "theurge glyph"
	garou_desc = "A glyph that represents the Theurge, the auspice of spirits and healing."
	icon_state = "theurge"

/obj/effect/decal/garou_glyph/philodox
	name = "crescent glyph"
	garou_name = "philodox glyph"
	garou_desc = "A glyph that represents the Philodox, the auspice of judgement and truth."
	icon_state = "philodox"

/obj/effect/decal/garou_glyph/galliard
	name = "gashed glyph"
	garou_name = "galliard glyph"
	garou_desc = "A glyph that represents the Galliard, auspice of storytelling, inspiration, and teaching."
	icon_state = "galliard"

/obj/effect/decal/garou_glyph/ahroun
	name = "circular glyph"
	garou_name = "ahroun glyph"
	garou_desc = "A glyph that represents the Ahroun, the auspice of rage and power."
	icon_state = "ahroun"

/obj/effect/decal/garou_glyph/homid
	name = "rigid glyph"
	garou_name = "homid glyph"
	garou_desc = "A glyph that represents both humans, and the Homidborn Garou born from them."
	icon_state = "homid"

/obj/effect/decal/garou_glyph/crinos
	name = "unsavory glyph"
	garou_name = "crinos glyph"
	garou_desc = "A glyph that represents the Crinos, warborn children of a forbidden Garou pairing."
	icon_state = "crinos"

/obj/effect/decal/garou_glyph/lupus
	name = "sharp glyph"
	garou_name = "lupus glyph"
	garou_desc = "A glyph that represents both wolves, and the Lupusborn Garou born from them."
	icon_state = "lupus"

/obj/effect/decal/garou_glyph/bunyip
	name = "sorrowful glyph"
	garou_name = "bunyip glyph"
	garou_desc = "A glyph that represents the Bunyip, a lost Garou tribe of marsupial thylacines."
	icon_state = "bunyip"

/obj/effect/decal/garou_glyph/croatan
	name = "lost glyph"
	garou_name = "croatan glyph"
	garou_desc = "A glyph that represents the Croatan, the Middle Brother of the Pure tribes, who sacrificed themselves to impede the Corrupting Wyrm."
	icon_state = "croatan"

/obj/effect/decal/garou_glyph/gnosis
	name = "energized glyph"
	garou_name = "gnosis glyph"
	garou_desc = "A glyph that represents gnosis, the welling of the chaotic energies of the Wyld in the self."
	icon_state = "gnosis"

/obj/effect/decal/garou_glyph/glory
	name = "proud glyph"
	garou_name = "glory glyph"
	garou_desc = "A glyph that represents glory, a form of Garou renown honoring prowess."
	icon_state = "glory"

/obj/effect/decal/garou_glyph/honor
	name = "noble glyph"
	garou_name = "honor glyph"
	garou_desc = "A glyph that represents honor, a form of Garou renown honoring respect."
	icon_state = "honor"

/obj/effect/decal/garou_glyph/wisdom
	name = "telling glyph"
	garou_name = "wisdom glyph"
	garou_desc = "A glyph that represents wisdom, a form of Garou renown honoring knowledge."
	icon_state = "wisdom"

/obj/effect/decal/garou_glyph/lost_cub
	name = "wandering glyph"
	garou_name = "lost cub glyph"
	garou_desc = "A glyph that represents a lost cub, a young Garou who has yet to find their way."
	icon_state = "lost_cub"

/obj/effect/decal/garou_glyph/silver_pack
	name = "venerable glyph"
	garou_name = "silver pack glyph"
	garou_desc = "A glyph that represents the Silver Pack, the heroic first pack to form in Garou history."
	icon_state = "silver_pack"

/obj/effect/decal/garou_glyph/silver_record
	name = "storied glyph"
	garou_name = "silver record glyph"
	garou_desc = "A glyph that represents the Silver Record, the written histories of the Garou nation."
	icon_state = "silver_record"

/obj/effect/decal/garou_glyph/klaive
	name = "dagger glyph"
	garou_name = "klaive glyph"
	garou_desc = "A glyph that represents a klaive, a spiritually potent dagger nearly always made of silver."
	icon_state = "klaive"

/obj/effect/decal/garou_glyph/war_of_rage
	name = "devastating glyph"
	garou_name = "war of rage glyph"
	garou_desc = "A glyph that represents the War of Rage, when the Garou destroyed most of the other Fera breeds."
	icon_state = "war_of_rage"

/obj/effect/decal/garou_glyph/gaia
	name = "worldly glyph"
	garou_name = "gaia glyph"
	garou_desc = "A glyph that represents Gaia, the living spirit of the earth, or even existence itself."
	icon_state = "gaia"

/obj/effect/decal/garou_glyph/star
	name = "pointy glyph"
	garou_name = "star glyph"
	garou_desc = "A glyph that represents a star, a shining spirit in the Umbra."
	icon_state = "star"

/obj/effect/decal/garou_glyph/animal
	name = "feral glyph"
	garou_name = "animal glyph"
	garou_desc = "A glyph that represents the animals and beasts."
	icon_state = "animal"

/obj/effect/decal/garou_glyph/horse
	name = "tasty glyph"
	garou_name = "horse glyph"
	garou_desc = "A glyph that represents horses, and by extension prey animals in general."
	icon_state = "horse"

/obj/effect/decal/garou_glyph/claw
	name = "line glyph"
	garou_name = "claw glyph"
	garou_desc = "A glyph that represents a singular claw."
	icon_state = "claw"

/obj/effect/decal/garou_glyph/tooth
	name = "curved glyph"
	garou_name = "tooth glyph"
	garou_desc = "A glyph that represents tooth and fang."
	icon_state = "tooth"

/obj/effect/decal/garou_glyph/bone
	name = "teardrop glyph"
	garou_name = "bone glyph"
	garou_desc = "A glyph that represents a bone."
	icon_state = "bone"

/obj/effect/decal/garou_glyph/wilderness
	name = "creeping glyph"
	garou_name = "wilderness glyph"
	garou_desc = "A glyph that represents the wilderness, the Wyld places where Weaver and Wyrm are weakest."
	icon_state = "wilderness"

/obj/effect/decal/garou_glyph/mountain
	name = "imposing glyph"
	garou_name = "mountain glyph"
	garou_desc = "A glyph that represents the mountains."
	icon_state = "mountain"

/obj/effect/decal/garou_glyph/desert
	name = "arid glyph"
	garou_name = "desert glyph"
	garou_desc = "A glyph that represents the deserts and the wastes, natural and unnatural places of the Wyrm."
	icon_state = "desert"

/obj/effect/decal/garou_glyph/air
	name = "curved glyph"
	garou_name = "air glyph"
	garou_desc = "A glyph that represents the air."
	icon_state = "air"

/obj/effect/decal/garou_glyph/water
	name = "wavy glyph"
	garou_name = "water glyph"
	garou_desc = "A glyph that represents water."
	icon_state = "water"

/obj/effect/decal/garou_glyph/metal
	name = "gash glyph"
	garou_name = "metal glyph"
	garou_desc = "A glyph that represents metal, often silver but in a non-violent context."
	icon_state = "metal"

/obj/effect/decal/garou_glyph/dark
	name = "shadowy glyph"
	garou_name = "dark glyph"
	garou_desc = "A glyph that represents the darkness."
	icon_state = "dark"

/obj/effect/decal/garou_glyph/stone
	name = "rigid glyph"
	garou_name = "stone glyph"
	garou_desc = "A glyph that represents stones, natural domain of the Weaver."
	icon_state = "stone"

/obj/effect/decal/garou_glyph/snow
	name = "cold glyph"
	garou_name = "snow glyph"
	garou_desc = "A glyph that represents snow."
	icon_state = "snow"

/obj/effect/decal/garou_glyph/rain
	name = "wet glyph"
	garou_name = "rain glyph"
	garou_desc = "A glyph that represents rain."
	icon_state = "rain"

/obj/effect/decal/garou_glyph/lightning
	name = "electric glyph"
	garou_name = "lightning glyph"
	garou_desc = "A glyph that represents lightning."
	icon_state = "lightning"

/obj/effect/decal/garou_glyph/flood
	name = "rushing glyph"
	garou_name = "flood glyph"
	garou_desc = "A glyph that represents a flood."
	icon_state = "flood"

/obj/effect/decal/garou_glyph/winter
	name = "freezing glyph"
	garou_name = "winter glyph"
	garou_desc = "A glyph that represents the winter, the season of leaf-bare."
	icon_state = "winter"

/obj/effect/decal/garou_glyph/spring
	name = "blossoming glyph"
	garou_name = "spring glyph"
	garou_desc = "A glyph that represents the spring, the season of new-leaf."
	icon_state = "spring"

/obj/effect/decal/garou_glyph/summer
	name = "warming glyph"
	garou_name = "summer glyph"
	garou_desc = "A glyph that represents the summer, the season of green-leaf."
	icon_state = "summer"

/obj/effect/decal/garou_glyph/autumn
	name = "chilling glyph"
	garou_name = "autumn glyph"
	garou_desc = "A glyph that represents the autumn, the season of leaf-fall."
	icon_state = "autumn"

/obj/effect/decal/garou_glyph/north
	name = "notched glyph"
	garou_name = "north glyph"
	garou_desc = "A glyph that represents the Brightstar, which leads voyagers northwards."
	icon_state = "north"

/obj/effect/decal/garou_glyph/south
	name = "notched glyph"
	garou_name = "south glyph"
	garou_desc = "A glyph that represents the Awaystar, which leads voyagers southwards."
	icon_state = "south"

/obj/effect/decal/garou_glyph/east
	name = "notched glyph"
	garou_name = "east glyph"
	garou_desc = "A glyph that represents the Sunriseway, the eastward path where the sun rises from."
	icon_state = "east"

/obj/effect/decal/garou_glyph/west
	name = "notched glyph"
	garou_name = "west glyph"
	garou_desc = "A glyph that represents the Sundownway, the westward path where the sun sets to."
	icon_state = "west"

/obj/effect/decal/garou_glyph/life
	name = "breathing glyph"
	garou_name = "life glyph"
	garou_desc = "A glyph that represents the very nature of life itself."
	icon_state = "life"

/obj/effect/decal/garou_glyph/death
	name = "still glyph"
	garou_name = "death glyph"
	garou_desc = "A glyph that represents the very nature of death itself."
	icon_state = "death"

/obj/effect/decal/garou_glyph/peace
	name = "soothing glyph"
	garou_name = "peace glyph"
	garou_desc = "A glyph that represents peace. Is such a thing even possible?"
	icon_state = "peace"

/obj/effect/decal/garou_glyph/sacrifice
	name = "giving glyph"
	garou_name = "sacrifice glyph"
	garou_desc = "A glyph that represents the act of sacrifice."
	icon_state = "sacrifice"

/obj/effect/decal/garou_glyph/garou_nation
	name = "united glyph"
	garou_name = "garou nation glyph"
	garou_desc = "A glyph that represents the Garou Nation, the largest organization of Garou worldwide."
	icon_state = "garou_nation"

/obj/effect/decal/garou_glyph/rage
	name = "angry glyph"
	garou_name = "rage glyph"
	garou_desc = "A glyph that represents rage and frenzy, when Luna's gifts overpower the Garou."
	icon_state = "rage"

/obj/effect/decal/garou_glyph/birth
	name = "new glyph"
	garou_name = "birth glyph"
	garou_desc = "A glyph that represents birth, or the beginning of something new."
	icon_state = "birth"

/obj/effect/decal/garou_glyph/love
	name = "warm glyph"
	garou_name = "love glyph"
	garou_desc = "A glyph that represents love and affection."
	icon_state = "love"

/obj/effect/decal/garou_glyph/quest
	name = "galvanizing glyph"
	garou_name = "quest glyph"
	garou_desc = "A glyph that represents a quest, often an aisling for a spirit."
	icon_state = "quest"

/obj/effect/decal/garou_glyph/create
	name = "signed glyph"
	garou_name = "create glyph"
	garou_desc = "A glyph that represents the act of creating, or an author, artist, or creator."
	icon_state = "create"

/obj/effect/decal/garou_glyph/build
	name = "constructive glyph"
	garou_name = "build glyph"
	garou_desc = "A glyph that represents building, joining together, or putting pieces together."
	icon_state = "build"

/obj/effect/decal/garou_glyph/defiance
	name = "prideful glyph"
	garou_name = "defiance glyph"
	garou_desc = "A glyph that represents an act of defiance."
	icon_state = "defiance"

/obj/effect/decal/garou_glyph/time
	name = "long glyph"
	garou_name = "time glyph"
	garou_desc = "A glyph that represents time, or more literally a joining of the past, present, and future."
	icon_state = "time"

/obj/effect/decal/garou_glyph/cycle
	name = "circular glyph"
	garou_name = "cycle glyph"
	garou_desc = "A glyph that represents a cycle, or the act of recurrence."
	icon_state = "cycle"

/obj/effect/decal/garou_glyph/ancient
	name = "archaic glyph"
	garou_name = "ancient glyph"
	garou_desc = "A glyph that represents the First Times, or simply something ancient in general."
	icon_state = "ancient"

/obj/effect/decal/garou_glyph/branded
	name = "wounding glyph"
	garou_name = "branded glyph"
	garou_desc = "A glyph that represents something to be branded or scarred, or simply refers to a scar itself."
	icon_state = "branded"

/obj/effect/decal/garou_glyph/coward
	name = "meek glyph"
	garou_name = "coward glyph"
	garou_desc = "A glyph that represents a coward or weakling."
	icon_state = "coward"

/obj/effect/decal/garou_glyph/rival
	name = "antagonistic glyph"
	garou_name = "rival glyph"
	garou_desc = "A glyph that represents a rival, or rivalry between two things or concepts."
	icon_state = "rival"

/obj/effect/decal/garou_glyph/destructive
	name = "violent glyph"
	garou_name = "destruction/purity glyph"
	garou_desc = "A glyph that represents brutal destruction, purification, or silver in a violent context."
	icon_state = "destructive"

/obj/effect/decal/garou_glyph/minotaur
	name = "demeaning glyph"
	garou_name = "minotaur glyph"
	garou_desc = "A glyph that represents Minotaur, a spirit that Stolen Moons often make pacts with.."
	icon_state = "minotaur"

/obj/effect/decal/garou_glyph/quick
	name = "rushed glyph"
	garou_name = "quick glyph"
	garou_desc = "A glyph that represents speed and quickness."
	icon_state = "quick"

/obj/effect/decal/garou_glyph/resilient
	name = "enduring glyph"
	garou_name = "resilient glyph"
	garou_desc = "A glyph that represents resilience, the strength to hold strong against impossible odds."
	icon_state = "resilient"

/obj/effect/decal/garou_glyph/hungry
	name = "begging glyph"
	garou_name = "hungry glyph"
	garou_desc = "A glyph that represents being hungry, or a state of hunger. Often used to mark food sources in cities."
	icon_state = "hungry"

/obj/effect/decal/garou_glyph/cold
	name = "chilly glyph"
	garou_name = "cold glyph"
	garou_desc = "A glyph that represents the cold itself."
	icon_state = "cold"

/obj/effect/decal/garou_glyph/wounded
	name = "painful glyph"
	garou_name = "wounded glyph"
	garou_desc = "A glyph that represents being wounded, or a state of hurt."
	icon_state = "wounded"

/obj/effect/decal/garou_glyph/eldered
	name = "elaborate glyph"
	garou_name = "eldered glyph"
	garou_desc = "A glyph that used for those who have become elders, or for those revered or wise."
	icon_state = "eldered"

/obj/effect/decal/garou_glyph/help
	name = "desperate glyph"
	garou_name = "help glyph"
	garou_desc = "A glyph that can both represent a cry or a promise for help."
	icon_state = "help"

/obj/effect/decal/garou_glyph/solar_eclipse
	name = "masked glyph"
	garou_name = "solar eclipse glyph"
	garou_desc = "A glyph that represents the solar eclipse, when Helios' light is covered by Luna's rage."
	icon_state = "solar_eclipse"

/obj/effect/decal/garou_glyph/lunar_eclipse
	name = "casted glyph"
	garou_name = "lunar eclipse glyph"
	garou_desc = "A glyph that represents the lunar eclipse, when Luna becomes red with rage."
	icon_state = "lunar_eclipse"

/obj/effect/decal/garou_glyph/legend
	name = "notable glyph"
	garou_name = "legend glyph"
	garou_desc = "A glyph that represents a legend, the stories of old or ancestors who achieved greatness."
	icon_state = "legend"

/obj/effect/decal/garou_glyph/mate
	name = "bound glyph"
	garou_name = "mate glyph"
	garou_desc = "A glyph that represents a mate, a partner one often holds for life."
	icon_state = "mate"

/obj/effect/decal/garou_glyph/rite
	name = "spiritual glyph"
	garou_name = "rite glyph"
	garou_desc = "A glyph that represents a rite, a Garou ritual used to fulfill a variety of functions."
	icon_state = "rite"

/obj/effect/decal/garou_glyph/realm
	name = "marked glyph"
	garou_name = "realm glyph"
	garou_desc = "A glyph that represents a realm, a pocket within the Umbra that concentrates a specific element of spiritual focus."
	icon_state = "realm"

/obj/effect/decal/garou_glyph/rite_of_passage
	name = "staring glyph"
	garou_name = "rite of passage glyph"
	garou_desc = "A glyph marking the rite of passage, a quest which leads young cubs to take on a tribe, spirit, and join the nation as a cliath."
	icon_state = "rite_of_passage"

/obj/effect/decal/garou_glyph/rite_of_binding
	name = "chained glyph"
	garou_name = "rite of binding glyph"
	garou_desc = "A glyph marking the rite of binding, which makes a spirit into ones servant. Generally, this is an agreed upon process for a temporary time, or an investiture into a talen"
	icon_state = "rite_of_binding"

/obj/effect/decal/garou_glyph/rite_of_the_fetish
	name = "convoluted glyph"
	garou_name = "rite of the fetish glyph"
	garou_desc = "A glyph marking the rite of the fetish, which binds a spirit into an object. Traditionally, the object must be cleansed for three consecutive nights in running water, pure earth, constant breeze or suspended above flame, before persuading or coercing the spirit inside. Fianna will flatter, Bone Gnawers and Silent Striders will bribe."
	icon_state = "rite_of_the_fetish"

/obj/effect/decal/garou_glyph/fetish
	name = "chaotic glyph"
	garou_name = "fetish glyph"
	garou_desc = "A glyph that represents a fetish, an object with a waking spirit inside of it."
	icon_state = "fetish"

/obj/effect/decal/garou_glyph/celestine
	name = "divine glyph"
	garou_name = "celestine glyph"
	garou_desc = "A glyph that represents one of the Celestine, powerful spirits such as Helios and Luna which are alike to Gods."
	icon_state = "celestine"

/obj/effect/decal/garou_glyph/incarna
	name = "angelic glyph"
	garou_name = "incarna glyph"
	garou_desc = "A glyph that represents the Incarna, powerful spirits that sit below the Celestine."
	icon_state = "incarna"

/obj/effect/decal/garou_glyph/deep_umbra
	name = "abstract glyph"
	garou_name = "deep umbra glyph"
	garou_desc = "A glyph that represents the Deep Umbra, the vast realm beyond the realms where abstract thought and concepts linger."
	icon_state = "deep_umbra"

/obj/effect/decal/garou_glyph/dark_umbra
	name = "final glyph"
	garou_name = "dark umbra glyph"
	garou_desc = "A glyph that represents the Dark Umbra, the domain of memories and the dead."
	icon_state = "dark_umbra"

/obj/effect/decal/garou_glyph/spirit_wilds
	name = "scratchy glyph"
	garou_name = "spirit wilds glyph"
	garou_desc = "A glyph that represents the Spirit Wilds, the vast realm reflective of Gaia's wild places, those that remain and those defiled."
	icon_state = "spirit_wilds"

/obj/effect/decal/garou_glyph/city
	name = "arched glyph"
	garou_name = "city glyph"
	garou_desc = "A glyph that represents the city, domain of man and the Weaver."
	icon_state = "city"

/obj/effect/decal/garou_glyph/building
	name = "structured glyph"
	garou_name = "building glyph"
	garou_desc = "A glyph that represents a building - dens of stone, concrete and lumber heavily influenced by the Weaver."
	icon_state = "building"

/obj/effect/decal/garou_glyph/gate
	name = "arch glyph"
	garou_name = "gate glyph"
	garou_desc = "A glyph that represents a gate, or an entrance to a city or a passage of Weaver design."
	icon_state = "gate"

/obj/effect/decal/garou_glyph/park
	name = "contained glyph"
	garou_name = "park glyph"
	garou_desc = "A glyph that represents a park, a small protected pocket of Wyld surrounded by mankind."
	icon_state = "park"

/obj/effect/decal/garou_glyph/monster
	name = "dangerous glyph"
	garou_name = "monster glyph"
	garou_desc = "A glyph that represents a monster."
	icon_state = "monster"

/obj/effect/decal/garou_glyph/abomination
	name = "horrifying glyph"
	garou_name = "abomination glyph"
	garou_desc = "A glyph that represents an abomination, a Garou tainted by the Eater-Of-Souls to become a leech in spite Luna's power."
	icon_state = "abomination"

/obj/effect/decal/garou_glyph/uktena
	name = "curious glyph"
	garou_name = "uktena glyph"
	garou_desc = "A glyph that represents the Uktena, one of the Garou tribes."
	icon_state = "uktena"

/obj/effect/decal/garou_glyph/jump
	name = "airy glyph"
	garou_name = "jump glyph"
	garou_desc = "A glyph that represents jumping, to lift oneself away from Gaia and ride with the wind."
	icon_state = "jump"

/obj/effect/decal/garou_glyph/sex
	name = "impassioned glyph"
	garou_name = "sex glyph"
	garou_desc = "A glyph that represents sex, the expression of love between mates - generally to bare children."
	icon_state = "sex"

/obj/effect/decal/garou_glyph/pregnant
	name = "nurturing glyph"
	garou_name = "pregnant glyph"
	garou_desc = "A glyph that represents pregnancy, the sacred and vital growth of new life and progeny."
	icon_state = "pregnant"

/obj/effect/decal/garou_glyph/sun
	name = "bright glyph"
	garou_name = "sun incarna glyph"
	garou_desc = "A glyph that represents Katanka-Sonnak, the Wind Rider, Incarna of the Sun, and aspect of Helios."
	icon_state = "sun"

/obj/effect/decal/garou_glyph/mercury
	name = "hot glyph"
	garou_name = "mercury incarna glyph"
	garou_desc = "A glyph that represents Mitanu, Incarna of Mercury. He is a trickster and lover of comedy."
	icon_state = "mercury"

/obj/effect/decal/garou_glyph/vulcan
	name = "unremarkable glyph"
	garou_name = "vulcan incarna glyph"
	garou_desc = "A glyph that represents Hakahe, Incarna of Vulcan. He respects secrecy, darkness, and silence, and favors the Uktena. Modern humans have lost their belief in him."
	icon_state = "vulcan"

/obj/effect/decal/garou_glyph/venus
	name = "shrouded glyph"
	garou_name = "venus incarna glyph"
	garou_desc = "A glyph that represents Tambiyah, Veiled Mother and Incarna of Venus. She respects balance, wisdom, and justice, favoring the Black Furies and others who aspire to her aspects."
	icon_state = "venus"

/obj/effect/decal/garou_glyph/earth
	name = "homely glyph"
	garou_name = "earth incarna glyph"
	garou_desc = "A glyph that represents Eshtarra, Songteller and Incarna of Earth. She is considered an aspect of the Great Mother herself, with an emphasis on music, fertility, and defensive combat."
	icon_state = "earth"

/obj/effect/decal/garou_glyph/moon
	name = "dark glyph"
	garou_name = "moon incarna glyph"
	garou_desc = "A glyph that represents Sokhta, the Lambent Lady and Incarna of the Moon. She is an aspect of Luna, the Moon of Eshtarra who emphasises tranquility, reflection, and meditation."
	icon_state = "moon"

/obj/effect/decal/garou_glyph/mars
	name = "intense glyph"
	garou_name = "mars incarna glyph"
	garou_desc = "A glyph that represents Nerigal, the Ice Warrior and Incarna of Mars. Also known as the Bloodied One, he is known to respect assertiveness and strong will."
	icon_state = "mars"

/obj/effect/decal/garou_glyph/asteroid_belt
	name = "foreboding glyph"
	garou_name = "asteroid belt incarna glyph"
	garou_desc = "A glyph that represents Rorg, the Many Taloned Hunter, Incarna of Turog, the destroyed planet that makes up the asteroid belt. He represents catastrophic change and doom."
	icon_state = "asteroid_belt"

/obj/effect/decal/garou_glyph/jupiter
	name = "regal glyph"
	garou_name = "jupiter incarna glyph"
	garou_desc = "A glyph that represents Zarok, the Incarna of Jupiter. He represents wisdom and authority, with a particular liking for the Silver Fangs."
	icon_state = "jupiter"

/obj/effect/decal/garou_glyph/saturn
	name = "quaint glyph"
	garou_name = "saturn incarna glyph"
	garou_desc = "A glyph that represents Lu-Bat, the Peaceful Counselor and Incarna of Saturn. He represents peace, acceptance, and wisdom, favoring the Children of Gaia."
	icon_state = "saturn"

/obj/effect/decal/garou_glyph/uranus
	name = "snaking glyph"
	garou_name = "uranus incarna glyph"
	garou_desc = "A glyph that represents Ruatma, the Shadowed One and Incarna of Uranus. He represents diplomacy and seeking hidden meaning, with a particular favor for the Shadow Lords."
	icon_state = "uranus"

/obj/effect/decal/garou_glyph/neptune
	name = "ravaged glyph"
	garou_name = "neptune incarna glyph"
	garou_desc = "A glyph that represents Shantar, the Loom Maker and Incarna of Neptune. She represents invention in particular, but also change, with a particular favor for the Glasswalkers."
	icon_state = "neptune"

/obj/effect/decal/garou_glyph/pluto
	name = "waving glyph"
	garou_name = "pluto incarna glyph"
	garou_desc = "A glyph that represents Meros, the Incarna of Pluto. His compulsion is to a relentless search of truth leading to inevitable death. As such, he represents death, truth, and questing, favoring the Silent Striders."
	icon_state = "pluto"

/obj/effect/decal/garou_glyph/red_star
	name = "perplexing glyph"
	garou_name = "red star glyph"
	garou_desc = "A glyph that represents Anthelios, the Red Star. It has only existed for but a decade... what does it mean?"
	icon_state = "red_star"

/obj/effect/decal/garou_glyph/storm_eater
	name = "imposing glyph"
	garou_name = "storm eater glyph"
	garou_desc = "A glyph that represents Storm Eater, a dreadful bane that threatened the Pure Lands in the times after the Wyrmcoming."
	icon_state = "storm_eater"

/obj/effect/decal/garou_glyph/ape_warders
	name = "archaic glyph"
	garou_name = "warders of apes glyph"
	garou_desc = "A glyph that represents the Ape Warders, the first name of the Glasswalkers when humans lived in simple villages."
	icon_state = "ape_warders"

/obj/effect/decal/garou_glyph/man_warders
	name = "ancient glyph"
	garou_name = "warders of man glyph"
	garou_desc = "A glyph that represents the Man Warders, the second name of the Glasswalkers that came as their villages expanded."
	icon_state = "man_warders"

/obj/effect/decal/garou_glyph/iron_riders
	name = "industrial glyph"
	garou_name = "iron riders glyph"
	garou_desc = "A glyph that represents the Iron Riders, the third name of the Glasswalkers that came as metallurgy expanded."
	icon_state = "iron_riders"

/obj/effect/decal/garou_glyph/claws
	name = "sharp glyph"
	garou_name = "claws glyph"
	garou_desc = "A glyph that represents many claws."
	icon_state = "claws"

/obj/effect/decal/garou_glyph/pelt
	name = "stolen glyph"
	garou_name = "pelt glyph"
	garou_desc = "A glyph that represents a pelt, whether the skin of animals often stolen by humans, or the pelts they wear."
	icon_state = "pelt"

/obj/effect/decal/garou_glyph/king
	name = "regal glyph"
	garou_name = "king glyph"
	garou_desc = "A glyph that represents a King, the human term for a patriarchal and absolute ruler often used by the Silver Fangs."
	icon_state = "king"

/obj/effect/decal/garou_glyph/nameless
	name = "lost glyph"
	garou_name = "nameless storyteller glyph"
	garou_desc = "A nameless glyph, often used by storytellers or for other purposes where one is missing a name."
	icon_state = "nameless"

/obj/effect/decal/garou_glyph/appalachia
	name = "homey glyph"
	garou_name = "appalachia glyph"
	garou_desc = "A glyph that represents Appalachia, the name of a mountain range in the Pure Lands."
	icon_state = "appalachia"

/obj/effect/decal/garou_glyph/new_york
	name = "caged glyph"
	garou_name = "new york glyph"
	garou_desc = "A glyph that represents New York, a state in America after the Wyrmcoming, and home to dense human populations."
	icon_state = "new_york"

/obj/effect/decal/garou_glyph/russia
	name = "violent glyph"
	garou_name = "russia glyph"
	garou_desc = "A glyph that represents Russia, the human name for a vast stretch of land important to the Silver Fangs, and once the Red Talons."
	icon_state = "russia"

/obj/effect/decal/garou_glyph/wyld_ways
	name = "elaborate glyph"
	garou_name = "wyld ways glyph"
	garou_desc = "A glyph that literally means The Wyld Ways of Hope Grief and Anger from Hand to Hand the Ways are Passed. It is often a story told by the Black Furies."
	icon_state = "wyld_ways"

/obj/effect/decal/garou_glyph/down_in_end_times
	name = "finite glyph"
	garou_name = "down in end times glyph"
	garou_desc = "A glyph that means Down and Out in the Last Times, often used as the name of a story told by Bone Gnawers."
	icon_state = "down_in_end_times"

/obj/effect/decal/garou_glyph/healing_gaia
	name = "healing glyph"
	garou_name = "healing of gaia glyph"
	garou_desc = "A glyph that exclaims that one is the healing of the world. Often used rhetorically by the Children of Gaia."
	icon_state = "healing_gaia"

/obj/effect/decal/garou_glyph/fiery_head_and_heart
	name = "smokey glyph"
	garou_name = "fire in head and heart glyph"
	garou_desc = "A glyph that means Fire in the Head and Heart. The name of a story often told by the Fianna."
	icon_state = "fiery_head_and_heart"

/obj/effect/decal/garou_glyph/axe_and_claw
	name = "warring glyph"
	garou_name = "axe and claw glyph"
	garou_desc = "A glyph that represents the axe, a human tool used also for war, and a claw, one of the weapons of lupus and Garou. Combined, it is oft used as a tale told by the Get of Fenris."
	icon_state = "axe_and_claw"

/obj/effect/decal/garou_glyph/wolves_at_gate
	name = "besieged glyph"
	garou_name = "wolves at the gate glyph"
	garou_desc = "A glyph that means wolves at the gate, a term used in Glasswalker stories but also in general to remark of the fury of the Wyld tribes against the Weaver."
	icon_state = "wolves_at_gate"

/obj/effect/decal/garou_glyph/hell_and_high_water
	name = "challenging glyph"
	garou_name = "through hell and high water glyph"
	garou_desc = "A glyph remarking on the human phrase, Through Hell and High Water, remarking about a perilous journey. It is often used as a device in kinfolk legends."
	icon_state = "hell_and_high_water"

/obj/effect/decal/garou_glyph/croatan_song
	name = "wistful glyph"
	garou_name = "croatan song glyph"
	garou_desc = "A glyph that speaks of the Croatan song, often used by the Pure Tribes in memory of their fallen middle brother."
	icon_state = "croatan_song"

/obj/effect/decal/garou_glyph/no_compromise
	name = "dangerous glyph"
	garou_name = "no compromise glyph"
	garou_desc = "A glyph that means No Compromise, often used by the Red Talons when affirming their zealotry."
	icon_state = "no_compromise"

/obj/effect/decal/garou_glyph/retribution_and_ascendance
	name = "resurgent glyph"
	garou_name = "retribution and ascendance glyph"
	garou_desc = "A glyph that means retribution and ascendance, often spoken of as a literary tool amongst the Shadow Lords."
	icon_state = "retribution_and_ascendance"

/obj/effect/decal/garou_glyph/long_haunted_road
	name = "perilous glyph"
	garou_name = "long haunted road glyph"
	garou_desc = "A glyph combining path and spirit, remarking of the spiritual presence along the path. It is often used by Silent Striders."
	icon_state = "long_haunted_road"

/obj/effect/decal/garou_glyph/shattered_soul
	name = "morose glyph"
	garou_name = "shattered soul glyph"
	garou_desc = "A glyph that remarks of a shattered soul, a human term for the spirit. It is often used as the name of a Silent Strider story."
	icon_state = "shattered_soul"

/obj/effect/decal/garou_glyph/once_and_future_kings
	name = "aspirational glyph"
	garou_name = "once and future kings glyph"
	garou_desc = "A glyph that speaks to the heritage of the Silver Fangs, who once ruled as kings over the Garou and seek to return to it."
	icon_state = "once_and_future_kings"

/obj/effect/decal/garou_glyph/king_of_wolves
	name = "lording glyph"
	garou_name = "king of wolves glyph"
	garou_desc = "A glyph that remarks to the self-perscribed status of the Silver Fangs as Kings of the wolves."
	icon_state = "king_of_wolves"

/obj/effect/decal/garou_glyph/elemental_mind
	name = "balanced glyph"
	garou_name = "elemental mind glyph"
	garou_desc = "A glyph that speaks to having a mind keen to the elements, often a lesson taught by the Stargazers."
	icon_state = "elemental_mind"

/obj/effect/decal/garou_glyph/binder_of_secrets
	name = "shrouded glyph"
	garou_name = "binder of secrets glyph"
	garou_desc = "A glyph that represents the Binder of Secrets, a tale often spoken of by the Older Brother."
	icon_state = "binder_of_secrets"

/obj/effect/decal/garou_glyph/vengeance_of_wind
	name = "chilling glyph"
	garou_name = "vengeance of the wind glyph"
	garou_desc = "A glyph that represents the vengeance of the wind, as told often in legends of the Younger Brother."
	icon_state = "vengeance_of_wind"

/obj/effect/decal/garou_glyph/vancouver
	name = "ominous glyph"
	garou_name = "vancouver glyph"
	garou_desc = "A glyph that represents Vancouver, a city in British Columbia."
	icon_state = "vancouver"

/obj/effect/decal/garou_glyph/blood_moon
	name = "fearsome glyph"
	garou_name = "blood moon glyph"
	garou_desc = "A glyph that represents the blood moon, when Luna turns red in her rage."
	icon_state = "blood_moon"

/obj/effect/decal/garou_glyph/bat
	name = "flighty glyph"
	garou_name = "bat glyph"
	garou_desc = "A glyph that represents a bat, or potentially the extinct Camazotz."
	icon_state = "bat"

/obj/effect/decal/garou_glyph/boar
	name = "sniveling glyph"
	garou_name = "boar glyph"
	garou_desc = "A glyph that represents the boars, or their extinct Fera bretheren, the Grondr."
	icon_state = "boar"

/obj/effect/decal/garou_glyph/cow
	name = "bullish glyph"
	garou_name = "cow glyph"
	garou_desc = "A glyph that represents cows, or their extinct Fera bretheren, the Apis."
	icon_state = "cow"

/obj/effect/decal/garou_glyph/coyote
	name = "tricky glyph"
	garou_name = "coyote glyph"
	garou_desc = "A glyph that represents coyotes, or their wily Fera bretheren, the Nuwisha."
	icon_state = "coyote"

/obj/effect/decal/garou_glyph/dragon
	name = "spiny glyph"
	garou_name = "dragon glyph"
	garou_desc = "A glyph that represents the dragons, reptiles, and their ancient Fera bretheren, the Mokole."
	icon_state = "dragon"

/obj/effect/decal/garou_glyph/fox
	name = "flashy glyph"
	garou_name = "fox glyph"
	garou_desc = "A glyph that represents the foxes, and their capricious Fera bretheren, the Kitsune."
	icon_state = "fox"

/obj/effect/decal/garou_glyph/hyena
	name = "funny glyph"
	garou_name = "hyena glyph"
	garou_desc = "A glyph that represents the hyenas, an African animal with deep importance to the humans who co-exist with them."
	icon_state = "hyena"

/obj/effect/decal/garou_glyph/phoenix
	name = "fiery glyph"
	garou_name = " glyph"
	garou_desc = "A glyph that represents the phoenix, the primeval firebirds."
	icon_state = "phoenix"

/obj/effect/decal/garou_glyph/tick
	name = "itchy glyph"
	garou_name = "tick glyph"
	garou_desc = "A glyph that represents Tick, Totem of Cunning, an intelligent parasite and trickster."
	icon_state = "tick"

/obj/effect/decal/garou_glyph/drone
	name = "rigid glyph"
	garou_name = "drone glyph"
	garou_desc = "A glyph that represents a drone, an animal possessed by weaver-spirits."
	icon_state = "drone"

/obj/effect/decal/garou_glyph/gorgon
	name = "energetic glyph"
	garou_name = "gorgon glyph"
	garou_desc = "A glyph that represents a gorgon, an animal possessed by wyld-spirits."
	icon_state = "gorgon"

/obj/effect/decal/garou_glyph/kami
	name = "impassioned glyph"
	garou_name = "kami glyph"
	garou_desc = "A glyph that represents the Kami, half-spirits of Gaia who have possessed an animal. The term is also the Japanese word for a spirit, but the glyph does not represent such."
	icon_state = "kami"

/obj/effect/decal/garou_glyph/sun_storm_shadow
	name = "multifaceted glyph"
	garou_name = "sun, storm, and shadow glyph"
	garou_desc = "A glyph that represents many states of difficult weather, often used by Corax to show that nothing can stop them on their mission to share and learn."
	icon_state = "sun_storm_shadow"
