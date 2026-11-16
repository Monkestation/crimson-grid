/**
 * Players can revive simplemobs with this.
 * In-game item that can be used to revive a simplemob once. Does not make mobs friendly.
 */
/obj/item/lazarus_injector/lazadon
	name = "lazadon injector"
	desc = "An injector with a cocktail chemicals, able to bring pets back from the brink."
	icon = 'modular_darkpack/modules/medical/icons/lazadon_injector.dmi'
	lefthand_file = 'modular_darkpack/modules/medical/icons/lazadon_lefthand.dmi'
	righthand_file = 'modular_darkpack/modules/medical/icons/lazadon_righthand.dmi'
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/medical/icons/lazadon_onfloor.dmi')

	brand = "magadon"
	should_tame = FALSE
