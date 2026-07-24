GLOBAL_LIST_INIT(all_brands, init_subtypes_w_path_keys(/datum/brand, list()))
GLOBAL_LIST_INIT(all_brandnames, brand_list_by_name())

/proc/brand_list_by_name()
	var/list/brand_list = GLOB.all_brands

	for(var/path in brand_list)
		var/datum/brand/this_brand = brand_list[path]
		brand_list[this_brand.manufacturer] = this_brand
	return brand_list

/datum/element/corp_label
	var/datum/brand/our_brand = /datum/brand
	element_flags = ELEMENT_BESPOKE
	argument_hash_start_idx = 1

/datum/element/corp_label/Attach(datum/target, datum/brand/my_brand)
	. = ..()
	if(!isatom(target))
		return ELEMENT_INCOMPATIBLE

	var/obj/product = target

	if(!product.brand)
		return ELEMENT_INCOMPATIBLE

	our_brand = my_brand

	if(isnull(my_brand))
		our_brand = /datum/brand

	RegisterSignal(target, COMSIG_ATOM_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(target, COMSIG_ATOM_EXAMINE_MORE, PROC_REF(on_examine_more))

/datum/element/corp_label/Detach(datum/target)
	UnregisterSignal(target, list(COMSIG_ATOM_EXAMINE, COMSIG_ATOM_EXAMINE_MORE))
	return ..()

/datum/element/corp_label/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	examine_list += span_notice("<br>This item is <span class='[our_brand.name_span ? our_brand.name_span : "info"]'>branded</span>. [EXAMINE_HINT("Look closer")] for more information.")

/datum/element/corp_label/proc/on_examine_more(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	var/logo
	if(our_brand.render_logo)
		logo = "[icon2html(our_brand.logo_icon, user, our_brand.manufacturer, extra_classes = "corplogo")]"

	examine_list += span_info("[logo ? "[logo]<br>" : ""]Brought to you by <span class='[our_brand.name_span ? our_brand.name_span : "info"]'>[our_brand.full_name].</span>")

	if(our_brand.slogan)
		examine_list += span_notice("<I>\"[our_brand.slogan]\"</I>")

/datum/brand
	abstract_type = /datum/brand

	// Used to index the brand and reference the icon_state
	var/manufacturer = "badcode"
	// The full, plain-text name of the company.
	var/full_name = "Bad Code Inc."
	// Company slogan. Displayed alongside the logo in most cases.
	var/slogan = "Bad Code Inc.: Telling America's Coders they screwed up since 1970."
	// Formatting applied to the name in item descriptions
	var/name_span = "hypnophrase"
	// The icon file we're grabbing our icon_state from. Default dimensions in this file are 300x110.
	var/logo_icon = 'modular_darkpack/modules/COMPANY_LOGOS/icons/corp_logos.dmi'
	// If FALSE, skip rendering the logo in examine text.
	var/render_logo = TRUE
	// Company color used for coloring certain items that change depending on brand
	var/company_color = COLOR_ADMIN_PINK

