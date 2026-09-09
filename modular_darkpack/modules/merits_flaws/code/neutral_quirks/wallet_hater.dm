/datum/quirk/darkpack/wallet_hater
	name = "Wallet Hater"
	desc = "You hate using wallets! Your character won't start with a wallet to hold their items, and might end up dropping some."
	ttrpg_sources = list(/datum/source_book/homebrew = WE_MADE_IT_UP)
	value = 0
	quirk_flags = QUIRK_HUMAN_ONLY|QUIRK_HIDE_FROM_SCAN
	icon = FA_ICON_WALLET
	gain_text = span_warning("You suddenly feel a sense of hatred for wallets.")
	lose_text = span_notice("You wonder why you ever hated wallets.")
	failure_message = "Fine, I'll use a wallet..."

/datum/quirk/darkpack/wallet_hater/add_unique(client/client_source)
	. = ..()
	var/obj/item/storage/wallet/wallet = locate() in quirk_holder.gather_belongings()
	var/list/wallet_contents = list()
	for(var/item in wallet.contents)
		wallet_contents += item
	wallet?.atom_storage.remove_all(update_storage = FALSE)
	qdel(wallet)
	for(var/obj/item/item as anything in wallet_contents)
		item.equip_to_best_slot(quirk_holder)
