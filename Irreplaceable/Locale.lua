local _, ns = ...

local enUS = {
    TITLE = "Irreplaceable",
    keep = "Keep it. Do not vendor.",
    pick = "Take this",
    avoid = "Do not take this",
    hold = "Do not turn in",
    UNKNOWN_ITEM = "Item %d",
    TURNIN_WARN = "This quest takes an item you cannot get again.",
    TURN_IN_ANYWAY = "Turn in anyway",
    LEAVE_OPEN = "Leave it open",
    QUEST_ACCEPTED = "Quest accepted",
    LOADED = "loaded. /irreplaceable test",
    HELP_TEST = "/irreplaceable test  shows the alert without owning the item",
    HELP_LIST = "/irreplaceable list  counts what applies to this character",
    LIST_COUNT = "%d entries for this character, %d in the catalog.",

    item1178 = "Explosive Rocket from Shipment to Stormwind. A small area blast that interrupts eating and first aid. You only ever get one stack.",
    item1434 = "Glowing Wax Stick from Kobold Candles. Lowers armor and prevents stealth. Useful against rogues and druids, and you cannot buy another.",
    item4945 = "Faintly Glowing Skull from Minshina's Skull. A one-shot life drain. On Hardcore it is an emergency button, and then it is gone.",
    item4941 = "Really Sticky Glue from A Solvent Spirit. Roots the target for ten seconds. A few charges, and the quest does not repeat.",
    item1191 = "Bag of Marbles from Gold Dust Exchange. Lowers the target's chance to hit by 25 percent for ten seconds, bosses included. Ten charges, then never again.",
    item3434 = "Slumber Sand from A New Plague. Sleeps one target for up to twenty seconds. Only a few charges.",
    item1322 = "Fishliver Oil from Selling Fish. Ten percent attack speed for thirty seconds, five charges. Save it for a physical class's big moment.",
    item5462 = "Dartol's Rod. Turns you into a furbolg for three minutes, on any class. Raene's Cleansing takes it when you turn in Ran Bloodtooth's skull. The rewards are not worth the rod.",
    item1127 = "Flash Bundle from Wolves at Our Heels. A pillar of fire on demand. A few charges, and no vendor sells it.",
    item5816 = "Light of Elune from Mage Summoner. Ten seconds of immunity to everything, long enough to hearth. The strongest leveling consumable, and you only get one.",
    item4984 = "Skull of Impending Doom from Forbidden Knowledge. A sprint that damages you, which breaks polymorph, frost nova, traps, and similar effects. Once only, and still useful later in PvP and on a few bosses.",
    item2820 = "Nifty Stopwatch from This Is Going to Be Hard. Forty percent run speed for ten seconds. One of the few sprints every class can use, including at 60.",
    item11122 = "Carrot on a Stick from Gahz'rilla. Three percent mounted speed. Stacks with the glove enchant and Mithril Spurs, not with Pursuit of Justice.",
    item5421 = "Fiery Blaze Enchantment, the only one-time weapon enchant from a quest. A chance to deal fire damage around you. Save it for AoE farming. Do not put it on a leveling weapon.",
    item19022 = "Nat Pagle's Extreme Angler FC-5000 from Snapjaws, Mon!. Plus 25 fishing, much easier than the Arcanite Fishing Pole, and only once.",
    item19141 = "Luffa from Incendosaurs? Whateverosaur is More Like It. Removes one bleed. Useful in PvP against rogues and warriors, and nothing replaces it.",
    item11905 = "Linken's Boomerang from It's Dangerous to Go Alone. Throws a boomerang that can stun or disarm. Often the only ranged pull for paladins, shamans, and druids. It is a guaranteed reward. Do not vendor it.",
    item15778 = "Mechanical Yeti from Are We There, Yeti?. Three charges. Each summons a yeti for ten minutes. There are no more after that.",
    item14023 = "Barov Peasant Caller from The Last Barov. Summons three servants that push back spells. Useful in PvP against casters, and the quest is once per character.",
    item1172 = "Grayson's Torch from The Coastal Menace. It gives off its own light. A one-time choice if you want the lamp. The shield beside it looks like a ship's wheel.",
    item1557 = "Buckler of the Seas from the same quest. A shield modeled on a ship's wheel. A one-time choice if you want the look. The torch is the other collector pick.",
    item7344 = "Torch of Holy Flame, a guaranteed reward from Morbent Fel. Using it lowers the target's armor, a weak Sunder Armor any class can apply. Paladins use it to pull at range. You can swap it in combat.",
    item9466 = "Orwin's Shovel. Plays the mining animation anywhere. Gordunni Cobalt takes it when you turn the quest in. Leave the quest open if you want to keep the shovel.",
    item13347 = "Crystal of Zin-Malor. While equipped it damages you and drains mana, which breaks crowd control. The last quest in the chain takes it. Do not turn it in.",
    item13289 = "Egan's Blaster from The Restless Souls. One of the few ranged weapons druids, paladins, and shamans can equip before relics exist. It does nothing outside the quest. You can turn the quest in. The weapon stays.",
    item11904 = "Spirit of Aquementas. An off-hand with 20 spell damage and healing. On It's Dangerous to Go Alone this is the right pick for casters and healers, until Molten Core replaces it. You still receive the boomerang.",
    item11902 = "Linken's Sword of Mastery. The worse of the two choices for casters and healers. Take the off-hand. You still receive the boomerang.",
}

local deDE = {
    TITLE = "Unersetzlich",
    keep = "Behalten, nicht verkaufen",
    pick = "Nimm das",
    avoid = "Nicht nehmen",
    hold = "Nicht abgeben",
    UNKNOWN_ITEM = "Gegenstand %d",
    TURNIN_WARN = "Diese Quest nimmt dir einen Gegenstand, den du nicht wiederbekommst.",
    TURN_IN_ANYWAY = "Trotzdem abgeben",
    LEAVE_OPEN = "Offen lassen",
    QUEST_ACCEPTED = "Quest angenommen",
    LOADED = "geladen. /irreplaceable test",
    HELP_TEST = "/irreplaceable test  zeigt den Hinweis, ohne dass du das Item hast",
    HELP_LIST = "/irreplaceable list  zählt, was für deinen Charakter gilt",
    LIST_COUNT = "%d Einträge für diesen Charakter, %d in der Liste.",

    item1178 = "Explosive Rocket aus Lieferung nach Sturmwind. Kleiner Flächenschaden, unterbricht Essen und Erste Hilfe. Den Stapel gibt es nur einmal.",
    item1434 = "Glowing Wax Stick aus Koboldkerzen. Senkt die Rüstung und verhindert Verstohlenheit. Gegen Schurken und Druiden, und nicht nachkaufbar.",
    item4945 = "Faintly Glowing Skull aus Minshinas Schädel. Einmaliger Lebensraub. Auf Hardcore ein Notnagel, danach ist er weg.",
    item4941 = "Really Sticky Glue aus Ein geistvolles Getränk. Hält das Ziel zehn Sekunden fest. Wenige Ladungen, keine zweite Quest.",
    item1191 = "Bag of Marbles aus Tauschhandel mit Goldstaub. Senkt die Trefferchance des Ziels zehn Sekunden lang um 25 Prozent, auch an Bossen. Zehn Ladungen, dann nie wieder.",
    item3434 = "Slumber Sand aus Eine neue Seuche. Legt ein Ziel bis zu zwanzig Sekunden schlafen. Nur ein paar Ladungen.",
    item1322 = "Fishliver Oil aus Fischhandel. Zehn Prozent mehr Angriffstempo für dreißig Sekunden, fünf Ladungen. Für physische Klassen der Moment, den du dir aufhebst.",
    item5462 = "Dartols Rute. Verwandelt dich drei Minuten in einen Furbolg, für jede Klasse. Raenes Säuberung nimmt sie dir ab, sobald du Ran Bloodtooths Schädel abgibst. Die Belohnungen sind die Rute nicht wert.",
    item1127 = "Flash Bundle aus Wölfe auf den Fersen. Eine Feuersäule auf Abruf, wenige Ladungen, kein Händler.",
    item5816 = "Light of Elune aus Magier-Beschwörer. Zehn Sekunden Immunität gegen alles, lang genug für den Ruhestein. Das stärkste Verbrauchsgut aus dem Questen, und es gibt nur eines.",
    item4984 = "Skull of Impending Doom aus Verbotenes Wissen. Sprint plus Selbstschaden, damit Verwandlung, Frostnova, Falle und ähnliche Effekte brechen. Einmalig, auch später im PvP und bei einzelnen Bossen nützlich.",
    item2820 = "Nifty Stopwatch aus Das wird schwierig. Vierzig Prozent Laufgeschwindigkeit für zehn Sekunden. Einer der wenigen Sprints für jede Klasse, auch auf Stufe 60.",
    item11122 = "Carrot on a Stick aus Gahz'rilla. Drei Prozent mehr Reittiertempo. Stapelt mit der Handschuhverzauberung und Mithrilsporen, nicht mit Streben nach Gerechtigkeit.",
    item5421 = "Fiery Blaze Enchantment, die einzige einmalige Waffenverzauberung aus einer Quest. Chance auf Feuerschaden um dich herum. Fürs Flächenfarmen aufheben, nicht auf eine Level-Waffe legen.",
    item19022 = "Nat Pagles Extremangler FC-5000 aus Schnappkiefer, Alter. Plus 25 Angeln, deutlich leichter als die Arkanitangel, und nur einmal.",
    item19141 = "Luffa aus Incendosaurier? Was-auch-immer-Saurier? Nimmt einen Blutungseffekt runter. Im PvP gegen Schurken und Krieger, und es gibt keinen Ersatz.",
    item11905 = "Linken's Boomerang aus Allein ist es gefährlich. Wirft einen Bumerang, der betäuben oder entwaffnen kann. Für Paladine, Schamanen und Druiden oft der einzige Fernkampfzug. Kommt garantiert, nicht wegwerfen.",
    item15778 = "Mechanical Yeti aus Sind wir endlich da, Yeti? Drei Ladungen, jede beschwört zehn Minuten einen Yeti. Danach gibt es keine neuen.",
    item14023 = "Barov Peasant Caller aus Der letzte Barov. Ruft drei Diener, die Zauber zurückwerfen. Im PvP gegen Caster, und die Quest gibt es nur einmal.",
    item1172 = "Grayson's Torch aus Die Küstenbedrohung. Leuchtet von selbst. Einmalige Auswahl, wenn du die Lampe behalten willst. Der Schild daneben sieht aus wie ein Steuerrad.",
    item1557 = "Buckler of the Seas aus derselben Quest. Schild mit dem Modell eines Steuerrads. Einmalige Auswahl, wenn du das Aussehen willst. Die Fackel ist die andere Sammlerwahl.",
    item7344 = "Torch of Holy Flame, garantiert von Morbent Fel. Benutzen senkt die Rüstung des Ziels, wie ein schwaches Rüstung zerreißen, für jede Klasse. Paladine ziehen damit aus der Ferne. Im Kampf wechselbar.",
    item9466 = "Orwins Schaufel. Spielt überall die Bergbau-Animation. Gordunnikobalt nimmt sie beim Abgeben weg. Die Quest liegen lassen, wenn du die Schaufel behalten willst.",
    item13347 = "Kristall von Zin-Malor. Solange er angelegt ist, fügt er dir Schaden zu und raubt Mana. Damit brechen Kontrollverlust-Effekte. Die letzte Quest der Kette nimmt ihn. Nicht abgeben.",
    item13289 = "Egan's Blaster aus Die ruhelosen Seelen. Für Druiden, Paladine und Schamanen eine der wenigen Waffen im Fernkampfplatz, bis es Relikte gibt. Tut außerhalb der Quest nichts. Die Quest darfst du abgeben, die Waffe bleibt.",
    item11904 = "Spirit of Aquementas. Nebenhand mit plus 20 auf Zauber und Heilung. Bei Allein ist es gefährlich die richtige Wahl für Caster und Heiler, bis etwas aus dem Geschmolzenen Kern sie ersetzt. Den Bumerang bekommst du so oder so.",
    item11902 = "Linken's Sword of Mastery. Für Caster und Heiler die schlechtere der zwei Wahlbelohnungen. Nimm die Nebenhand. Den Bumerang bekommst du trotzdem.",
}

local L = {}
ns.L = L

local function Apply(source)
    for key, value in pairs(source) do
        L[key] = value
    end
end

Apply(enUS)
if GetLocale() == "deDE" then
    Apply(deDE)
end
