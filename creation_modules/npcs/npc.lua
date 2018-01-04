-- TODO Conversations and Quests should be created seperately and then added to the npc 
-- through this script, minimize the amount of code that goes into each different npc script

local M = {}

--[[ Functions to enable or disable chat and quest bubbles above npc's head ]]--
function M.enable_quest_bubble() msg.post("#questBubble", "enable") end
function M.disable_quest_bubble() msg.post("#questBubble", "disable") end
function M.enable_chat_bubble() msg.post("#chatBubble", "enable") end
function M.disable_chat_bubble() msg.post("#chatBubble", "disable") end

--[[ First function to call when creating a new npc, intializes the basic data for a npc ]]
function M.create_npc()
	-- Disable npc talk bubbles when player is not in range
	M.disable_chat_bubble()
	M.disable_quest_bubble()

	local npc_table = {
		npc_name,
		
		has_quest = false,
		has_conversation = false,

		quest_table = nil,
		conversation_table = nil
	}
	return npc_table
end

--[[ Functions to set and get the name of the npc ]]
function M.set_name(self, name) self.npc_table.npc_name = name end
function M.get_name(self) return self.npc_table.npc_name end

function M.set_quest(self, quest)
	self.npc_table.has_quest = true
	self.npc_table.quest_table = quest
end

function M.get_quest(self, quest)
	return self.npc_table.quest_table
end

--[[ Functions to check whether npc has a conversation or quest ]]
function M.has_conversation(self) return self.npc_table.has_conversation end
function M.has_quest(self) return self.npc_table.has_quest end

--[[ Gets the URL of this npc so it can be sent messages ]]
function M.get_npc_url()
	-- Construct address of quest giver to set as quest completer
	local self_url = msg.url()
	-- This may be a source of future errors, i.e. what makes a npc in the default socket vs elsewhere
	self_url.socket = "default"
	self_url.path = go.get_id()
	return self_url
end


return M