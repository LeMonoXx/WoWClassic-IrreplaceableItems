QuestItemDBKeys = {
    ['itemId'] = 1, -- int id of the item to choose
    ['description'] = 2, -- string description why the item should be taken
	['questId'] = 3, -- int id of the quest
	['side'] = 4, -- string H for horde. A for Alliance
	['class'] = 5 -- string name of the class that the reward is for
}

QuestItemDB = {
   [1] = { 
	  5394, 
	  "This item iiiiiiiinncredible! BiS!", 
	  456,	  
	  "A",
	  nil 
	},
   [2] = {
      1172,
      "This is one of the few equippable items in the game that emits its own light source. It’s worth hanging on to if you’re into roleplaying at all.",
	  104,
	  "A",
      nil
   },
   [3] = {
      16788,
      "A shield with the model of a ship’s wheel. Worth keeping for any aspiring roleplayers looking to complete their pirate set.",
      104,
      nil,
      nil
   },
   [4] = {
      5462,
      "This item is completely unique and irreplaceable. Simply keep the quest active in your quest log, and the item will remain in your bags. If you do abandon the quest and the rod is destroyed, simply re-accept the quest (and keep it this time), and you will be able to continue using the rod indefinitely. The rewards from the quest are nowhere near as valuable as the rod itself - so don’t hand it in! Pro tip: this can be used in PvP to ‘fake’ casting a spell in order to bait an interrupt from you opponent.",
      1046,
      "A",
      nil
   },
   [5] = {
      7344,
      "It functions like a weak Sunder Armor which all classes can use - helpful for melee classes when attempting a difficult mob since it can be switched in/out during combat. This is an especially important item for Paladins due to their lack of any long range attack - this allows Paladins to initiate ranged pulls when tanking.",
      55,
      nil,
      nil
   },
   [6] = {
      4984,
      "This is one of the most unique items in the game and is extremely useful in PvP as well as niche PvE scenarios. Make sure you keep hold of it. The speed increase is a great on-use sprint for all classes, but the real benefit is the ability to damage yourself on command. This allows you to break (and become temporarily immune to) certain types of CC which break when damage is taken, such as Polymorph, Frost Nova, Blind, Sap, and Freezing Trap. It’s also useful for breaking some PvE effects, such as Blind and Gouge on High Priest Thekal (Tiger boss in ZG) and Enveloping Winds (a 10s stun) cast by Ossirian the Unscarred (final boss in AQ20).",
      737,
      nil,
      nil
   },
   [7] = {
	  9466,
      "A novelty item that allows you to perform the ‘mining’ animation anywhere in the world. Can be used for maximum BM by ‘mining’ the corpse of your recently defeated foes. Just make sure not to hand in the quest in order to keep the shovel in your inventory.",
      2987,
      "H",
      nil
   },
   [8] = {
      2820,
      "This trinket is extremely useful, even at max level. As such, make you keep hold of it.",
      778,
      nil,
      nil
   },
   [9] = {
      19141,
      "Removing bleed effects is generally not possible without a Paladin bubble, which makes this trinket very unique. There are some limited uses in PvE (e.g. Core Hounds in Molten Core) though it’s probably more useful for PvP twinks to use vs. Warriors/Rogues.",
      7727,
      nil,
      nil
   },
   [10] = {
      11122,
      "This is the only possible quest reward, so there’s no risk of not choosing it, just make sure you keep hold of it. It’s the only trinket in the game that provides a mounted movement speed increase. It does stack with the 2% increase from the Riding Skill enchant on gloves, as well as the 4% increase from the Mithril Spurs blacksmithing ‘enchant’. It doesn’t stack with the Retribution Paladin talent Pursuit of Justice",
      2770,
      nil,
      nil
   },
   [12] = {
      11902,
      "This is an extremely unique trinket with a ranged stun/disarm effect which can see use in PvP. It’s also an item which Paladins can use to assist with ranged pulls when tanking.",
      3962,
      nil,
      nil
   },
   [13] = {
      13347,
      "The value in this item comes from being able to damage yourself to break CC effects on demand, but it cannot be switched during combat, and also that the damage doesn’t stop until the trinket is unequipped. This again works well for the Ossirian encounter in AQ20, since healing through the relatively low periodic damage from the trinket is much easier to manage than dealing with a threat drop on the main tank (caused by the whirlwind CC effect). In order to keep this item, make sure you do not hand in the quest",
      5253,
      "A",
      nil
   },
   [14] = {
      14023,
      "This might look like a novelty item at first - it spawns three relatively weak npcs that will attack hostile enemies. They don’t hit hard, but with three of them they hit quite fast. This can be particularly useful in PvP vs. casters, since the npcs do a great job of pushing back spell casting. As such, make sure you keep hold of this item.",
      5344,
      nil,
      nil
   },
   [15] = {
      11904,
      "All casters should make sure to take the offhand as the reward from this quest, and to keep hold of it. This is a fantastic starter offhand for both healers and DPS at level 60, and is unlikely to be replaced until you can get hold of either Drakestone (DPS), or Thaurissan's Royal Scepter (Healers).",
      3962,
      nil,
      nil
   },
   [17] = {
      5421,
      "This is the only quest which offers a unique weapon enchant as a reward. It’s not possible to acquire this enchant by any other means, and you only get one ‘copy’ to use per character. Save it if you plan on doing any AoE tanking/farming to use on your weapon at lvl 60.",
      706,
      nil,
      nil
   },
   [18] = {
      1131,
      "Something that aspiring bear druids may wish to hold on to since it functions as an additional thorns effect when AoE tanking large groups.",
      101,
      "A",
      "Druid"
   },
   [19] = {
      13966,
      "It’s strongly recommended that all Druids take this trinket as it is the best-in-slot trinket for bear tanks through all Vanilla content and will never be replaced. If you want to keep your options open for tanking, take this as your reward.",
      5102,
      nil,
      "Druid"
   },
   [20] = {
      19991,
      "An excellent trinket, useful throughout all content due to Hunters having the ability to Feign Death & trinket swap to cycle trinkets in combat. Always take this. The hit% is useful initially but the AP buff will always be valuable. It is comparable to the Earthstrike trinket which comes in phase 5.",
      8232,
      nil,
      "Hunter"
   },
   [21] = {
      19107,
      "This is a fantastic pre-BiS crossbow for Hunters. Always take this. The slow 3.30 speed makes it ideal for weaving in aimed shots between auto shot. Initially Blackcrow from LBRS may be better for reaching the hit% cap, but once hit capped, Bloodseeker becomes the best pre-BiS ranged weapon for Hunters.",
      8271,
      nil,
      "Hunter"
   },
   [22] = {
      20036,
      "This is easily the most unique and most useful item of the three. Not only do you get a refillable mana potion to use every three minutes, it also gives a huge buff to your next fire spell. Has its uses when farming and for popping in between trash pulls before switching to a more powerful trinket while cooling down. It’s like a budget Warmth of Forgiveness which is locked all the way behind the Four Horsemen in Naxx! Always take this.",
      8253,
      nil,
      "Mage"
   },
   [23] = {
      20512,
      "Items that offer crit for both spells and melee are extremely hard to come by, making this trinket quite unique. It’s useful both offensively and defensively, for damage as well as healing, making this a great item all round. It’s likely to be replaced in the long run, however it’s a great trinket for levelling and early level 60. Always take this.",
      8418,
      "A",
      "Paladin"
   },
   [24] = {
      13243,
      "If you plan on trying out Paladin tanking at all, it may be worth taking the shield over the sword. The effect is unique and extremely useful, especially for AoE tanking. The downside is that you miss out on the unique weapon model of the sword.",
      5265,
      "A",
      "Paladin"
   },
   [25] = {
      13246,
      "The sword is ok stat-wise - it can be useful in Stratholme and Scholomance due to the proc, however Mirah's Song is a fine alternative. The main consideration for the sword is for looks. It’s one of only two weapons with a glowing blade effect (aka lightsaber model), and as far as I can tell this is the only one with a blue blade.",
      5265,
      "A",
      "Paladin"
   },
   [26] = {
      16058,
      "This ring is absolutely amazing for Holy. Depending on how lucky you get with drops in MC/BWL, you may end up not replacing this for a very long time. If you’re planning to heal in any capacity, it is strongly recommended that you take the ring over the other items.",
      5944,
      "A",
      "Paladin"
   },
   [27] = {
      5244,
      "While it may seem unimpressive at first glance, this wand has a ridiculously fast 1.2s attack speed, making it one of the fastest wands available. This is particularly useful on long boss fights - during a low damage phase, casters are encouraged to switch to wanding while a Paladin keeps Judgement of Wisdom on the boss, allowing the raid to restore mana over time. It is recommended that you keep hold of this item. It can also be useful for increased spell pushback on caster opponents in PvP.",
      223,
      "A",
      "Priest"
   },
   [28] = {
      19990,
      "This is a fantastic trinket for healing and will be useful even at level 60. Trinkets that give an on-use bonus to healing are very hard to come by, so it’s absolutely worth taking this over the other possible rewards, even if you plan to go shadow.",
      8257,
      nil,
      "Priest"
   },
   [29] = {
      16058,
      "This ring is absolutely amazing for healers. Depending on how lucky you get with drops in MC/BWL, you may end up not replacing this for a very long time. If you’re planning to heal in any capacity, it is strongly recommended that you take the ring over the cloak.",
      5944,
      nil,
      "Priest"
   },
   [30] = {
      17705,
      "Despite being rewarded from a level 51 quest, Thrash Blade is an excellent starter weapon for combat Rogues, at level 60. Take this as your reward and keep hold of it, as it will likely serve you until you can get your hands on Dal’Rend's from UBRS.",
      7065,
      nil,
      "Rogue"
   },
   [31] = {
      19982,
      "This cloak really is a unique item, applying a passive ‘Safe Fall’ buff which stacks with the Rogue’s existing Safe Fall ability. It’s estimated to be somewhere around 60% as effective as the Rogue ability, allowing you to take even less damage when falling from greater heights. This can be especially useful for moving from higher bases to lower bases in Arathi Basin, where the height of the terrain can be a hazard to other classes. There is an engineering item, the Parachute Cloak, which has an on-use effect of reducing fall speed, however this requires engineering to use, has a 30min cooldown, and lasts for only 10sec whereas the Duskbat Drape buff is permanent. It is strongly recommended that you take the cloak over the other two items.",
      8236,
      nil,
      "Rogue"
   },
   [32] = {
      20503,
      "An excellent trinket, giving you an additional Mana Spring Totem to cast every three minutes. It’s free to cast, grants more mana than an improved Mana Spring Totem, and doesn’t interrupt your MP5 regen window when cast. Useful in dungeons and raids at 60 - make sure you take this item over the other two.",
      8413,
      "H",
      "Shaman"
   },
   [33] = {
      15108,
      "Despite its low level, this is an excellent offhand for Warlocks. It’s comparable to the pre-BiS options which are usually items with the ‘...of Shadow Wrath’ suffix making them difficult (or expensive) to obtain. It is highly recommended that you take this item over the staff.",
      4964,
      nil,
      "Warlock"
   },
   [34] = {
      20536,
      "One of the most awesome weapon models for Warlocks. The downside is that the weapon will be replaced relatively quickly upon reaching lvl 60. The main reason to take this is for looks rather than the stats. There isn’t really a right answer between taking this vs. the trinket - it’s down to preference.",
      8422,
      nil,
      "Warlock"
   },
   [35] = {
      20534,
      "Unlike the other items, the trinket will not simply be replaced at 60 since the effect is so unique. While not the most useful effect, it does have its applications, for example you can use it to get an extra shield from Sacrifice, even if you’re out of shards or mana. Take this if you’d prefer to have a unique and semi-useful trinket rather than the uber looking staff.",
      8422,
      nil,
      "Warlock"
   },
   [36] = {
      6972,
      "This is essentially a reusable Rage Potion. It’s somewhat limited due to the long one hour cooldown, but probably the most useful application is to use this along with similar items to build rage prior to a boss pull for maximum threat during the first few seconds.",
      1782,
      "A",
      "Warrior"
   },
   [37] = {
      7133,
      "This is essentially a reusable Rage Potion. It’s somewhat limited due to the long one hour cooldown, but probably the most useful application is to use this along with similar items to build rage prior to a boss pull for maximum threat during the first few seconds.",
      1848,
      "H",
      "Warrior"
   },
   [38] = {
      17774,
      "Given its level, it may seem weak compared to some of the other early tanking trinkets at level 60, however this is one of the best items in terms of raw tank stats, and even tops Taladril's list for Sustained Value. Granting 25 stam, 25 agi, and 25 str for one whole minute is absolutely bonkers for a proc, since it’s uptime will end up being close to 100% when tanking groups of mobs. That equates to an incredible 250hp, 1.25% crit, 1.25% dodge, 50 attack power, and 1.25 block value!",
      7067,
      nil,
      "Warrior"
   },
   [39] = {
      17705,
      "Thrash Blade is an excellent Main Hand weapon for fresh lvl 60 Fury Warriors. It probably won’t be replaced until you get Dal’Rend's from UBRS (or Ironfoe, lol). Even if you plan on tanking 100%, there will be occasions where you need to DPS, and Thrash Blade is a great option early on. It is strongly recommended that you take the sword over the staff.",
      7065,
      nil,
      "Warrior"
   },
   [40] = {
      20130,
      "This trinket is incredible - 75 str for one minute is a huge buff given similar on-use trinkets only last for 20sec or less. This can be stacked with Deathwish, Recklessness and consumables for some ridiculous burst. There are similar trinkets from AQ onwards but having more options means more trinkets to swap in while others are cool down. Always take the trinket.",
      8425,
      nil,
      "Warrior"
   },
   [41] = {
      13243,
      "This shield is great for AoE tanking and can provide a decent alternative to Force Reactive Disk for non-engineers. The proc provides excellent mitigation, and appears to have no internal cooldown, making it ideal for negating damage from large numbers of small mobs (e.g. after Ramstein the Gorger in Stratholme or AoE farming low level dungeons). It is recommended to take the shield if you have no interest in the weapon model of the sword.",
      5265,
      nil,
      "Warrior"
   },
   [42] = {
      13246,
      "The sword is ok stat-wise - it can be useful in Stratholme and Scholomance due to the proc, however Mirah's Song is a fine alternative. The main consideration for the sword is for looks. It is one of only two weapons with a glowing blade effect (aka lightsaber model), and as far as I can tell this is the only one with a blue blade. For Warriors, it is down to personal preference if you value the AoE tanking capability provided by the shield over the weapon model and RP potential of the sword.",
      5265,
      nil,
      "Warrior"
   },
   [43] = {
      13984,
      "Make sure you take this over the sword. The fast attack speed and chance on hit make it a great weapon for the Viscidus fight in AQ40.",
      5466,
      nil,
      "Warrior"
   },
   [44] = {
      15411,
      "This is a fantastic pre-BiS neck piece for Fury which isn’t replaced until you get the Onyxia Tooth Pendant. It’s comparable to the Eye of Hakkar from Hakkar in ZG (Phase 4), having only 14 less attack power. It is strongly recommended that you take this over the chest, even if you plan on tanking 100%.",
      5944,
      nil,
      "Warrior"
   },
   [45] = {
      13959,
      "Take this over the gloves, unless you already happen to have Brigam Girdle from UBRS.",
      4903,
      nil,
      "Warrior"
   },
   [46] = {
      13965,
      "Always take this. The other tank trinket is hot trash. This is pre-BiS for DPS and also great for threat if you plan on tanking.",
      5102,
      nil,
      "Warrior"
   },
   [47] = {
      18404,
      "Given the importance of threat when tanking, the neck piece is generally considered to be the better pick between this and the trinket. The agi and stam are perfect tank stats, and the hit% and crit% combo is perfect for threat. Only one other neck has this combination of hit and crit and it drops from AQ20 with no tank stats to back it up. This neck is not replaced for tanks until C'Thun and for DPS it’s useful through all content but can be replaced with the neck from KT in Naxx if the hit isn’t needed. The same rule applies that as a tank you will undoubtedly spend some of your time DPSing, making the neck more valuable overall. See Skarm’s video for further commentary.",
      7496,
      nil,
      "Warrior"
   },
   [48] = {
      18406,
      "This is an excellent tanking trinket for mitigation, and probably wouldn’t ever be completely replaced. However, mitigation is generally less important than threat in high level raiding, hence this trinket becomes less valuable. Tanks will usually end up using a combination of Styleen's and DFT from BWL onwards. The 15FR is nice but not essential since there are other trinkets which fill that role. As a substitute, Force of Will provides 1 less Defence but replaces the 1% parry with a proc effect. The 7 health per 5 sec is irrelevant.",
      7496,
      nil,
      "Warrior"
   },
   [49] = {
      19383,
      "This is another tough choice for tanks.The neck is BiS for mitigation until C'Thun, however if you’ve chosen to take the Ony neck, you will already have a great item in this slot. If you took the Ony trinket instead, then taking the neck here is probably the right choice. However the ring is fantastic for both threat and DPS, and given the importance of threat, may mean that the ring is a slightly better option.",
      7782,
      nil,
      "Warrior"
   },
   [50] = {
      19384,
      "For Fury, this is the obvious choice, however for tanks it comes down to what you need more: a defensive neck piece or a threat/DPS ring. If you already have Accuria, and Don Julio's (both from phase 3), the ring becomes less valuable. If you already have the Ony neck and Medallion of Steadfast Might, the neck becomes less valuable. It all comes down to what slots you currently have filled, what gear you find yourself using the most (threat vs. mitigation) and what you are most likely to use going into AQ40.",
      7782,
      nil,
      "Warrior"
   }
}

function getByItemId(searchId, myTable)
	for key,value in pairs(myTable) do
		local itemId = myTable[key][QuestItemDBKeys['itemId']]
		-- print("itemId is: " ..itemId.. "")
		if searchId == itemId then
			-- print("found: " ..itemId.. "")
			return myTable[key];
		end
	end
end

function getByQuestId(searchId, myTable)
	for key,value in pairs(myTable) do
		local questId = myTable[key][QuestItemDBKeys['questId']]
		-- print("QuestId is: " ..questId.. "")
		if searchId == questId then
			-- print("found: " ..questId.. "")
			return myTable[key];
		end
	end
	return nil;
end


-- foundQuest = getByQuestId(7496,QuestItemDB)
-- foundQuest2 = getByItemId(4984,QuestItemDB)
-- print(foundQuest[QuestItemDBKeys['questId']]) 
-- print(foundQuest2[QuestItemDBKeys['itemId']])
