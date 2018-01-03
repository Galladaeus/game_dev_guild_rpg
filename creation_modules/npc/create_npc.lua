-- TODO Conversations and Quests should be created seperately and then added to the npc 
-- through this script, minimize the amount of code that goes into each different npc script

local M = {}

function M.create_npc()
	-- Disable npc talk bubbles when player is not in range
	msg.post("#chat_bubble", "disable")
	msg.post("#quest_bubble", "disable")

	local npc_table = {
		npc_name = "none",
		
		has_quest = false,
		has_conversation = false,

		quest_table = nil
		conversation_table = nil
	}
	return npc_table
end

function M.get_name(self)
	return self.npc_table.npc_name
end

function M.set_name(self, name)
	self.npc_table.npc_name = name
end

function M.add_quest(self, quest)
	self.npc_table.has_quest = true
	self.npc_table.quest_table = quest
end

function M.has_quest(self)
	return self.npc_table.has_quest
end

return M