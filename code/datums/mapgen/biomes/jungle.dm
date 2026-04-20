// DARKPACK EDIT CHANGE START
/datum/biome/mudlands
	open_turf_type = /turf/open/misc/dirt
	closed_turf_type = /turf/closed/wall/vampwall/rock
	flora_types = list(
		/obj/structure/flora/rock/pile/darkpack = 2,
		/obj/structure/flora/rock/darkpack = 1,
		/obj/structure/flora/rock/darkpack_big = 1,
		/obj/effect/mine/stick = 1,
	)
	flora_density = 3

/datum/biome/plains
	open_turf_type = /turf/open/misc/grass
	closed_turf_type = /turf/closed/wall/vampwall/rock
	flora_types = list(
		/obj/effect/spawner/random/flora/grass = 50,
		/obj/effect/spawner/random/flora/bushes = 15,
		/obj/structure/flora/tree/vamp/pine = 1,
		/obj/structure/flora/rock/pile/darkpack = 1,
		/obj/structure/flora/rock/darkpack = 1,
		/obj/effect/mine/stick = 2,
	)
	flora_density = 70
	fauna_types = list(
		/mob/living/basic/butterfly = 40,
		/mob/living/basic/deer = 20,
		/mob/living/basic/cockroach = 10,
		/mob/living/basic/goose = 10,
		/mob/living/basic/frog = 10,
		/mob/living/basic/pet/fox = 2,
		/mob/living/basic/stoat = 2,
		/mob/living/basic/pet/dog/wolf = 1,
	)
	fauna_density = 2

/datum/biome/jungle
	open_turf_type = /turf/open/misc/grass
	closed_turf_type = /turf/closed/wall/vampwall/rock
	flora_types = list(
		/obj/effect/spawner/random/flora/grass = 5,
		/obj/effect/spawner/random/flora/flowers = 2,
		/obj/structure/flora/tree/vamp/pine = 3,
		/obj/structure/flora/rock/pile/darkpack = 1,
		/obj/structure/flora/rock/darkpack = 1,
		/obj/effect/mine/stick = 3,
	)
	flora_density = 40
	fauna_types = list(
		/mob/living/basic/butterfly = 40,
		/mob/living/basic/deer = 20,
		/mob/living/basic/cockroach = 10,
		/mob/living/basic/goose = 10,
		/mob/living/basic/frog = 10,
		/mob/living/basic/pet/fox = 2,
		/mob/living/basic/stoat = 2,
		/mob/living/basic/pet/dog/wolf = 1,
	)
	fauna_density = 1

/datum/biome/jungle/deep
	flora_density = 60

/datum/biome/wasteland
	open_turf_type = /turf/open/misc/dirt
	closed_turf_type = /turf/closed/wall/vampwall/rock
	flora_types = list(
		/obj/structure/flora/rock/pile/darkpack = 10,
		/obj/structure/flora/rock/darkpack = 2,
		/obj/structure/flora/rock/darkpack_big = 1,
		/obj/effect/mine/stick = 1,
	)
	flora_density = 5

/datum/biome/water
	open_turf_type = /turf/open/water/beach/vamp
	closed_turf_type = /turf/closed/wall/vampwall/rock

/datum/biome/mountain
	closed_turf_type = /turf/closed/wall/vampwall/rock
	open_turf_type = /turf/closed/wall/vampwall/rock
// DARKPACK EDIT CHANGE END
