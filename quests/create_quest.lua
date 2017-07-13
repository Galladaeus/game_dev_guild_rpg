-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

-- Include and use this module in any npc that you want to create a quest for

local M = {}

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
end	

--[[ Call this function first with the type of quest you want to create
and store this table in a self.quest_table inside your quest giving npc ]]
function M.get_quest_table(quest_type)
	quest_table = {
			quest_name = 'default_quest',
			quest_type = 'kill_quest',
			quest_giver = 'default_npc',
			exp_reward = 10,
			monetary_reward = 10
		}	
	-- Set specific values for quest type
	if quest_type == 'kill_quest' then
		quest_table.number_to_kill = 3
		quest_table.enemy_type = 'rat'
	elseif quest_type == 'talk_quest' then
		quest_table.npc_to_contact = 'default_npc'
	end
	
	return quest_table
end

--[[ Set the name of your quest ]]
function M.set_quest_name(quest_table, quest_name)
	check_table_validity(quest_table, 'set_quest_name')
	quest_table.quest_name = quest_name
end	

--[[ Set exp/monetary quest reward ]]
function M.set_quest_reward(quest_table, exp_reward, monetary_reward)
	check_table_validity(quest_table, 'set_quest_reward')
	quest_table.exp_reward = exp_reward
	quest_table.monetary_reward = monetary_reward
end

--[[ Set quest giver ]]
function M.set_quest_giver(quest_giver)
	check_table_validity(quest_table, 'set_quest_giver')
	quest_table.quest_giver = quest_giver
end