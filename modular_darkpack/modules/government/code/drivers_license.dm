/obj/item/identification/drivers_license
	name = "driver's license"
	desc = "An identification card allowing its holder to own and operate motor vehicles. Doubles as a valid form of identification."
	icon = 'modular_darkpack/modules/government/icons/docs.dmi'
	icon_state = "drivers"
	worn_icon_state = ""
	slot_flags = NONE
	ONFLOOR_ICON_HELPER('modular_darkpack/modules/government/icons/docsonfloor.dmi')

	var/issuing_state = "California"
	var/organ_donor

	var/additional_text = ""

/obj/item/identification/drivers_license/link_human(mob/living/carbon/human/user)
	. = ..()

	if(fake)
		organ_donor = user.dna.fake_organ_donor
	else
		organ_donor = user.dna.organ_donor

	if(user.dna.country_of_origin == DEFAULT_COUNTRY_NAME)
		issuing_state = user.dna.state_of_origin

/obj/item/identification/drivers_license/examine(mob/user)
	. = ..()
	if(!owner)
		return

	var/id_examine = span_slightly_larger(separator_hr("You examine [src]...</em>"))
	id_examine += "<div class='img_by_text_container'>"
	id_examine += "[icon2html(get_owner_id_photo(), user, extra_classes = "hugeicon")]"
	id_examine += "<div class='img_text'>"
	var/organ_donor_text = organ_donor ? "YES" : "NO"
	var/additional_blurb = additional_text ? " &bull; [additional_text]" : ""
	id_examine += span_notice(jointext(list(
		" &bull; Name: [owner]",
		" &bull; Birth Year: [dob]",
		" &bull; Issuing State: [issuing_state]",
		" &bull; Issued Year: [issued_year]",
		" &bull; Expiry Year: [expiry_year]",
		" &bull; Gender: [owner_gender]",
		" &bull; Organ Donor: [organ_donor_text]",
		additional_blurb,
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
