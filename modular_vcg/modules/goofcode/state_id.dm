/obj/item/card/drivers_license/state_issued_id
	name = "state issued identification"
	desc = "An identification card issued by the state of California to serve as a valid form of identification. <b>Does NOT qualify as a license to drive!</b>"
	icon = 'modular_vcg/modules/goofcode/icons/docs.dmi'
	icon_state = "state_id"
	slot_flags = NONE
	ONFLOOR_ICON_HELPER('modular_vcg/modules/goofcode/icons/docsonfloor.dmi')
	additional_text = span_boldwarning("NOT APPROVED TO OPERATE MOTOR VEHICLES")

/obj/item/card/drivers_license/international
	name = "international driver's license"
	desc = "A temporary driver's license card issued to aliens that is valid for their stay in the United States."

/datum/dna
	var/country_of_origin
	var/state_of_origin
	var/fake_name_identity
	var/fake_age
	var/fake_organ_donor
	var/fake_gender
	var/organ_donor
