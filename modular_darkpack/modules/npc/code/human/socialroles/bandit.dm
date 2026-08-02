
/datum/socialrole/bandit
	s_tones = list(
		"albino",
		"caucasian1",
		"caucasian2",
		"caucasian3",
		"latino",
		"mediterranean",
		"asian1",
		"asian2",
		"arab",
		"indian",
		"african1",
		"african2"
	)

	min_age = 18
	max_age = 45
	preferred_gender = MALE
	male_names = null
	surnames = null
	is_criminal = TRUE

	hair_colors = list(
		"#040404",	//Black
		"#120b05",	//Dark Brown
		"#342414",	//Brown
		"#554433"	//Light Brown
	)
	male_hair = list(
		"Balding Hair",
		"Bedhead",
		"Bedhead 2",
		"Bedhead 3",
		"Boddicker",
		"Business Hair",
		"Business Hair 2",
		"Business Hair 3",
		"Business Hair 4",
		"Coffee House",
		"Combover",
		"Crewcut",
		"Father",
		"Flat Top",
		"Gelled Back",
		"Joestar",
		"Keanu Hair",
		"Oxton",
		"Volaju"
	)
	male_facial = list(
		"Beard (Abraham Lincoln)",
		"Beard (Chinstrap)",
		"Beard (Full)",
		"Beard (Cropped Fullbeard)",
		"Beard (Hipster)",
		"Beard (Neckbeard)",
		"Beard (Three o Clock Shadow)",
		"Beard (Five o Clock Shadow)",
		"Beard (Seven o Clock Shadow)",
		"Moustache (Hulk Hogan)",
		"Moustache (Watson)",
		"Sideburns (Elvis)",
		"Sideburns",
		"Shaved"
	)

	shoes = list(
		/obj/item/clothing/shoes/vampire/sneakers,
		/obj/item/clothing/shoes/vampire/sneakers/red,
		/obj/item/clothing/shoes/vampire/jackboots
	)
	uniforms = list(
		/obj/item/clothing/under/vampire/larry,
		/obj/item/clothing/under/vampire/bandit,
		/obj/item/clothing/under/vampire/biker
	)
	hats = list(
		/obj/item/clothing/head/vampire/bandana,
		/obj/item/clothing/head/vampire/bandana/red,
		/obj/item/clothing/head/vampire/bandana/black,
		/obj/item/clothing/head/vampire/beanie,
		/obj/item/clothing/head/vampire/beanie/black
	)
	pockets = list(
		// /obj/item/stack/dollar/rand,
		/obj/item/vamp/keys/hack
	)

	//[Lucia] - this has been edited to have better English because it included slurs, but none of the others have yet
	male_phrases = list(
		"Whatchu staring at?",
		"Tryina threaten me or sumthin'?",
		"You need somethin'?",
		"You've got some balls, that's for sure.",
		"You know who I work for?",
		"Get the hell outta here, 'fore I get my gang on yo' ass.",
		"You need sumn' punk?",
		"Get lost, liberal.",
		"Get outta this side of town.",
		"Think you scare me? You know who I work for?",
		"Think you're hot shit?"
	)
	neutral_phrases = list(
		"Why you starin' at me like that?",
		"Another dumbass tryin' to look threatening.",
		"Halloween's over, what's with the costumes.",
		"I think that whore gave me the clap.",
		"Gotta get home soon, family to feed and all that.",
		"Get lost, liberal.",
		"I think.. I miss my wife.",
		"What? You need somethin?",
		"Outta my way.",
		"Piss off asshole, ain't in the mood for your shit.",
		"Fuck off."
	)
	random_phrases = list(
		"Dumbass.",
		"I miss my girl...",
		"What's wrong bro?",
		"GOOD. FUCKING. EVENING.",
		"Evenin.",
		"Y'know I saw you sellin' dope, right?",
		"We're fucking doomed...",
		"It's over...",
		"Guh..."
	)
	answer_phrases = list(
		"I've got it...",
		"Fucking hellhole, this whole town.",
		"Shit, man.",
		"You don' look like I know you.. Do I know you?",
		"Right.",
		"Uhmm... Cool I guess",
		"Had some good food over at gummaguts, stomach hurts though..."
	)
	drug_turf_phrases = list(
		"I'll beat your ass punk!",
		"Scram you fuckin' rat!",
		"Find your own corner bitch!",
		"You're pushin' weight on my block?",
		"Someone's about to learn some respect!",
	)
	help_phrases = list(
		"God, not again!",
		"Fucking FREAK!",
		"What the hell are you doing!?",
		"You fucked up!",
		"Check yo' self, fool!",
		"We got shit, shit that'll shut you up for good!"
	)
	drug_purchase_phrases = list(
		"You know what kid? I'm feeling generous.",
		"Yeah, that's about as much as that junk is worth.",
		"Take that and take a hike if you know what's good for ya."
	)
