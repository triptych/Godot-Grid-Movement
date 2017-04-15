extends Area2D

var player
var cell_size
var cursor_pos
var direction

var active = true

func _ready():
	player = get_parent()
	cell_size = player.cell_size
	cursor_pos = {
		"up":    Vector2( cell_size , -cell_size ),
		"down":  Vector2( cell_size , cell_size*3 ),
		"left":  Vector2( -cell_size , cell_size ),
		"right": Vector2( cell_size*3 , cell_size )
	}
	_set_cursor_direction( player.direction )
	set_fixed_process(true)

func _fixed_process(delta):
	_set_cursor_direction( player.direction )

func _set_cursor_direction(dir):
	if dir != direction:
		direction = dir
		if cursor_pos.has(dir):
			set_pos( cursor_pos[dir] )
		else:
			print("ERROR: sent invalid direction to set_cursor_direction()")

func interact():
	if active == true:
		active = false
		var overlaps = get_overlapping_bodies()
		for obj in overlaps:
			if obj.is_in_group("Interactive"):
				obj.on_interact()
		active = true
