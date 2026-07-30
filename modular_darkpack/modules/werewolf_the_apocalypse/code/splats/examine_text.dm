/datum/splat/werewolf/proc/examine_other_human(mob/living/carbon/examined)
	var/datum/splat/werewolf/wolp_splat = get_werewolf_splat(examined)
	if(wolp_splat)
		var/list/honor_flavor = list("claim to good conduct", "claim to honor", "claim to chivalry")
		var/list/wisdom_flavor = list("claim to insight", "claim to wisdom", "claim to sagacity")
		var/list/glory_flavor = list("claim to bravery", "claim to valor", "claim to glory")

		var/same_tribe = FALSE
		var/is_known = FALSE

		if(!tribe)
			return
		if(!wolp_splat.tribe || !wolp_splat.auspice)
			return
		if(tribe.name == wolp_splat.tribe.name)
			same_tribe = TRUE

		switch(wolp_splat.renown_rank)
			if(RANK_CUB to RANK_FOSTERN)
				if(same_tribe)
					. += "<b>You know [examined.p_them()] as \a [fera_rank_name(wolp_splat.renown_rank, wolp_splat.id)] of the [wolp_splat.tribe.name].</b>"
					is_known = TRUE
			if(RANK_ADREN to RANK_LEGEND)
				. += "<b>You know [examined.p_them()] as \a [fera_rank_name(wolp_splat.renown_rank, wolp_splat.id)] [wolp_splat.auspice.name] of the [wolp_splat.tribe.name].</b>"
				is_known = TRUE

		if(is_known)
			switch(wolp_splat.renown[RENOWN_HONOR])
				if(4,5,6)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [honor_flavor[1]].</i>"
				if(7,8,9)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [honor_flavor[2]].</i>"
				if(10)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [honor_flavor[3]].</i>"
			switch(wolp_splat.renown[RENOWN_WISDOM])
				if(4,5,6)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [wisdom_flavor[1]].</i>"
				if(7,8,9)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [wisdom_flavor[2]].</i>"
				if(10)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [wisdom_flavor[3]].</i>"
			switch(wolp_splat.renown[RENOWN_GLORY])
				if(4,5,6)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [glory_flavor[1]].</i>"
				if(7,8,9)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [glory_flavor[2]].</i>"
				if(10)
					. += "<i>In the local Garou, you have heard of [examined.p_their(TRUE)] [glory_flavor[3]].</i>"
