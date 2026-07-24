/**
 * # Splat
 *
 * A type of supernatural being (like vampires, werewolves, ghouls, etc.) that
 * players can be. Has traits and actions that are inherent to all members
 * of the splat.
 *
 * Also manages the supernatural powers of this splat that the owner has, but
 * it's limited until future reworks improve powers.
 */
/datum/splat
	abstract_type = /datum/splat

	/// Name of the splat
	var/name
	/// Description of what the splat is and what it does
	var/desc
	/// ID for trait sources and whatnot
	var/id

	/**
	 * The priority a splat has in being returned when checked for, and for overriding behavoirs if something contests
	 *
	 * Typically a two digit number plus a SPLAT_PRIO define to ensure its easy to shift around prios and nothing overlaps.
	 * e.g 50 + SPLAT_PRIO_SPLAT for a mid imporant fullsplat
	 */
	var/splat_priority = SPLAT_PRIO_SPLAT
	var/half_splat = FALSE

	/// Traits possessed by all members of this splat
	var/list/splat_traits
	/// Actions possessed by all members of this splat
	var/list/splat_actions
	/// Biotypes possessed by all members of this splat
	var/splat_biotypes
	/// Base type of the powers that this splat has
	var/power_type

	/// If examining the pulled tooth of the splat can gain some indication of what it is.
	var/tooth_fingerprint = FALSE

	/// Can frenzy and is given a verb to manually do it.
	var/can_frenzy = TRUE

	/// Splats that someone with this splat cannot gain
	var/list/incompatible_splats

	/// Powers unique to this splat possessed by the owner
	var/list/datum/action/powers
	/// Which power is currently selected by keybinds
	var/datum/action/selected_power
	/// Mob this splat belongs to
	var/mob/living/carbon/human/owner
