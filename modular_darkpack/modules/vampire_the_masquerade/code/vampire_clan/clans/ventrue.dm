/datum/subsplat/vampire_clan/ventrue
	name = "Ventrue"
	ru_name = "Вентру"
	id = VAMPIRE_CLAN_VENTRUE
	desc = "Вентру не зря зовут Кланом Королей. Они тщательно отбирают потомков среди смертных, знающих толк во власти, богатстве и влиянии, и считают себя аристократами вампирского мира. От каждого из них ждут, что он возьмёт командование на себя везде, где это возможно, и они готовы выдержать любую бурю, лишь бы вести за собой. Вентру - аристократы, управленцы и правители, которые во многих городах стоят в центре власти Камарильи. Старейшина Вентру нередко удерживает праксис в качестве Князя, и клан пользуется престижем и влиянием в местной политике. Вентру убеждены, что править - их право и их долг, хотя многие видят в них заносчивых снобов, помешанных на контроле. Гордецы, большинство Вентру могут проследить цепочку Становлений в своём роду до самого основателя клана. Клановый изъян позволяет им питаться только от строго определённых сосудов."
	icon = "ventrue"
	curse = "Кровь простолюдинов и животных им омерзительна."
	roleplay_level = "Средний"
	sense_the_sin_text = "не находит вкуса в крови бедняков."
	clan_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/fortitude,
		/datum/discipline/presence
	)
	subsplat_traits = list(
		TRAIT_FEEDING_RESTRICTION,
		TRAIT_VENTRUE_SENSE,
	)
	male_clothes = /obj/item/clothing/under/vampire/ventrue
	female_clothes = /obj/item/clothing/under/vampire/ventrue/female
	subsplat_keys = /obj/item/vamp/keys/ventrue

/* CORVAX EDIT REMOVE
/datum/subsplat/vampire_clan/ventrue/antitribu
	name = "Ventrue antitribu"
	ru_name = "Вентру-антитрибу"
	id = VAMPIRE_CLAN_VENTRUE_ANTITRIBU
	desc = "Основная ветвь Вентру - это прежде всего \"великодушные\" лорды и леди Камарильи, которые предпочитают править человечеством через Маскарад и хитросплетённые сети гулей и подставных лиц, служа Патриархам и своим сирам. Вентру-антитрибу - Тёмные Рыцари и Крестоносцы Шабаша. Они поклялись сражаться с малодушной Камарильей, что правит мягкой силой во благо Третьего поколения Сородичей, предавшего, как известно, Каина, Тёмного Отца всех вампиров."
	icon = "ventrue_antitribu"
	roleplay_level = "Высокий"
	clan_disciplines = list(
		/datum/discipline/dominate,
		/datum/discipline/fortitude,
		/datum/discipline/auspex
	)
*/
