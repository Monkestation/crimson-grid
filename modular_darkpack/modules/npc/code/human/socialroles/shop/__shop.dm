/datum/socialrole/shop
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

	hair_colors = list(
		"#040404",	//Black
		"#120b05",	//Dark Brown
		"#342414",	//Brown
		"#554433",	//Light Brown
		"#695c3b",	//Dark Blond
		"#ad924e",	//Blond
		"#dac07f",	//Light Blond
		"#802400",	//Ginger
		"#a5380e",	//Ginger alt
		"#ffeace",	//Albino
		"#650b0b",	//Punk Red
		"#14350e",	//Punk Green
		"#080918"	//Punk Blue
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
		/obj/item/clothing/shoes/vampire,
		/obj/item/clothing/shoes/vampire/brown
	)
	uniforms = list(
		/obj/item/clothing/under/vampire/mechanic,
		/obj/item/clothing/under/vampire/brujah,
		/obj/item/clothing/under/vampire/emo,
		/obj/item/clothing/under/vampire/suit,
		/obj/item/clothing/under/vampire/turtleneck_black,
		/obj/item/clothing/under/vampire/office,
		/obj/item/clothing/under/vampire/gangrel,
		/obj/item/clothing/under/vampire/tremere,
		/obj/item/clothing/under/vampire/supply,
	)
	pockets = list(
		/obj/item/vamp/keys/npc,
		// /obj/item/stack/dollar/rand
	)

	male_phrases = list(
		"Wanna buy something?",
		"Can I help?",
		"Hey, wanna buy it?"
	)
	neutral_phrases = list(
		"Wanna buy something?",
		"Can I help?",
		"Hey, wanna buy it?"
	)
	random_phrases = list(
		"Can I help you find something?",
		"Let me know if you need anything.",
		"Take your time.",
		"Good eye, that one's popular.",
		"Cash or card, don't matter to me.",
		"We just got a new shipment in.",
		"You look like you know what you want.",
		"That one's on sale. Don't ask why.",
		"Been a slow day. Glad you stopped in.",
		"I've been running this place twelve years. Feels like thirty.",
		"My last employee quit without notice. Hence... this.",
		"Everything's priced fair. Mostly.",
		"Take a look around, no pressure.",
		"The owner's never here. I basically run this place.",
		"We don't do refunds.",
		"You need a bag? Bags are five cents. City law. Don't blame me!",
		"Holler if you need me, I'll be pretending to do inventory.",
	)
	answer_phrases = list("I just work here...")
	help_phrases = list(
		"What in the god damn?!",
		"Go away or I will call the cops!!",
		"What is happening?!",
		"Stop doing this!",
		"Someone, call the ambulance!"
	)
	var/masquerade_item_phrases = list(
		"Eh? You get this from a garage sale?",
		"Looks funny. I'll give it to my uncle for his birthday.",
		"Take the money and go. I don't do business with Satanists."
	)
	var/masquerade_item_failure_phrases = list(
		"What the hell? Buddy, you're creeping me out.",
		"Where did you get this?!",
		"Ok, I'll buy it, but please leave..."
	)
