-- TunedVehicles by ING

-- #################################################################################################################################

-- <<< PRESETS >>>

--  KEY = The key the player has to press: http://wiki.jc-mp.com/Lua/Client/Action
--        (you have to type in the number, enum not working here)

--   UP = A upwards going velocity trigger, turns on when the vehicle velocity is bigger than UP
--        You have to define a ACC value when using this trigger, use 0 to not change the acceleration
--        You also can define a optional MAX value to limit the forward velocity
		  
-- DOWN = A downwards going velocity trigger, turns on when the vehicle velocity is lower than DOWN
--        You have to define a DEC value when using this trigger, use 0 to not change the deceleration
--        You also can define a optional MIN value to limit the backward velocity

-- MAX and -ACC blocking wheels on cars when up triggered
-- All values are in m/s! Divide by 3.6 to use km/h.

-- #################################################################################################################################

-- Realistic plane reversing
PlaneReverse = {
	KEY  = 65, -- Action.PlaneDecTrust
	[59] = {DOWN = 0.5, DEC =  5, MIN = -10}, --airhawk
	[81] = {DOWN = 0.5, DEC = 10, MIN = -20}, --silverbolt
	[51] = {DOWN = 0.5, DEC =  7, MIN = -10}, --personal jet
	[34] = {DOWN = 0.5, DEC =  7, MIN = -10}, --eclipse
	[30] = {DOWN = 0.5, DEC =  7, MIN = -15}, --fightjet
	[39] = {DOWN = 0.5, DEC =  6, MIN =  -6}, --airbus
	[85] = {DOWN = 0.5, DEC =  6, MIN =  -5}, --bering
}

-- Boost the plane when hold down shift and flying faster than 200 km/h
PlaneBoost = {
	KEY  = 64, -- Action.PlaneIncTrust
	[59] = {UP = 200 / 3.6, ACC = 50}, --airhawk
	[51] = {UP = 200 / 3.6, ACC = 40}, --airbus
	[85] = {UP = 200 / 3.6, ACC = 30}, --bering
}

-- Backward flying planes
PlaneBackwardFly = {
	KEY  = 65, -- Action.PlaneDecTrust
	[39] = {DOWN = 0.5, DEC = 40}, --airbus
}

-- Increase velocity
FastForward = {
	KEY  = 30, --Action.MoveForward 
	 [2] = {UP = 0, ACC = 25}, --titus
	 [6] = {UP = 0, ACC = 10, MAX = 500 / 3.6}, --sailboat
	[62] = {UP = 20 / 3.6, ACC = 30, MAX = 500 / 3.6}, --chippewa
}

-- Increased backwards velocity and limit it to 200 km/h
FastBackward = {
	KEY  = 31, --Action.MoveBackward
	 [2] = {DOWN = -10, DEC = 15, MIN = -200 / 3.6}, --titus
}

-- #################################################################################################################################

-- <<< LIBRARY >>>

-- The library contains the preset bindings, the set can be change during the runtime with: Events:Fire("ChangeTunePresets", "<SetName>")
-- Complete library can changed in the last line of client and server script

TunesLibrary = {
	Default = {}, -- Default set. Empty, select that to disable all tunes
	
	-- Demo set
	Demo = {
		[59] = PlaneReverse, --airhawk
		[81] = PlaneReverse, --silverbolt
		[51] = PlaneReverse, --personal jet
		[34] = PlaneReverse, --eclipse
		[30] = PlaneReverse, --fightjet
		[39] = PlaneReverse, --airbus
		[85] = PlaneReverse, --bering
		
--      comment a line to enable / disable tuning
--		 [2] = FastForward,  --titus
--		 [6] = FastForward,  --sailboat
--		[62] = FastForward,  --chippewa

--		[39] = PlaneBackwardFly, --airbus
-- 		[59] = PlaneBoost, --airhawk
--		[51] = PlaneBoost, --personal jet
--		[85] = PlaneBoost, --bering
	}
}
