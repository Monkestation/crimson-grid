#define JOB_START_HELPER(job_type, job_name)	\
	/obj/effect/landmark/start/darkpack/##job_type {	\
		name = ##job_name; \
		icon_state = ##job_name; \
		icon = 'modular_vcg/modules/jobs/icons/landmarks.dmi'; \
	}

JOB_START_HELPER(primogen/brujah, JOB_PRIMOGEN_BRUJAH)

JOB_START_HELPER(forest_wolves/keeper, JOB_GAROU_KEEPER)

// Triad
/obj/effect/landmark/start/darkpack/triad
	name = "generic triad start"

JOB_START_HELPER(triad/mountain_master, JOB_MOUNTAIN_MASTER)
JOB_START_HELPER(triad/deputy_mountain_master, JOB_DEPUTY_MOUNTAIN_MASTER)
JOB_START_HELPER(triad/red_pole, JOB_TRIAD_RED_POLE)
JOB_START_HELPER(triad/blue_lanterns, JOB_TRIAD_BLUE_LANTERNS)

#undef JOB_START_HELPER
