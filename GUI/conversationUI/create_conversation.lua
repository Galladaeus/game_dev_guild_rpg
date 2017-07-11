-- To get access to the functions, you need to put:
-- require "GUI/conversationUI/create_conversation"

-- This module contains all the needed functions to create and build your own conversation
-- with MAX FOUR different player options, as well as the option to have a quest option
-- quests are be built in the create_quest.lua module

--[[ To add more than four different conversation options you will have to alter the table
as well as redesign part of the conversationUI and conversationUIscript.gui_script ]]

local conversation_creator = {
	
---------------------------------------------------------------------------------------------------
--------------------------------------PRIMARY FUNCTIONS--------------------------------------------
----------------------These are all the functions you should need to create------------------------
-------------------------------------your conversations--------------------------------------------
---------------------------------------------------------------------------------------------------

--[[ ALTER TABLE AT YOUR OWN RISK ]]	
--[[ Call this function before any others and use the table it creates
to pass into the other functions inside of this module, you should only
change this table using the functions provided in this module or you
could break the entire conversation UI ]]
local function get_conversation_table()
	local conversation_table = {
						npc_greeting = "Hello",
						hub_return = "Alright, let's talk about something else", 
						--having 'option_one','option_two'...etc is optional to include improves readability
						player_choices = {'option_one', 'option_two', 'option_three', 'option_four'},
						npc_responses = {'option_one', 'option_two', 'option_three', 'option_four'},
						player_responses = {'option_one', 'option_two', 'option_three', 'option_four'},
						player_quest_responses = {'yes_option', 'no_option'},
						quest_response_text = {'option', 'text'},
						quest_name = nil
					}
	conversation_table.player_quest_responses['yes_option'] = 'yes'
	conversation_table.player_quest_responses['no_option'] = 'no'
	return conversation_table
end

--[[ Sets the first thing NPC says to player ]]
local function set_npc_greeting(conversation_table, npc_greeting)
	check_table_validity(conversation_table, 'set_npc_greeting()')
	conversation_table.npc_greeting = npc_greeting
end

--[[ Sets what the npc will say if the player selects return in the middle of a npc dialog ]]
local function set_npc_hub_return_text(conversation_table, hub_return_text)
	check_table_validity(conversation_table, 'set_hub_return_button()')
	conversation_table.hub_return = hub_return_text
end

--[[ Sets a player choice, for conversation_option use 'option_one', 'option_two', 'option_three', 
or 'option_four' to set which button the text goes into ]]
local function set_conversation_option(conversation_table, conversation_option ,player_choice_button_text)
	if check_argument_validity(conversation_table, conversation_option, 'set_conversation_option()') then	
		conversation_table.player_choices[conversation_option] = player_choice_button_text
	end
end

--[[ Sets npc response to the response_table where each string is the next thing the npc says
response_option should correspond to the conversation_option it matches, use set_npc_quest_request()
if you want the option to lead to a quest request ]]
local function set_npc_response(conversation_table, response_option, response_table)
	if check_argument_validity(conversation_table, response_option, 'set_npc_response()') then	
		set_response(conversation_table, response_option, response_table, npc_responses)
	end
end

--[[ Sets up one of the npc_response options to send the player a quest request, response_table_quest_text
is the line of text in your response_table that corresponds to the player quest response, the quest 
table created in create_quest.lua module ]]
local function set_npc_quest_request(conversation_table, response_option, response_table, response_table_quest_text, quest_name)
	if check_argument_validity(conversation_table, response_option, 'set_npc_quest_request()') then
		conversation_table.npc_responses[response_option] = response_table
		conversation_table.quest_response_text['option'] = response_option
		conversation_table.quest_response_text['text'] = response_table_quest_text
		conversation_table.quest_name = quest_name
	end
end

--[[ Sets player responses to the response_table where each string is the next thing the player says
in response to npc_responses, response_option should correspond to the conversation_option it matches ]]
local function set_player_response(conversation_table, response_option, response_table)
	if check_argument_validity(conversation_table, response_option, 'set_npc_response()') then	
		set_response(conversation_table, response_option, response_table, player_responses)
	end
end

--[[ Set up player answers to a quest request, default is yes and no ]]
local function set_player_quest_responses(conversation_table, yes_option, no_option)
	check_table_validity(conversation_table)
	conversation_table.player_quest_responses['yes_option'] = yes_option
	conversation_table.player_quest_responses['no_option'] = no_option
end

--TODO Should be in own quest module?
--[[ Sets up quest information, call set_quest_accept() to set up player accept response
quest_name, npc_name, and quest_description should all be single strings, the quest_type table
should be one created from create_quest ]]
local function set_quest(conversation_table, quest_name, npc_name, quest_description, quest_type)
	check_table_validity(conversation_table, 'set_quest')
	conversation_table.quest_data.quest_name = quest_name
	conversation_table.quest_data.npc_name = npc_name
	conversation_table.quest_data.quest_description = quest_description
	conversation_table.quest_data.quest_type = quest_type
end

---------------------------------------------------------------------------------------------------
--------------------------------------HELPER FUNCTIONS---------------------------------------------
----------------------Should not have any reson to call outside this module------------------------
---------------------------------------------------------------------------------------------------

--[[ Helper function for set_npc_response and set_player_response ]]
local function set_response(conversation_table, response_option, response_table, entity_responses)
	if conversation_table.player_choices[response_option] == nil then
		pprint("ERROR: "..response_option..)
		error("set_response(response_option) trying to respond to nil player_choice")
	else
		conversation_table.entity_responses[response_option] = response_table
	end
end

--[[ Helper function to ensure table is valid ]]
local function check_table_validity(conversation_table, function_name)
	if not conversation_table.npc_greeting then 
		pprint("ERROR: make sure to use get_conversation_table to create you conversation")
		error("conversation_table missing npc_greeting passed to "..function_name) end
	if not conversation_table.player_choices then
		pprint("ERROR: make sure to use get_conversation_table to create you conversation")
		error("conversation_table missing player_choices passed to "..function_name) end
	if not conversation_table.npc_responses then 
		pprint("ERROR: make sure to use get_conversation_table to create you conversation")
		error("conversation_table missing npc_responses passed to "..function_name) end
	if not conversation_table.player_responses then 
		pprint("ERROR: make sure to use get_conversation_table to create you conversation")
		error("conversation_table missing player_responses passed to "..function_name) end
	if not conversation_table.quest_name then 
		pprint("ERROR: make sure to use get_conversation_table to create you conversation")
		error("conversation_table missing quest_data passed to "..function_name) end
end	

--[[ Helper function to ensure data integrity for response
/choice setters, wont need during optimization phase ]]
local function check_argument_validity(conversation_table, option, function_name)
	check_table_validity(conversation_table, function_name)
	
	if option == 'option_one' or option == 'option_two'
			or option == 'option_three' or option == 'option_four' then
		return true
	else 
		error("Invalid option passed to "..function_name)
	end
	error("Uknown error in check_argument_validity on "..function_name)
end

}

return conversation_creator