/obj/structure
	/// If projectiles shot through this object (not fired from an adjacent tile) will have a percent chance to be blocked.
	var/projectile_cover = FALSE
	var/projectile_pass_rate = 0

/obj/structure/CanAllowThrough(atom/movable/mover, border_dir)
	. = ..()
	// Based on /obj/structure/barricade
	if(isprojectile(mover) && projectile_cover)
		if(!anchored)
			return TRUE
		var/obj/projectile/proj = mover
		if(proj.firer && Adjacent(proj.firer))
			return TRUE
		if(prob(projectile_pass_rate))
			return TRUE
		return FALSE
