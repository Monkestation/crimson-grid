// These are left as unobtainable in game. We assign martial arts via character creation.
// These remain just for purely debug purposes or the rare chance these are needed for something event/admin related.

/obj/item/book/granter/martial/kungfu
	martial = /datum/martial_art/darkpack_kungfu
	name = "old scroll"
	martial_name = "Kung Fu"
	desc = "An aged and frayed scrap of paper written in a foreign language. There is elaborate illustrations of forms and stances"
	greet = span_bolddanger("You have learned the techniques of Kung-Fo")
	icon = 'icons/obj/scrolls.dmi'
	icon_state ="plasmafist"
	remarks = list(
		"Balance...",
		"Power...",
		"Control...",
		"Mastery...",
		"Vigilance...",
		"Skill...",
	)

/obj/item/book/granter/martial/kungfu/on_reading_finished(mob/living/carbon/user)
	. = ..()
	update_appearance()

/obj/item/book/granter/martial/kungfu/update_appearance(updates)
	. = ..()
	name = initial(name)
	desc = initial(desc)
	icon_state = initial(icon_state)

/obj/item/book/granter/martial/cqb
	martial = /datum/martial_art/darkpack_cqb
	name = "old manual"
	martial_name = "close quarters brawling"
	desc = "A small, black manual. There are drawn instructions of tactical hand-to-hand combat."
	greet = span_bolddanger("You've mastered the basics of CQB.")
	icon_state = "cqcmanual"
	remarks = list(
		"Kick... Slam...",
		"Lock... Kick...",
		"Strike their abdomen, neck and back for critical damage...",
		"Slam... Lock...",
		"The last and final moment is yours...",
	)

/obj/item/book/granter/martial/cqb/on_reading_finished(mob/living/carbon/user)
	. = ..()
	if(uses <= 0)
		to_chat(user, span_warning("[src] beeps ominously..."))

/obj/item/book/granter/martial/cqb/recoil(mob/living/user)
	to_chat(user, span_warning("[src] explodes!"))
	playsound(src,'sound/effects/explosion/explosion1.ogg',40,TRUE)
	user.flash_act(1, 1)
	qdel(src)


/obj/item/book/granter/martial/boxing
	martial = /datum/martial_art/darkpack_boxing
	name = "chocolate-stained scroll"
	martial_name = "street boxing"
	desc = "An old scrap of paper illustrating banned boxing techniques.. there seems to be some chocolate stains on it."
	greet = span_bolddanger("You have learned the basics of Street Boxing")
	icon = 'icons/obj/scrolls.dmi'
	icon_state ="sparringcontract"
	remarks = list(
		"Dodge his punch.. then counter punch",
		"Go for the head..",
		"If he dies... he dies",
		"Dance like a fly.. bite like a mosquito",
	)

/obj/item/book/granter/martial/kungfu/on_reading_finished(mob/living/carbon/user)
	. = ..()
	update_appearance()

/obj/item/book/granter/martial/kungfu/update_appearance(updates)
	. = ..()
	name = initial(name)
	desc = initial(desc)
	icon_state = initial(icon_state)

