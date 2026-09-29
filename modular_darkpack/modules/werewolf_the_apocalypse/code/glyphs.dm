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
	garou_desc = "A glyph that represents Horned Serpent, the totem spirit of the Galestalkers."
	icon_state = "horned_serpent"

/obj/effect/decal/garou_glyph/unicorn
	name = "noble glyph"
	garou_name = "unicorn glyph"
	garou_desc = "A glyph that represents Unicorn, the totem spirit of the Children of Gaia."
	icon_state = "unicorn"

/obj/effect/decal/garou_glyph/north_wind
	name = "simple glyph"
	garou_name = "north wind glyph"
	garou_desc = "A glyph that represents North Wind, the totem spirit of the Ghost Council."
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
