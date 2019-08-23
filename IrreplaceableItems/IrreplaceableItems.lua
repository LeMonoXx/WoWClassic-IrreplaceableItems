-- require('QuestItemDB')

local function OnQuestAccepted(QuestLogIndex, QuestId)

	local dbEntry = getByQuestId(QuestId, QuestItemDB)
	if(dbEntry ~= nil) then
	-- DEFAULT_CHAT_FRAME:AddMessage(("|cff6666ccTrackResources|r: %s"):format(str));
		SendChatMessage("Take Item: " ..dbEntry.itemId.. "", "WHISPER", nil, GetUnitName("PLAYER"))
		SendChatMessage("" ..dbEntry.description.. "", "WHISPER", nil, GetUnitName("PLAYER"))
	else
		SendChatMessage("No Item found... ", "WHISPER", nil, GetUnitName("PLAYER"))
	end
end

-- event frame
local quest = CreateFrame("Frame")
quest:RegisterEvent("QUEST_ACCEPTED") -- PLAYER_ENTERING_WORLD
quest:SetScript("OnEvent", OnQuestAccepted)

-- foundQuest = getByQuestId(7496,QuestItemDB)
-- foundQuest2 = getByItemId(4984,QuestItemDB)
-- print(foundQuest[QuestItemDBKeys['questId']]) 
-- print(foundQuest2[QuestItemDBKeys['itemId']])