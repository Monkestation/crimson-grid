/// An image keeps its loc alive, and features lose track of their images once the player ghosts or gets matrixed
/mob/living/Destroy()
	for(var/client/viewer as anything in GLOB.clients)
		var/list/stale_images
		for(var/image/shown as anything in viewer.images)
			if(shown.loc == src)
				LAZYADD(stale_images, shown)
		if(stale_images)
			viewer.images -= stale_images
	return ..()
