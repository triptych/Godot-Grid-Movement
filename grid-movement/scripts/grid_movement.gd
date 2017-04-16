extends KinematicBody2D

# Public instance variables
# The size of grid cells in the game world
export(int) var cell_size = 32
# Determines the speed of movement
export(float) var movespeed = 6
# The current direction of the player
export(String, "up", "down", "left", "right") var direction = "up"
# Whether input is locked. Objects with this script need to be sent explicit
# directions so this will not always be necessary to set.
export(bool) var input_lock = false

# Private instance variables
# An array representing a queue of stored movements
var motion_queue = []

# Dictionary of vector modifiers for the 4 directions of movement
var dir_vector = {
	"up":    { "x": 0  , "y": -1 },
	"down":  { "x": 0  , "y": 1  },
	"left":  { "x": -1 , "y": 0  },
	"right": { "x": 1  , "y": 0  }
}

# Whether noclip is on
var noclip = false

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if is_moving():
		_process_movement(motion_queue[0], delta)

# Begins moving based on the provided vector
func _make_motion(dir=direction, speed=movespeed):
	var vx = dir_vector[dir].x * cell_size
	var vy = dir_vector[dir].y * cell_size
	motion_queue.append({
		"direction": dir,
		"start_point": get_pos(),
		"end_point": get_pos() + _get_adjacent_tile_vector(dir),
		"speed": speed,
		"vector": Vector2( vx , vy )
	})

# Determines if the current motion has arrived at its end point
func _arrived(motion):
	var pos = get_pos()
	var p_x = pos.x
	var p_y = pos.y
	var d = motion.direction
	var ep_x = motion.end_point.x
	var ep_y = motion.end_point.y
	if (d == "up" and p_y <= ep_y) or (d == "down" and p_y >= ep_y) \
	or (d == "left" and p_x <= ep_x) or (d == "right" and p_x >= ep_x):
		return true
	else:
		return false

# Projects the cycle's movement and returns true if it would 
# overshoot the motion's end point
func _will_overshoot(motion, delta):
	var projection = get_pos() + (motion.vector * motion.speed * delta)
	var pr_x = projection.x
	var pr_y = projection.y
	var d = motion.direction
	var ep_x = motion.end_point.x
	var ep_y = motion.end_point.y
	if (d == "up" and pr_y < ep_y) or (d == "down" and pr_y > ep_y) \
	or (d == "left" and pr_x < ep_x) or (d == "right" and pr_x > ep_x):
		return true
	else:
		return false

# Processes a motion
func _process_movement(motion, delta):
	if _arrived(motion):
		motion_queue.pop_front()
	elif _will_overshoot(motion, delta):
		set_pos(motion.end_point)
		motion_queue.pop_front()
	else:
		move( motion.vector * motion.speed * delta )

# Retrieves the vector for moving to an adjacent tile for a direction
func _get_adjacent_tile_vector(dir):
	return Vector2( cell_size*dir_vector[dir].x, cell_size*dir_vector[dir].y)

# Returns whether moving in direction dir would trigger a collision
func _check_dir(dir):
	return !test_move( _get_adjacent_tile_vector(dir) )

# Returns whether or not the motion queue is stacked
func is_moving():
	return !motion_queue.empty()

# Activates "noclip" by removing the collision and layer masks
func noclip_on():
	set_collision_mask(0)
	set_layer_mask(0)
	noclip = true

# Restores collision to default masks
func noclip_off():
	set_collision_mask(1)
	set_layer_mask(1)
	noclip = false
	
# Toggles noclip based on current state
func toggle_noclip():
	if noclip:
		noclip_off()
	else:
		noclip_on()

# Begins movement if there are no collisions at the destination and player
# is not already moving
func take_move_command(dir):
	if dir != direction:
		direction = dir
	if _check_dir(dir) and !is_moving() and !input_lock:
		_make_motion(dir)


