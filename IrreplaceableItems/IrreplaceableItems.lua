require('fileFunctions')
require('tableFunctions')

--Load JSON library
JSON = (loadfile "JSON/JSON.lua")()
path = "IrreplaceableItems.json"

jsonString = readAllFromFile(path)
local itemTable = JSON:decode(jsonString) -- https://docs.google.com/document/d/1TpZA5byhhbVcaNr_USzUQsBnWg4vFHbIYtDn83HK9rM/preview#
local pretty_json_text = JSON:encode_pretty(itemTable)
-- print(pretty_json_text)

local item = getByItemId("1172", itemTable)
if(item ~= nil) then
	print("Item: " ..item.itemId.. "")
	print("Quest:" ..item.questId.. "");
	print("Description: " ..item.description.. "");
else
	print("No item found!");
end