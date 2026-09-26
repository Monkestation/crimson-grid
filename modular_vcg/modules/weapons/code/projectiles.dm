// Handgun/Compact cartridges

// 9mm

/obj/projectile/bullet/darkpack/vamp9mm
	damage = 30
	exposed_wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp9mm/hp
	damage = 35
	exposed_wound_bonus = 20
	armour_penetration = -5
	weak_against_armour = TRUE

/obj/projectile/bullet/darkpack/vamp9mm/ap
	damage = 25
	exposed_wound_bonus = 0
	wound_bonus = 5
	armour_penetration = 25

/obj/projectile/bullet/darkpack/vamp9mm/silver
	exposed_wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp9mm/plus
	damage = 34
	armour_penetration = 15

// 4.6mm

/obj/projectile/bullet/darkpack/vamp46mm
	damage = 25
	armour_penetration = 35
	exposed_wound_bonus = -5
	wound_bonus = 0

/obj/projectile/bullet/darkpack/vamp46mm/ap
	damage = 20
	armour_penetration = 55
	exposed_wound_bonus = -10
	wound_bonus = -5

// .45 Auto

/obj/projectile/bullet/darkpack/vamp45acp
	damage = 35
	armour_penetration = 0

/obj/projectile/bullet/darkpack/vamp45acp/plus
	damage = 40
	armour_penetration = 10

/obj/projectile/bullet/darkpack/vamp45acp/ap
	damage = 30
	armour_penetration = 30

/obj/projectile/bullet/darkpack/vamp45acp/wp
	damage = 40
	armour_penetration = -10
	var/fire_stacks = 4

/obj/projectile/bullet/darkpack/vamp45acp/wp/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	do_sparks(2, TRUE, src)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()

/obj/projectile/bullet/darkpack/vamp45acp/silver
	armour_penetration = 0

/obj/projectile/bullet/darkpack/vamp45acp/hp
	damage = 40
	armour_penetration = -10
	exposed_wound_bonus = 25
	wound_bonus = 10
	weak_against_armour = TRUE

// .44 Magnum

/obj/projectile/bullet/darkpack/vamp44
	damage = 45
	armour_penetration = 25
	exposed_wound_bonus = 0
	wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp44/ep
	damage = 33
	armour_penetration = 90
	exposed_wound_bonus = -10
	wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp44/hp
	damage = 50
	armour_penetration = 0
	exposed_wound_bonus = 20
	wound_bonus = 15
	weak_against_armour = TRUE

/obj/projectile/bullet/darkpack/vamp44/wp
	damage = 50
	armour_penetration = 10
	exposed_wound_bonus = 5
	wound_bonus = 10
	var/fire_stacks = 5

/obj/projectile/bullet/darkpack/vamp44/wp/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	do_sparks(2, TRUE, src)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()

/obj/projectile/bullet/darkpack/vamp44/silver
	exposed_wound_bonus = -5

// .50 Action Express

/obj/projectile/bullet/darkpack/vamp50ae
	damage = 60
	armour_penetration = 10
	exposed_wound_bonus = 10
	wound_bonus = 10
	sharpness = SHARP_EDGED

/obj/projectile/bullet/darkpack/vamp50ae/ap
	damage = 50
	armour_penetration = 75
	exposed_wound_bonus = 0
	wound_bonus = 15

/obj/projectile/bullet/darkpack/vamp50ae/hp
	damage = 70
	armour_penetration = 0
	exposed_wound_bonus = 30
	wound_bonus = 20

/obj/projectile/bullet/darkpack/vamp50ae/wp
	damage = 70
	armour_penetration = -10
	exposed_wound_bonus = 10
	wound_bonus = 15
	var/fire_stacks = 2

/obj/projectile/bullet/darkpack/vamp50ae/wp/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	do_sparks(2, TRUE, src)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()

/obj/projectile/bullet/darkpack/vamp50ae/he
	damage = 75
	armour_penetration = 50
	exposed_wound_bonus = 20
	wound_bonus = 25

// Rifle cartridges

// 5.56mm

/obj/projectile/bullet/darkpack/vamp556mm
	damage = 33
	armour_penetration = 33
	exposed_wound_bonus = -10
	wound_bonus = 5

/obj/projectile/bullet/darkpack/vamp556mm/ap
	damage = 28
	armour_penetration = 65
	exposed_wound_bonus = -20
	wound_bonus = 0

/obj/projectile/bullet/darkpack/vamp556mm/hp
	damage = 40
	armour_penetration = 10
	exposed_wound_bonus = 20
	wound_bonus = 15
	weak_against_armour = TRUE

/obj/projectile/bullet/darkpack/vamp556mm/incendiary
	armour_penetration = 15
	exposed_wound_bonus = 5
	wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp556mm/silver
	wound_bonus = 10

// 5.45mm

/obj/projectile/bullet/darkpack/vamp545mm
	damage = 30
	armour_penetration = 40
	exposed_wound_bonus = -10
	wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp545mm/ap
	damage = 25
	armour_penetration = 70
	exposed_wound_bonus = -20
	wound_bonus = 5

/obj/projectile/bullet/darkpack/vamp545mm/hp
	damage = 35
	armour_penetration = 5
	exposed_wound_bonus = 15
	wound_bonus = 15
	weak_against_armour = TRUE

/obj/projectile/bullet/darkpack/vamp545mm/incendiary
	damage = 35
	armour_penetration = 10
	exposed_wound_bonus = 5
	wound_bonus = 10
	var/fire_stacks = 2

/obj/projectile/bullet/darkpack/vamp545mm/incendiary/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	do_sparks(2, TRUE, src)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()

// 7.62x51mm

/obj/projectile/bullet/darkpack/vamp762x51mm
	armour_penetration = 45
	exposed_wound_bonus = -5
	wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp762x51mm/ap
	damage = 38
	armour_penetration = 75
	exposed_wound_bonus = -15
	wound_bonus = 5

/obj/projectile/bullet/darkpack/vamp762x51mm/hp
	damage = 50
	armour_penetration = 10
	exposed_wound_bonus = 20
	wound_bonus = 15
	weak_against_armour = TRUE

/obj/projectile/bullet/darkpack/vamp762x51mm/silver
	exposed_wound_bonus = 0
	wound_bonus = 5

/obj/projectile/bullet/darkpack/vamp762x51mm/incendiary
	armour_penetration = 15
	exposed_wound_bonus = 5
	wound_bonus = 10

/obj/projectile/bullet/darkpack/vamp762x51mm/incendiary/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	do_sparks(2, TRUE, src)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()

// .50 BMG
/obj/projectile/bullet/darkpack/vamp50
	damage = 100
	armour_penetration = 80
	exposed_wound_bonus = -10
	wound_bonus = 20
	sharpness = SHARP_EDGED

/obj/projectile/bullet/darkpack/vamp50/du
	damage = 100
	armour_penetration = 90
	exposed_wound_bonus = 0
	wound_bonus = 15
	projectile_phasing = PASSTABLE | PASSGLASS | PASSGRILLE | PASSCLOSEDTURF | PASSMACHINE | PASSSTRUCTURE | PASSDOORS
	max_pierces = 2

/obj/projectile/bullet/darkpack/vamp50/rauf
	damage = 150
	armour_penetration = 80
	exposed_wound_bonus = 20
	wound_bonus = 25
	dismemberment = 50
	catastropic_dismemberment = TRUE

/obj/projectile/bullet/darkpack/vamp50/ratshot
	damage = 12
	armour_penetration = -10
	exposed_wound_bonus = 5
	wound_bonus = 5
	ricochet_chance = 80
	ricochet_decay_chance = 0.5
	weak_against_armour = TRUE

/obj/projectile/bullet/darkpack/vamp50/api
	damage = 100
	armour_penetration = 75
	exposed_wound_bonus = 20
	wound_bonus = 30
	var/fire_stacks = 5

/obj/projectile/bullet/darkpack/vamp50/api/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	do_sparks(2, TRUE, src)
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.ignite_mob()

// Shotgun ammunition

/obj/projectile/bullet/darkpack/dragonsbreath
	damage = 10
	armour_penetration = 0
	exposed_wound_bonus = 5
	wound_bonus = 5

/obj/projectile/bullet/darkpack/shotpellet
	damage = 12
	armour_penetration = -10

/obj/projectile/bullet/darkpack/shotpellet/flech
	damage = 8
	armour_penetration = 40
	exposed_wound_bonus = 0
	wound_bonus = 5

/obj/projectile/bullet/darkpack/shotpellet/silver
	damage = 9

/obj/projectile/bullet/darkpack/shotpellet/silver/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	fera_silver_damage(target, 1)

/obj/projectile/bullet/shotgun_slug/vamp
	damage = 80
	exposed_wound_bonus = 10
	sharpness = SHARP_EDGED

/obj/projectile/bullet/shotgun_slug/vamp/ap
	damage = 70
	armour_penetration = 50
	exposed_wound_bonus = 5
	wound_bonus = 10

/obj/projectile/bullet/shotgun_slug/vamp/hp
	damage = 80
	armour_penetration = -10
	exposed_wound_bonus = 15
	wound_bonus = 20
	weak_against_armour = TRUE
	sharpness = SHARP_POINTY

/obj/projectile/bullet/shotgun_slug/vamp/he
	damage = 90
	armour_penetration = 40
	exposed_wound_bonus = 20
	wound_bonus = 25

/obj/projectile/bullet/shotgun_slug/vamp/silver
	exposed_wound_bonus = 5

// Special projectiles

/obj/projectile/bullet/darkpack/rubber
	damage = 5
	exposed_wound_bonus = 0
	wound_bonus = -5
	sharpness = NONE

/obj/projectile/bullet/crossbow_bolt
	damage = 45
	armour_penetration = 75
	exposed_wound_bonus = 30
	wound_bonus = 30

/obj/projectile/bullet/crossbow_bolt/bodkin
	damage = 40
	armour_penetration = 90
	exposed_wound_bonus = 15
	wound_bonus = 15

/obj/projectile/bullet/crossbow_bolt/broadhead
	damage = 60
	armour_penetration = 30
	exposed_wound_bonus = 40
	wound_bonus = 40
	weak_against_armour = TRUE
	sharpness = SHARP_EDGED

/obj/projectile/bullet/crossbow_bolt/silver
	exposed_wound_bonus = 25

/obj/projectile/bullet/crossbow_bolt/silver/on_hit(atom/target, blocked = 0, pierce_hit)
	. = ..()
	fera_silver_damage(target, 10)

/obj/projectile/bullet/darkpack/vamp75
	damage = 120
	armour_penetration = 0
	exposed_wound_bonus = 15
	wound_bonus = 15
	sharpness = SHARP_EDGED

/obj/projectile/bullet/darkpack/vamp75/silver
	armour_penetration = 2

