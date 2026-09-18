/obj/effect/spawner/random/structure/shipping_container/darkpack
	name = "random darkpack shipping container spawner"
	icon = 'modular_darkpack/modules/decor/icons/smallcontainers.dmi'
	icon_state = "random_container"
	loot = list(
		/obj/structure/shipping_container/darkpack/endron = 3,
		/obj/structure/shipping_container/darkpack/endron/alt = 3,
		/obj/structure/shipping_container/darkpack/endron/gas = 3,
		/obj/structure/shipping_container/darkpack/magadon = 3,
		/obj/structure/shipping_container/darkpack/kings = 3,
		/obj/structure/shipping_container/darkpack/kings/alt = 3,
		/obj/structure/shipping_container/darkpack/avalon = 3,
		/obj/structure/shipping_container/darkpack/tellus = 3,
		/obj/structure/shipping_container/darkpack/otolleys = 3,
		/obj/structure/shipping_container/darkpack/gateway = 3,
		/obj/structure/shipping_container/darkpack/gateway/alt = 3,
	)

/obj/structure/shipping_container/darkpack
	name = "shipping container"
	desc = "DONT PLACE THIS !! ITS FAKE AS HELL !!"
	icon = 'modular_darkpack/modules/decor/icons/smallcontainers.dmi'
	icon_state = "random_container"
	abstract_type = /obj/structure/shipping_container/darkpack

/obj/structure/shipping_container/darkpack/endron
	name = "\improper Endron shipping container"
	desc = "A standard-measure shipping container for bulk transport of goods. This one is marked with Endron branding."
	icon_state = "endron1"

/obj/structure/shipping_container/darkpack/endron/alt
	icon_state = "endron2"

/obj/structure/shipping_container/darkpack/endron/gas
	name = "\improper Endron bulk gas tank"
	desc = "A standard-measure gas tank for bulk transport of gases. This one is marked with Endron branding, but no indication of what gas it holds."
	icon_state = "endron3"

/obj/structure/shipping_container/darkpack/magadon
	name = "\improper Magadon shipping container"
	desc = "A standard-measure shipping container for bulk transport of goods. This one is marked with Magadon Pharmaceuticals branding."
	icon_state = "magadon"

/obj/structure/shipping_container/darkpack/kings
	name = "\improper Kings Breweries shipping container"
	desc = "A standard-measure shipping container for bulk transport of goods. This one is marked with Kings Breweries branding."
	icon_state = "kings1"

/obj/structure/shipping_container/darkpack/kings/alt
	icon_state = "kings2"

/obj/structure/shipping_container/darkpack/avalon
	name = "\improper Avalon Incorporated shipping container"
	desc = "A standard-measure shipping container for bulk transport of goods. This one is marked with Avalon Incorporated branding."
	icon_state = "avalon"

/obj/structure/shipping_container/darkpack/tellus
	name = "\improper Tellus Enterprises shipping container"
	desc = "A standard-measure shipping container for bulk transport of goods. This one is marked with Tellus Enterprises branding."
	icon_state = "tellus"

/obj/structure/shipping_container/darkpack/otolleys
	name = "\improper O'Tolley's shipping container"
	desc = "A standard-measure shipping container for bulk transport of goods. This one is marked with O'Tolley's branding."
	icon_state = "otolleys"

// I just made these up because I needed some filler containers.
/obj/structure/shipping_container/darkpack/gateway
	name = "\improper Gateway Logistics shipping container"
	desc = "A standard-measure shipping container for bulk transport of goods. This one is marked with Gateway Logistics branding."
	icon_state = "gateway1"

/obj/structure/shipping_container/darkpack/gateway/alt
	icon_state = "gateway2"
