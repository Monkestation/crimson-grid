https://github.com/Monkestation/crimson-grid/pull/<!--PR Number-->

## Shapeshift quirk traits

Module ID: SHAPESHIFT_QUIRK_TRAITS

### Description:

Merits and flaws that only add a trait (Touch of the Wyld, Pale Aura, Iron Will, and so on) now keep that trait while the holder is in an animal form from Shape of the Beast, Mist Form, Animalism and the like. A quirk opts in with `keep_trait_on_shapeshift = TRUE`. The trait is dropped with the animal body when the holder changes back.

Animal forms still do not carry the caster's splats, so checks that look at splats (Sense Wyrm, Philodox) do not see a shapeshifted vampire.

### TG Proc/File Changes:

- N/A

### Modular Overrides:

- `modular_darkpack/modules/merits_flaws/code/_darkpack_quirk.dm`: `/datum/quirk/darkpack/add_to_holder`, `/datum/quirk/darkpack/remove_from_current_holder`, `var/keep_trait_on_shapeshift`

### Defines:

- N/A

### Included files that are not contained in this module:

- N/A

### Credits:

Absolucy
