/datum/commodity/diamond
	name = "Diamond"
	ticker = "DMD"
	desc = "Cut and raw stones. Rare, volatile, and prized by every vault in the city."
	item_type = /obj/item/stack/sheet/mineral/diamond
	base_price = 250
	drift = 0.0012
	volatility = 0.02

/datum/commodity/gold
	name = "Gold"
	ticker = "GLD"
	desc = "The old reliable. Slow, steady, and always wanted."
	item_type = /obj/item/stack/sheet/mineral/gold
	base_price = 120
	drift = 0.0008
	volatility = 0.01

/datum/commodity/silver
	name = "Silver"
	ticker = "SLV"
	desc = "Gold's poorer cousin. Industrial demand keeps it jumpy."
	item_type = /obj/item/stack/sheet/mineral/silver
	base_price = 60
	drift = 0.0006
	volatility = 0.014

/datum/commodity/bond
	abstract = TRUE
	is_bond = TRUE
	floor_frac = 0.9

/datum/commodity/bond/treasury
	abstract = FALSE
	name = "City Treasury Bond"
	ticker = "CTB"
	desc = "Municipal debt. Dull, safe, pays a small coupon."
	base_price = 100
	drift = 0.0003
	volatility = 0.002
	coupon = 0.004

/datum/commodity/bond/corporate
	abstract = FALSE
	name = "Corporate Debenture"
	ticker = "CDB"
	desc = "Lent to the big houses. Pays better than the city, moves more too."
	base_price = 100
	drift = 0.0005
	volatility = 0.005
	floor_frac = 0.8
	coupon = 0.007
