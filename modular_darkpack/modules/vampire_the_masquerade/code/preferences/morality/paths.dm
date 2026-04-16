/datum/morality
	var/name = ""
	var/desc = ""
	/// Humanity or Enlightenment
	var/alignment
	/// The bearing of the path's ethos
	var/bearing

/datum/morality/humanity
	name = "Path of Humanity"
	desc = "The Path of Humanity, the most common Path across all Kindred by far, and the only Path which is deemed to be acceptable by the Camarilla, posits that the only way to resist the Beast is by staying true to the values and nature of mortal life. Much in the way the Masquerade seeks to conceal the awareness of vampires from mortal society, the Path of Humanity seeks to suppress the Beast by denying Vampirism and it's darkest urges, and thus, the Masquerade and Humanity go hand-in-hand. Humanity, unlike most Paths, has many advantages, including affecting how 'human' a vampire may look to others. A character who has embraced a Path of Enlightenment or is distant from their Humanity may never breathe or blink, may exhibit animalistic snarls or sunken eyes. Make no mistake - a Vampire on the Path of Humantiy is not a saint. Vampires are predators by nature, and just because they follow this Path doesn't mean they're not. Most mortals are on this Path - but ironically enough, a vampire extremely high in humanity may seem more human than most mortals. Deviating from this Path is intensely dangerous, requires extremely low Humanity, and requires a mentor, and your character will have forever discarded all remaining behaviors, beliefs, appearance, and morality of what once made them human."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_MUNDANE

/datum/morality/power
	name = "Path of Power and the Inner Voice"
	desc = "The Path of Power and the Inner Voice is a Path of Enlightenment that controls the Beast through rigorous determination and the amassing of worldly power. Adherents are called Unifiers."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_COMMAND

/datum/morality/heaven
	name = "Path of Heaven"
	desc = "Followers of Via Caeli attempt to control their Beast through religious devotion. They are frequently referred to as the Faithful."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_HOLINESS

/datum/morality/metamorphosis
	name = "Path of Metamorphosis"
	desc = "The Path of Metamorphosis is a Path of Enlightenment that controls the Beast by studying its limits and the limits of vampirism in general. The Path is the result of the earlier Road of Metamorphosis and it is practiced mostly by the Tzimisce clan."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_INHUMANITY

/datum/morality/assamite
	name = "Path of Blood"
	desc = "The Path of Blood is a Path of Enlightenment found almost exclusively among the Banu Haqim. Its followers fight the Beast with rigorous devotion to the cause of their founder. Adherents are called Dervishes."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_RESOLVE

/datum/morality/hive
	name = "Path of the Hive"
	desc = "Via Hyron, more commonly called Road of the Hive or Path of the Hive, is a minor Road that is followed almost exclusively by the Baali. Adherents are called Abelenes."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_JUSTICE

/datum/morality/kings
	name = "Road of Kings"
	desc = "Via Regalis, commonly called the Road of Kings. Followers of Via Regalis control their Beast by ruling over others. Mortals are inferior, promises will be fulfilled, and power is everything. Those who follow the Road of Kings are known as Scions."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_COMMAND

/datum/morality/heart
	name = "Path of the Scorched Heart"
	desc = "The Path of the Scorched Heart, originally called the Path of Rathmonicus, is an ancient Path of Enlightenment that originates with the True Brujah. Based on the Book of the Empty Heart by Rathmonicus, it was first disseminated among a few Kindred in the Catholic Church; its scriptures were later reunited and compiled by the True Black Hand. The Path of the Scorched Heart controls the Beast by systematically eradicating every emotion within the vampire's heart. The Path is especially favored among the True Brujah, who already cultivate few emotions. Adherents are called the Unforgiving."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_INTELLECT

/datum/morality/typhon
	name = "Path of Typhon"
	desc = "The Path of Typhon is a Path of Enlightenment that draws heavily on Setite doctrine and the religion around their Antediluvian. Adherents are called Theophidians and Typhonists. Outsiders call them Corruptors."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_DEVOTION

/datum/morality/typhon/ecstasy
	name = "Path of Ecstasy"
	desc = "The Path of Ecstasy is intimately tied to a variant of Setite doctrine, finding the act of reveling in euphoria to itself be holy. Ecstatics stuff the beast full of pleasure to render it fat and lazy, and vary from the Typhonists in focusing upon the pleasures rather than the corruption itself."
	bearing = BEARING_RAPTURE

/datum/morality/typhon/warrior
	name = "Path of the Warrior"
	desc = "The Setites of this Path do not corrupt from the shadows, but embody their ideal of Set as a warrior. They consider their fanaticism and masochism to itself be their holy acts, fighting a war to intimidate even the Beast itself with their prowess."
	bearing = BEARING_FURY

/datum/morality/bones
	name = "Path of the Bones"
	desc = "The Path of the Bones, whose followers are nicknamed Gravediggers, is a Path of Enlightenment that suppresses the Beast by studying the true nature of death and its relationships with other states of existence. Scholars of death and the transition into it, followers of this Path benefit Necromantic and Thanatological study via the knowledge they bring, rather than the political or pragmatic benefits of their concourse with the dead. This Path is sometimes derided as one that celebrates wanton murder, but the Gravedigger's curiosity supercedes their concern for life - and their encounters with all manner of mortality can be made victim of their grim curiosity, causing them to rarely deal with mortals, resulting in a very introverted, quiet temperament."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_SILENCE

/datum/morality/bones/death
	name = "Path of Death and the Soul"
	desc = "A path oft-considered 'inspired by' the Path of the Bones when charitable and 'stolen from' the Path when discharitable, it holds many of the same tenets but would be found more commonly amongst the Sabbat. Its adherents claim a distinct nature, but outsiders have yet to identify these distictions."

/datum/morality/night
	name = "Path of Night"
	desc = "Those who follow this path accept that the Embrace has damned them; and they will not be damned alone. Found largely among the younger Lasombra, the purpose of this path is simply to act as an agent of evil and fulfill your sinful nature."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_DARKNESS

/datum/morality/night/road
	name = "Road of Night"
	desc = "Via Noctis, commonly called the Road of Night. The Redeemers feel the weight of Caine's curse and their own damnation, even more so than those who follow Via Caeli. Also like the Faithful, the Redeemers seek redemption and forgiveness, and to earn it requires suffering and purification. However, instead of the fairly benign ways of the Faithful, the Redeemers actively go about the world of man, punishing and killing mortal sinners. Some followers of Via Noctis offer penance for lesser deeds, and still others will Embrace irredeemable mortals to help them in their punishment. They also target Cainites who would tempt mortals into corruption, outstanding examples being the Followers of Set and the Baali."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_GUILT

/datum/morality/honor
	name = "Path of Honorable Accord"
	desc = "The Path of Honorable Accord is a Path of Enlightenment that harnesses the Beast through the rigorous practice of honorable and chivalrous behavior. Known for their loyalty to their group, their leaders, and it's allies, as well as their firm devotion to upholding their own word and promises, these vampires place duty above all else. Adherents are called Knights, Patriots, or Canonici. Make no mistake - vampires who follow this path are not compassionate or humane in any sense. Indeed, they still see humans as little more than chattel or food, and undeserving of the considerations of honor that are bestowed on other vampires."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_DEVOTION

/datum/morality/beast
	name = "Path of the Feral Heart"
	desc = "The Path of the Feral Heart (sometimes called the 'Path of the Beast') is a Path of Enlightenment practiced especially by members of Clan Gangrel. It controls the Beast by accepting its urges as natural and accepting their role as a hunter among hunters. Adherents are called Bestials or Beasts."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_MENACE

/datum/morality/beast/harmony
	name = "Path of Harmony"
	desc = "A similar path to that of the Feral Heart, this is often considered a more ancient variant. While a Harmonist feels much the same regarding their role as a predator, they contextualize themself further with their role in the natural world and tend to have greater Conscience."

/datum/morality/samiel
	name = "Code of Samiel"
	desc = "The Code of Samiel is a doctrine that formalized the tenets of the Warrior Salubri and of the Path of Retribution. It was designed by Saulot's greatest childe warrior, Samiel himself. Adherents swear to bring retribution to all manner of evil, chief among which are Infernalists, Demons and the Followers of Set. Vengeance, vigilance and righteousness are all held as core virtues."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_JUSTICE //I have no idea what this actually does

/datum/morality/caine
	name = "Path of Caine"
	desc = "The Path of Caine, whose followers are commonly called Noddists, are Cainites who devote themselves to studying the nature of the vampyric condition, particularly through the emulation of Caine and the teachings of the Book of Nod. Adherents swear to study, reflect, and unearth the true nature of what it means to be a vampire, as well as embrace and reach the ultimate form of the condition. Followers are often scholarly or introspective vampires who excel in their discipline and rigor. Noddists swear to cast aside their lost humanity, embrace their new condition, emulate Caine in all things, as well as take the vitae of the unworthy through Diablerie to become closer to the Dark Father. Sins include befriending or co-existing with mortals, succumbing to Frenzy or Rotschrek, failing to diablerize a 'Humane' vampire, failing to engage in study or research into vampirism, as well as denying the inherent needs of a vampire by failing to feed or by showing compassion."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_FAITH

/datum/morality/cathari
	name = "Path of Cathari"
	desc = "The Path of Cathari, whose followers are commonly called Albigensians, are vampires whose ethos sprung forth from the Cathar heresy of the Catholic Church in the Dark Ages. The Cathar heresy posited that the world was created in equal parts by a good ('light') creator, responsible for virtue and spirit, and an evil ('dark') creator, responsible for the material world and all it's vices. Vampires who follow this path reason that since those cursed with vampirism are denied the everlasting spiritual peace of an afterlife, due to their immortality, the very essence of their being is to favor this 'dark' creator by tempting others with all the trappings of the material world. Followers of this path, in a way, thus seek spirituality in 'depravity'. Sins include showing restraint, showing trust, murder, sacrificing your own gratification for someone else's convenience, refraining from indulgence, or encouraging others to excersize restraint."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_SEDUCTION // add this

/datum/morality/lilith
	name = "Path of Lilith"
	desc = "The Path of Lilith, often called Bahari or Lilins, are those vampires who study the teachings and lessons of Lilith. Considered heretical by most Cainites of the Sabbat, the Bahari practice the ancient ways handed down by Lilith herself, believing that pain, tribulation, and suffering, are the only roads to learning and true growth. Only through suffering, experiencing the limits of creation and it's sensations, can understanding be had, is what these vampires believe, with little compassion for those who lack the insight or the will to embark upon it's journey. Sins include feeding immediately when hungry, pursuing wealth or power, not correcting others regarding the story of Caine and Lilith, feeling remorse for someone in pain, fearing death, murder, failing to dispense pain and anguish, and shunning pain."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_TRIBULATION // add this

/datum/morality/lilith/seed
	name = "Path of the Serpent's Seed"
	desc = "A variant of Bahari beliefs, adherents of this prefer a much softer touch; to defeat Caine, they have no intent of destruction, they would much prefer to subvert the Noddists and bury his legacy."

/datum/morality/lilith/midwives
	name = "Path of the Red Midwives"
	desc = "A variant of Bahari beliefs, those of this path find birth and creation to be their art. The inhuman and monstrous creatures around them, or those which are newly embraced, are a glory to behold and assist in searching for power in this world."

/datum/morality/lilith/thorn
	name = "Path of the Thorn Garden"
	desc = "A variant of Bahari beliefs, those of the Thorns find a much stronger sense of justice imbued within them. Revenge is set aside in pursuit of the enforcement of code and law; with punishment doled out more than appropriately for those who breach it."

/datum/morality/lilith/witches
	name = "Path of the Lilin Witches"
	desc = "A variant of Bahari beliefs, the witches seek the eldritch lore of the Dark Mother, defending their faithful and even working to cultivate Goddess cults amongst even mortals to venerate Her."

/datum/morality/redemption
	name = "Path of Redemption"
	desc = "There are thousands of terms for God. Jesus, Yahweh, Allah, Ahura-Mazda. Yet one thing is certain: Vampires, being immortal, being cursed by God, witnessing the Great Flood, and being in the First City know that God is real. Followers of this Path are thus extremely devoted believers in their faith and religious principles, using the Curse as evidence of their chance for redemption on the day of their judgment by a benevolent creator. Indeed, vampires are outcasts of Heaven, but could this all be a test? Commonly called 'Martyrs', those who follow the Path of Redemption seek to redeem themselves by sacrificing themselves for others, undoing the selfish, animalistic pull of the Beast and making themselves worthy of the forgiveness of their chosen God (or Gods) once more. Yet God does not expect perfection. Followers of this path embrace the Divine Tide, or the natural cycle of sin, forgiveness, and rebirth. Followers of this Path are also often expected to take confession from members also on this Path, and confess, in turn. Vampires who follow this path are not saints - in fact, they recognize sin as an unfortunate, cyclical destiny as part of the Divine Tide, hoping to one day overcome it with a great and final act of martyrdom, redemption. Sins include not following the ethos of your religion, putting physical needs before spiritual, refusing to offer the opportunity of redemption to others, refusing to take or give confession, allowing a cardinal sin to go unpunished (such as lust, gluttony, anger, pride), and the murder of innocents. Blood Magic is looked down upon by this Path."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_FAITH

/datum/morality/revelation
	name = "Path of Evil Revelations"
	desc = "The Demons, the Fallen Angels, were the first children of God, before man was made from clay, and before the life of Caine. The First Rebel, the Lord Lucifer, demanded explanations from God about His forbidden creations in Shadow, the Qlipphoth, and God not only denied him, but banished him from Heaven forevermore, along with his allies, for if God explained the nature of these creations to Lucifer, it would reveal that God is a fool. An unjust, tyrannical Father who plays favorites with his Children. This great injustice, hidden from the comprehension of mortals, will be undone when Lucifer completes his rebellion. His army of Demons outnumbers the Angels, and when the pretenders are thrown out, Creation will be made right. Vampires who follow the Path of Revelations, called 'Infernalists' thus obey and call themselves allies of Demons, believing themselves natural allies as both are outcasts of Heaven, outside the natural order - after all, vampires hunt humans, God's children. Followers of this Path do not merely accept their inner evil, plenty of other Paths offer that. To follow this Path requires a participation in a battle much more ancient than humankind, than vampirism, than creation itself, in service to an unfathomable 'evil'. Sins include obeying any laws, failing to observe infernalist rituals, altruistic acts, not grabbing power when the opportunity is present, showing self-interest, refusing to support infernal atrocities, failing to serve your Patron Demon, and allowing yourself to be defeated, or outsmarted, by the servants of God."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_CORRUPTION

/datum/morality/entelechy
	name = "Path of Entelechy"
	desc = "Developed by the European Brujah, this intellectual Path posits that Via Humanitas' focus on rejecting the Beast and suppressing it is a passive thing and will never be enough. One must actively fight the Beast with rigorous and disciplined intellectualism, traits which were once essential among Clan Brujah, and traits which they hope, with this Path and it's followers, will reclaim their rightful place as Warrior-Princes among Kindred. With three core principles: Enkrateia (inner strength), Reie (courage) and Saphrosyne (control of the self), this demanding and diligent Path is an eternal battle against the Beast, whereas Humanity merely rejects it. Sins include ill defined or idle thinking, acting on impulse, petty crime like theft robbery or vandalism, causing deliberate harm to any mortal, feeding from an innocent by force, succumbing to the beast, allowing a crime to go unpunished, the murder of innocents, or aiding someone on another path. Never show cowardice. Never take mortals for granted. Feed only to live, no more. Commit yourself to rigorous study and reflection and you will master the Beast. This Path is extremely rare, a grand majority of it's followers being Elder Brujah spreading it once more in reaction to the 'fallen' state of the clan as the Anarch Free State struggles against the New Promise Mandarinate."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_RESOLVE

/datum/morality/ashirra
	name = "Sharia El-Sama"
	desc = "In 623 AD, a Cainite named Suleiman ibn Abdullah visited the city of Medina, seeking to make a hunt of sorts, and feed, on the Prophet Muhammad. Suleiman asked for an audience with the Prophet, and, when granted one, was absolutely stunned by the man's divinity, and bowed before him, overhwlemed by the man's divinity as God's messenger. Suleiman Ibn Abdullah became the first of the Ahirra, the Brotherhood, Vampires who swore to uphold God's holy law as set forth by His Final and Greatest Prophet. In this way, the demon within, the Beast, may be silenced, and a vampire may seek forgiveness from God through prayer and unshakeable faith. Sins include failing to observe the Five Pillars of Islam nightly, not spreading the Faith of Islam, failing to be charitable when necessary, embracing a non-believer, enslaving someone, breaking an oath, murder. Do not feed from an unbeliever. It is preferable to feed from animals. Do not embrace a non-believer, and do not embrace believers, lest they have given consent. The blood bond is slavery - only non-believers must be subjected to it, and if they show true piety to God, they may be released. Follow God in all things, and the Beast inside will be purged. Blood magic is looked down upon by followers of this Path, with Serpentis, daimoinon and Vicissitude completely forbidden."
	alignment = MORALITY_HUMANITY
	bearing = BEARING_FAITH

/datum/morality/paradox
	name = "Path of Paradox"
	desc = "The Path of Paradox is centered around the karmic duty Kindred hold. According to its adherents, Kindred have eluded samsara and hold a svadharma to fulfill; advancement of the cycle of the universe. This largely centers around either finding other Kindreds' role to play in this, or destroying them to return them to samsara."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_CONFIDENCE

/datum/morality/self_focus
	name = "Path of Self-Focus"
	desc = "The Internalists of the Path of Self-Focus would find inaction and acceptance to be their code; they do not worry about what is or what is to be, they worry only about the now. They feed and kill when they need, yet find themselves considered slow and passive by most. A charitable observer may call them perceptive and introspective."
	alignment = MORALITY_ENLIGHTENMENT
	bearing = BEARING_BALANCE
