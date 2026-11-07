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
local pendingBags
local offeredQuestID
local offeredTitle
local offeredItems
local recentQuestToast = {}

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
        if owner and owner ~= UIParent and owner ~= tooltip and (owner.info or owner.GetBag or owner.bag ~= nil) then
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

local function BlockHeight(fontString)
    local height = fontString:GetStringHeight()
    if type(height) == "number" and height > 1 then
        return height
    end
    return 14
end

local function ShowLootNotice(itemID)
    local entry = ns.items[itemID]
    if not entry then
        return false
    end
    if ns.questNotice then
        ns.questNotice:Hide()
    end
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
    local function fit()
        local height = 12 + BlockHeight(frame.title) + 2 + BlockHeight(frame.name) + 6 + BlockHeight(frame.body) + 14
        if height < 68 then
            height = 68
        elseif height > 320 then
            height = 320
        end
        frame:SetHeight(height)
    end
    fit()
    frame:Show()
    C_Timer.After(0, function()
        if toastItemID == itemID and frame:IsShown() then
            fit()
        end
    end)
    return frame
end

local function ShowQuestNotice(notice)
    if ns.toast then
        ns.toast:Hide()
    end
    toastItemID = nil
    local frame = ns.questNotice
    local items = notice.items or {}
    local first = items[1] and ns.items[items[1]]
    local r, g, b = unpack(first and LabelColor(first.action) or GOLD)
    ApplyFlat(frame, r, g, b)
    frame.kicker:SetText(Text("QUEST_ACCEPTED"))
    frame.quest:SetText(notice.title or "")
    local shown = 0
    for index, row in ipairs(frame.rows) do
        local itemID = items[index]
        local entry = itemID and ns.items[itemID]
        if itemID and entry then
            shown = shown + 1
            row.itemID = itemID
            local ar, ag, ab = unpack(LabelColor(entry.action))
            row.icon:SetTexture(ItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
            row.name:SetText(ItemName(itemID))
            row.action:SetText(Label(entry))
            row.action:SetTextColor(ar, ag, ab)
            row.why:SetText(Why(entry))
            row.frameTop:SetVertexColor(ar, ag, ab, 1)
            row.frameBottom:SetVertexColor(ar, ag, ab, 1)
            row.frameLeft:SetVertexColor(ar, ag, ab, 1)
            row.frameRight:SetVertexColor(ar, ag, ab, 1)
            row:Show()
        else
            row.itemID = nil
            row:Hide()
        end
    end
    local function fit()
        local cursor = 12 + BlockHeight(frame.kicker) + 2 + BlockHeight(frame.quest) + 8
        frame.rule:ClearAllPoints()
        frame.rule:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -cursor)
        frame.rule:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
        cursor = cursor + 10
        for index = 1, shown do
            local row = frame.rows[index]
            row.why:SetWidth(382)
            local textHeight = BlockHeight(row.name) + 1 + BlockHeight(row.action) + 2 + BlockHeight(row.why)
            local rowHeight = textHeight
            if rowHeight < 36 then
                rowHeight = 36
            end
            row:ClearAllPoints()
            row:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -cursor)
            row:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
            row:SetHeight(rowHeight)
            cursor = cursor + rowHeight + 10
        end
        local height = cursor + 6
        if height < 96 then
            height = 96
        elseif height > 360 then
            height = 360
        end
        frame:SetHeight(height)
    end
    fit()
    frame:Show()
    C_Timer.After(0, function()
        if frame:IsShown() then
            fit()
        end
    end)
    return frame
end

local function ShowNextToast()
    if toastBusy then
        return
    end
    local notice = table.remove(toastQueue, 1)
    if not notice then
        return
    end
    local frame
    if type(notice) == "table" and notice.kind == "quest" then
        frame = ShowQuestNotice(notice)
    else
        local itemID = type(notice) == "table" and notice.itemID or notice
        local entry = itemID and ns.items[itemID]
        if not entry then
            ShowNextToast()
            return
        end
        frame = ShowLootNotice(itemID)
    end
    if not frame then
        ShowNextToast()
        return
    end
    toastBusy = true
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
    toastQueue[#toastQueue + 1] = { kind = "loot", itemID = itemID }
    ShowNextToast()
end

local function BuildToast()
    local frame = CreateFrame("Frame", "IrreplaceableToast", UIParent, "BackdropTemplate")
    frame:SetSize(440, 68)
    frame:SetPoint("TOP", UIParent, "TOP", 0, -120)
    frame:SetFrameStrata("DIALOG")
    frame:Hide()
    ApplyFlat(frame, GOLD[1], GOLD[2], GOLD[3])

    local icon = frame:CreateTexture(nil, "ARTWORK")
    icon:SetSize(36, 36)
    icon:SetPoint("TOPLEFT", 14, -14)
    frame.icon = icon

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", 62, -12)
    title:SetPoint("RIGHT", frame, "RIGHT", -14, 0)
    title:SetJustifyH("LEFT")
    frame.title = title

    local name = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    name:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -2)
    name:SetPoint("RIGHT", frame, "RIGHT", -14, 0)
    name:SetJustifyH("LEFT")
    frame.name = name

    local body = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    body:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -6)
    body:SetPoint("RIGHT", frame, "RIGHT", -14, 0)
    body:SetJustifyH("LEFT")
    body:SetWordWrap(true)
    body:SetTextColor(CREAM[1], CREAM[2], CREAM[3])
    frame.body = body

    ns.toast = frame
end

local function BuildQuestNotice()
    local frame = CreateFrame("Frame", "IrreplaceableQuestNotice", UIParent, "BackdropTemplate")
    frame:SetSize(460, 120)
    frame:SetPoint("TOP", UIParent, "TOP", 0, -120)
    frame:SetFrameStrata("DIALOG")
    frame:Hide()
    ApplyFlat(frame, GOLD[1], GOLD[2], GOLD[3])

    local kicker = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    kicker:SetPoint("TOPLEFT", 16, -12)
    kicker:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
    kicker:SetJustifyH("LEFT")
    kicker:SetTextColor(GOLD[1], GOLD[2], GOLD[3])
    frame.kicker = kicker

    local quest = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    quest:SetPoint("TOPLEFT", kicker, "BOTTOMLEFT", 0, -2)
    quest:SetPoint("RIGHT", frame, "RIGHT", -16, 0)
    quest:SetJustifyH("LEFT")
    quest:SetTextColor(INK[1], INK[2], INK[3])
    frame.quest = quest

    local rule = frame:CreateTexture(nil, "ARTWORK")
    rule:SetTexture("Interface\\Buttons\\WHITE8X8")
    rule:SetVertexColor(GOLD[1], GOLD[2], GOLD[3], 0.4)
    rule:SetHeight(1)
    frame.rule = rule

    frame.rows = {}
    for index = 1, 3 do
        local row = CreateFrame("Frame", nil, frame)
        row:SetHeight(36)
        local icon = row:CreateTexture(nil, "ARTWORK")
        icon:SetSize(36, 36)
        icon:SetPoint("TOPLEFT", 0, 0)
        row.icon = icon

        local function edge()
            local texture = row:CreateTexture(nil, "OVERLAY")
            texture:SetTexture("Interface\\Buttons\\WHITE8X8")
            return texture
        end
        row.frameTop = edge()
        row.frameBottom = edge()
        row.frameLeft = edge()
        row.frameRight = edge()
        row.frameTop:SetHeight(2)
        row.frameTop:SetPoint("TOPLEFT", icon, "TOPLEFT")
        row.frameTop:SetPoint("TOPRIGHT", icon, "TOPRIGHT")
        row.frameBottom:SetHeight(2)
        row.frameBottom:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT")
        row.frameBottom:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT")
        row.frameLeft:SetWidth(2)
        row.frameLeft:SetPoint("TOPLEFT", icon, "TOPLEFT", 0, -2)
        row.frameLeft:SetPoint("BOTTOMLEFT", icon, "BOTTOMLEFT", 0, 2)
        row.frameRight:SetWidth(2)
        row.frameRight:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 0, -2)
        row.frameRight:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 2)

        local name = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        name:SetPoint("TOPLEFT", icon, "TOPRIGHT", 10, 1)
        name:SetWidth(382)
        name:SetJustifyH("LEFT")
        name:SetTextColor(INK[1], INK[2], INK[3])
        row.name = name

        local action = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        action:SetPoint("TOPLEFT", name, "BOTTOMLEFT", 0, -1)
        action:SetWidth(382)
        action:SetJustifyH("LEFT")
        row.action = action

        local why = row:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        why:SetPoint("TOPLEFT", action, "BOTTOMLEFT", 0, -2)
        why:SetWidth(382)
        why:SetJustifyH("LEFT")
        why:SetWordWrap(true)
        why:SetTextColor(CREAM[1], CREAM[2], CREAM[3])
        row.why = why

        row:Hide()
        frame.rows[index] = row
    end

    ns.questNotice = frame
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
        local told = recentQuestToast[itemID]
        local justFromQuest = told and GetTime() - told < 3
        if stack > previous and ns:Entry(itemID) and not justFromQuest then
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

local function IsLocked(info)
    if type(info) ~= "table" then
        return false
    end
    local locked = info.isLocked
    if locked == nil or Secret(locked) then
        return false
    end
    return locked == true
end

local function KnownSlotID(button)
    local info = button.info
    if type(info) ~= "table" then
        return nil, false
    end
    if IsLocked(info) then
        return nil, true
    end
    local id = info.itemID
    if type(id) == "number" and not Secret(id) then
        return id, true
    end
    local fromLink = ItemIDFromLink(info.hyperlink)
    if fromLink then
        return fromLink, true
    end
    if id == nil and info.hyperlink == nil and not button.hasItem then
        return nil, true
    end
    return nil, false
end

local function ButtonLiveItemID(button)
    local info = button.info
    if type(info) == "table" then
        local id = info.itemID
        if type(id) == "number" and not Secret(id) then
            return id
        end
        local fromLink = ItemIDFromLink(info.hyperlink)
        if fromLink then
            return fromLink
        end
        if id == nil and info.hyperlink == nil then
            return nil
        end
    end
    local id = ButtonItemID(button)
    if id then
        return id
    end
    local bag
    if button.GetBagID then
        bag = button:GetBagID()
    elseif button.GetBag then
        bag = button:GetBag()
    else
        bag = button.bag
    end
    local slot = button.GetID and button:GetID()
    if type(bag) == "number" and type(slot) == "number" and C_Container and C_Container.GetContainerItemID then
        local ok, itemID = pcall(C_Container.GetContainerItemID, bag, slot)
        if ok and type(itemID) == "number" and not Secret(itemID) then
            return itemID
        end
    end
end

local hookedMeta = {}

local function WatchButton(button)
    if button.HookScript and not button.irreplaceableWatch then
        button.irreplaceableWatch = true
        button:HookScript("OnShow", function(self)
            ns:MarkButton(self)
        end)
        button:HookScript("OnHide", function(self)
            if self.irreplaceableGlowFrame then
                self.irreplaceableGlowFrame:Hide()
            end
            if self.irreplaceableFrame then
                self.irreplaceableFrame:Hide()
            end
        end)
    end
    local meta = getmetatable(button)
    if not meta or hookedMeta[meta] then
        return
    end
    hookedMeta[meta] = true
    if type(meta.Update) == "function" then
        local original = meta.Update
        meta.Update = function(self, ...)
            original(self, ...)
            ns:MarkButton(self)
        end
    end
    if type(meta.UpdateLocked) == "function" then
        local original = meta.UpdateLocked
        meta.UpdateLocked = function(self, ...)
            original(self, ...)
            ns:MarkButton(self)
        end
    end
end

local function MarkGroup(group)
    if type(group) ~= "table" then
        return
    end
    if type(group.byBag) == "table" then
        for _, slots in pairs(group.byBag) do
            if type(slots) == "table" then
                for _, button in pairs(slots) do
                    if type(button) == "table" and button.CreateTexture and button.IsShown and button:IsShown() then
                        ns:MarkButton(button)
                    end
                end
            end
        end
        return
    end
    if type(group.buttons) == "table" then
        for _, button in ipairs(group.buttons) do
            ns:MarkButton(button)
        end
    end
end

local function MarkOpenBags()
    for i = 1, 4 do
        for _, name in ipairs({ "BagBrotherInventory", "BagBrotherBank", "BagBrotherGuild" }) do
            local frame = _G[name .. i]
            if frame and frame.IsShown and frame:IsShown() then
                MarkGroup(frame.ItemGroup)
            end
        end
    end
    local children = { UIParent:GetChildren() }
    for i = 1, #children do
        local child = children[i]
        if child:IsShown() then
            MarkGroup(child.ItemGroup)
            if child.GetChildren then
                local nested = { child:GetChildren() }
                for n = 1, #nested do
                    local grand = nested[n]
                    if grand:IsShown() and grand.byBag then
                        MarkGroup(grand)
                    end
                end
            end
        end
    end
end

local function MarkAddonButtons()
    for _, prefix in ipairs({ "BagBrotherItem", "BagBrotherContainerItem" }) do
        for i = 1, 400 do
            local button = _G[prefix .. i]
            if not button then
                break
            end
            ns:MarkButton(button)
        end
    end
end

local function PointOnRect(p, w, h)
    local peri = 2 * (w + h)
    local d = p % 1
    if d < 0 then
        d = d + 1
    end
    d = d * peri
    if d <= w then
        return -w / 2 + d, h / 2, "h"
    end
    d = d - w
    if d <= h then
        return w / 2, h / 2 - d, "v"
    end
    d = d - h
    if d <= w then
        return w / 2 - d, -h / 2, "h"
    end
    d = d - w
    return -w / 2, -h / 2 + d, "v"
end

local function PlaceDash(texture, frame, p, w, h, length, alpha)
    local x, y, edge = PointOnRect(p, w, h)
    texture:ClearAllPoints()
    texture:SetPoint("CENTER", frame, "CENTER", x, y)
    if edge == "h" then
        texture:SetSize(length, 3)
    else
        texture:SetSize(3, length)
    end
    texture:SetAlpha(alpha)
end

local function DriveGlow(frame)
    local w = frame:GetWidth()
    local h = frame:GetHeight()
    if not w or not h or w < 8 or h < 8 then
        return
    end
    local now = GetTime()
    local lap = now / 1.6
    local breath = 0.14 + 0.22 * (0.5 + 0.5 * math.sin(now * 2.2))
    frame.halo:SetSize(w * 1.7, h * 1.7)
    frame.halo:SetAlpha(breath)
    if frame.halo.SetRotation then
        frame.halo:SetRotation(now * 0.45)
    end
    local length = math.max(12, math.min(w, h) * 0.48)
    for i = 1, 4 do
        local p = lap + (i - 1) / 4
        PlaceDash(frame.sparks[i], frame, p, w, h, length, 1)
        PlaceDash(frame.tails[i], frame, p - 0.05, w, h, length * 0.62, 0.38)
    end
end

local function SlotCleared(button)
    local info = button.info
    if type(info) == "table" then
        local locked = info.isLocked
        if locked == true and not Secret(locked) then
            return true
        end
        if not info.itemID and not info.hyperlink then
            return true
        end
    end
    return button.hasItem == false
end

local function ReadSlot(button)
    local info = button.info
    if type(info) == "table" then
        local locked = info.isLocked
        if locked == true and not Secret(locked) then
            return nil
        end
        local id = info.itemID
        if type(id) == "number" and not Secret(id) then
            return id
        end
        local fromLink = ItemIDFromLink(info.hyperlink)
        if fromLink then
            return fromLink
        end
    end
    local bag
    if button.GetBag then
        bag = button:GetBag()
    elseif button.GetBagID then
        bag = button:GetBagID()
    else
        bag = button.bag
    end
    local slot = button.GetID and button:GetID()
    if type(bag) == "number" and type(slot) == "number" and not Secret(bag) and not Secret(slot) then
        if C_Container and C_Container.GetContainerItemLink then
            local ok, link = pcall(C_Container.GetContainerItemLink, bag, slot)
            local fromLink = ok and ItemIDFromLink(link)
            if fromLink then
                return fromLink
            end
        end
        if C_Container and C_Container.GetContainerItemID then
            local ok, id = pcall(C_Container.GetContainerItemID, bag, slot)
            if ok and type(id) == "number" and not Secret(id) then
                return id
            end
        end
        if C_TooltipInfo and C_TooltipInfo.GetBagItem then
            local ok, data = pcall(C_TooltipInfo.GetBagItem, bag, slot)
            if ok and type(data) == "table" then
                local id = data.id
                if type(id) == "number" and not Secret(id) then
                    return id
                end
                local fromTip = ItemIDFromLink(data.hyperlink)
                if fromTip then
                    return fromTip
                end
            end
        end
    end
    if type(info) == "table" and not button.hasItem then
        return nil
    end
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
    local halo = frame:CreateTexture(nil, "BACKGROUND")
    halo:SetTexture("Interface\\Cooldown\\star4")
    halo:SetBlendMode("ADD")
    halo:SetPoint("CENTER", frame, "CENTER", 0, 0)
    frame.halo = halo
    local function dash()
        local texture = frame:CreateTexture(nil, "OVERLAY")
        texture:SetTexture("Interface\\SpellActivationOverlay\\IconAlertAnts")
        texture:SetBlendMode("ADD")
        texture:SetTexCoord(0.0625, 0.9375, 0.0625, 0.9375)
        return texture
    end
    frame.sparks = {}
    frame.tails = {}
    for i = 1, 4 do
        frame.sparks[i] = dash()
        frame.tails[i] = dash()
    end
    frame:SetScript("OnUpdate", DriveGlow)
    button.irreplaceableFrame = frame
    return frame
end

function ns:MarkButton(button, itemID)
    if not button or not button.CreateTexture then
        return
    end
    WatchButton(button)
    if type(button.info) == "table" or button.GetBag ~= nil or button.bag ~= nil then
        local live = ReadSlot(button)
        if live then
            itemID = live
        elseif SlotCleared(button) then
            itemID = nil
        end
    end
    local entry = itemID and not Secret(itemID) and ns:Entry(itemID)
    if button.irreplaceableGlowFrame then
        button.irreplaceableGlowFrame:Hide()
    end
    local anchor = button.Icon or button.icon or button.IconTexture or button
    local frame = EnsureIconFrame(button, anchor)
    if not frame then
        return
    end
    if entry and (not button.IsShown or button:IsShown()) then
        local r, g, b = unpack(LabelColor(entry.action))
        frame:ClearAllPoints()
        frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", 0, 0)
        frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 0, 0)
        frame.top:SetVertexColor(r, g, b, 1)
        frame.bottom:SetVertexColor(r, g, b, 1)
        frame.left:SetVertexColor(r, g, b, 1)
        frame.right:SetVertexColor(r, g, b, 1)
        frame.halo:SetVertexColor(r, g, b, 1)
        for i = 1, 4 do
            frame.sparks[i]:SetVertexColor(r, g, b, 1)
            frame.tails[i]:SetVertexColor(r, g, b, 1)
        end
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

local function RememberOffer()
    local items = {}
    local seen = {}
    for _, kind in ipairs({ "choice", "reward" }) do
        for _, itemID in ipairs(QuestItems(kind)) do
            local entry = ns:Entry(itemID)
            if entry and not seen[itemID] and (entry.action == "pick" or entry.action == "avoid" or entry.action == "keep") then
                seen[itemID] = true
                items[#items + 1] = itemID
            end
        end
    end
    if #items > 0 then
        offeredQuestID = OpenQuestID()
        offeredItems = items
        if GetTitleText then
            local ok, title = pcall(GetTitleText)
            if ok and type(title) == "string" and title ~= "" then
                offeredTitle = title
            end
        end
    end
end

local function QuestTitleFor(questID)
    if offeredTitle and offeredTitle ~= "" then
        return offeredTitle
    end
    if questID and C_QuestLog and C_QuestLog.GetTitleForQuestID then
        local ok, title = pcall(C_QuestLog.GetTitleForQuestID, questID)
        if ok and type(title) == "string" and title ~= "" then
            return title
        end
    end
    return Text("QUEST_ACCEPTED")
end

local function AnnounceAccepted(questID)
    if not offeredItems then
        return
    end
    if offeredQuestID and questID and offeredQuestID ~= questID then
        return
    end
    local now = GetTime()
    local items = offeredItems
    local title = QuestTitleFor(questID)
    for _, itemID in ipairs(items) do
        recentQuestToast[itemID] = now
    end
    toastQueue[#toastQueue + 1] = { kind = "quest", title = title, items = items }
    ShowNextToast()
    offeredQuestID = nil
    offeredTitle = nil
    offeredItems = nil
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
        if button.irreplaceableTag then
            button.irreplaceableTag:Hide()
        end
        ns:MarkButton(button, itemID)
    end)

    RememberOffer()

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
    elseif event == "QUEST_ACCEPTED" then
        local questID = ...
        AnnounceAccepted(questID)
    elseif event == "QUEST_FINISHED" or event == "QUEST_TURNED_IN" then
        allowTurnIn = false
        if cover then
            cover:Hide()
        end
    elseif event == "ITEM_DATA_LOAD_RESULT" then
        local itemID = ...
        if toastItemID and itemID == toastItemID and ns.toast and ns.toast:IsShown() then
            ns.toast.name:SetText(ItemName(itemID))
            ns.toast.icon:SetTexture(ItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
        end
        if ns.questNotice and ns.questNotice:IsShown() then
            for _, row in ipairs(ns.questNotice.rows) do
                if row.itemID == itemID and row:IsShown() then
                    row.name:SetText(ItemName(itemID))
                    row.icon:SetTexture(ItemIcon(itemID) or "Interface\\Icons\\INV_Misc_QuestionMark")
                end
            end
        end
    end
end)

local function Register(event)
    pcall(frame.RegisterEvent, frame, event)
end

InstallPopup()
InstallTooltip()
BuildToast()
BuildQuestNotice()

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
Register("QUEST_ACCEPTED")
Register("QUEST_FINISHED")
Register("QUEST_TURNED_IN")
Register("ITEM_DATA_LOAD_RESULT")

if type(QuestInfo_ShowRewards) == "function" then
    hooksecurefunc("QuestInfo_ShowRewards", function()
        C_Timer.After(0, RefreshQuest)
    end)
end

print("|cffffd200" .. Text("TITLE") .. "|r " .. Text("LOADED"))

local function SoonMarkBags()
    C_Timer.After(0, function()
        ns:MarkBags()
        MarkAddonButtons()
        MarkOpenBags()
    end)
    C_Timer.After(0.2, function()
        ns:MarkBags()
        MarkAddonButtons()
        MarkOpenBags()
    end)
end

if type(hooksecurefunc) == "function" then
    for _, name in ipairs({ "ToggleAllBags", "ToggleBag", "ToggleBackpack", "OpenAllBags", "OpenBackpack" }) do
        if type(_G[name]) == "function" then
            hooksecurefunc(name, SoonMarkBags)
        end
    end
end

local glowWatch = CreateFrame("Frame")
glowWatch:SetScript("OnUpdate", function(self, elapsed)
    self.wait = (self.wait or 0) + elapsed
    if self.wait < 0.4 then
        return
    end
    self.wait = 0
    MarkAddonButtons()
    MarkOpenBags()
end)
