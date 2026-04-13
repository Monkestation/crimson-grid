/mob/living/carbon/human/Initialize(mapload)
	. = ..()
	// clientless mobs are given a random voice
	if(!client && length(SSblooper.blooper_list))
		var/blooper_key = pick(SSblooper.blooper_list)
		blooper = SSblooper.blooper_list[blooper_key]
		blooper_speed = rand(0, 100)
		blooper_pitch = rand(0, 100)
		blooper_pitch_range = rand(0, 100)
