#define JOB_START_HELPER(job_type, job_name)	\
	/obj/effect/landmark/start/darkpack/##job_type {	\
		name = ##job_name; \
		icon_state = ##job_name; \
	}

/obj/effect/landmark/start/darkpack
	name = "generic darkpack start"
	desc = "Var-edit me if you're an idiot who doesn't like making subtypes!"
	icon = 'modular_darkpack/modules/jobs/icons/landmarks.dmi'

/* Anarchs */
/obj/effect/landmark/start/darkpack/anarch
	name = "generic anarch start"

JOB_START_HELPER(anarch/baron, JOB_BARON)
JOB_START_HELPER(anarch/bruiser, JOB_BRUISER)
JOB_START_HELPER(anarch/emissary, JOB_EMISSARY)
JOB_START_HELPER(anarch/sweeper, JOB_SWEEPER)
JOB_START_HELPER(anarch/tapster, JOB_TAPSTER)

/* Supply */
/obj/effect/landmark/start/darkpack/axe
	name = "generic warehouse start"

JOB_START_HELPER(supply/dealer, JOB_DEALER)
JOB_START_HELPER(supply/tech, JOB_SUPPLY_TECH)

/* Camarilla */
/obj/effect/landmark/start/darkpack/camarilla
	name = "generic camarilla start"

JOB_START_HELPER(camarilla/prince, JOB_PRINCE)
JOB_START_HELPER(camarilla/clerk, JOB_SENESCHAL)
JOB_START_HELPER(camarilla/sheriff, JOB_SHERIFF)
JOB_START_HELPER(camarilla/hound, JOB_HOUND)
JOB_START_HELPER(camarilla/harpy, JOB_HARPY)
JOB_START_HELPER(camarilla/towerwork, JOB_TOWERWORK)

/* Primogen Council */
/obj/effect/landmark/start/darkpack/primogen
	name = "generic primogen start"

JOB_START_HELPER(primogen/toreador, JOB_PRIMOGEN_TOREADOR)
JOB_START_HELPER(primogen/banu, JOB_PRIMOGEN_BANU_HAQIM)
JOB_START_HELPER(primogen/lasombra, JOB_PRIMOGEN_LASOMBRA)
JOB_START_HELPER(primogen/malkavian, JOB_PRIMOGEN_MALKAVIAN)
JOB_START_HELPER(primogen/nosferatu, JOB_PRIMOGEN_NOSFERATU)
JOB_START_HELPER(primogen/ventrue, JOB_PRIMOGEN_VENTRUE)

/* Hospital */
/obj/effect/landmark/start/darkpack/hospital
	name = "generic hospital start"

JOB_START_HELPER(hospital/clinic_director, JOB_CLINIC_DIRECTOR)
JOB_START_HELPER(hospital/doctor, JOB_DOCTOR)

/* Government & Police */
/obj/effect/landmark/start/darkpack/law_enforcement
	name = "generic police start"

JOB_START_HELPER(law_enforcement/captain, JOB_POLICE_CAPTAIN)
JOB_START_HELPER(law_enforcement/sergeant, JOB_POLICE_SERGEANT)
JOB_START_HELPER(law_enforcement/officer, JOB_POLICE_OFFICER)
JOB_START_HELPER(law_enforcement/dispatcher, JOB_EMERGENCY_DISPATCHER)
JOB_START_HELPER(law_enforcement/fbi, JOB_FEDERAL_INVESTIGATOR)

/* Giovanni */
/obj/effect/landmark/start/darkpack/hecata
	name = "generic hecata start"

JOB_START_HELPER(hecata/capo, JOB_CAPO)
JOB_START_HELPER(hecata/nonni, JOB_I_NONNI)
JOB_START_HELPER(hecata/famiglia, JOB_LA_SQUADRA)
JOB_START_HELPER(hecata/squadra, JOB_LA_FAMIGLIA)

/* Civilian */
/obj/effect/landmark/start/darkpack/citizen
	name = "generic citizen start"

JOB_START_HELPER(citizen/citizen, JOB_CITIZEN)
JOB_START_HELPER(citizen/club_worker, JOB_CLUB_WORKER)
JOB_START_HELPER(citizen/janitor, JOB_STREET_JANITOR)
JOB_START_HELPER(citizen/priest, JOB_PRIEST)
JOB_START_HELPER(citizen/taxi, JOB_TAXI_DRIVER)
JOB_START_HELPER(citizen/red_news, JOB_RED_NEWS_REPORTER)

/* Sabbat */
/obj/effect/landmark/start/darkpack/sabbat
	name = "generic sabbat start"

JOB_START_HELPER(sabbat/ductus, JOB_SABBAT_DUCTUS)
JOB_START_HELPER(sabbat/pack, JOB_SABBAT_PACK)
JOB_START_HELPER(sabbat/priest, JOB_SABBAT_PRIEST)

/* Chantry */
/obj/effect/landmark/start/darkpack/chantry
	name = "generic chantry start"

JOB_START_HELPER(chantry/regent, JOB_CHANTRY_REGENT)
JOB_START_HELPER(chantry/archivist, JOB_CHANTRY_ARCHIVIST)
JOB_START_HELPER(chantry/gargoyle, JOB_CHANTRY_GARGOYLE)

/* Forest Wolves */
/obj/effect/landmark/start/darkpack/forest_wolves
	name = "generic dog start"

JOB_START_HELPER(forest_wolves/council, JOB_GAROU_COUNCIL)
JOB_START_HELPER(forest_wolves/warder, JOB_GAROU_WARDER)
JOB_START_HELPER(forest_wolves/catcher, JOB_GAROU_TRUTHCATCHER)
JOB_START_HELPER(forest_wolves/wyrmfoe, JOB_GAROU_WYRMFOE)
JOB_START_HELPER(forest_wolves/guardian, JOB_GAROU_GUARDIAN)

/* Pentex */
/obj/effect/landmark/start/darkpack/pentex
	name = "generic evil dog start"

JOB_START_HELPER(pentex/lead, JOB_PENTEX_LEAD)
JOB_START_HELPER(pentex/executive, JOB_PENTEX_EXEC)
JOB_START_HELPER(pentex/affairs, JOB_PENTEX_AFFAIRS)
JOB_START_HELPER(pentex/secchief, JOB_PENTEX_SEC_CHIEF)
JOB_START_HELPER(pentex/sec, JOB_PENTEX_SEC)
JOB_START_HELPER(pentex/employee, JOB_PENTEX_EMPLOYEE)

/* Voivodate */
/obj/effect/landmark/start/darkpack/voivode
	name = "generic voivodate start"

JOB_START_HELPER(voivode/voivode, JOB_VOIVODE)
JOB_START_HELPER(voivode/bogatyr, JOB_BOGATYR)
JOB_START_HELPER(voivode/zadruga, JOB_ZADRUGA)

/* Society of Leopold */
/obj/effect/landmark/start/darkpack/society_of_leopold
	name = "generic hunter start"

JOB_START_HELPER(society_of_leopold/abbe, JOB_ABBE)
JOB_START_HELPER(society_of_leopold/condittieri, JOB_CONDOTTIERI)
JOB_START_HELPER(society_of_leopold/inquisitor, JOB_INQUISITOR)
JOB_START_HELPER(society_of_leopold/novice, JOB_NOVICE)

#undef JOB_START_HELPER
