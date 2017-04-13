extends Area2D

var player
var tile_size
var cursor_pos

var active = true

func _ready():
	player = get_parent()
	tile_size = player.tile_size
	cursor_pos = {
		"up":    Vector2( tile_size , -tile_size ),
		"down":  Vector2( tile_size , tile_size*3 ),
		"left":  Vector2( -tile_size , tile_size ),
		"right": Vector2( tile_size*3 , tile_size )
	}
	set_cursor_direction( player.direction )

func set_cursor_direction(dir):
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
