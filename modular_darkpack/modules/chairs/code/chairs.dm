// FOUR LEGGED CHAIRS / OBJECTS

/obj/structure/chair/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "chair"
	item_chair = /obj/item/chair/darkpack

/obj/structure/chair/darkpack/blue
	icon_state = "chair_blue"
	item_chair = /obj/item/chair/darkpack/blue

/obj/structure/chair/darkpack/green
	icon_state = "chair_green"
	item_chair = /obj/item/chair/darkpack/green

/obj/structure/chair/darkpack/red
	icon_state = "chair_red"
	item_chair = /obj/item/chair/darkpack/red

// FOUR LEGGED CHAIRS / ITEMS

/obj/item/chair/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "chair_toppled"
	inhand_icon_state = "chair"
	origin_type = /obj/structure/chair/darkpack

/obj/item/chair/darkpack/blue
	icon_state = "chair_blue_toppled"
	origin_type = /obj/structure/chair/darkpack/blue

/obj/item/chair/darkpack/green
	icon_state = "chair_green_toppled"
	origin_type = /obj/structure/chair/darkpack/green

/obj/item/chair/darkpack/red
	icon_state = "chair_red_toppled"
	origin_type = /obj/structure/chair/darkpack/red

// PLASTIC CHAIR / OBJECTS

/obj/structure/chair/plastic/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "plastic_chair"
	name = "plastic chair"
	item_chair = /obj/item/chair/plastic/darkpack

// PLASTIC CHAIR / ITEMS

/obj/item/chair/plastic/darkpack
	name = "plastic chair"
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "folded_chair"
	origin_type = /obj/structure/chair/plastic/darkpack

// OFFICE CHAIRS / OBJECTS

/obj/structure/chair/office/darkpack
	icon_state = "officechair"
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'

/obj/structure/chair/office/darkpack/blue
	icon_state = "officechair_blue"

/obj/structure/chair/office/darkpack/green
	icon_state = "officechair_green"

/obj/structure/chair/office/darkpack/red
	icon_state = "officechair_red"

// BARSTOOLS / OBJECTS

/obj/structure/chair/stool/bar/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "bar"
	item_chair = /obj/item/chair/stool/bar/darkpack

/obj/structure/chair/stool/bar/darkpack/red
	icon_state = "bar_red"
	item_chair = /obj/item/chair/stool/bar/darkpack/red

/obj/structure/chair/stool/bar/darkpack/green
	icon_state = "bar_green"
	item_chair = /obj/item/chair/stool/bar/darkpack/green

/obj/structure/chair/stool/bar/darkpack/blue
	icon_state = "bar_blue"
	item_chair = /obj/item/chair/stool/bar/darkpack/blue

/obj/structure/chair/stool/bar/darkpack/black
	icon_state = "bar_black"
	item_chair = /obj/item/chair/stool/bar/darkpack/black

// BARSTOOLS / ITEMS

/obj/item/chair/stool/bar/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "bar_toppled"
	origin_type = /obj/structure/chair/stool/bar/darkpack

/obj/item/chair/stool/bar/darkpack/red
	icon_state = "bar_red_toppled"
	origin_type = /obj/structure/chair/stool/bar/darkpack/red

/obj/item/chair/stool/bar/darkpack/green
	icon_state = "bar_green_toppled"
	origin_type = /obj/structure/chair/stool/bar/darkpack/green

/obj/item/chair/stool/bar/darkpack/blue
	icon_state = "bar_blue_toppled"
	origin_type = /obj/structure/chair/stool/bar/darkpack/blue

/obj/item/chair/stool/bar/darkpack/black
	icon_state = "bar_black_toppled"
	origin_type = /obj/structure/chair/stool/bar/darkpack/black

// WOODEN CHAIRS / OBJECTS

/obj/structure/chair/wood/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "wooden_chair"
	resistance_flags = FLAMMABLE
	item_chair = /obj/item/chair/wood/darkpack

/obj/structure/chair/wood/darkpack/red
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "wooden_chair_red"
	resistance_flags = FLAMMABLE
	item_chair = /obj/item/chair/wood/darkpack/red

// WOODEN CHAIRS / ITEMS

/obj/item/chair/wood/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "wooden_chair_toppled"
	inhand_icon_state = "woodenchair"
	origin_type = /obj/structure/chair/wood/darkpack

/obj/item/chair/wood/darkpack/red
	icon_state = "wooden_chair_red_toppled"
	inhand_icon_state = "woodenchair"
	origin_type = /obj/structure/chair/wood/darkpack/red

// COMFY CHAIRS / OBJECTS

/obj/structure/chair/comfy/darkpack
	icon = 'modular_darkpack/modules/chairs/icons/chairs.dmi'
	icon_state = "comfy"

/obj/structure/chair/comfy/darkpack/dark
	icon_state = "comfy_dark"

/obj/structure/chair/comfy/darkpack/blue
	icon_state = "comfy_blue"

/obj/structure/chair/comfy/darkpack/green
	icon_state = "comfy_green"

/obj/structure/chair/comfy/darkpack/red
	icon_state = "comfy_red"

// Tileable booth seats

/obj/structure/chair/sofa/booth_seat
	name = "booth seat"
	desc = "A comfy cushioned seat in a booth."
	has_armrest = FALSE
	icon = 'modular_darkpack/modules/chairs/icons/dinersofa_tileable.dmi'
	icon_state = "middle"

/obj/structure/chair/sofa/booth_seat/left
	icon_state = "left"

/obj/structure/chair/sofa/booth_seat/right
	icon_state = "right"

// Standalone booth seats

/obj/structure/chair/comfy/darkpack/booth_seat
	icon = 'modular_darkpack/modules/chairs/icons/dinersofa_48.dmi'
	icon_state = "dinner"
