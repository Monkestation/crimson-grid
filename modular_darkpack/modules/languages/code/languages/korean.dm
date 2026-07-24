/datum/language/korean
	name = "Korean"
	desc = "Korean is spoken in Korea, as well as being the eighth most spoken language in San Francisco."
	flags = LANGUAGE_TONGUELESS_SPEECH
	key = "K"
	space_chance = 100
	sentence_chance = 10
	between_word_sentence_chance = 10
	between_word_space_chance = 75
	additional_syllable_low = -2
	additional_syllable_high = -1
	// Words instead of syllables
	syllables = list(
		"geureochiman","na","geona","geurigo","go","geuraeseo","seo","nikka","myeon","wa","wihae",
		"geuttae","kkeudeopda","keuda","meolda","gabyeopda","gwayeon","jal","bammada","imi",
		"bijeongsangjeok","areumdapda","gimanjeok","chimyeongjeok","joyonghada","yak","an","bak",
		"ap","sok","igeo","geugeo","jeogeo","yeogi","geogi","geubun","noe","geu","geu nyeo","uri",
		"geu dul","nado","sigan","namja","bangbeop","saramdeul","insaeng","nal","il","jeonhwa",
		"bam","jip","saenggak","don","ireum","abeoji","jangso","neukkim","yeoja","maeum","gajok",
		"munje","huimang","jugeum","kkeut","gihoi","pi","sinloe","myeongryeong","bit","joyonghan",
		"gamgak","gongpo","beomjoe","yeonghon","bagjwi","mulda","heubhyeolgwi","geulimja",
		"nollaun","bagjwi","gae","agmong","jeongchi","sal-in","daenseu","gippeum","eummo",
		"miseuteoli","godaeui","eondedeu","gwisin","nongjang","eolyeoun","yeohaenghada",
		"jadongcha","daeyang","agma","gyohoe","malttug","sanyangkkun","dallida","doju","chaeg","jinsil"
	)
	icon_state = "korean"
	default_priority = 90

	mutual_understanding = list(
		/datum/language/japanese = 25,
	)

	restricted = FALSE
