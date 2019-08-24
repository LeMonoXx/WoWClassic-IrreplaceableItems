RAEventHandler = {}

function RAEventHandler:OnQuestAccepted(QuestLogIndex, QuestId)
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