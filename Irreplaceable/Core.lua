local _, ns = ...

local L = ns.L

local GOLD = { 0.90, 0.74, 0.42 }
local CREAM = { 0.70, 0.66, 0.60 }
local INK = { 0.96, 0.94, 0.90 }
local RED = { 0.90, 0.46, 0.42 }
local GREEN = { 0.52, 0.80, 0.60 }
local PANEL = { 0.05, 0.05, 0.06, 0.94 }

local counts
local bagsReady
local toastQueue = {}
local toastBusy
local toastItemID
local allowTurnIn
local cover
local banner
local pendingBags

local function Secret(value)
    return type(issecretvalue) == "function" and issecretvalue(value)
end

local function PlayerFaction()
    local faction = UnitFactionGroup("player")
    if Secret(faction) then
        return nil
    end
    return faction
end

local function PlayerClass()
    local _, classFile = UnitClass("player")
    if Secret(classFile) then
        return nil
    end
    return classFile
end

local function Text(key)
    return L[key] or key
end

local function Why(entry)
    return Text(entry.why)
end

function ns:Entry(itemID)
    if not itemID or Secret(itemID) then
        return nil
    end
    local entry = ns.items[itemID]
    if not entry then
        return nil
    end
    if entry.faction and entry.faction ~= PlayerFaction() then
        return nil
    end
    if entry.classes and not entry.classes[PlayerClass()] then
        return nil
    end
    return entry
end

local function ItemIDFromLink(link)
    if type(link) ~= "string" then
        return nil
    end
    local id = link:match("item:(%d+)")
    return id and tonumber(id)
end

local function ItemName(itemID)
    if C_Item and C_Item.GetItemInfo then
        local name = C_Item.GetItemInfo(itemID)
        if type(name) == "string" and name ~= "" then
            return name
        end
    end
    if C_Item and C_Item.RequestLoadItemDataByID then
        C_Item.RequestLoadItemDataByID(itemID)
    end
    return string.format(Text("UNKNOWN_ITEM"), itemID)
end

local function ItemIcon(itemID)
    if C_Item and C_Item.GetItemIconByID then
        return C_Item.GetItemIconByID(itemID)
    end
    return nil
end

local function Label(entry)
    return Text(entry.action)
end

local function LabelColor(action)
    if action == "avoid" or action == "hold" then
        return RED
    end
    if action == "pick" then
        return GREEN
    end
    return GOLD
end

local RAIL_HOOKS = {}

local function HideRail(tooltip)
    if tooltip and tooltip.irreplaceableRail then
        tooltip.irreplaceableRail:Hide()
    end
end

local function ShowRail(tooltip, r, g, b)
    if not tooltip or not tooltip.CreateTexture then
        return
    end
    local rail = tooltip.irreplaceableRail
    if not rail then
        rail = tooltip:CreateTexture(nil, "OVERLAY")
        rail:SetTexture("Interface\\Buttons\\WHITE8X8")
        rail:SetWidth(2)
        rail:SetPoint("TOPLEFT", tooltip, "TOPLEFT", 1, -1)
        rail:SetPoint("BOTTOMLEFT", tooltip, "BOTTOMLEFT", 1, 1)
        tooltip.irreplaceableRail = rail
    end
    rail:SetVertexColor(r, g, b, 1)
    rail:Show()
    if not RAIL_HOOKS[tooltip] and tooltip.HookScript then
        RAIL_HOOKS[tooltip] = true
        tooltip:HookScript("OnHide", HideRail)
    end
end

local function AddTooltipLines(tooltip, itemID)
    local entry = itemID and ns:Entry(itemID)
    if not entry or not tooltip or not tooltip.AddLine then
        HideRail(tooltip)
        return
    end
    local r, g, b = unpack(LabelColor(entry.action))
    tooltip:AddLine(" ")
    tooltip:AddLine(Text("TITLE"), INK[1], INK[2], INK[3])
    tooltip:AddLine(Label(entry), r, g, b)
    tooltip:AddLine(Why(entry), CREAM[1], CREAM[2], CREAM[3], true)
    ShowRail(tooltip, r, g, b)
    if tooltip.GetOwner then
        local owner = tooltip:GetOwner()
        if owner and owner ~= UIParent and owner ~= tooltip and owner.CreateTexture then
            ns:MarkButton(owner, itemID)
        end
    end
end

local function ApplyFlat(frame, r, g, b)
    if not frame or not frame.SetBackdrop then
        return
    end
    frame:SetBackdrop({
        bgFile = "Interface\\Buttons\\WHITE8X8",
        edgeFile = "Interface\\Buttons\\WHITE8X8",
        edgeSize = 1,
        insets = { left = 1, right = 1, top = 1, bottom = 1 },
    })
    frame:SetBackdropColor(PANEL[1], PANEL[2], PANEL[3], PANEL[4])
    frame:SetBackdropBorderColor(r or GOLD[1], g or GOLD[2], b or GOLD[3], 0.45)
    if not frame.irreplaceableRail and frame.CreateTexture then
        local rail = frame:CreateTexture(nil, "OVERLAY")
        rail:SetTexture("Interface\\Buttons\\WHITE8X8")
        rail:SetWidth(2)
        rail:SetPoint("TOPLEFT", frame, "TOPLEFT", 1, -1)
        rail:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 1, 1)
        frame.irreplaceableRail = rail
    end
    if frame.irreplaceableRail then
        frame.irreplaceableRail:SetVertexColor(r or GOLD[1], g or GOLD[2], b or GOLD[3], 1)
    end
end

local function ShowNextToast()
    if toastBusy then
        return
    end
    local itemID = table.remove(toastQueue, 1)
    if not itemID then
        return
    end
    local entry = ns.items[itemID]
    if not entry then
        ShowNextToast()
        return
    end

    toastBusy = true
    toastItemID = itemID
    local frame = ns.toast
    local r, g, b = unpack(LabelColor(entry.action))
    ApplyFlat(frame, r, g, b)
    frame.title:SetText(Text("TITLE"))
    frame.title:SetTextColor(r, g, b)
    frame.name:SetText(ItemName(itemID))
    frame.name:SetTextColor(INK[1], INK[2], INK[3])
    frame.body:SetText(Label(entry) .. "\n" .. Why(entry))
    frame.icon:SetTexture(ItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
    frame:Show()

    C_Timer.After(8, function()
        frame:Hide()
        toastBusy = false
        ShowNextToast()
    end)
end

function ns:Toast(itemID)
    if not itemID then
        return
    end
    toastQueue[#toastQueue + 1] = itemID
    ShowNextToast()
end

local function BuildToast()
    local frame = CreateFrame("Frame", "IrreplaceableToast", UIParent, "BackdropTemplate")
    frame:SetSize(380, 108)
    frame:SetPoint("TOP", UIParent, "TOP", 0, -120)
    frame:SetFrameStrata("DIALOG")
    frame:Hide()
    ApplyFlat(frame, GOLD[1], GOLD[2], GOLD[3])

    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(36, 36)
    icon:SetPoint("LEFT", 16, 0)
    frame.icon = icon

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", icon, "TOPRIGHT", 12, 2)
    title:SetJustifyH("LEFT")
    frame.title = title

    local name = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    name:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
    name:SetJustifyH("LEFT")
    frame.name = name

    local body = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    body:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -4)
    body:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
    body:SetJustifyH("LEFT")
    body:SetWordWrap(true)
    body:SetTextColor(CREAM[1], CREAM[2], CREAM[3])
    frame.body = body

    ns.toast = frame
end

local function ScanBags()
    local now = {}
    if not C_Container or not C_Container.GetContainerNumSlots then
        return now
    end
    for bag = 0, 5 do
        local slots = C_Container.GetContainerNumSlots(bag)
        if type(slots) == "number" and slots > 0 then
            for slot = 1, slots do
                local itemID = C_Container.GetContainerItemID(bag, slot)
                if itemID and not Secret(itemID) and ns.items[itemID] then
                    local info = C_Container.GetContainerItemInfo(bag, slot)
                    local stack = 1
                    if type(info) == "table" and type(info.stackCount) == "number" then
                        stack = info.stackCount
                    end
                    now[itemID] = (now[itemID] or 0) + stack
                end
            end
        end
    end
    return now
end

local function ArmBags()
    bagsReady = false
    C_Timer.After(1, function()
        counts = ScanBags()
        bagsReady = true
        ns:MarkBags()
    end)
end

local function OnBags()
    if not bagsReady then
        return
    end
    local now = ScanBags()
    for itemID, stack in pairs(now) do
        local previous = counts[itemID] or 0
        if stack > previous and ns:Entry(itemID) then
            ns:Toast(itemID)
        end
    end
    counts = now
    ns:MarkBags()
end

local function ButtonBagSlot(button)
    local bag, slot
    if button.GetBagID then
        bag = button:GetBagID()
    end
    if button.GetID then
        slot = button:GetID()
    end
    return bag, slot
end

function ns:MarkBags()
    if InCombatLockdown() then
        pendingBags = true
        return
    end
    pendingBags = false
    local frames = NUM_CONTAINER_FRAMES or 13
    for i = 1, frames do
        local frame = _G["ContainerFrame" .. i]
        if frame then
            local buttons = frame.Items
            if buttons then
                for _, button in ipairs(buttons) do
                    ns:MarkButton(button)
                end
            else
                local name = frame:GetName()
                if name then
                    for slot = 1, 36 do
                        local button = _G[name .. "Item" .. slot]
                        if button then
                            ns:MarkButton(button)
                        end
                    end
                end
            end
        end
    end
end

local function ButtonItemID(button)
    if not button then
        return nil
    end
    if button.GetItemID then
        local id = button:GetItemID()
        if type(id) == "number" and not Secret(id) then
            return id
        end
    end
    local link = button.itemLink or button.ItemLink
    local fromLink = ItemIDFromLink(link)
    if fromLink then
        return fromLink
    end
    local slot = button.slotIndex or button.lootSlot
    if type(slot) ~= "number" and button.GetSlot then
        slot = button:GetSlot()
    end
    if type(slot) == "number" and slot > 0 and GetLootSlotLink then
        local ok, lootLink = pcall(GetLootSlotLink, slot)
        if ok then
            return ItemIDFromLink(lootLink)
        end
    end
    return nil
end

local function EnsureIconFrame(button, anchor)
    local frame = button.irreplaceableFrame
    if frame then
        return frame
    end
    local parent = (anchor.GetParent and anchor:GetParent()) or button
    local ok, created = pcall(CreateFrame, "Frame", nil, parent)
    if not ok or not created then
        return nil
    end
    frame = created
    if frame.SetFrameLevel and parent.GetFrameLevel then
        frame:SetFrameLevel(parent:GetFrameLevel() + 4)
    end
    local function edge()
        local texture = frame:CreateTexture(nil, "OVERLAY")
        texture:SetTexture("Interface\\Buttons\\WHITE8X8")
        return texture
    end
    frame.top = edge()
    frame.bottom = edge()
    frame.left = edge()
    frame.right = edge()
    frame.top:SetHeight(2)
    frame.bottom:SetHeight(2)
    frame.left:SetWidth(2)
    frame.right:SetWidth(2)
    frame.top:SetPoint("TOPLEFT", frame, "TOPLEFT")
    frame.top:SetPoint("TOPRIGHT", frame, "TOPRIGHT")
    frame.bottom:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
    frame.bottom:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")
    frame.left:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -2)
    frame.left:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 0, 2)
    frame.right:SetPoint("TOPRIGHT", frame, "TOPRIGHT", 0, -2)
    frame.right:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0, 2)
    button.irreplaceableFrame = frame
    return frame
end

function ns:MarkButton(button, itemID)
    if not button or not button.CreateTexture then
        return
    end
    if not itemID then
        local bag, slot = ButtonBagSlot(button)
        if bag and slot and C_Container and C_Container.GetContainerItemID then
            itemID = C_Container.GetContainerItemID(bag, slot)
        end
    end
    local entry = itemID and not Secret(itemID) and ns:Entry(itemID)
    if button.irreplaceableGlow then
        button.irreplaceableGlow:Hide()
    end
    local anchor = button.Icon or button.icon or button.IconTexture or button
    local frame = EnsureIconFrame(button, anchor)
    if not frame then
        return
    end
    if entry then
        local r, g, b = unpack(LabelColor(entry.action))
        frame:ClearAllPoints()
        frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
        frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 0, 0)
        frame.top:SetVertexColor(r, g, b, 1)
        frame.bottom:SetVertexColor(r, g, b, 1)
        frame.left:SetVertexColor(r, g, b, 1)
        frame.right:SetVertexColor(r, g, b, 1)
        frame:Show()
    else
        frame:Hide()
    end
end

local function MarkLootRow(row)
    if not row then
        return
    end
    local button = row.Item or row.item or row.ItemButton or row
    local itemID = ButtonItemID(button) or ButtonItemID(row)
    if button ~= row then
        ns:MarkButton(button, itemID)
    elseif button.CreateTexture then
        ns:MarkButton(button, itemID)
    end
end

function ns:MarkLoot()
    for i = 1, 20 do
        local button = _G["LootButton" .. i]
        if button and button:IsShown() then
            MarkLootRow(button)
        end
    end
    local roots = { LootFrame }
    for i = 1, 4 do
        roots[#roots + 1] = _G["GroupLootFrame" .. i]
    end
    local function looksLikeItem(frame)
        if not frame then
            return false
        end
        if frame.Item or frame.item or frame.ItemButton or frame.itemLink or frame.ItemLink or frame.Icon then
            return true
        end
        local name = frame.GetName and frame:GetName()
        return type(name) == "string" and name:match("^LootButton") ~= nil
    end
    local function walk(frame, depth)
        if not frame or depth > 8 then
            return
        end
        if looksLikeItem(frame) then
            MarkLootRow(frame)
        end
        local box = frame.ScrollBox
        if box and box.ForEachFrame then
            box:ForEachFrame(MarkLootRow)
        end
        if frame.GetChildren then
            for _, child in ipairs({ frame:GetChildren() }) do
                walk(child, depth + 1)
            end
        end
    end
    for _, root in ipairs(roots) do
        if root then
            walk(root, 0)
        end
    end
end

local function TagButton(button, entry)
    local tag = button.irreplaceableTag
    if not tag then
        tag = CreateFrame("Frame", nil, button)
        tag:SetSize(140, 28)
        tag:SetPoint("BOTTOM", button, "TOP", 0, 0)
        tag:SetFrameStrata("HIGH")
        local text = tag:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        text:SetAllPoints()
        text:SetJustifyH("CENTER")
        tag.text = text
        button.irreplaceableTag = tag
    end
    if not entry then
        tag:Hide()
        return
    end
    local r, g, b = unpack(LabelColor(entry.action))
    tag.text:SetText(Label(entry))
    tag.text:SetTextColor(r, g, b)
    tag:Show()
end

local function EachRewardButton(visitor)
    local rewards = QuestInfoRewardsFrame or (QuestInfoFrame and QuestInfoFrame.rewardsFrame)
    if rewards and rewards.RewardButtons then
        for _, button in ipairs(rewards.RewardButtons) do
            visitor(button)
        end
        return
    end
    for i = 1, 20 do
        local button = _G["QuestInfoRewardsFrameQuestInfoItem" .. i]
        if button then
            visitor(button)
        end
    end
end

local function QuestItemCount(kind)
    if kind == "choice" and GetNumQuestChoices then
        return GetNumQuestChoices() or 0
    end
    if kind == "reward" and GetNumQuestRewards then
        return GetNumQuestRewards() or 0
    end
    if kind == "required" and GetNumQuestItems then
        return GetNumQuestItems() or 0
    end
    return 0
end

local function QuestItems(kind)
    local found = {}
    local count = QuestItemCount(kind)
    if count <= 0 or not GetQuestItemLink then
        return found
    end
    for index = 1, count do
        local ok, link = pcall(GetQuestItemLink, kind, index)
        if ok then
            local itemID = ItemIDFromLink(link)
            if itemID then
                found[#found + 1] = itemID
            end
        end
    end
    return found
end

local function OpenQuestID()
    if not GetQuestID then
        return nil
    end
    local ok, questID = pcall(GetQuestID)
    if ok and type(questID) == "number" then
        return questID
    end
    return nil
end

local function HoldOnThisQuest()
    local questID = OpenQuestID()
    local reasons = {}
    local seen = {}
    local function add(entry)
        if entry and not seen[entry] then
            seen[entry] = true
            reasons[#reasons + 1] = entry
        end
    end
    for _, itemID in ipairs(QuestItems("required")) do
        local entry = ns:Entry(itemID)
        if entry and entry.action == "hold" then
            add(entry)
        end
    end
    if questID then
        for itemID, entry in pairs(ns.items) do
            if entry.action == "hold" and entry.quests and entry.quests[questID] and ns:Entry(itemID) then
                add(entry)
            end
        end
    end
    return reasons
end

local function CompleteButton()
    return QuestFrameCompleteQuestButton or QuestFrameCompleteButton
end

local function EnsureCover()
    if cover then
        return cover
    end
    cover = CreateFrame("Button", "IrreplaceableTurnInCover", UIParent)
    cover:SetFrameStrata("FULLSCREEN_DIALOG")
    cover:Hide()
    cover:RegisterForClicks("AnyUp")
    local bg = cover:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0.45, 0.05, 0.05, 0.92)
    local text = cover:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    text:SetPoint("CENTER")
    text:SetText(Text("hold"))
    cover.label = text
    cover:SetScript("OnClick", function()
        local lines = { Text("TURNIN_WARN") }
        for _, entry in ipairs(cover.reasons or {}) do
            lines[#lines + 1] = " "
            lines[#lines + 1] = Why(entry)
        end
        StaticPopupDialogs["IRREPLACEABLE_HOLD"].text = table.concat(lines, "\n")
        StaticPopup_Show("IRREPLACEABLE_HOLD")
    end)
    cover:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:AddLine(Text("hold"), RED[1], RED[2], RED[3])
        for _, entry in ipairs(self.reasons or {}) do
            GameTooltip:AddLine(Why(entry), CREAM[1], CREAM[2], CREAM[3], true)
        end
        GameTooltip:Show()
    end)
    cover:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
    return cover
end

local function EnsureBanner()
    if banner then
        return banner
    end
    banner = CreateFrame("Frame", "IrreplaceableQuestBanner", UIParent, "BackdropTemplate")
    banner:SetSize(360, 72)
    banner:SetFrameStrata("HIGH")
    banner:Hide()
    ApplyFlat(banner, GOLD[1], GOLD[2], GOLD[3])
    local title = banner:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", 14, -12)
    title:SetPoint("RIGHT", banner, "RIGHT", -12, 0)
    title:SetJustifyH("LEFT")
    banner.title = title
    local body = banner:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    body:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
    body:SetPoint("RIGHT", banner, "RIGHT", -12, 0)
    body:SetJustifyH("LEFT")
    body:SetWordWrap(true)
    body:SetTextColor(CREAM[1], CREAM[2], CREAM[3])
    banner.body = body
    return banner
end

local function RefreshQuest()
    EachRewardButton(function(button)
        local kind = button.type or button.objectType
        local index = button.index or (button.GetID and button:GetID())
        local itemID
        if kind and index and GetQuestItemLink then
            local ok, link = pcall(GetQuestItemLink, kind, index)
            if ok then
                itemID = ItemIDFromLink(link)
            end
        end
        TagButton(button, itemID and ns:Entry(itemID))
    end)

    local note
    for _, kind in ipairs({ "choice", "reward" }) do
        for _, itemID in ipairs(QuestItems(kind)) do
            local entry = ns:Entry(itemID)
            if entry and (entry.action == "pick" or entry.action == "avoid" or entry.action == "keep") then
                if entry.action == "pick" or not note then
                    note = entry
                end
            end
        end
    end

    local bar = EnsureBanner()
    local anchor = QuestFrame or QuestInfoFrame
    if note and anchor then
        local r, g, b = unpack(LabelColor(note.action))
        ApplyFlat(bar, r, g, b)
        bar.title:SetText(Text("TITLE"))
        bar.title:SetTextColor(r, g, b)
        bar.body:SetText(Label(note) .. "\n" .. Why(note))
        bar:ClearAllPoints()
        bar:SetPoint("BOTTOM", anchor, "TOP", 0, -8)
        bar:Show()
    else
        bar:Hide()
    end

    local reasons = HoldOnThisQuest()
    local button = CompleteButton()
    local guard = EnsureCover()
    if button and button:IsShown() and #reasons > 0 and not allowTurnIn then
        guard.reasons = reasons
        guard.label:SetText(Text("hold"))
        guard:ClearAllPoints()
        guard:SetAllPoints(button)
        guard:Show()
    else
        guard:Hide()
    end
end

local function InstallTooltip()
    if TooltipDataProcessor and Enum and Enum.TooltipDataType and TooltipDataProcessor.AddTooltipPostCall then
        TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
            if data and data.id and not Secret(data.id) then
                AddTooltipLines(tooltip, data.id)
            end
        end)
        return
    end
    if GameTooltip and GameTooltip.HookScript then
        GameTooltip:HookScript("OnTooltipSetItem", function(tooltip)
            local _, link = tooltip:GetItem()
            AddTooltipLines(tooltip, ItemIDFromLink(link))
        end)
    end
end

local function InstallPopup()
    StaticPopupDialogs["IRREPLACEABLE_HOLD"] = {
        text = Text("TURNIN_WARN"),
        button1 = Text("TURN_IN_ANYWAY"),
        button2 = Text("LEAVE_OPEN"),
        OnAccept = function()
            allowTurnIn = true
            if cover then
                cover:Hide()
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
end

local function PrintHelp()
    print("|cffffd200" .. Text("TITLE") .. "|r")
    print(Text("HELP_TEST"))
    print(Text("HELP_LIST"))
end

local function PrintList()
    local catalog = 0
    for _ in pairs(ns.items) do
        catalog = catalog + 1
    end
    local mine = 0
    for itemID in pairs(ns.items) do
        if ns:Entry(itemID) then
            mine = mine + 1
        end
    end
    print("|cffffd200" .. Text("TITLE") .. "|r " .. string.format(Text("LIST_COUNT"), mine, catalog))
end

SLASH_IRREPLACEABLE1 = "/irreplaceable"
SLASH_IRREPLACEABLE2 = "/irr"
SlashCmdList["IRREPLACEABLE"] = function(msg)
    msg = strtrim(msg or ""):lower()
    if msg == "test" then
        ns:Toast(5816)
    elseif msg == "list" then
        PrintList()
    else
        PrintHelp()
    end
end

local frame = CreateFrame("Frame")
frame:SetScript("OnEvent", function(_, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        ArmBags()
    elseif event == "BAG_UPDATE_DELAYED" then
        OnBags()
    elseif event == "LOOT_OPENED" or event == "LOOT_READY" or event == "LOOT_SLOT_CHANGED" then
        C_Timer.After(0, function()
            ns:MarkLoot()
        end)
        C_Timer.After(0.15, function()
            ns:MarkLoot()
        end)
    elseif event == "PLAYER_REGEN_ENABLED" then
        if pendingBags then
            ns:MarkBags()
        end
    elseif event == "QUEST_COMPLETE" or event == "QUEST_PROGRESS" or event == "QUEST_DETAIL" or event == "QUEST_ITEM_UPDATE" then
        allowTurnIn = false
        C_Timer.After(0, RefreshQuest)
    elseif event == "QUEST_FINISHED" or event == "QUEST_TURNED_IN" then
        allowTurnIn = false
        if cover then
            cover:Hide()
        end
        if banner then
            banner:Hide()
        end
    elseif event == "ITEM_DATA_LOAD_RESULT" then
        local itemID = ...
        if toastItemID and itemID == toastItemID and ns.toast and ns.toast:IsShown() then
            ns.toast.name:SetText(ItemName(itemID))
            ns.toast.icon:SetTexture(ItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
        end
    end
end)

local function Register(event)
    pcall(frame.RegisterEvent, frame, event)
end

InstallPopup()
InstallTooltip()
BuildToast()

Register("PLAYER_ENTERING_WORLD")
Register("BAG_UPDATE_DELAYED")
Register("LOOT_OPENED")
Register("LOOT_READY")
Register("LOOT_SLOT_CHANGED")
Register("PLAYER_REGEN_ENABLED")
Register("QUEST_COMPLETE")
Register("QUEST_PROGRESS")
Register("QUEST_DETAIL")
Register("QUEST_ITEM_UPDATE")
Register("QUEST_FINISHED")
Register("QUEST_TURNED_IN")
Register("ITEM_DATA_LOAD_RESULT")

if type(QuestInfo_ShowRewards) == "function" then
    hooksecurefunc("QuestInfo_ShowRewards", function()
        C_Timer.After(0, RefreshQuest)
    end)
end

print("|cffffd200" .. Text("TITLE") .. "|r " .. Text("LOADED"))
