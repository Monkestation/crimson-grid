/obj/item/identification/drivers_license
	name = "driver's license"
	desc = "An identification card allowing its holder to own and operate motor vehicles. Doubles as a valid form of identification."
	icon_state = "drivers"

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

/obj/item/identification/drivers_license/get_owner_information(mob/user)
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

	return boxed_message(id_examine)

/obj/item/identification/drivers_license/state_issued_id
	name = "state issued identification"
	desc = "An identification card issued by the state of California to serve as a valid form of identification. <b>Does NOT qualify as a license to drive!</b>"
	icon_state = "state_id"
	additional_text = span_boldwarning("NOT APPROVED TO OPERATE MOTOR VEHICLES")

/obj/item/identification/drivers_license/international
	name = "international driver's license"
	desc = "A temporary driver's license card issued to aliens that is valid for their stay in the United States."
