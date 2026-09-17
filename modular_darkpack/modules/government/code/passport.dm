/obj/item/identification/passport
	name = "passport"
	desc = "A book with someone's license, photo, and identifying information. Don't lose it!"
	icon = 'modular_darkpack/modules/government/icons/docs.dmi'
	worn_icon = 'modular_darkpack/modules/clothes/icons/worn.dmi'
	icon_state = "passport1"
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/government/icons/docsonfloor.dmi')

	/// Country of origin for the passport holder
	var/country_of_origin = DEFAULT_COUNTRY_NAME

/obj/item/identification/passport/link_human(mob/living/carbon/human/user)
	. = ..()

	country_of_origin = user.dna.country_of_origin
	if(country_of_origin == DEFAULT_COUNTRY_NAME)
		country_of_origin = "[user.dna.state_of_origin], [DEFAULT_COUNTRY_NAME]"
	icon_state = pick("passport1", "passport")

/obj/item/identification/passport/examine(mob/user)
	. = ..()
	if(!owner)
		return

	flick("passport0", src)
	var/id_examine = span_slightly_larger(separator_hr("You examine [src]...</em>"))
	id_examine += "<div class='img_by_text_container'>"
	id_examine += "[icon2html(get_owner_id_photo(), user, extra_classes = "hugeicon")]"
	id_examine += "<div class='img_text'>"
	id_examine += span_notice(jointext(list(
		" &bull; Name: [owner]",
		" &bull; Birth Year: [dob]",
		" &bull; Issuing Country: [country_of_origin]",
		" &bull; Issued Year: [issued_year]",
		" &bull; Expiry Year: [expiry_year]",
		" &bull; Gender: [owner_gender]",
	), "<br>"))
	id_examine += "</div>" // container
	id_examine += "</div>" // text

	. += boxed_message(id_examine)
	if(our_human == user)
		return

	if(fake)
		var/roll_result = examine_roll.st_roll(user, src)
		if(roll_result == ROLL_SUCCESS)
			. += span_boldwarning("It looks like a crude counterfeit; this document is forged!")
