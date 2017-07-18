-- To get access to the functions, you need to put this table into a local table inside the npc using:
-- require "creation_moduels/create_conversation"

-- This module contains all the needed functions to create and build your own conversation
-- with MAX FOUR different player options, as well as the option to have a quest option
-- quests are be built in the create_quest.lua module

-- Make sure if you create a player choice option you have npc responses to match it or the
-- game will break

--[[ To add more than four different conversation options you will have to alter the table
as well as redesign part of the conversationUI and conversationUIscript.gui_script ]]

local M = {}

---------------------------------------------------------------------------------------------------
--------------------------------------HELPER FUNCTIONS---------------------------------------------
----------------------Should not have any reson to call outside this module------------------------
---------------------------------------------------------------------------------------------------

--[[ Helper function to ensure table is valid ]]
local function check_table_validity(conversation_table, function_name)
	if not conversation_table.npc_greeting then 
		pprint("ERROR: make sure to use get_conversation_table to create your conversation table")
		error("conversation_table missing npc_greeting passed to "..function_name) end
	if not conversation_table.player_choices then
		pprint("ERROR: make sure to use get_conversation_table to create your conversation table")
		error("conversation_table missing player_choices passed to "..function_name) end
	if not conversation_table.npc_responses then 
		pprint("ERROR: make sure to use get_conversation_table to create your conversation table")
		error("conversation_table missing npc_responses passed to "..function_name) end
	if not conversation_table.player_responses then 
		pprint("ERROR: make sure to use get_conversation_table to create your conversation table")
		error("conversation_table missing player_responses passed to "..function_name) end
end	

--[[ Helper function to ensure data integrity for response
/choice setters, wont need during optimization phase ]]
local function check_argument_validity(conversation_table, option, function_name)
	check_table_validity(conversation_table, function_name)
	
	if option == 'option_one' or option == 'option_two'
			or option == 'option_three' or option == 'option_four' then
		return true
	else 
		error("Invalid option passed to "..function_name.." use 'option_one', 'option_two'...etc")
	end
	error("Uknown error in check_argument_validity on "..function_name)
end
	
---------------------------------------------------------------------------------------------------
-------------------------------------CREATION FUNCTIONS--------------------------------------------
----------------------These are all the functions you should need to create------------------------
-------------------------------------your conversations--------------------------------------------
---------------------------------------------------------------------------------------------------

--[[ DO NOT CHANGE TABLE DATA UNLESS YOU ARE SURE YOU KNOW EVERYTHING IT WILL ALTER ]]	
--[[ Call this function before any others and use the table it creates
to pass into the other functions inside of this module, you should only
change this table using the functions provided in this module or you
could break the entire conversation UI ]]
function M.get_conversation_table()
	local conversation_table = {
		npc_name = "default_npc",
		npc_greeting = "Hello",
		hub_return_text = "Alright, let's talk about something else", 
		player_choices = {},
		npc_responses = {},
		player_responses = {},
		player_quest_responses = {'yes_option', 'no_option'}, --TODO set defaults
		quest_response_text = 'text',
		quest_table = nil
	}
	-- Set defaults
	conversation_table.player_quest_responses['yes_option'] = "I'll help"
	conversation_table.player_quest_responses['no_option'] = "I won't help"	
	return conversation_table
end

--[[ Set npc_name, make sure this name matches the image name in conversation_images.atlas so
the proper npc image will show up during conversations ]]
function M.set_npc_name(conversation_table, npc_name)
	check_table_validity(conversation_table, 'set_npc_name()')
	conversation_table.npc_name = npc_name	
end

--[[ Sets the first thing NPC says to player ]]
function M.set_npc_greeting(conversation_table, npc_greeting)
	--check_table_validity(conversation_table, 'set_npc_greeting()')
	conversation_table.npc_greeting = npc_greeting
end

--[[ Sets what the npc will say if the player selects return in the middle of a npc dialog ]]
function M.set_npc_hub_return_text(conversation_table, hub_return_text)
	check_table_validity(conversation_table, 'set_hub_return_button()')
	conversation_table.hub_return_text = hub_return_text
end

--[[ Sets a player choice, for conversation_option use 'option_one', 'option_two', 'option_three', 
or 'option_four' to set which button the text goes into ]]
function M.set_player_option(conversation_table, conversation_option ,player_choice_button_text)
	if check_argument_validity(conversation_table, conversation_option, 'set_player_option()') then	
		conversation_table.player_choices[conversation_option] = player_choice_button_text
	end
end

--[[ Sets npc response to the response_table where each string is the next thing the npc says
response_option should correspond to the conversation_option it matches, use set_npc_quest_request()
if you want the option to lead to a quest request ]]
function M.set_npc_responses(conversation_table, response_option, response_table)
	if check_argument_validity(conversation_table, response_option, 'set_npc_responses()') then	
		if conversation_table.player_choices[response_option] == nil then
			pprint("ERROR: "..response_option)
			error("set_response(response_option) trying to respond to nil player_choice")
		else
			conversation_table.npc_responses[response_option] = response_table
		end
	end
end

--[[ Sets up one of the npc_response options to send the player a quest request, response_table_quest_text
is the line of text in your response_table that corresponds to the player quest response, the quest 
table created in create_quest.lua module ]]
function M.set_npc_quest_request(conversation_table, response_option, response_table, response_table_quest_text, quest_name)
	if check_argument_validity(conversation_table, response_option, 'set_npc_quest_request()') then
		conversation_table.npc_responses[response_option] = response_table
		conversation_table.quest_response_text = response_table_quest_text
		conversation_table.quest_name = quest_name
	end
end

--[[ Sets player responses to the response_table where each string is the next thing the player says
in response to npc_responses, response_option should correspond to the conversation_option it matches ]]
function M.set_player_responses(conversation_table, response_option, response_table)
	if check_argument_validity(conversation_table, response_option, 'set_npc_response()') then	
		if conversation_table.player_choices[response_option] == nil then
			pprint("ERROR: "..response_option)
			error("set_response(response_option) trying to respond to nil player_choice")
		else
			conversation_table.player_responses[response_option] = response_table
		end
	end
end

--[[ Set up player answers to a quest request, default is yes and no ]]
function M.set_player_quest_responses(conversation_table, yes_option, no_option)
	check_table_validity(conversation_table)
	if type(yes_option) ~= "string" or type(no_option) ~= "string" then
		error("Incorrect type passed to yes/no option in set_player_quest_response()")
	else
		conversation_table.player_quest_responses['yes_option'] = yes_option
		conversation_table.player_quest_responses['no_option'] = no_option
	end
end

--[[ Inputs a quest table made through create_quest.lua into your conversation ]]
function M.set_quest(conversation_table, quest_table)
	check_table_validity(conversation_table, 'set_quest')
	if quest_table.quest_type == 'none' then
		error("Attempted to assign a quest without a type to quest: "..quest_table.quest_name)
	end	
	conversation_table.quest_table = quest_table
end

return M