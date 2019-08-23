-- require('QuestItemDB')

local function OnQuestAccepted(QuestLogIndex, QuestId)

	local dbEntry = getByQuestId(QuestId, QuestItemDB)
	if(dbEntry ~= nil) then
	-- DEFAULT_CHAT_FRAME:AddMessage(("|cff6666ccTrackResources|r: %s"):format(str));
		local itemInfo = GetItemInfo(dbEntry[QuestItemDBKeys['itemId']])
		SendChatMessage("Take Item: " ..itemInfo.itemLink.. "", "WHISPER", nil, GetUnitName("PLAYER"))
		SendChatMessage("" ..dbEntry[QuestItemDBKeys['description']].. "", "WHISPER", nil, GetUnitName("PLAYER"))
	else
		SendChatMessage("No Item found... ", "WHISPER", nil, GetUnitName("PLAYER"))
	end
end

-- event frame
local quest = CreateFrame("Frame")
quest:RegisterEvent("QUEST_ACCEPTED") 
quest:SetScript("OnEvent", OnQuestAccepted)

-- foundQuest = getByQuestId(7496,QuestItemDB)
-- foundQuest2 = getByItemId(4984,QuestItemDB)
-- print(foundQuest[QuestItemDBKeys['questId']]) 
-- print(foundQuest2[QuestItemDBKeys['itemId']])
-- local itemInfo = GetItemInfo(foundQuest2[QuestItemDBKeys['itemId']])
-- DEFAULT_CHAT_FRAME:AddMessage("Take Item: " ..itemInfo.itemLink.. "")
-- DEFAULT_CHAT_FRAME:AddMessage(foundQuest2[QuestItemDBKeys['description']])