GLOBAL_LIST_INIT(source_book_priority, list(
	SOURCE_OFFICAL = 1,
	SOURCE_STORYTELLER_VAULT = 2,
	SOURCE_HOMEBREW = 3,
))

/datum/source_book
	var/name
	/// Determiner for how accurate it is to whitewolf published media.
	var/offical_status
	/// Media does not have or care about page numbers
	var/ignore_pages = FALSE

/datum/source_book/vtm20
	name = "Vampire The Masquerade 20th Anniversary Edition"
	offical_status = SOURCE_OFFICAL

/datum/source_book/vtm20/lotc
	name = "Lore of the Clans"

/datum/source_book/vtm20/lotb
	name = "Lore of the Bloodlines"

/datum/source_book/vtm20/hunterhunted2
	name = "The Hunters Hunted II"
	offical_status = SOURCE_OFFICAL

/datum/source_book/vtm20/ghouls_and_revenants
	name = "Ghouls & Revenants"
	offical_status = SOURCE_OFFICAL

/datum/source_book/wta20
	name = "Werewolf The Apocalypse 20th Anniversary Edition"
	offical_status = SOURCE_OFFICAL
	
/datum/source_book/gt_tmr
	name = "The Black Hand Guide to The Tal'Mahe'Ra"
	offical_status = SOURCE_OFFICAL

/datum/source_book/ctd20
	name = "Changeling the Dreaming 20th Anniversary Edition"
	offical_status = SOURCE_OFFICAL

/datum/source_book/mta20
	name = "Mage the Ascension 20th Anniversary Edition"
	offical_status = SOURCE_OFFICAL

/datum/source_book/mta20/bos
	name = "The Book of Secrets"

/datum/source_book/htr3
	name = "Hunter the Reckoning Revised Edition"
	offical_status = SOURCE_OFFICAL

/datum/source_book/htr3/pg
	name = "Hunter the Reckoning Players' Guide"

/datum/source_book/vtm20/vampire_wild_west
	name = "Vampire The Wild West"
	offical_status = SOURCE_STORYTELLER_VAULT

/datum/source_book/homebrew
	name = "Homebrew"
	offical_status = SOURCE_HOMEBREW

/datum/proc/highest_source_offical_status()
	var/highest_book
	for(var/datum/source_book/book, page_number in ttrpg_sources)
		if(!highest_book || GLOB.source_book_priority[book] < highest_book)
			highest_book = GLOB.source_book_priority[book]

	return highest_book

/datum/proc/soure_book_allowed(source_cutoff)
	var/main_source = highest_source_offical_status()
	if(!main_source)
		return TRUE

	if(GLOB.source_book_priority[main_source] > GLOB.source_book_priority[source_cutoff])
		return FALSE

	return TRUE


/datum/proc/get_book_sources_readable()
	var/books = list()
	for(var/datum/source_book/book, page_number in ttrpg_sources)
		if(isnum(page_number))
			books += "[book::name]: p. [page_number]"
		else
			books += "[book::name]: [page_number]"
