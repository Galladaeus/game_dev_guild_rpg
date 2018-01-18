-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

-- This module will contain all the movement logic for battle levels

M = {}

M.x_move_distance = 128
M.y_move_distance = 90.4

function M.end_turn(self)
	self.is_turn = false
	msg.post("/battleController", "end_turn", { msg.url() })
end

function M.start_turn(self)
	self.is_turn = true
end

-- Casts a ray 
function M.cast_ray_from_self(self, distance, direction)
	local ray_distance = distance
	-- Add hashed groups to the table if you want to detect other collision groups
	local collision_groups = { hash("border"), hash("enemy"), hash("battlePlayer") }

	local from = go.get_position()
	local to = go.get_position()
	to[direction] = to[direction] + ray_distance

	physics.ray_cast(from, to, collision_groups)
end

-- Checks for obstacles before allowing game object to move and end turn
function M.try_moving(self, distance, direction)
	-- Set the move variables for if move is successful
	self.move_direction = direction
	self.move_distance = distance
		
	-- Check for collisions before moving player
	M.cast_ray_from_self(self, distance, direction)
end

-- Performs a one space move
function M.move(self, distance, direction)
	local pos = go.get_position() 

	pos[self.move_direction] = pos[self.move_direction] + self.move_distance
	go.set_position(pos) 

	M.end_turn(self)
end

--[[ ANIMATION FUNCTIONS ]]--
-- [[ Makes sprite flash in and out, used for when something takes damage ]]
function M.animate_flash(self)
	local values = { 
		0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1,
		0,
	}

	local square_easing = vmath.vector(values)
	go.animate("#sprite", "scale", go.PLAYBACK_ONCE_FORWARD, vmath.vector3(0, 0, 0), square_easing, 1)
end

return M