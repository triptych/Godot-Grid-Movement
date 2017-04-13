extends KinematicBody2D

# The size of tiles in the game world
const TILE_SIZE = 32
# Each time moveTimer*100 exceeds this value, the player moves by STEP_DISTANCE
const STEP_SPEED = 0.4
# The amount of distance the player bounds each time movement occurs
# Should be divisible by TILE_SIZE!
const STEP_DISTANCE = 4

# Whether the player is currently moving. Locks off command input if true
var moving = false
# The vector that describes how the player moves
var moveVector = Vector2( 0 , 0 )
# How many moves remain in the current movement command
var moveRemaining = 0
# A timer that stores delta time, initiating a step and 
# resetting after each step of movement is complete
var moveTimer = 0

# The current direction of the player
export var direction = "up"

# Contains dictionaries of vectors for the 4 directions of movement.
# adjacent_tile: The distance to the adjacent tile in this direction.
# step_vector:   The distance to the next "step" in this direction.
# cursor_pos:    The position of the child cursor relative to this object
var direction_data = {
	"up": {
		"adjacent_tile": Vector2( 0 , -TILE_SIZE ),
		"step_vector":   Vector2( 0 , -STEP_DISTANCE ),
		"cursor_pos":    Vector2( 16 , -16 )
	},
	"down": {
		"adjacent_tile": Vector2( 0 , TILE_SIZE ),
		"step_vector":   Vector2( 0 , STEP_DISTANCE ),
		"cursor_pos":    Vector2( 16 , 48 )
	},
	"left": {
		"adjacent_tile": Vector2( -TILE_SIZE , 0 ),
		"step_vector":   Vector2( -STEP_DISTANCE , 0 ),
		"cursor_pos":    Vector2( -16 , 16 )
	},
	"right": {
		"adjacent_tile": Vector2( TILE_SIZE , 0 ),
		"step_vector":   Vector2( STEP_DISTANCE , 0 ),
		"cursor_pos":    Vector2( 48 , 16 )
	}
}

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if moving and moveRemaining <= 0:
		_end_movement()
	elif moving:
		_process_movement(delta)

# Begins moving based on the provided vector
func _make_movement(vector):
	moveVector = vector
	moveRemaining = TILE_SIZE
	moving = true

# Ends movement and resets variables
func _end_movement():
	moving = false
	moveVector = Vector2( 0 , 0 )
	moveTimer = 0

# Processes movement, taking a step each time moveTimer*100 exceeds STEP_SPEED
func _process_movement(delta):
	moveTimer += delta
	if (moveTimer*100) >= STEP_SPEED:
		move(moveVector)
		moveRemaining -= STEP_DISTANCE
		moveTimer = 0

# Returns whether moving in direction dir would trigger a collision
func _check_dir(dir):
	return !test_move( direction_data[dir].adjacent_tile )

func _recalibrate_tile_cursor(dir):
	get_node("AdjacentTile").set_pos( direction_data[dir].cursor_pos )

# Retrieves a move command that has been input
# Begins movement if there are no collisions at the destination and player
# is not already moving
func take_move_command(dir):
	if dir != direction:
		direction = dir
		_recalibrate_tile_cursor(dir)
	if _check_dir(dir) and !moving:
		_make_movement( direction_data[dir].step_vector )


