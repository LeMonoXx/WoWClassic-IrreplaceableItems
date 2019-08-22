function getByItemId(searchId, myTable)
	for key,value in pairs(myTable) do
		local itemId = myTable[key].itemId
		-- print(itemId)
		if searchId == itemId then
			return myTable[key];
		end
	end
end

function getByQuestId(searchId, myTable)
	for key,value in pairs(myTable) do
		local questId = myTable[key].questId
		-- print(questId)
		if searchId == questId then
			return myTable[key];
		end
	end
	return nil;
end
