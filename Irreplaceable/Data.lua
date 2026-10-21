local _, ns = ...

-- Classic item IDs. Forever uses the same IDs when the item exists.
-- action:
--   keep  = do not vendor
--   pick  = choose this quest reward
--   avoid = do not choose this quest reward
--   hold  = do not turn the quest in, or the item is destroyed
-- faction and classes filter to the logged-in character. nil means everyone.
-- why is a key in Locale.lua.

local CASTER = {
    MAGE = true,
    PRIEST = true,
    WARLOCK = true,
    DRUID = true,
    SHAMAN = true,
    PALADIN = true,
}

local RELIC = {
    DRUID = true,
    PALADIN = true,
    SHAMAN = true,
}

ns.items = {
    [1178] = { faction = "Alliance", action = "keep", why = "item1178" },
    [1434] = { faction = "Alliance", action = "keep", why = "item1434" },
    [4945] = { faction = "Horde", action = "keep", why = "item4945" },
    [4941] = { faction = "Horde", action = "keep", why = "item4941" },
    [1191] = { faction = "Alliance", action = "keep", why = "item1191" },
    [3434] = { faction = "Horde", action = "keep", why = "item3434" },
    [1322] = { faction = "Alliance", action = "keep", why = "item1322" },
    [5462] = { faction = "Alliance", action = "hold", quests = { [1046] = true }, why = "item5462" },
    [1127] = { faction = "Alliance", action = "keep", why = "item1127" },
    [5816] = { faction = "Alliance", action = "keep", why = "item5816" },
    [4984] = { action = "keep", why = "item4984" },
    [2820] = { action = "keep", why = "item2820" },
    [11122] = { action = "keep", why = "item11122" },
    [5421] = { faction = "Alliance", action = "keep", why = "item5421" },
    [19022] = { faction = "Horde", action = "keep", why = "item19022" },
    [19141] = { action = "keep", why = "item19141" },
    [11905] = { action = "keep", why = "item11905" },
    [15778] = { action = "keep", why = "item15778" },
    [14023] = { action = "keep", why = "item14023" },
    [1172] = { faction = "Alliance", action = "keep", why = "item1172" },
    [1557] = { faction = "Alliance", action = "keep", why = "item1557" },
    [7344] = { faction = "Alliance", action = "keep", why = "item7344" },
    [9466] = { faction = "Horde", action = "hold", quests = { [2987] = true }, why = "item9466" },
    [13347] = { faction = "Alliance", action = "hold", quests = { [5253] = true }, why = "item13347" },
    [13289] = { classes = RELIC, action = "keep", why = "item13289" },
    [11904] = { classes = CASTER, action = "pick", why = "item11904" },
    [11902] = { classes = CASTER, action = "avoid", why = "item11902" },
}
