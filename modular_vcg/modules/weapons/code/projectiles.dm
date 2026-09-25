// Handgun/Compact cartridges

// 9mm

/obj/projectile/bullet/darkpack/vamp9mm
	damage = 20

/obj/projectile/bullet/darkpack/vamp9mm/plus
	damage = 15
	//Edit was 34, reduced to 15 AP Ammo
	armour_penetration = 15

// 4.6mm

/obj/projectile/bullet/darkpack/vamp46mm
	damage = 25
	armour_penetration = 15
	//Edit was 35, Reduced to 15, reducing armor across the board

// .45 Auto

/obj/projectile/bullet/darkpack/vamp45acp
	damage = 25
	//Edit was 35, reduced to 25 5 damage per TT Damage value
	armour_penetration = 0

/obj/projectile/bullet/darkpack/vamp45acp/silver
	armour_penetration = 0

/obj/projectile/bullet/darkpack/vamp45acp/HP
	damage = 30
	//Edit was 50, reduced to 30 5 damage per TT Damage value +5 for HP
	armour_penetration = -10

// .44 Magnum

/obj/projectile/bullet/darkpack/vamp44
	damage = 30
	//Edit was 45, reduced to 30 5 damage per TT Damage value
	armour_penetration = 15
	//Edit was 25, reduced to 15

// .50 Action Express

/obj/projectile/bullet/darkpack/vamp50ae
	damage = 35
	//Edit was 60, reduced to 35 5 damage per TT Damage value +5
	armour_penetration = 10

// Rifle cartridges

// 5.56mm

/obj/projectile/bullet/darkpack/vamp556mm
	damage = 28
	//Edit was 33, reduced to 28 4 damage per TT Damage value AR round
	armour_penetration = 10
	//Edit was 33, Reduced to 10 5.56 is not an AP round

/obj/projectile/bullet/darkpack/vamp556mm/incendiary
	damage= 24
	//CG Edit was 30, reduced to 24
	armour_penetration = 5
	//Edit was 15, reduced to 5

// 5.45mm

/obj/projectile/bullet/darkpack/vamp545mm
	damage = 30
	armour_penetration = 20
	//Edit was 40, Reduced to 20, reducing armor across the board

// 7.62x51mm

/obj/projectile/bullet/darkpack/vamp762x51mm
	damage = 32
	//CG Edit was 55, reduced to 32 4 Damage per TT Value +1 larger AR

/obj/projectile/bullet/darkpack/vamp762x51mm/silver
	exposed_wound_bonus = 0
	wound_bonus = 5

/obj/projectile/bullet/darkpack/vamp762x51mm/incendiary
	Damage = 28
	//CG Edit was 40, reduced to 28 4 per TT damage -1 from parent for incen

// .50 BMG
/obj/projectile/bullet/darkpack/vamp50
	damage = 60
	//Edit was 120, reduced to 60 5 damage per TT Damage Estimating 12 damage
	armour_penetration = 50
	//Edit was 95, reduced to 50 Equiv to Heaviest Armor
	exposed_wound_bonus = -10
	wound_bonus = 20
	sharpness = SHARP_EDGED

// Shotgun ammunition

/obj/projectile/bullet/darkpack/dragonsbreath
	damage = 5
	//Edit was 10, reduced to 5

/obj/projectile/bullet/darkpack/shotpellet
	damage = 5
	//Edit was 12, reduced to 5
	armour_penetration = -10

/obj/projectile/bullet/shotgun_slug/vamp
	damage = 40
	//Edit was 80, reduced to 40 5 damage per TT Damage
	exposed_wound_bonus = 10

// Special projectiles

/obj/projectile/bullet/darkpack/rubber
	damage = 5
	exposed_wound_bonus = 0
	wound_bonus = -5
	sharpness = NONE

/obj/projectile/bullet/crossbow_bolt
	damage = 25
	//Edit was 45, reduced to 25 5 damage per TT Damage
	armour_penetration = 20
	//Edit was 75, reduced to 20

/obj/projectile/bullet/darkpack/vamp75
	damage = 50
	//Edit was 150, reduced to 50 5 damage per TT Damage Estimating 10 damage
	armour_penetration = 20
	//Edit was 60, reduced to 20

/obj/projectile/bullet/darkpack/vamp75/silver
	armour_penetration = 10
	//Edit was 50 reduced to 10
