-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

-- Include and use this module in any npc that you want to create a quest for

local M = {}

---------------------------------------------------------------------------------------------------
--------------------------------------HELPER FUNCTIONS---------------------------------------------
----------------------Should not have any reson to call outside this module------------------------
---------------------------------------------------------------------------------------------------

--[[ Helper function to ensure table is valid ]]
local function check_table_validity(quest_table, function_name)
	if not quest_table.quest_name then 
		pprint("ERROR: make sure to use get_quest_table to create your quest")
		error("quest_table missing quest_name passed to "..function_name) end
	if not quest_table.quest_type then
		pprint("ERROR: make sure to use get_quest_table to create your quest")
		error("quest_table missing quest_type passed to "..function_name) end
	if not quest_table.quest_giver then 
		pprint("ERROR: make sure to use get_quest_table to create your quest")
		error("quest_table missing quest_giver passed to "..function_name) end
	if not quest_table.exp_reward then 
		pprint("ERROR: make sure to use get_quest_table to create your quest")
		error("quest_table missing quest_exp_reward passed to "..function_name) end
	if not quest_table.monetary_reward then 
		pprint("ERROR: make sure to use get_quest_table to create your quest")
		error("quest_table missing quest_monetary_reward passed to "..function_name) end
	if not quest_table.quest_description then
		pprint("ERROR: make sure to use get_quest_table to create your quest")
		error("quest_table missing quest_description passed to "..function_name) end
end	

--[[ Checks that the provided arguments are of the correct type ]]
local function check_argument_validity(function_name, expected_type, ...)
	given_types = {...}
	for i,v in pairs(given_types) do
		if type(v) ~= expected_type then
			error(function_name.." received incorrect param type '"..type(v).."' with value '"..tostring(v).." instead of '"..expected_type"'")
		end
	end
end

---------------------------------------------------------------------------------------------------
-------------------------------------CREATION FUNCTIONS--------------------------------------------
----------------------These are all the functions you should need to create------------------------
---------------------------------------your own quests---------------------------------------------
---------------------------------------------------------------------------------------------------

--[[ Call this function first and store this table in a self.quest_table inside your quest giving npc ]]
function M.get_quest_table()
	quest_table = {
			quest_name = 'none',
			quest_description = 'none',
			quest_type = 'none',
			quest_giver = 'none',
			exp_reward = 10,
			monetary_reward = 10
		}	
	
	return quest_table
end

--[[ Set the name of your quest ]]
function M.set_quest_name(quest_table, quest_name)
	check_table_validity(quest_table, 'set_quest_name')
	check_argument_validity('set_quest_name', 'string', quest_name)
	
	quest_table.quest_name = quest_name
end	

--[[ Set a short description of your quest ]]
function M.set_quest_description(quest_table, quest_description)
	check_table_validity(quest_table, 'set_quest_description')
	check_argument_validity('set_quest_description', 'string', quest_description)
	
	quest_table.quest_description = quest_description
end

--[[ Set exp/monetary quest reward ]]
function M.set_quest_reward(quest_table, exp_reward, monetary_reward)
	check_table_validity(quest_table, 'set_quest_reward')
	check_argument_validity('set_quest_reward', 'number', exp_reward, monetary_reward)
	
	quest_table.exp_reward = exp_reward
	quest_table.monetary_reward = monetary_reward
end

--[[ Set quest giver, MAKE SURE that the quest givers name matches the image name
you want to be displayed during conversations and in the quest log ]]
function M.set_quest_giver(quest_table, quest_giver)
	check_table_validity(quest_table, 'set_quest_giver')
	check_argument_validity('set_quest_giver', 'string', quest_giver)
	
	quest_table.quest_giver = quest_giver
end

--[[ Set the data needed for a kill quest ]]
function M.set_kill_quest(quest_table, enemy, number_to_kill)
	check_table_validity(quest_table, 'set_kill_quest')
	check_argument_validity('set_kill_quest', 'string', enemy)
	check_argument_validity('set_kill_quest', 'number', number_to_kill)
	
	quest_table.quest_type = 'kill_quest'
	quest_table.number_to_kill = number_to_kill
	quest_table.enemy_type = enemy
end

return M