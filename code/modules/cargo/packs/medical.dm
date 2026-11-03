/datum/supply_pack/medical
	group = "Медицина"
	access_view = ACCESS_MEDICAL
	crate_type = /obj/structure/closet/crate/medical/department

/datum/supply_pack/medical/bloodpacks
	name = "Ящик с разнообразными пакетами крови"
	desc = "Содержит десять различных наборов крови для повторного введения пациентам."
	cost = CARGO_CRATE_VALUE * 20 // CRIMSON EDIT CHANGE - ORIGINAL: cost = CARGO_CRATE_VALUE * 7
	contains = list(
		/obj/item/reagent_containers/blood/random = 10,
		/obj/item/paper/fluff/jobs/medical/blood_types,
	)
	crate_name = "морозильный ящик"
	crate_type = /obj/structure/closet/crate/freezer

/datum/supply_pack/medical/medipen_variety
	name = "Набор различных медипенов"
	desc = "Содержит восемь различных медипенов трех различных модификаций, \
		которые помогают быстро оказать помощь тяжелораненым пациентам."
	cost = CARGO_CRATE_VALUE * 3.5
	contains = list(/obj/item/reagent_containers/hypospray/medipen = 2,
					/obj/item/reagent_containers/hypospray/medipen/ekit = 3,
					/obj/item/reagent_containers/hypospray/medipen/blood_loss = 3)
	crate_name = null
	crate_type = /obj/structure/closet/crate/deforest

/datum/supply_pack/medical/coroner_crate
	name = "Набор аутопсии"
	desc = "Содержит сканер для вскрытия."
	cost = CARGO_CRATE_VALUE * 2.5
	contains = list(
		/obj/item/autopsy_scanner = 1,
		// /obj/item/storage/medkit/coroner = 1, // CORVAX EDIT
	)
	crate_name = "набор аутопсии"

/datum/supply_pack/medical/chemical
	name = "Стартовый набор химика"
	desc = "Содержит тринадцать различных химических веществ, которые помогут вам провести множество увлекательных экспериментов."
	cost = CARGO_CRATE_VALUE * 10
	contains = list(
		/obj/item/reagent_containers/cup/bottle/hydrogen,
		/obj/item/reagent_containers/cup/bottle/carbon,
		/obj/item/reagent_containers/cup/bottle/nitrogen,
		/obj/item/reagent_containers/cup/bottle/oxygen,
		/obj/item/reagent_containers/cup/bottle/fluorine,
		/obj/item/reagent_containers/cup/bottle/phosphorus,
		/obj/item/reagent_containers/cup/bottle/silicon,
		/obj/item/reagent_containers/cup/bottle/chlorine,
		/obj/item/reagent_containers/cup/bottle/radium,
		/obj/item/reagent_containers/cup/bottle/sacid,
		/obj/item/reagent_containers/cup/bottle/ethanol,
		/obj/item/reagent_containers/cup/bottle/potassium,
		/obj/item/reagent_containers/cup/bottle/sugar,
		/obj/item/clothing/glasses/science,
		/obj/item/reagent_containers/dropper,
		/obj/item/storage/box/beakers,
	)
	crate_name = "набор химика"

/datum/supply_pack/medical/defibs
	name = "Ящик дефиблиляторов"
	desc = "Содержит два дефибриллятора для возвращения к жизни недавно умерших."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/item/defibrillator/loaded = 2)
	crate_name = null
	crate_type = /obj/structure/closet/crate/deforest

/datum/supply_pack/medical/iv_drip
	name = "Ящик с капильницей"
	desc = "Содержит одну капельницу для внутривенного введения крови пациентам."
	cost = CARGO_CRATE_VALUE * 2
	contains = list(/obj/machinery/iv_drip)
	crate_name = null
	crate_type = /obj/structure/closet/crate/deforest

/datum/supply_pack/medical/supplies
	name = "Medical Supplies Crate"
	desc = "Contains a random assortment of medical supplies. German doctor not included."
	cost = CARGO_CRATE_VALUE * 4
	order_flags = ORDER_INVISIBLE // CORVAX EDIT ADD
	contains = list(
		/obj/item/reagent_containers/cup/bottle/multiver,
		/obj/item/reagent_containers/cup/bottle/epinephrine,
		/obj/item/reagent_containers/cup/bottle/morphine,
		/obj/item/reagent_containers/cup/bottle/toxin,
		/obj/item/reagent_containers/cup/beaker/large,
		/obj/item/reagent_containers/applicator/pill/insulin,
		/obj/item/stack/medical/wrap/gauze,
		/obj/item/storage/box/bandages,
		/obj/item/storage/box/beakers,
		/obj/item/storage/box/medigels,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/bodybags,
		/obj/item/storage/medkit/regular,
		/obj/item/storage/medkit/o2,
		/obj/item/storage/medkit/toxin,
		/obj/item/storage/medkit/brute,
		/obj/item/storage/medkit/fire,
		/obj/item/defibrillator/loaded,
		/obj/item/reagent_containers/blood/o_minus,
		/obj/item/storage/pill_bottle/mining,
		/obj/item/reagent_containers/applicator/pill/neurine,
		/obj/item/stack/medical/bone_gel = 2,
		/obj/item/vending_refill/medical,
		/obj/item/vending_refill/drugs,
	)
	crate_name = null
	crate_type = /obj/structure/closet/crate/deforest
	test_ignored = TRUE

/datum/supply_pack/medical/supplies/fill(obj/container)
	for(var/i in 1 to 10)
		var/item = pick(contains)
		new item(container)

/datum/supply_pack/medical/experimentalmedicine
	name = "Ящик экспериментального лекарства"
	desc = "Ящик с лекарством, необходимым для жизни с наследственными множественными заболеваниями, - Сансуфентанилом."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/storage/pill_bottle/sansufentanyl = 2)
	crate_name = null
	crate_type = /obj/structure/closet/crate/interdyne_normal

/datum/supply_pack/medical/surgery
	name = "Набор начинающего хирурга"
	desc = "Вы хотите провести хирургическую операцию, но у вас нет диплома специалиста? \
		Просто начните с этого набора, в котором находится хирургический лоток, стерилизующий спрей \
		и складная кровать на роликах."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(
		/obj/item/surgery_tray/full,
		/obj/item/reagent_containers/medigel/sterilizine,
		/obj/item/emergency_bed,
	)
	crate_name = null
	crate_type = /obj/structure/closet/crate/deforest

/* CORVAX EDIT REMOVAL
/datum/supply_pack/medical/salglucanister
	name = "Heavy-Duty Saline Canister"
	desc = "Contains a bulk supply of saline-glucose condensed into a single canister that \
		should last several days, with a large pump to fill containers with. Direct injection \
		of saline should be left to medical professionals as the pump is capable of overdosing \
		patients."
	cost = CARGO_CRATE_VALUE * 6
	access = ACCESS_MEDICAL
	contains = list(/obj/machinery/iv_drip/saline)
	crate_type = /obj/structure/closet/crate/large
*/

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/medical/virus
	name = "Virus Crate"
	desc = "Contains twelve different bottles of several viral samples for virology \
		research. Also includes seven beakers and syringes. Balled-up jeans not included."
	cost = CARGO_CRATE_VALUE * 5
	access = ACCESS_CMO
	access_view = ACCESS_VIROLOGY
	contains = list(
		/obj/item/reagent_containers/cup/bottle/flu_virion,
		/obj/item/reagent_containers/cup/bottle/cold,
		/obj/item/reagent_containers/cup/bottle/random_virus = 4,
		/obj/item/reagent_containers/cup/bottle/fake_gbs,
		/obj/item/reagent_containers/cup/bottle/magnitis,
		/obj/item/reagent_containers/cup/bottle/pierrot_throat,
		/obj/item/reagent_containers/cup/bottle/brainrot,
		/obj/item/reagent_containers/cup/bottle/anxiety,
		/obj/item/reagent_containers/cup/bottle/beesease,
		/obj/item/storage/box/syringes,
		/obj/item/storage/box/beakers,
		/obj/item/reagent_containers/cup/bottle/mutagen,
	)
	crate_name = "virus crate"
	crate_type = /obj/structure/closet/crate/secure/plasma
	order_flags = ORDER_DANGEROUS

/datum/supply_pack/medical/cmoturtlenecks
	name = "Chief Medical Officer Turtlenecks"
	desc = "Contains the CMO's turtleneck and turtleneck skirt."
	cost = CARGO_CRATE_VALUE * 2
	access = ACCESS_CMO
	contains = list(
		/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck,
		/obj/item/clothing/under/rank/medical/chief_medical_officer/turtleneck/skirt,
	)

/datum/supply_pack/medical/arm_implants
	name = "Strong-Arm Implant Set"
	desc = "A crate containing two implants, which can be surgically implanted to empower the strength of humanoid arms. Warranty void if exposed to electromagnetic pulses."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/organ/cyberimp/arm/strongarm = 2)
	crate_name = "\improper Strong-Arm implant crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE

/datum/supply_pack/medical/paperwork_implants
	name = "Paperwork Implant Set"
	desc = "A crate containing two implants, which can be surgically implanted to effectivize crewmembers at paperwork. Warranty void if exposed to electromagnetic pulses."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/organ/cyberimp/arm/toolkit/paperwork = 2)
	crate_name = "Paperwork implant crate"
	discountable = SUPPLY_PACK_RARE_DISCOUNTABLE
*/

/datum/supply_pack/medical/lost_crew
	name = "Recovered NT Employee corpse"
	desc = "We don't have the accomodations to bring them back, could we send them to you? Please revive and employ them. \
	The price is a downpayment, we will reimburse the medical budget once our employee has been alive again for a bit."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(/obj/structure/closet/body_bag/lost_crew/with_body)
	crate_name = "body freezer"
	crate_type = /obj/structure/closet/crate/secure/freezer
	order_flags = ORDER_INVISIBLE // DARKPACK EDIT ADD

/* // DARKPACK EDIT REMOVAL
/datum/supply_pack/medical/organ_growing
	name = "Organ Growing Kit"
	desc = "All the tools you need to grow organs at home! Besides letting you grow standard organs from tissue samples, \
	you might find mutant cells which can be further proliferated to grow strange properties."
	cost = CARGO_CRATE_VALUE * 5
	contains = list(
		/obj/machinery/vatgrower/small/unanchored,
		/obj/item/biopsy_tool/organ,
		/obj/item/storage/box/petridish,
		/obj/structure/microscope/unanchored,
		/obj/item/reagent_containers/cup/mortar,
		/obj/item/pestle,
	)
	crate_name = "organ growing kit"
*/

/datum/supply_pack/medical/chiral_inversing_buffer
	name = "Chiral Inversing Buffer Crate"
	desc = "A crate containing a rare sample of an inversing buffer. \
		It can transform impure reagents into their inverse counterparts when the right conditions are met."
	cost = CARGO_CRATE_VALUE * 3
	contains = list(/obj/item/reagent_containers/cup/bottle/inversing_buffer)
	crate_name = "chiral inversing buffer crate"

/* CORVAX EDIT REMOVAL
/datum/supply_pack/medical/handheld_crew_monitor
	name = "Handheld Crew Monitor Crate"
	desc = "A crate containing three handheld crew monitors"
	cost = (CARGO_CRATE_VALUE * /obj/item/sensor_device::custom_premium_price * 3 * 0.8) / 280 // Bulk discount .8X base /tg/ vending machine value with the CARGO_CRATE_VALUE modifier
	contains = list(
		/obj/item/sensor_device,
		/obj/item/sensor_device,
		/obj/item/sensor_device,
	)
	crate_name = null
	crate_type = /obj/structure/closet/crate/deforest

/datum/supply_pack/medical/first_aid_board
	name = "DeForest First Aid Station"
	desc = "A crate containing a circuit board used to construct a DeForest First Aid Station - \
		a machine designed to treat minor injuries and ailments. Components not included."
	cost = CARGO_CRATE_VALUE * 6
	contains = list(/obj/item/circuitboard/machine/wall_healer)
	crate_name = null
	crate_type = /obj/structure/closet/crate/deforest
*/
