require('fileFunctions')
require('tableFunctions')

--Load JSON library
JSON = (loadfile "JSON/JSON.lua")()
path = "IrreplaceableItems.json"

jsonString = readAllFromFile(path)
local itemTable = JSON:decode(jsonString)

local function OnQuestAccepted(QuestLogIndex, QuestId)
	-- local item = getByQuestId(questId, itemTable)
	-- 
	local item = getByItemId(QuestId, itemTable)
	if(item ~= nil) then
		SendChatMessage("Take Item: " ..item.itemId.. "", "WHISPER", nil, GetUnitName("PLAYER"))
		SendChatMessage("" ..item.description.. "", "WHISPER", nil, GetUnitName("PLAYER"))
	else
		SendChatMessage("No Item found... ", "WHISPER", nil, GetUnitName("PLAYER"))
	end
end

-- event frame
local quest = CreateFrame("Frame")
quest:RegisterEvent("QUEST_ACCEPTED") -- QUEST_ACCEPTED
quest:SetScript("OnEvent", OnQuestAccepted)