// Very mediorce solution. Much much better then what cars USED to do.
/turf/proc/get_blocking_contents(exclude_mobs = FALSE, source_atom = null, list/ignore_atoms)
	if(density)
		return list(src)

	var/list/blocking_content = list()
	var/border_dir = source_atom ? get_dir(source_atom, src) : NONE
	for(var/atom/atom_content as anything in contents)
		// We don't want to block ourselves or consider any ignored atoms.
		if((atom_content == source_atom) || (atom_content in ignore_atoms))
			continue
		// If the thing is dense AND we're including mobs or the thing isn't a mob AND if there's a source atom and
		// it cannot pass through the thing on the turf,  we consider the turf blocked.
		if(atom_content.density && (!exclude_mobs || !ismob(atom_content)))
			if(source_atom && atom_content.CanPass(source_atom, border_dir))
				continue
			blocking_content += atom_content
	return blocking_content
