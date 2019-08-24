-- require('QuestItemDB')

function OnQuestAccepted(QuestLogIndex, QuestId)
--	DEFAULT_CHAT_FRAME:AddMessage("Event: OnQuestAccepted")
	local dbEntry = getByQuestId(QuestId)	
	if(dbEntry ~= nil) then
		local item = Item:CreateFromItemID(QuestId)
		item:ContinueOnItemLoad(function()
			DEFAULT_CHAT_FRAME:AddMessage("Take Item: " ..item:GetItemLink().. "") 
			DEFAULT_CHAT_FRAME:AddMessage(..dbEntry:description..) 
		end)
	end
end

-- event frame
local quest = CreateFrame("Frame")
quest:RegisterEvent("QUEST_ACCEPTED", IIEventHandler.QUEST_ACCEPTED) 

-- foundQuest = getByQuestId(7496)
 foundQuest2 = getByItemId(4984)
-- print(foundQuest[QuestItemDBKeys['questId']]) 
-- print(foundQuest2[QuestItemDBKeys['itemId']])
-- local itemInfo = GetItemInfo(4984)
-- DEFAULT_CHAT_FRAME:AddMessage("Take Item: " ..itemInfo.. "")
-- DEFAULT_CHAT_FRAME:AddMessage("Take Item: " ..itemInfo.itemLink.. "")
-- DEFAULT_CHAT_FRAME:AddMessage(foundQuest2[QuestItemDBKeys['description']])
-- DEFAULT_CHAT_FRAME:AddMessage("Take Item: |cff9d9d9d|Hitem:7073::::::::::::|h[Broken Fang]|h|r") 

DEFAULT_CHAT_FRAME:AddMessage("IrreplaceableItems Addon loaded.")