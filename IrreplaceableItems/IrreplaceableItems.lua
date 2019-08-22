require('fileFunctions')
require('tableFunctions')

--Load JSON library
JSON = (loadfile "JSON/JSON.lua")()
path = "IrreplaceableItems.json"

jsonString = readAllFromFile(path)
local itemTable = JSON:decode(jsonString) -- https://docs.google.com/document/d/1TpZA5byhhbVcaNr_USzUQsBnWg4vFHbIYtDn83HK9rM/preview#
-- local pretty_json_text = JSON:encode_pretty(itemTable)
-- print(pretty_json_text)
[[ 
local item = getByItemId(1172, itemTable)
if(item ~= nil) then
	print("Take Item: " ..item.itemId.. "")
	print("Description: " ..item.description.. "");
else
	print("No item found!");
end
]]
  print("HELLO")

local function OnQuestAccepted(questIndex, questId)
	-- local item = getByQuestId(questId, itemTable)
   -- SendChatMessage("Take Item: " ..item.itemId.. "", "WHISPER", nil, GetUnitName("PLAYER"))
   local item = getByItemId(1172, itemTable)
   print("Take Item: " ..item.itemId.. "")
end

-- event frame
local quest = CreateFrame("Frame")
quest:RegisterEvent("PLAYER_ENTERING_WORLD")
quest:SetScript("OnEvent", OnQuestAccepted)