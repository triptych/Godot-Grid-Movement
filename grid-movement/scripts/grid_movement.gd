extends KinematicBody2D

# Public instance variables
# The size of grid cells in the game world
export(int) var cell_size = 32
# Each time move_timer exceeds this value, the player moves by step_distance
export(float) var step_delay = 0.01
# The amount of distance the player bounds each time movement occurs
# Be divisible into cell_size for best results
export(int) var step_distance = 4
# The current direction of the player
export(String, "up", "down", "left", "right") var direction = "up"
# Whether input is locked. Objects with this script need to be sent explicit
# directions so this will not always be necessary to set.
export(bool) var input_lock = false

# Private instance variables
# Whether the player is currently moving. Locks off command input if true
var moving = false
# The vector that describes how the player moves
var move_vector = Vector2( 0 , 0 )
# How many moves remain in the current movement command
var remaining_steps = 0
# A timer that stores delta time, initiating a step and 
# resetting after each step of movement is complete
var move_timer = 0
# If there is a remainder when determining how many steps to run,
# this will store it, allowing an overflow vector to run.
var step_remainder = 0

# Dictionary of vector modifiers for the 4 directions of movement
var vector_dir_mod = {
	"up":    { "x": 0 ,  "y": -1 },
	"down":  { "x": 0 ,  "y": 1  },
	"left":  { "x": -1 , "y": 0  },
	"right": { "x": 1 ,  "y": 0  }
}

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if moving and remaining_steps == 0 and step_remainder == 0:
		_end_movement()
	elif moving and remaining_steps == 0:
		_process_overflow_movement(delta)
	elif moving:
		_process_movement(delta)

# Begins moving based on the provided vector
func _make_movement(vector):
	move_vector = vector
	step_remainder = cell_size % step_distance
	remaining_steps = floor(cell_size / step_distance)
	moving = true

# Ends movement and resets variables
func _end_movement():
	moving = false
	move_vector = Vector2( 0 , 0 )
	move_timer = 0

# Processes movement, taking a step each time moveTimer*100 exceeds step_delay
func _process_movement(delta):
	move_timer += delta
	if move_timer >= step_delay:
		move(move_vector)
		remaining_steps -= 1
		move_timer = 0

# Processes "overflow" movement, providing an extra step
func _process_overflow_movement(delta):
	move_timer += delta
	if move_timer >= step_delay:
		var xmod = vector_dir_mod[direction].x
		var ymod = vector_dir_mod[direction].y
		move(Vector2(step_remainder*xmod, step_remainder*ymod))
		step_remainder = 0

# Retrieves the vector for moving to an adjacent tile for a direction
func _get_adjacent_tile_vector(dir):
	return Vector2( cell_size*vector_dir_mod[dir].x, cell_size*vector_dir_mod[dir].y)

func _get_step_vector(dir):
	return Vector2( step_distance*vector_dir_mod[dir].x, step_distance*vector_dir_mod[dir].y)
	
# Returns whether moving in direction dir would trigger a collision
func _check_dir(dir):
	return !test_move( _get_adjacent_tile_vector(dir) )

# Retrieves a move command that has been input
# Begins movement if there are no collisions at the destination and player
# is not already moving
func take_move_command(dir):
	if dir != direction:
		direction = dir
	if _check_dir(dir) and !moving and !input_lock:
		_make_movement( _get_step_vector(dir) )


