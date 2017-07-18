-- Put functions in this file to use them in several other scripts.
-- To get access to the functions, you need to put:
-- require "my_directory.my_file"
-- in any script using the functions.

local M = {}

-------------------------------------------------------------------------------------------------------
--------This set of animations animates a gui node to flucuate size before returning to normal---------
-------------------------------------------------------------------------------------------------------

-- Animation functions are set up in a timeline, i.e. anim1 triggers first then anim2 etc.
function M.anim4(self, node)
	-- animate scale to 100%
	-- local s = 0.26767 
	gui.animate(node, gui.PROP_SCALE, vmath.vector4(0.1, 0.1, 1, 0), gui.EASING_INOUT, 0.12, 0)
end

function M.anim3(self, node)
	-- animate scale to 106%
	local s = .1
	gui.animate(node, gui.PROP_SCALE, vmath.vector4(s, s, s, 0), gui.EASING_INOUT, 0.12, 0, M.anim4)
end

function M.anim2(self, node)
	-- animate scale to 98%
	local s = .08
	gui.animate(node, gui.PROP_SCALE, vmath.vector4(s, s, s, 0), gui.EASING_INOUT, 0.12, 0, M.anim3)
end

function M.anim1(node, delay)
	-- set alpha to 1 to avoid bug where alpha remains changed if menu is left too soon
	local reset_alpha = gui.get_color(node)
	reset_alpha.w = 1
	gui.set_color(node, reset_alpha)
	
	-- set scale to 70%
	local start_scale = 0.1
	gui.set_scale(node, vmath.vector4(start_scale, start_scale, start_scale, 0))
	
	-- get current color and set alpha to 0 to fade up
	local from_color = gui.get_color(node)
	local to_color = gui.get_color(node)
	from_color.w = 0
	gui.set_color(node, from_color)
	
	-- animate alpha value from 0 to 1
	gui.animate(node, gui.PROP_COLOR, to_color, gui.EASING_IN, 0.2, delay)
	
	-- animate scale from 70% to 110%
	local s = .2
	gui.animate(node, gui.PROP_SCALE, vmath.vector4(s, s, s, 0), gui.EASING_IN, 0.2, delay, M.anim2)
end

-------------------------------------------------------------------------------------------------------

return M
