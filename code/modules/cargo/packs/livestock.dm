/datum/supply_pack/critter
	group = "Животные"
	crate_type = /obj/structure/closet/crate/critter

/* // CORVAX EDIT REMOVAL
/datum/supply_pack/critter/stasis
	crate_type = /obj/structure/closet/crate/critter/stasis

/datum/supply_pack/critter/stasis/fill(obj/container)
	. = ..()
	for(var/mob/living/stasis_mob in container)
		stasis_mob.apply_status_effect(/datum/status_effect/grouped/stasis, STASIS_CRATE_EFFECT)
*/

/datum/supply_pack/critter/parrot
	name = "Ящик с попугаями"
	desc = "Пять говорящих птиц. Не гарантируется, что они будут повторять что-то приличное."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/parrot)
	crate_name = "ящик с попугаями"

/datum/supply_pack/critter/parrot/generate(atom/A, datum/bank_account/paying_account, crate_override)
	. = ..()
	for(var/i in 1 to 4)
		new /mob/living/basic/parrot(.)

/* // CORVAX EDIT REMOVAL
/datum/supply_pack/critter/butterfly
	name = "Butterflies Crate"
	desc = "Not a very dangerous insect, but they do give off a better image than, say, flies or cockroaches."//is that a motherfucking worm reference
	order_flags = ORDER_CONTRABAND
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/mob/living/basic/butterfly)
	crate_name = "entomology samples crate"

/datum/supply_pack/critter/butterfly/generate(atom/A, datum/bank_account/paying_account, crate_override)
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/basic/butterfly(.)
*/

/datum/supply_pack/critter/cat
	name = "Ящик с кошкой"
	desc = "Кошка говорит «мяу». В комплекте ошейник и игрушка. Чизбургер не входит."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/mob/living/basic/pet/cat,
		/obj/item/clothing/neck/petcollar,
		/obj/item/toy/cattoy,
	)
	crate_name = "ящик с кошкой"

/datum/supply_pack/critter/cat/generate(atom/A, datum/bank_account/paying_account, crate_override)
	. = ..()
	if(!prob(50))
		return
	var/mob/living/basic/pet/cat/delete_cat = locate() in .
	if(isnull(delete_cat))
		return
	qdel(delete_cat)
	new /mob/living/basic/pet/cat/_proc(.)

/datum/supply_pack/critter/chick
	name = "Ящик с цыплёнком"
	desc = "Цыплёнок говорит «пиу». Содержит одного цыплёнка."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/mob/living/basic/chick)
	crate_name = "ящик с цыплёнком"

/datum/supply_pack/critter/corgi
	name = "Ящик с корги"
	desc = "По мнению тысяч исследователей, оптимальная порода собак. Этот корги — лишь один из миллионов потомков благородного рода Иэна. В комплекте милый ошейник."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/pet/dog/corgi,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "ящик с корги"

/datum/supply_pack/critter/corgi/generate(atom/A, datum/bank_account/paying_account, crate_override)
	. = ..()
	if(prob(50))
		var/mob/living/basic/pet/dog/corgi/D = locate() in .
		if(D.gender == FEMALE)
			qdel(D)
			new /mob/living/basic/pet/dog/corgi/lisa(.)

/datum/supply_pack/critter/cow
	name = "Ящик с коровой"
	desc = "Корова говорит «му». Содержит одну корову."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/mob/living/basic/cow)
	crate_name = "ящик с коровой"

/datum/supply_pack/critter/sheep
	name = "Ящик с овцой"
	desc = "Овца говорит «бе-е-е». Содержит одну овцу."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/mob/living/basic/sheep)
	crate_name = "ящик с овцой"

/datum/supply_pack/critter/pig
	name = "Ящик со свиньёй"
	desc = "Свинья говорит «хрю». Содержит одну свинью."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/mob/living/basic/pig)
	crate_name = "ящик со свиньёй"

/datum/supply_pack/critter/pony
	name = "Ящик с пони"
	desc = "Пони, ура! (Всего один.)"
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/mob/living/basic/pony)
	crate_name = "ящик с пони"

/* // CORVAX EDIT REMOVAL
/datum/supply_pack/critter/crab
	name = "Crab Rocket"
	desc = "CRAAAAAAB ROCKET. CRAB ROCKET. CRAB ROCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB \
		CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB \
		CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB \
		CRAB CRAB CRAB CRAB CRAB CRAB ROCKET. CRAFT. ROCKET. BUY. CRAFT ROCKET. CRAB ROOOCKET. \
		CRAB ROOOOCKET. CRAB CRAB CRAB CRAB CRAB CRAB CRAB CRAB ROOOOOOOOOOOOOOOOOOOOOOCK \
		EEEEEEEEEEEEEEEEEEEEEEEEE EEEETTTTTTTTTTTTAAAAAAAAA AAAHHHHHHHHHHHHH. CRAB ROCKET. CRAAAB \
		ROCKEEEEEEEEEGGGGHHHHTT CRAB CRAB CRAABROCKET CRAB ROCKEEEET."//fun fact: i actually spent like 10 minutes and transcribed the entire video.
	cost = CARGO_CRATE_VALUE * 8
	contains = list(/mob/living/basic/crab)
	crate_name = "look sir free crabs"
	order_flags = ORDER_POD_ONLY

/datum/supply_pack/critter/crab/generate(atom/A, datum/bank_account/paying_account, crate_override)
	. = ..()
	for(var/i in 1 to 49)
		new /mob/living/basic/crab(.)

/datum/supply_pack/critter/corgis/exotic
	name = "Exotic Corgi Crate"
	desc = "Corgi fit for a king, this corgi comes in a unique color to signify their superiority. \
		Comes with a cute collar!"
	cost = CARGO_CRATE_VALUE * 7
	contains = list(/mob/living/basic/pet/dog/corgi/exoticcorgi,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "exotic corgi crate"
*/

/datum/supply_pack/critter/fox
	name = "Ящик с лисой"
	desc = "Лиса говорит...? Содержит одну лису. В комплекте ошейник."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(
		/mob/living/basic/pet/fox,
		/obj/item/clothing/neck/petcollar,
	)
	crate_name = "ящик с лисой"

/datum/supply_pack/critter/goat
	name = "Ящик с козой"
	desc = "Коза говорит «ме-е». Содержит одну козу. Гарантия недействительна, если использовать как замену Питу."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/mob/living/basic/goat)
	crate_name = "ящик с козой"

/datum/supply_pack/critter/rabbit
	name = "Ящик с кроликом"
	desc = "Какие звуки вообще издают кролики? Содержит одного кролика."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/mob/living/basic/rabbit)
	crate_name = "ящик с кроликом"

/* // CORVAX EDIT REMOVAL
/datum/supply_pack/critter/mothroach
	name = "Mothroach Crate"
	desc = "Put the mothroach on your head and find out what true cuteness looks like. \
		Contains one mothroach."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/mob/living/basic/mothroach)
	crate_name = "mothroach crate"
*/

/* // DARKPACK EDIT REMOVAL - (Removes Monkey Cubes and Bees)
/datum/supply_pack/critter/monkey
	name = "Monkey Cube Crate"
	desc = "Stop monkeying around! Contains seven monkey cubes. Just add water!"
	cost = CARGO_CRATE_VALUE * 4
	contains = list (/obj/item/storage/box/monkeycubes)
	crate_type = /obj/structure/closet/crate
	crate_name = "monkey cube crate"
*/

/datum/supply_pack/critter/pug
	name = "Ящик с мопсом"
	desc = "Как обычная собака, но... сплюснутая. Содержит одного мопса. В комплекте хороший ошейник."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/pet/dog/pug,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "ящик с мопсом"

/datum/supply_pack/critter/bullterrier
	name = "Ящик с бультерьером"
	desc = "Как обычная собака, но с головой формы яйца. Содержит одного бультерьера. В комплекте хороший ошейник."
	cost = CARGO_CRATE_VALUE * 4
	contains = list(/mob/living/basic/pet/dog/bullterrier,
					/obj/item/clothing/neck/petcollar,
				)
	crate_name = "ящик с бультерьером"

/datum/supply_pack/critter/snake
	name = "Ящик со змеями"
	desc = "Устали от этих змей в этом городе? Тогда этот ящик не для вас. Содержит трёх ядовитых змей. Требуется разрешение на содержание опасных животных."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/mob/living/basic/snake = 3)
	crate_name = "ящик со змеями"

/datum/supply_pack/critter/amphibians
	name = "Ящик с амфибиями"
	desc = "Два милых скользких друга. Содержит одну лягушку и одного аксолотля. Внимание: лягушка может быть ядовитой, не пробуйте её на вкус."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(
		/mob/living/basic/axolotl,
		/obj/effect/spawner/random/frog,
	)
	crate_name = "ящик с амфибиями"

/datum/supply_pack/critter/lizard
	name = "Ящик с ящерицей"
	desc = "Шшш! Содержит дружелюбную ящерицу. Не путать с ящеролюдом."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/mob/living/basic/lizard)
	crate_name = "ящик с ящерицей"

/* // CORVAX EDIT REMOVAL
/datum/supply_pack/critter/garden_gnome
	name = "Garden Gnome Crate"
	desc = "Collect them all for your garden. Comes with three!"
	order_flags = ORDER_EMAG_ONLY
	cost = CARGO_CRATE_VALUE * 15
	contains = list(/mob/living/basic/garden_gnome)
	crate_name = "garden gnome crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/critter/garden_gnome/generate(atom/A, datum/bank_account/paying_account, crate_override)
	. = ..()
	for(var/i in 1 to 2)
		new /mob/living/basic/garden_gnome(.)
*/

/datum/supply_pack/critter/fish
	test_ignored = TRUE // However, we should be wary of how possible it is to get more valuable fish out of this on average, depending on sample size.

/datum/supply_pack/critter/fish/aquarium_fish
	name = "Кейс с аквариумными рыбами"
	desc = "Набор аквариумных рыб, отобранных вручную. Содержит двух случайных рыб."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random = 2)
	crate_name = "кейс с аквариумными рыбами"

/* // DARKPACK EDIT REMOVAL - FISHING
/datum/supply_pack/critter/fish/freshwater_fish
	name = "Freshwater Fish Case"
	desc = "Aquarium fish that have had most of their mud cleaned off."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random/freshwater = 2)
	crate_name = "freshwater fish crate"

/datum/supply_pack/critter/fish/saltwater_fish
	name = "Saltwater Fish Case"
	desc = "Aquarium fish that fill the room with the smell of salt."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/random/saltwater = 2)
	crate_name = "saltwater fish crate"

/datum/supply_pack/critter/fish/tiziran_fish
	name = "Tiziran Fish Case"
	desc = "Tiziran saltwater fish imported from the Zagos Sea."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/item/storage/fish_case/tiziran = 2)
	crate_name = "tiziran fish crate"
*/

/datum/supply_pack/critter/stasis/turtle
	name = "Ящик с черепахой"
	desc = "Милые растительноядные черепахи, которые излучают хорошие вибрации для nearby plants! Содержит одну черепаху."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/mob/living/basic/turtle)
	crate_name = "ящик с черепахой"
